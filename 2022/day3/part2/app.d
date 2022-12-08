import std;

void main()
{
	immutable letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";    // characters ordered by weight
	stdin.byLineCopy.array                                                         // read input
	     .slide!(No.withPartial)(3, 3)                                             // iterate by groups of 3
	     .map!(chunk => chunk.front.findAmong(chunk[1]).findAmong(chunk[2]).front) // find the badge
	     .map!(ch => letters.countUntil(ch) + 1)                                   // calculate the weight
	     .sum                                                                      // get the total amount
	     .writeln;
}
