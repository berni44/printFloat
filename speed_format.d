import std.stdio;
import std.datetime: MonoTime;
import std.random;
import std.math;
import core.memory;

import f1 = format_old;
import f2 = format_new;

void main(string[] args)
{
    enum format = "%f";

    uint seed = uniform(0,uint.max);
    stderr.writeln("seed: ",seed);
    auto rnd = Random(seed);

    ulong count = 0;
    ulong[2] sum = 0;

    ulong[256][2] e_sum = 0;
    ulong[256] e_count = 0;

    ulong faster = 0;

    foreach (i;0..100_000_000)
    {
        if (i%1_000_000==0) { stderr.write("."); stderr.flush(); }

        A a;
        a.u = uniform!"[]"(0,uint.max,rnd);
        int exp = (a.u >> 23) & ((1L << 8) - 1);

        string r_old;
        string r_new;

        ulong d1;
        ulong d2;

        {
            GC.minimize();
            auto start = MonoTime.currTime;
            r_old = f1.format!format(a.f);
            auto delta = (MonoTime.currTime-start).total!"nsecs";

            d1 = delta;
        }

        {
            GC.minimize();
            auto start = MonoTime.currTime;
            r_new = f2.format!format(a.f);
            auto delta = (MonoTime.currTime-start).total!"nsecs";

            d2 = delta;
        }

        ++count;
        sum[0] += d1;
        sum[1] += d2;

        ++e_count[exp];

        e_sum[0][exp] += d1;
        e_sum[1][exp] += d2;

        if (d2<d1) ++faster;

    }
    stderr.writeln();

    foreach (i;0..256)
        writeln(e_sum[0][i]/e_count[i], " ", e_sum[1][i]/e_count[i]);
    writeln;
    writeln(sum[0]/count, " ",sum[1]/count," ",faster," ",count);
}

union A
{
    float f;
    uint u;
}
