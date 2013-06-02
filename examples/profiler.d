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

