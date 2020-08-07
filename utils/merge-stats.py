#!/usr/bin/env python3
'''
Merge .stats files generated by llvm tools

merge-stats.py takes as argument a list of stats files to merge
and output the result on stdout

Usage:
  merge-stats.py $(find ./builddir/ -name "*.stats") > total.stats
'''

import json
import sys

result = {}

for arg in range(1, len(sys.argv)):
  with open(sys.argv[arg], "r", encoding='utf-8',
            errors='ignore') as f:
    text = f.read()
    try:
      data = json.loads(text)
    except:
      print('ignored %s: failed to parse' % sys.argv[arg], file= sys.stderr)
      continue
    for key in data:
      if key in result:
        result[key] += data[key]
      else:
        result[key] = data[key]

out = json.dumps(result, indent=2)
print(out)
