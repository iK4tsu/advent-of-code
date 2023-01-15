import std;

void main()
{
	const grid = stdin.byLineCopy.array; // read input into matrix
	const height = grid.length;          // matrix height
	const width = grid.front.length;     // matrix width
	size_t scenic;                       // highest scenic score

	foreach (y; 0 .. height)
	foreach (x; 0 .. width)
	{
		const elem = grid[y][x];

		// trees seen in a range direction from the current elem
		size_t check(R)(R range)
		{
			// stop when a tree taller or equal is found
			return range.until!(bind!((y, x) => elem <= grid[y][x]))(No.openRight).walkLength;
		}

		const seen = check(zip(y.repeat(width - x), x.iota(width).dropOne))   // right
		           * check(zip(y.iota(height).dropOne, x.repeat(height - y))) // bottom
		           * check(zip(y.repeat(x), 0.iota(x).retro))                 // left
		           * check(zip(0.iota(y).retro, x.repeat(y)));                // top

		scenic = max(scenic, seen); // always keep the maximum score
	}

	scenic.writeln;
}
