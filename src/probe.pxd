
cdef extern from "probe.h":

	# External definiton of a static dtrace probe c function with 5 arguments.
	# taken from /usr/include/sys/sdt.h
    void __dtrace_pythonprobes___pythonprobe(unsigned long arg0,
                                             unsigned long arg1,
                                             unsigned long arg2,
                                             unsigned long arg3,
                                             unsigned long arg4)
