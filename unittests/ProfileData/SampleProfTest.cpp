//===- unittest/ProfileData/SampleProfTest.cpp -------------------*- C++
//-*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/IR/Metadata.h"
#include "llvm/ProfileData/SampleProfReader.h"
#include "llvm/ProfileData/SampleProfWriter.h"
#include "gtest/gtest.h"

#include <cstdarg>

using namespace llvm;
using namespace sampleprof;

static ::testing::AssertionResult NoError(std::error_code EC) {
  if (!EC)
    return ::testing::AssertionSuccess();
  return ::testing::AssertionFailure() << "error " << EC.value() << ": "
                                       << EC.message();
}

namespace {

struct SampleProfTest : ::testing::Test {
  std::string Data;
  std::unique_ptr<raw_ostream> OS;
  std::unique_ptr<SampleProfileWriter> Writer;
  std::unique_ptr<SampleProfileReader> Reader;

  SampleProfTest()
      : Data(), OS(new raw_string_ostream(Data)), Writer(), Reader() {}

  void createWriter(SampleProfileFormat Format) {
    auto WriterOrErr = SampleProfileWriter::create(OS, Format);
    ASSERT_TRUE(NoError(WriterOrErr.getError()));
    Writer = std::move(WriterOrErr.get());
  }

  void readProfile(std::unique_ptr<MemoryBuffer> &Profile) {
    auto ReaderOrErr = SampleProfileReader::create(Profile, getGlobalContext());
    ASSERT_TRUE(NoError(ReaderOrErr.getError()));
    Reader = std::move(ReaderOrErr.get());
  }

  void testRoundTrip(SampleProfileFormat Format) {
    createWriter(Format);

    StringRef FooName("_Z3fooi");
    FunctionSamples FooSamples;
    FooSamples.setName(FooName);
    FooSamples.addTotalSamples(7711);
    FooSamples.addHeadSamples(610);
    FooSamples.addBodySamples(1, 0, 610);
    FooSamples.addBodySamples(2, 0, 600);
    FooSamples.addBodySamples(4, 0, 60000);
    FooSamples.addBodySamples(8, 0, 60351);
    FooSamples.addBodySamples(10, 0, 605);

    StringRef BarName("_Z3bari");
    FunctionSamples BarSamples;
    BarSamples.setName(BarName);
    BarSamples.addTotalSamples(20301);
    BarSamples.addHeadSamples(1437);
    BarSamples.addBodySamples(1, 0, 1437);

    StringMap<FunctionSamples> Profiles;
    Profiles[FooName] = std::move(FooSamples);
    Profiles[BarName] = std::move(BarSamples);

    std::error_code EC;
    EC = Writer->write(Profiles);
    ASSERT_TRUE(NoError(EC));

    Writer->getOutputStream().flush();

    auto Profile = MemoryBuffer::getMemBufferCopy(Data);
    readProfile(Profile);

    EC = Reader->read();
    ASSERT_TRUE(NoError(EC));

    StringMap<FunctionSamples> &ReadProfiles = Reader->getProfiles();
    ASSERT_EQ(2u, ReadProfiles.size());

    FunctionSamples &ReadFooSamples = ReadProfiles[FooName];
    ASSERT_EQ(7711u, ReadFooSamples.getTotalSamples());
    ASSERT_EQ(610u, ReadFooSamples.getHeadSamples());

    FunctionSamples &ReadBarSamples = ReadProfiles[BarName];
    ASSERT_EQ(20301u, ReadBarSamples.getTotalSamples());
    ASSERT_EQ(1437u, ReadBarSamples.getHeadSamples());

    auto VerifySummary = [](SampleProfileSummary &Summary) mutable {
      ASSERT_EQ(123603u, Summary.getTotalSamples());
      ASSERT_EQ(6u, Summary.getNumLinesWithSamples());
      ASSERT_EQ(2u, Summary.getNumFunctions());
      ASSERT_EQ(1437u, Summary.getMaxHeadSamples());
      ASSERT_EQ(60351u, Summary.getMaxSamplesPerLine());

      uint32_t Cutoff = 800000;
      auto Predicate = [&Cutoff](const ProfileSummaryEntry &PE) {
        return PE.Cutoff == Cutoff;
      };
      std::vector<ProfileSummaryEntry> &Details = Summary.getDetailedSummary();
      auto EightyPerc = std::find_if(Details.begin(), Details.end(), Predicate);
      Cutoff = 900000;
      auto NinetyPerc = std::find_if(Details.begin(), Details.end(), Predicate);
      Cutoff = 950000;
      auto NinetyFivePerc =
          std::find_if(Details.begin(), Details.end(), Predicate);
      Cutoff = 990000;
      auto NinetyNinePerc =
          std::find_if(Details.begin(), Details.end(), Predicate);
      ASSERT_EQ(60000u, EightyPerc->MinCount);
      ASSERT_EQ(60000u, NinetyPerc->MinCount);
      ASSERT_EQ(60000u, NinetyFivePerc->MinCount);
      ASSERT_EQ(610u, NinetyNinePerc->MinCount);
    };

    SampleProfileSummary &Summary = Reader->getSummary();
    VerifySummary(Summary);

    Metadata *MD = Summary.getMD(getGlobalContext());
    ASSERT_TRUE(MD);
    ProfileSummary *PS = ProfileSummary::getFromMD(MD);
    ASSERT_TRUE(PS);
    ASSERT_TRUE(isa<SampleProfileSummary>(PS));
    SampleProfileSummary *SPS = cast<SampleProfileSummary>(PS);
    VerifySummary(*SPS);
  }
};

TEST_F(SampleProfTest, roundtrip_text_profile) {
  testRoundTrip(SampleProfileFormat::SPF_Text);
}

TEST_F(SampleProfTest, roundtrip_binary_profile) {
  testRoundTrip(SampleProfileFormat::SPF_Binary);
}

TEST_F(SampleProfTest, sample_overflow_saturation) {
  const uint64_t Max = std::numeric_limits<uint64_t>::max();
  sampleprof_error Result;

  StringRef FooName("_Z3fooi");
  FunctionSamples FooSamples;
  Result = FooSamples.addTotalSamples(1);
  ASSERT_EQ(Result, sampleprof_error::success);

  Result = FooSamples.addHeadSamples(1);
  ASSERT_EQ(Result, sampleprof_error::success);

  Result = FooSamples.addBodySamples(10, 0, 1);
  ASSERT_EQ(Result, sampleprof_error::success);

  Result = FooSamples.addTotalSamples(Max);
  ASSERT_EQ(Result, sampleprof_error::counter_overflow);
  ASSERT_EQ(FooSamples.getTotalSamples(), Max);

  Result = FooSamples.addHeadSamples(Max);
  ASSERT_EQ(Result, sampleprof_error::counter_overflow);
  ASSERT_EQ(FooSamples.getHeadSamples(), Max);

  Result = FooSamples.addBodySamples(10, 0, Max);
  ASSERT_EQ(Result, sampleprof_error::counter_overflow);
  ErrorOr<uint64_t> BodySamples = FooSamples.findSamplesAt(10, 0);
  ASSERT_FALSE(BodySamples.getError());
  ASSERT_EQ(BodySamples.get(), Max);
}

} // end anonymous namespace
