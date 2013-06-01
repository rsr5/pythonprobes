"""
Contains a harmless function that does nothing so that the pythonprobes
library may be included in projects that need to run on platforms that
do not support DTrace as well as those that do.
"""


def dtrace_probe(*args, **kwargs):
    """
    Fires the static dtrace probe.  You must pass anything up to 5 strings to
    this function and these will be available from dtrace.  For example with
    ``copyinstr(arg0)``.  A string containing the work ``null`` is returned
    for any args that are not passed.  ``null`` was chosen so that it would
    hopefully not clash with any likely strings users would like to pass to
    the probe.
    """
    pass
