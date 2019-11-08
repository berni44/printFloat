import std.stdio;
import std.datetime: MonoTime;
import std.random;
import std.math;

import f1 = format_old;
import f2 = format_new;

void main(string[] args)
{
    FloatingPointControl fpctrl;

    auto r_tab = [FloatingPointControl.roundDown, FloatingPointControl.roundUp,
                  FloatingPointControl.roundToZero, FloatingPointControl.roundToNearest];

    uint seed = uniform(0,uint.max);
    writeln("seed: ",seed);
    auto rnd = Random(seed);

    ulong count = 0;
    ulong correct = 0;

    foreach (i;0..100_000_000)
    {
        if (i%10_000_000==0) { stderr.write("."); stderr.flush(); }

        A a;
        a.u[0] = uniform!"[]"(0,uint.max,rnd);
        a.u[1] = uniform!"[]"(0,uint.max,rnd);

        import std.conv: to;
        string format = "%"
            ~ (uniform(0,2,rnd)==0?"-":"")
            ~ (uniform(0,2,rnd)==0?"+":"")
            ~ (uniform(0,2,rnd)==0?" ":"")
            ~ (uniform(0,2,rnd)==0?"0":"")
            ~ (uniform(0,2,rnd)==0?"#":"")
            ~ (uniform(0,100,rnd)==0?to!string(uniform(0,200,rnd)):"")
            ~ (uniform(0,100,rnd)==0?"." ~ to!string(uniform(0,200,rnd)):"")
            ~ "fF"[uniform(0,2,rnd)];

        fpctrl.rounding = r_tab[uniform(0,4,rnd)];

        string r_old = f1.format(format,a.f);
        string r_new = f2.format(format,a.f);

        ++count;
        if (r_old==r_new) ++correct;
    }
    stderr.writeln();

    writeln("seed: ",seed);
    writefln!"checks: %d\ncorrect: %d"(count,correct);
}

union A
{
    double f;
    uint[2] u;
}
