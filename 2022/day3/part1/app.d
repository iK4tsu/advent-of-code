import std;

void main()
{
	immutable letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"; // characters ordered by weight
	stdin.byLineCopy.array                                                      // read input
	     .map!(str => str.representation.evenChunks(2))                         // split in 2 compartements
	     .map!(chunk => chunk.front.findAmong(chunk.back).front)                // find the duplicated item
	     .map!(ch => letters.countUntil(ch) + 1)                                // calculate the weight
	     .sum                                                                   // get the total amount
	     .writeln;
}
