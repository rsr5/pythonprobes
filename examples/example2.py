'''
Another example of using the Python DTrace probes.

@author: rsr5
'''
from probe import dtrace_probe


SOME_WORDS = """
Sun Microsystems designed DTrace to give operational insights that allow users
to tune and troubleshoot applications and the OS itself.

Testers write tracing programs (also referred to as scripts) using the D
programming language (not to be confused with other programming languages
named "D"). The language, a subset of C, includes added functions and variables
specific to tracing. D programs resemble awk programs in structure; they
consist of a list of one or more probes (instrumentation points), and each
probe is associated with an action. These probes are comparable to a pointcut
in aspect-oriented programming. Whenever the condition for the probe is met,
the associated action is executed (the probe "fires"). A typical probe might
fire when a certain file is opened, or a process is started, or a certain
line of code is executed. A probe that fires may analyze the run-time situation
by accessing the call stack and context variables and evaluating expressions;
it can then print out or log some information, record it in a database, or
modify context variables. The reading and writing of context variables allows
probes to pass information to each other, allowing them to cooperatively
analyze the correlation of different events.
"""


def main():
    while True:
        for word in SOME_WORDS.split(" "):
            dtrace_probe(word.rstrip("\n"))

if __name__ == '__main__':
    raw_input("Run the DTrace script and then hit return.")
    main()
