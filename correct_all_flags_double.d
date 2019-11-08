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

    auto f_tab = [double.nan, double.infinity, -double.nan, -double.infinity, 0.0, -0.0,
                  1.0,0.1,1e10,1e-10,1e20,1e-20,1e30,1e-30,1e-40,1e100,1e-100,1e300,1e-300,
                  1.23456789,1.23456789e10,1.23456789e20,1.23456789e30,1.23456789e100,1.23456789e300,
                  1.23456789e-1,1.23456789e-10,1.23456789e-20,1.23456789e-30,1.23456789e-100,1.23456789e-300,
                  -1.0,-0.1,-1e10,-1e-10,-1e20,-1e-20,-1e30,-1e-30,-1e-40,-1e100,-1e300,
                  -1.23456789,-1.23456789e10,-1.23456789e20,-1.23456789e30,-1.23456789e100,-1.23456789e300,
                  -1.23456789e-1,-1.23456789e-10,-1.23456789e-20,-1.23456789e-30,-1.23456789e-100,1.123456789e-300,
                  1.010101010101010101010101010101, 9.989898989898989898989898989898,76767676767.7676767676767676767,
                  -29610.9609375, 26535.5078125,
                  0.1,0.02,0.003,0.004,0.0005,0.00006,0.000007,0.0000008,0.00000009,
                  10,200,3000,40000,500000,6000000,70000000,8000000000,90000000000];

    auto w_tab = ["", "0", "1", "5", "10", "25", "100", "125", "200", "500", "1000"];
    auto p_tab = ["", ".0", ".1", ".5", ".10", ".25", ".100", ".125", ".200", ".500", ".1000"];
    auto s_tab = "fF";

    ulong count = 0;
    ulong correct = 0;

    foreach (r;r_tab)
    {
        fpctrl.rounding = r;

        foreach (f;f_tab)
            foreach (flag;0..32)
                foreach (width;w_tab)
                    foreach (precision;p_tab)
                        foreach (spec;s_tab)
                        {
                            string format = "%"
                                ~ ((flag&1)==0?"-":"")
                                ~ ((flag&2)==0?"+":"")
                                ~ ((flag&4)==0?" ":"")
                                ~ ((flag&8)==0?"0":"")
                                ~ ((flag&16)==0?"#":"")
                                ~ width
                                ~ precision
                                ~ spec;

                            double d = f; // make sure that we use a double

                            string r_old = f1.format(format,d);
                            string r_new = f2.format(format,d);

                            ++count;
                            if (r_old==r_new) ++correct;
                        }
    }

    writefln!"checks: %d\ncorrect: %d"(count,correct);
}
