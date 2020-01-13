#!/usr/bin/env python3

"""A test case update script.

This script is a utility to update LLVM 'llc' based test cases with new
FileCheck patterns. It can either update all of the tests in the file or
a single test function.
"""

from __future__ import print_function

import argparse
import os  # Used to advertise this file's name ("autogenerated_note").

from UpdateTestChecks import asm, common

# llc is the only llc-like in the LLVM tree but downstream forks can add
# additional ones here if they have them.
LLC_LIKE_TOOLS = ('llc',)

def main():
  parser = argparse.ArgumentParser(description=__doc__)
  parser.add_argument('--llc-binary', default=None,
                      help='The "llc" binary to use to generate the test case')
  parser.add_argument(
      '--function', help='The function in the test file to update')
  parser.add_argument(
      '--extra_scrub', action='store_true',
      help='Always use additional regex to further reduce diffs between various subtargets')
  parser.add_argument(
      '--x86_scrub_rip', action='store_true', default=True,
      help='Use more regex for x86 matching to reduce diffs between various subtargets')
  parser.add_argument(
      '--no_x86_scrub_rip', action='store_false', dest='x86_scrub_rip')
  parser.add_argument(
      '--no_x86_scrub_mem_shuffle', action='store_true', default=False,
      help='Reduce scrubbing shuffles with memory operands')
  parser.add_argument('tests', nargs='+')
  initial_args = common.parse_commandline_args(parser)

  script_name = os.path.basename(__file__)

  for ti in common.itertests(initial_args.tests, parser,
                             script_name='utils/' + script_name):
    triple_in_ir = None
    for l in ti.input_lines:
      m = common.TRIPLE_IR_RE.match(l)
      if m:
        triple_in_ir = m.groups()[0]
        break

    run_list = []
    for l in ti.run_lines:
      if '|' not in l:
        common.warn('Skipping unparseable RUN line: ' + l)
        continue

      commands = [cmd.strip() for cmd in l.split('|', 1)]
      llc_cmd = commands[0]
      llc_tool = llc_cmd.split(' ')[0]

      triple_in_cmd = None
      m = common.TRIPLE_ARG_RE.search(llc_cmd)
      if m:
        triple_in_cmd = m.groups()[0]

      march_in_cmd = None
      m = common.MARCH_ARG_RE.search(llc_cmd)
      if m:
        march_in_cmd = m.groups()[0]

      filecheck_cmd = ''
      if len(commands) > 1:
        filecheck_cmd = commands[1]
      common.verify_filecheck_prefixes(filecheck_cmd)
      if llc_tool not in LLC_LIKE_TOOLS:
        common.warn('Skipping non-llc RUN line: ' + l)
        continue

      if not filecheck_cmd.startswith('FileCheck '):
        common.warn('Skipping non-FileChecked RUN line: ' + l)
        continue

      llc_cmd_args = llc_cmd[len(llc_tool):].strip()
      llc_cmd_args = llc_cmd_args.replace('< %s', '').replace('%s', '').strip()
      if ti.path.endswith('.mir'):
        llc_cmd_args += ' -x mir'
      check_prefixes = [item for m in common.CHECK_PREFIX_RE.finditer(filecheck_cmd)
                               for item in m.group(1).split(',')]
      if not check_prefixes:
        check_prefixes = ['CHECK']

      # FIXME: We should use multiple check prefixes to common check lines. For
      # now, we just ignore all but the last.
      run_list.append((check_prefixes, llc_cmd_args, triple_in_cmd, march_in_cmd))

    if ti.path.endswith('.mir'):
      check_indent = '  '
    else:
      check_indent = ''

    func_dict = {}
    func_order = {}
    for p in run_list:
      prefixes = p[0]
      for prefix in prefixes:
        func_dict.update({prefix: dict()})
        func_order.update({prefix: []})
    for prefixes, llc_args, triple_in_cmd, march_in_cmd in run_list:
      common.debug('Extracted LLC cmd:', llc_tool, llc_args)
      common.debug('Extracted FileCheck prefixes:', str(prefixes))

      raw_tool_output = common.invoke_tool(ti.args.llc_binary or llc_tool, llc_args, ti.path)
      triple = triple_in_cmd or triple_in_ir
      if not triple:
        triple = asm.get_triple_from_march(march_in_cmd)

      asm.build_function_body_dictionary_for_triple(ti.args, raw_tool_output,
          triple, prefixes, func_dict, func_order)

    is_in_function = False
    is_in_function_start = False
    func_name = None
    prefix_set = set([prefix for p in run_list for prefix in p[0]])
    common.debug('Rewriting FileCheck prefixes:', str(prefix_set))
    output_lines = []

    include_generated_funcs = common.find_arg_in_test(ti,
                                                      lambda args: ti.args.include_generated_funcs,
                                                      '--include-generated-funcs',
                                                      True)

    if include_generated_funcs:
      # Generate the appropriate checks for each function.  We need to emit
      # these in the order according to the generated output so that CHECK-LABEL
      # works properly.  func_order provides that.

      # We can't predict where various passes might insert functions so we can't
      # be sure the input function order is maintained.  Therefore, first spit
      # out all the source lines.
      common.dump_input_lines(output_lines, ti, prefix_set, ';')

      # Now generate all the checks.
      common.add_checks_at_end(output_lines, run_list, func_order,
                               check_indent + ';',
                               lambda my_output_lines, prefixes, func:
                               asm.add_asm_checks(my_output_lines,
                                                  check_indent + ';',
                                                  prefixes, func_dict, func))
    else:
      for input_info in ti.iterlines(output_lines):
        input_line = input_info.line
        args = input_info.args
        if is_in_function_start:
          if input_line == '':
            continue
          if input_line.lstrip().startswith(';'):
            m = common.CHECK_RE.match(input_line)
            if not m or m.group(1) not in prefix_set:
              output_lines.append(input_line)
              continue

          # Print out the various check lines here.
          asm.add_asm_checks(output_lines, check_indent + ';', run_list, func_dict, func_name)
          is_in_function_start = False

        if is_in_function:
          if common.should_add_line_to_output(input_line, prefix_set):
            # This input line of the function body will go as-is into the output.
            output_lines.append(input_line)
          else:
            continue
          if input_line.strip() == '}':
            is_in_function = False
          continue

        # If it's outside a function, it just gets copied to the output.
        output_lines.append(input_line)

        m = common.IR_FUNCTION_RE.match(input_line)
        if not m:
          continue
        func_name = m.group(1)
        if args.function is not None and func_name != args.function:
          # When filtering on a specific function, skip all others.
          continue
        is_in_function = is_in_function_start = True

    common.debug('Writing %d lines to %s...' % (len(output_lines), ti.path))

    with open(ti.path, 'wb') as f:
      f.writelines(['{}\n'.format(l).encode('utf-8') for l in output_lines])


if __name__ == '__main__':
  main()
