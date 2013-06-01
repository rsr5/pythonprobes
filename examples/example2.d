#!/usr/sbin/dtrace -qs

/*
 Displays the top ten words trace per second.
 */

/* Count words */
pythonprobes*:::pythonprobe
{
    @words[copyinstr(arg0)] = count();
}

/* Display data and truncate the aggregation. */
tick-1sec
{
    trunc(@words, 10);
    printf("Top Ten Words this Second\n\n");
    printa(@words);
    clear(@words);
}

