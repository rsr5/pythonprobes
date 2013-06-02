pythonprobes
============

Fire a static Dtrace probe from Python with the ability to pass arbitrary strings to Dtrace.  Makes it possible to add static Dtrace probes to any Python project without knowing any C.

Install
-------

Download, and run:

```
python setup.py install
```

Example
-------

Save the following script to a file and set to have execute permissions.

```
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
    printf("%s\n", copyinstr(arg4));
}
```

And then run the following in a Python shell:

```Python
import probe
```

It is important to import ```probe``` before running the D script as otherwise
the Dtrace probe will not be installed when you run the D script.

Now run your Dtrace as root or a privileged user in another terminal.

```
./example.d
```

Run the following in your Python shell.

```Python
for i in xrange(6):
    probe.dtrace_probe(*[str(x) for x in xrange(i)])

```

And you should see the following output from the Dtrace script.

```
null || null || null || null || null
0 || null || null || null || null
0 || 1 || null || null || null
0 || 1 || 2 || null || null
0 || 1 || 2 || 3 || null
0 || 1 || 2 || 3 || 4

```

DTraceProfiler
==============

Is a line level profiler for Python that utilizes the ```pythonprobes```
package above and DTrace to gather line level profiling statistics on a
Python program.

Consider the following Python program:

```Python
from time import sleep

from profiler import DTraceProfiler

def tester():
    print "Hello"
    x = 1
    x = x + x + x
    print "Good Bye"
    sleep(1)

def main():
    for i in xrange(15):
        tester()

pr = DTraceProfiler()
pr.run("main()")
```

When run in conjunction with the following D script:

```
#!/usr/sbin/dtrace -qs

self uint64_t lasttime;

BEGIN{
    self->lasttime = 0;
}

pythonprobes*:::pythonprobe
/self->lasttime == 0/
{
    self->lasttime = walltimestamp;
}


pythonprobes*:::pythonprobe
/self->lasttime != 0/
{
   @[copyinstr(arg1), copyinstr(arg0)] = sum(walltimestamp - self->lasttime);
   self->lasttime = walltimestamp;
}
```

The following output is returned after pressing ctrl-c on the D script.

```
root@southside:~# ~robin/workspace/dprobes/examples/profiler.d 
^C

  1                                                   /var/tmp/test.py                                                  0
  1                                                   <string>                                                          0
  14                                                  /var/tmp/test.py                                                  0
  6                                                   /var/tmp/test.py                                                  0
  7                                                   /var/tmp/test.py                                                  0
  8                                                   /var/tmp/test.py                                                  0
  9                                                   /var/tmp/test.py                                                  0
  13                                                  /var/tmp/test.py                                            9919833
  10                                                  /var/tmp/test.py                                        15020029009
root@southside:~# 
```

We can see that the program spends around 15 seconds in line 10 of ```test.py```
which is what would be expected with this program.  Line 10
```for i in xrange(15):``` is the second hot spot.
