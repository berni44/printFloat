import std.stdio;
import std.datetime: MonoTime;
import std.bigint;

import f1 = format_old;
import f2 = format_new;

void main(string[] args)
{
    enum format = "%100.40f";

    BigInt count = BigInt(0);
    BigInt correct = BigInt(0);

    A a;
    foreach (uint i; 0..uint.max)
    {
        if (i%100_000_000==0) { stderr.write("."); stderr.flush(); }

        a.u = i;

        string r_old = f1.format!format(a.f);
        string r_new = f2.format!format(a.f);

        ++count;
        if (r_old==r_new) ++correct;
    }

    a.u = uint.max;
    string r_old = f1.format!format(a.f);
    string r_new = f2.format!format(a.f);

    ++count;
    if (r_old==r_new) ++correct;

    stderr.writeln();

    writefln!"checks: %d\ncorrect: %d"(count,correct);
}

union A
{
    float f;
    uint u;
}
