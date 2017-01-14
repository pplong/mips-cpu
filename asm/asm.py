# -*- coding: utf-8 -*-

import sys
import re

CUR_LINE = 0

def message(level):
  def print_msg(*args):
    print('{}(line {}): '.format(level, CUR_LINE), args, file=sys.stderr)
    if level == 'ERROR':
      sys.exit(1)
  return print_msg

info = message('INFO')
warning = message('WARNING')
error = message('ERROR')

def form_bits(f, b):
  if f >= 0:
    if f >= 2**b:
      error('domain error')
    else:
      return f
  else:
    return ((-f) ^ (2**b - 1)) + 1

def form_word(fields, bits):
  res = 0
  for (f, b) in zip(fields, bits):
    res = (res << b) | form_bits(f, b)
  return res

def opform(fields, bits):
  def form(kwargs):
    field_values = []
    for f in fields:
      if f in kwargs:
        field_values.append(kwargs[f])
      else:
        field_values.append(0)
    return form_word(field_values, bits)
  return form

Rform = opform(['opcode', 'rs', 'rt', 'rd', 'shamt', 'funct'], [6, 5, 5, 5, 5, 6])
Iform = opform(['opcode', 'rs', 'rt', 'immediate'], [6, 5, 5, 16])
Jform = opform(['opcode', 'address'], [6, 26])
FRform = opform(['opcode', 'fmt', 'ft', 'fs', 'fd', 'funct'], [6, 5, 5, 5, 5, 6])
FIform = opform(['opcode', 'fmt', 'ft', 'immediate'], [6, 5, 5, 16])
DATAform = opform(['data'], [32])

PSEUDO_INSTRUCTIONS = ['BLT', 'BGT', 'BLE', 'BGE', 'LI', 'MOVE', 'NOP', 'FBEQ', 'FBNE', 'FBGT', 'FBLE']
MNEMONICS = set(PSEUDO_INSTRUCTIONS)
NUM_ARGS = {'BLT': 3, 'BGT': 3, 'BLE': 3, 'BGE': 3, 'LI': 2, 'MOVE': 2, 'NOP': 0, 'FBEQ': 3, 'FBNE': 3, 'FBGT': 3, 'FBLE': 3}

def make_op(name, form, argnames, **defaultargs):
  global MNEMONICS
  global NUM_ARGS
  MNEMONICS.add(name.upper())
  NUM_ARGS[name.upper()] = len(argnames)

  def op(*args):
    args_kw = dict()
    for (a, v) in zip(argnames, args):
      args_kw[a] = v
    for a in defaultargs:
      args_kw[a] = defaultargs[a]
    return form(args_kw)
  return op

# 3-register R-form
RFORM_3REGS_ARGS = ['rd', 'rs', 'rt']
AND = make_op('and', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x24)
OR = make_op('or', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x25)
NOR = make_op('nor', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x27)
# MULT = make_op('mult', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x18)
# DIV = make_op('div', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x1a)
# REM = make_op('rem', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x1b)
ADD = make_op('add', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x20)
SUB = make_op('sub', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x22)
SLT = make_op('slt', Rform, RFORM_3REGS_ARGS, opcode=0, funct=0x2a)
SYNTH = make_op('synth', Rform, ['rs'], opcode=0x3f, rt=0, rd=0, shamt=0, funct=0)

# R-form(others)
SLL = make_op('sll', Rform, ['rd', 'rs', 'shamt'], opcode=0, funct=0x00)
SRL = make_op('srl', Rform, ['rd', 'rs', 'shamt'], opcode=0, funct=0x02)
JR = make_op('jr', Rform, ['rs'], opcode=0, funct=0x08)
IN = make_op('in', Rform, ['rd'], opcode=0x01, funct=0x00)
OUT = make_op('out', Rform, ['rs'], opcode=0x01, funct=0x01)
FMOV = make_op('fmov', Rform, ['rd', 'rs'], opcode=0x33, funct=0x00)
FNEG = make_op('fneg', Rform, ['rd', 'rs'], opcode=0x33, funct=0x01)

