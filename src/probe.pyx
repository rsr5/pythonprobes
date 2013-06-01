
cimport probe


def dtrace_probe(*args, **kwargs):
    """
    Fires the static dtrace probe.  You must pass anything up to 5 strings to
    this function and these will be available from dtrace.  For example with
    ``copyinstr(arg0)``.  A string contieing the work ``null`` is returned
    for any args that are not passed.  ``null`` was chosen so that it would
    hopefully not clash with any likely strings users would like to pass to
    the probe.
    """

    def new_args():
        """
        Generator that converts the python strings to byte strings and then
        returns their addresses to be passed to the dtrace probe function below.
        """
        cdef bytes py_bytes
        cdef char* arg
        cdef unsigned long addr

        for x in xrange(5):
            try:
                arg = args[x]
            except IndexError:
                arg = "null"

            py_bytes = arg.encode()
            arg = py_bytes
            addr = <unsigned long>arg

            # Return the strings and addresses as otherwise the strigns get
            # thrown away before a D script has time to copy the string over
            # using copyinstr()
            yield (py_bytes, arg, addr)

    alist = list(new_args())
    # I would have liked to use starred notation here but it is not allowed
    # when calling a c function.
    probe.__dtrace_pythonprobes___pythonprobe(alist[0][2], alist[1][2],
                                              alist[2][2], alist[3][2],
                                              alist[4][2])
