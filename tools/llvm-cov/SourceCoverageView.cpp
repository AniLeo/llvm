//===- SourceCoverageView.cpp - Code coverage view for source code --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file This class implements rendering for code coverage of source code.
///
//===----------------------------------------------------------------------===//

#include "SourceCoverageView.h"
#include "SourceCoverageViewHTML.h"
#include "SourceCoverageViewText.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/LineIterator.h"
#include "llvm/Support/Path.h"

using namespace llvm;

void CoveragePrinter::StreamDestructor::operator()(raw_ostream *OS) const {
  if (OS == &outs())
    return;
  delete OS;
}

std::string CoveragePrinter::getOutputPath(StringRef Path, StringRef Extension,
                                           bool InToplevel,
                                           bool Relative) const {
  assert(Extension.size() && "The file extension may not be empty");

  SmallString<256> FullPath;

  if (!Relative)
    FullPath.append(Opts.ShowOutputDirectory);

  if (!InToplevel)
    sys::path::append(FullPath, getCoverageDir());

  SmallString<256> ParentPath = sys::path::parent_path(Path);
  sys::path::remove_dots(ParentPath, /*remove_dot_dots=*/true);
  sys::path::append(FullPath, sys::path::relative_path(ParentPath));

  auto PathFilename = (sys::path::filename(Path) + "." + Extension).str();
  sys::path::append(FullPath, PathFilename);
  sys::path::native(FullPath);

  return FullPath.str();
}

Expected<CoveragePrinter::OwnedStream>
CoveragePrinter::createOutputStream(StringRef Path, StringRef Extension,
                                    bool InToplevel) const {
  if (!Opts.hasOutputDirectory())
    return OwnedStream(&outs());

  std::string FullPath = getOutputPath(Path, Extension, InToplevel, false);

  auto ParentDir = sys::path::parent_path(FullPath);
  if (auto E = sys::fs::create_directories(ParentDir))
    return errorCodeToError(E);

  std::error_code E;
  raw_ostream *RawStream = new raw_fd_ostream(FullPath, E, sys::fs::F_RW);
  auto OS = CoveragePrinter::OwnedStream(RawStream);
  if (E)
    return errorCodeToError(E);
  return std::move(OS);
}

std::unique_ptr<CoveragePrinter>
CoveragePrinter::create(const CoverageViewOptions &Opts) {
  switch (Opts.Format) {
  case CoverageViewOptions::OutputFormat::Text:
    return llvm::make_unique<CoveragePrinterText>(Opts);
  case CoverageViewOptions::OutputFormat::HTML:
    return llvm::make_unique<CoveragePrinterHTML>(Opts);
  }
  llvm_unreachable("Unknown coverage output format!");
}

unsigned SourceCoverageView::getFirstUncoveredLineNo() {
  const auto MinSegIt =
      find_if(CoverageInfo, [](const coverage::CoverageSegment &S) {
        return S.HasCount && S.Count == 0;
      });

  // There is no uncovered line, return zero.
  if (MinSegIt == CoverageInfo.end())
    return 0;

  return (*MinSegIt).Line;
}

std::string SourceCoverageView::formatCount(uint64_t N) {
  std::string Number = utostr(N);
  int Len = Number.size();
  if (Len <= 3)
    return Number;
  int IntLen = Len % 3 == 0 ? 3 : Len % 3;
  std::string Result(Number.data(), IntLen);
  if (IntLen != 3) {
    Result.push_back('.');
    Result += Number.substr(IntLen, 3 - IntLen);
  }
  Result.push_back(" kMGTPEZY"[(Len - 1) / 3]);
  return Result;
}

bool SourceCoverageView::shouldRenderRegionMarkers(
    CoverageSegmentArray Segments) const {
  if (!getOptions().ShowRegionMarkers)
    return false;

  // Render the region markers if there's more than one count to show.
  unsigned RegionCount = 0;
  for (const auto *S : Segments)
    if (S->IsRegionEntry)
      if (++RegionCount > 1)
        return true;
  return false;
}

bool SourceCoverageView::hasSubViews() const {
  return !ExpansionSubViews.empty() || !InstantiationSubViews.empty();
}

std::unique_ptr<SourceCoverageView>
SourceCoverageView::create(StringRef SourceName, const MemoryBuffer &File,
                           const CoverageViewOptions &Options,
                           coverage::CoverageData &&CoverageInfo) {
  switch (Options.Format) {
  case CoverageViewOptions::OutputFormat::Text:
    return llvm::make_unique<SourceCoverageViewText>(
        SourceName, File, Options, std::move(CoverageInfo));
  case CoverageViewOptions::OutputFormat::HTML:
    return llvm::make_unique<SourceCoverageViewHTML>(
        SourceName, File, Options, std::move(CoverageInfo));
  }
  llvm_unreachable("Unknown coverage output format!");
}

