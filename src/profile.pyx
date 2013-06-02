from python25 cimport PyFrameObject, PyObject, PyStringObject

from probe import dtrace_probe

cdef extern from "frameobject.h":
    ctypedef int (*Py_tracefunc)(object self, PyFrameObject *py_frame, int what, PyObject *arg)


cdef extern from "Python.h":
    cdef void PyEval_SetProfile(Py_tracefunc func, object arg)
    cdef void PyEval_SetTrace(Py_tracefunc func, object arg)

    cdef int PyTrace_CALL
    cdef int PyTrace_EXCEPTION
    cdef int PyTrace_LINE
    cdef int PyTrace_RETURN
    cdef int PyTrace_C_CALL
    cdef int PyTrace_C_EXCEPTION
    cdef int PyTrace_C_RETURN


cdef extern from "unset_trace.h":
    void unset_trace()


cdef class DTraceProfiler:
    """ Fire a DTrace probe on every line execution.
    """
    def enable(self):
        PyEval_SetTrace(python_trace_callback, self)

    def disable(self):
        self.last_time = {}
        unset_trace()

    def run(self, cmd):
        """ Profile a single executable statment in the main namespace.
        """
        import __main__
        dict = __main__.__dict__
        return self.runctx(cmd, dict, dict)

    def runctx(self, cmd, globals, locals):
        """ Profile a single executable statement in the given namespaces.
        """
        self.enable()
        try:
            exec cmd in globals, locals
        finally:
            self.disable()
        return self


cdef int python_trace_callback(object self, PyFrameObject *py_frame, int what,
    PyObject *arg):
    """ The PyEval_SetTrace() callback.  Fires the DTrace probe.
    """
    if what == PyTrace_LINE or what == PyTrace_RETURN:
        code = <object>py_frame.f_code
        line_or_return = "RETURN" if what == PyTrace_RETURN else "LINE"
        dtrace_probe(code.co_filename, str(py_frame.f_lineno), line_or_return)