# I-form
IFORM_ARGS = ['rt', 'rs', 'immediate']
ANDI = make_op('andi', Iform, IFORM_ARGS, opcode=0x0c)
ORI = make_op('ori', Iform, IFORM_ARGS, opcode=0x0d)
ADDI = make_op('addi', Iform, IFORM_ARGS, opcode=0x08)
BEQ = make_op('beq', Iform, IFORM_ARGS, opcode=0x04)
BNE = make_op('bne', Iform, IFORM_ARGS, opcode=0x05)
LW = make_op('lw', Iform, IFORM_ARGS, opcode=0x23)
LWC = make_op('lwc', Iform, IFORM_ARGS, opcode=0x24)
SW = make_op('sw', Iform, IFORM_ARGS, opcode=0x2b)
LWCL = make_op('lwcl', Iform, IFORM_ARGS, opcode=0x31)
LWCLC = make_op('lwclc', Iform, IFORM_ARGS, opcode=0x32)
SWCL = make_op('swcl', Iform, IFORM_ARGS, opcode=0x39)

# J-form
JFORM_ARGS = ['address']
J = make_op('j', Jform, JFORM_ARGS, opcode=0x02)
JAL = make_op('jal', Jform, JFORM_ARGS, opcode=0x03)

# FR-form
FRFORM_ARGS = ['fd', 'fs', 'ft']
FADD = make_op('fadd', FRform, FRFORM_ARGS, opcode=0x11, fmt=0x10, funct=0x00)
FSUB = make_op('fsub', FRform, FRFORM_ARGS, opcode=0x11, fmt=0x10, funct=0x01)
FMUL = make_op('fmul', FRform, FRFORM_ARGS, opcode=0x11, fmt=0x10, funct=0x02)
FINV = make_op('finv', FRform, ['fd', 'fs'], opcode=0x11, fmt=0x10, funct=0x03, ft=0)
FSLT = make_op('fslt', FRform, FRFORM_ARGS, opcode=0x12, fmt=0x10, funct=0x00)
FEQ  = make_op('feq',  FRform, FRFORM_ARGS, opcode=0x12, fmt=0x10, funct=0x01)

# Data
DATA = make_op('data', DATAform, ['data'])

# BreakPoint
BP = make_op('bp', Jform, [], opcode=0x3f, address=0)

# translate
def trans(labels, args, addr, absolute):
  res = []
  for a in args:
    if a[0] == '%':
      a = a[1:]
    if re.match('0x[0-9A-Fa-f]+', a):
      res.append(int(a[2:], 16))
    elif re.match('-?\d+', a):
      res.append(int(a))
    elif re.match('r\d+', a):
      res.append(int(a[1:]))
    elif re.match('f\d+', a):
      res.append(int(a[1:]))
    elif a in labels:
      laddr = labels[a]
      if absolute:
        res.append(laddr)
      else:
        res.append(laddr - 1 - addr)
    else:
      error('invalid operand: "{}"'.format(a))
  return res

# output 32bit integer (big endian)
def out32(f, v):
  a, b, c, d = (v >> 24), ((v >> 16) & 255), ((v >> 8) & 255), (v & 255)
  f.write(bytes([a, b, c, d]))

