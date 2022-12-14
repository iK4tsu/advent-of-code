import std;

void main()
{
	stdin.readln                                                                         // read input
	     .slide(4)                                                                       // iterate in groups of 4
	     .until!(str => str.enumerate(1).all!(bind!((i, c) => !str.drop(i).canFind(c)))) // find the first unique group
	     .walkLength.only(4).sum                                                         // how many characters
	     .writeln;

	// Note: the number of characters is counted by summing the number of groups
	// iterated until one with all characters different (exclusive) with the
	// length of each group:
	// [a, b, a, d, e, r, ...]
	// [a, b, a, d], [b, a, d, e]: 1 + 4 = 5
}