std::string SourceCoverageView::getSourceName() const {
  SmallString<128> SourceText(SourceName);
  sys::path::remove_dots(SourceText, /*remove_dot_dots=*/true);
  sys::path::native(SourceText);
  return SourceText.str();
}

void SourceCoverageView::addExpansion(
    const coverage::CounterMappingRegion &Region,
    std::unique_ptr<SourceCoverageView> View) {
  ExpansionSubViews.emplace_back(Region, std::move(View));
}

void SourceCoverageView::addInstantiation(
    StringRef FunctionName, unsigned Line,
    std::unique_ptr<SourceCoverageView> View) {
  InstantiationSubViews.emplace_back(FunctionName, Line, std::move(View));
}

void SourceCoverageView::print(raw_ostream &OS, bool WholeFile,
                               bool ShowSourceName, bool ShowTitle,
                               unsigned ViewDepth) {
  if (ShowTitle)
    renderTitle(OS, "Coverage Report");

  renderViewHeader(OS);

  if (ShowSourceName)
    renderSourceName(OS, WholeFile);

  renderTableHeader(OS, (ViewDepth > 0) ? 0 : getFirstUncoveredLineNo(),
                    ViewDepth);

  // We need the expansions and instantiations sorted so we can go through them
  // while we iterate lines.
  std::sort(ExpansionSubViews.begin(), ExpansionSubViews.end());
  std::sort(InstantiationSubViews.begin(), InstantiationSubViews.end());
  auto NextESV = ExpansionSubViews.begin();
  auto EndESV = ExpansionSubViews.end();
  auto NextISV = InstantiationSubViews.begin();
  auto EndISV = InstantiationSubViews.end();

  // Get the coverage information for the file.
  auto StartSegment = CoverageInfo.begin();
  auto EndSegment = CoverageInfo.end();
  LineCoverageIterator LCI{CoverageInfo, 1};
  LineCoverageIterator LCIEnd = LCI.getEnd();

  unsigned FirstLine = StartSegment != EndSegment ? StartSegment->Line : 0;
  for (line_iterator LI(File, /*SkipBlanks=*/false); !LI.is_at_eof();
       ++LI, ++LCI) {
    // If we aren't rendering the whole file, we need to filter out the prologue
    // and epilogue.
    if (!WholeFile) {
      if (LCI == LCIEnd)
        break;
      else if (LI.line_number() < FirstLine)
        continue;
    }

    renderLinePrefix(OS, ViewDepth);
    if (getOptions().ShowLineNumbers)
      renderLineNumberColumn(OS, LI.line_number());

    if (getOptions().ShowLineStats)
      renderLineCoverageColumn(OS, *LCI);

    // If there are expansion subviews, we want to highlight the first one.
    unsigned ExpansionColumn = 0;
    if (NextESV != EndESV && NextESV->getLine() == LI.line_number() &&
        getOptions().Colors)
      ExpansionColumn = NextESV->getStartCol();

    // Display the source code for the current line.
    renderLine(OS, {*LI, LI.line_number()}, LCI->getWrappedSegment(),
               LCI->getLineSegments(), ExpansionColumn, ViewDepth);

    // Show the region markers.
    if (shouldRenderRegionMarkers(LCI->getLineSegments()))
      renderRegionMarkers(OS, LCI->getLineSegments(), ViewDepth);

    // Show the expansions and instantiations for this line.
    bool RenderedSubView = false;
    for (; NextESV != EndESV && NextESV->getLine() == LI.line_number();
         ++NextESV) {
      renderViewDivider(OS, ViewDepth + 1);

      // Re-render the current line and highlight the expansion range for
      // this subview.
      if (RenderedSubView) {
        ExpansionColumn = NextESV->getStartCol();
        renderExpansionSite(OS, {*LI, LI.line_number()},
                            LCI->getWrappedSegment(), LCI->getLineSegments(),
                            ExpansionColumn, ViewDepth);
        renderViewDivider(OS, ViewDepth + 1);
      }

      renderExpansionView(OS, *NextESV, ViewDepth + 1);
      RenderedSubView = true;
    }
    for (; NextISV != EndISV && NextISV->Line == LI.line_number(); ++NextISV) {
      renderViewDivider(OS, ViewDepth + 1);
      renderInstantiationView(OS, *NextISV, ViewDepth + 1);
      RenderedSubView = true;
    }
    if (RenderedSubView)
      renderViewDivider(OS, ViewDepth + 1);
    renderLineSuffix(OS, ViewDepth);
  }

  renderViewFooter(OS);
}
