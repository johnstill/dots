" Set up the include paths for python.  By calling the python via system, we
" get the right paths whether we're inside a virtual environment or not
let s:prog = join([
\"from __future__ import print_function",
\"import sys",
\"paths = [p for p in sys.path if p]",
\"paths = [p if p.endswith('.zip') else p + '/**' for p in paths]",
\"print(','.join(paths), end='')",
\], "\n")

let s:paths = system('python -c "'.s:prog.'"')
let &path='.,,'.s:paths
