import std;

void main()
{
	stdin.byLineCopy.array                                     // read input
		 .splitter("")                                         // group by elves' calories
		 .map!(map!(to!size_t))                                // map each calory to a number
		 .map!sum                                              // sum each elf's calories
		 .fold!((result, n) {                                  // get top 3 elves
			result.minPos.takeOne.filter!(i => n > i).fill(n); // + replace the lowest calory by if lower than the newest
			return result;                                     // + return the top 3 calory sum
		 })(size_t[3].init[]) // stack allocated buffer
		 .sum                                                  // sum remaining calories
		 .writeln;
}
