import std;

void main()
{
	"/dev/stdin".slurp!(Repeat!(4, double))("%s-%s,%s-%s").array                                  // read input
	            .map!(bind!((begA, endA, begB, endB) => tuple(cmp(begA, endB), cmp(begB, endA)))) // 3 way compare section limits
	            .filter!(bind!((a, b) => only(a, b).any!"a == 0" || a == b))                      // filter contained sections
	            .walkLength                                                                       // how many
	            .writeln;

	// Note: we only need to compare the beginning to end of both sections. If
	// any of them is '0' there's 100% guarantee that either section A contains
	// B or vice-versa. Otherwise, we check for equality. Since the comparison is
	// between 'begA,endB' and 'begB,endA', meaning the second is the inverse,
	// and filter any '0s', if they're the same it means that begA is lower
	// than endB and endA is higher than begB. The inverse equality of this
	// result won't ever happen because it's an impossible result, if begA is
	// higher than endB, then it's impossible for endA to be lower than begB.
}
