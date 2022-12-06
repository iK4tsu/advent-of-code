import std;

void main()
{
	stdin.byLineCopy.array      // read input
		 .splitter("")          // group by elves' calories
		 .map!(map!(to!size_t)) // map each calory to a number
		 .map!sum               // sum each elf's calories
		 .maxElement            // get the highest calory
		 .writeln;
}
