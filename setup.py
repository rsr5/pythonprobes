
from distutils.core import setup
from distutils.extension import Extension

from build_ext import build_ext

setup(
    ext_modules=[Extension("probe", ["src/probe.c"],
                           include_dirs=["include"])],
    cmdclass={'build_ext': build_ext}
)
