#!/usr/sbin/dtrace -qs

/**
 Prints out the arguments passed from Python
*/

pythonprobes*:::pythonprobe
{
    printf("%s || ", copyinstr(arg0));
    printf("%s || ", copyinstr(arg1));
    printf("%s || ", copyinstr(arg2));
    printf("%s || ", copyinstr(arg3));
    printf("%s", copyinstr(arg4));
}

