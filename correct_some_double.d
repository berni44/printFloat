import std.stdio;
import std.datetime: MonoTime;

import f1 = format_old;
import f2 = format_new;

void main(string[] args)
{
    enum format = "%.10f";

    ulong count = 0;
    ulong correct = 0;

    A a;
    foreach (uint i; 0..uint.max)
    {
        if (i%100_000_000==0) { stderr.write("."); stderr.flush(); }
        if (i%77!=0) continue;

        a.u[0] = i;
        a.u[1] = i;

        string r_old = f1.format!format(a.f);
        string r_new = f2.format!format(a.f);

        ++count;
        if (r_old==r_new) ++correct;
    }

    stderr.writeln();

    writefln!"checks: %d\ncorrect: %d"(count,correct);
}

union A
{
    double f;
    uint[2] u;
}
