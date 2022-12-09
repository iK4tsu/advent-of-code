import std;

void main()
{
	"/dev/stdin".slurp!(Repeat!(4, double))("%s-%s,%s-%s").array                                  // read input
	            .map!(bind!((begA, endA, begB, endB) => tuple(cmp(begA, begB), cmp(endB, endA)))) // 3 way compare section limits
	            .filter!(bind!((a, b) => only(a, b).any!"a == 0" || a == b))                      // filter fully contained sections
	            .walkLength                                                                       // how many
	            .writeln;

	// Note: we only need to compare the beginning of both sections and the ends
	// to themselves. If any of them is '0' there's a 100% guarantee that either
	// section A fully contains B or vice-versa. Otherwise we check for equality,
	// since the comparison is between 'begA,begB' and 'endB,endA', meaning
	// the second is the inverse, and filter any '0s', if they're the same it
	// means that begA is lower than begB and endA is higher than endB or
	// vice-versa.
}
