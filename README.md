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
