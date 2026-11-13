#!/usr/bin/env python3
"""FFR 着色器直连库读数（修前/修后同一把尺子）。

用法：python count_metrics.py <pack/shaders/direct/b-xxxxxxxxxxxx 目录>

打印：
  records                       着色器记录数
  dropped                       "Failed to find handle"（删读置 0）条数
  tbuf_array_records            出现 array<texture_buffer<...>, N> 绑定的着色器数（池数组回退）
  note_one / note_many          本修复新增的两类注记条数
"""
import collections
import glob
import json
import os
import sys

sys.stdout.reconfigure(encoding='utf-8', errors='replace')


def obj_at(d, start):
    depth, in_str, esc = 0, False, False
    for i in range(start, len(d)):
        c = d[i:i + 1]
        if in_str:
            if esc:
                esc = False
            elif c == b'\\':
                esc = True
            elif c == b'"':
                in_str = False
            continue
        if c == b'"':
            in_str = True
        elif c == b'{':
            depth += 1
        elif c == b'}':
            depth -= 1
            if depth == 0:
                return d[start:i + 1]
    return None


def main(root):
    records = dropped = tbuf = note_one = note_many = 0
    paks = sorted(glob.glob(os.path.join(root, '*.pak')))
    for p in paks:
        d = open(p, 'rb').read()
        dropped += d.count(b'Failed to find handle')
        note_one += d.count(b'Bindless handle taken from the one c[2] handle')
        note_many += d.count(b'Bindless handle chosen at run time among')
        pos = 0
        while True:
            i = d.find(b'"notes"', pos)
            if i < 0:
                break
            start = d.rfind(b'{', 0, i)
            pos = i + 1
            chunk = obj_at(d, start) if start >= 0 else None
            if not chunk:
                continue
            try:
                o = json.loads(chunk)
            except Exception:
                continue
            records += 1
            if any('array<texture_buffer' in b.get('msl_type', '') for b in o.get('bindings', [])):
                tbuf += 1
    print('library        ', root)
    print('paks           ', len(paks))
    print('records        ', records)
    print('dropped        ', dropped)
    print('tbuf_array_records', tbuf)
    print('note_one       ', note_one)
    print('note_many      ', note_many)


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])