# main process
def main():
  global CUR_LINE

  if len(sys.argv) < 3:
    print('python asm.py [infile] [outfile]', file=sys.stderr)
    return 0

  with open(sys.argv[1], 'r') as infile:
    instructions = []
    label_names = set()

    # read program
    for line in infile.readlines():
      CUR_LINE += 1
      instr = re.sub(r'#.*', '', line).strip()

      if len(instr) > 0:
        if instr[-1] == ':':
          lname = instr[:-1]
          instructions.append((CUR_LINE, 'label', instr[:-1]))
          if lname in label_names:
            error('duplicate label names: "{}"'.format(lname))
          else:
            label_names.add(lname)
        else:
          if instr.upper() == 'NOP' or instr.upper() == 'BP':
            mnemonic = instr
            args = ''
          else:
            mnemonic, args = re.split(r'\W+', instr, maxsplit=1)
          mnemonic = mnemonic.upper()
          if mnemonic not in MNEMONICS:
            error('invalid mnemonic: "{}"'.format(mnemonic))
          args = re.sub(r'\s+', '', args).split(',')
          if args[0] == '':
            args = []
          if len(args) != NUM_ARGS[mnemonic]:
            error('{} takes exactly {} arguments ({} given)'.format(mnemonic, NUM_ARGS[mnemonic], len(args)))
          instructions.append((CUR_LINE, mnemonic.upper(), args))

    # process pseudo-instructions and labels
    CUR_LINE = 0
    regular_instructions = []
    label_addrs = dict()
    for (cl, mnemonic, args) in instructions:
      CUR_LINE = cl
      if mnemonic == 'label':
        label_addrs[args] = len(regular_instructions)
      elif mnemonic in PSEUDO_INSTRUCTIONS:
        if mnemonic == 'LI':
          regular_instructions.append([CUR_LINE, 'ADDI', [args[0], '0', args[1]]])
        elif mnemonic == 'MOVE':
          regular_instructions.append([CUR_LINE, 'ADD', [args[0], '0', args[1]]])
        elif mnemonic == 'NOP':
          regular_instructions.append([CUR_LINE, 'SLL', ['0', '0', '0']])
        elif mnemonic == 'BLT':
          regular_instructions.append([CUR_LINE, 'SLT', ['1', args[0], args[1]]])
          regular_instructions.append([CUR_LINE, 'BNE', ['0', '1', args[2]]])
        elif mnemonic == 'BGT':
          regular_instructions.append([CUR_LINE, 'SLT', ['1', args[1], args[0]]])
          regular_instructions.append([CUR_LINE, 'BNE', ['0', '1', args[2]]])
        elif mnemonic == 'BLE':
          regular_instructions.append([CUR_LINE, 'SLT', ['1', args[1], args[0]]])
          regular_instructions.append([CUR_LINE, 'BEQ', ['0', '1', args[2]]])
        elif mnemonic == 'BGE':
          regular_instructions.append([CUR_LINE, 'SLT', ['1', args[0], args[1]]])
          regular_instructions.append([CUR_LINE, 'BEQ', ['0', '1', args[2]]])
        elif mnemonic == 'FBEQ':
          regular_instructions.append([CUR_LINE, 'FEQ', ['1', args[0], args[1]]])
          regular_instructions.append([CUR_LINE, 'BNE', ['0', '1', args[2]]])
        elif mnemonic == 'FBNE':
          regular_instructions.append([CUR_LINE, 'FEQ', ['1', args[0], args[1]]])
          regular_instructions.append([CUR_LINE, 'BEQ', ['0', '1', args[2]]])
        elif mnemonic == 'FBGT':
          regular_instructions.append([CUR_LINE, 'FSLT', ['1', args[1], args[0]]])
          regular_instructions.append([CUR_LINE, 'BNE', ['0', '1', args[2]]])
        elif mnemonic == 'FBLE':
          regular_instructions.append([CUR_LINE, 'FSLT', ['1', args[1], args[0]]])
          regular_instructions.append([CUR_LINE, 'BEQ', ['0', '1', args[2]]])
      else:
        regular_instructions.append([CUR_LINE, mnemonic, args])

    # label/register translate
    for addr in range(len(regular_instructions)):
      instr = regular_instructions[addr]
      CUR_LINE = instr[0]
      label_rel = instr[1] == 'BEQ' or instr[1] == 'BNE'
      regular_instructions[addr][2] = trans(label_addrs, regular_instructions[addr][2], addr, not label_rel)

    # output
    with open(sys.argv[2], 'wb') as outfile:
      out32(outfile, len(regular_instructions))
      for (line, op, args) in regular_instructions:
        CUR_LINE = line
        out32(outfile, eval('{}(*args)'.format(op)))

if __name__ == '__main__':
  main()
