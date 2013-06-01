
from distutils.core import setup
from distutils.extension import Extension

from build_ext import build_ext

setup(
    name='pythonprobes',
    version='1.0',
    description='Static DTrace Probes for Python Applications',
    author='rsr5',
    url='https://github.com/rsr5/pythonprobes',
    ext_modules=[Extension('probe', ['src/probe.c'],
                           include_dirs=['include'])],
    cmdclass={'build_ext': build_ext}
)
