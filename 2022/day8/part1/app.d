import std;

/*
given the input:

30373
25512
65332
33549
35390

it is possible to check all visible trees in a row/column with one passage by
keeping track of the tallest seen tree. So, looking left to right,

30373 - '3' can be seen, so it is stored as the current tallest tree
^

30373 - '0' cannot be seen so it is skipped
 ^

30373 - '3' same as above
  ^

30373 - '7' can be seen, store it as the tallest tree
   ^

30373 - '3' cannot be seen
    ^

the end was reached, [3, 7] are the only trees that can be seen looking left to
right with positions [0, 3]

by following the same procedure for each row we have all positions [y, x] of
seen trees left to right, and by reversing, all seen trees right to left
this can be replicated for each column giving all positions [x, y]
*/
auto visibleTrees(Range)(Range r)
{
	auto visibleTreesImpl(R)(R range)
	{
		struct VisibleTrees
		{
			this(R range)
			{
				this.range = range;
			}

			void popFront() { return skipUnseen(); }
			bool empty() { return range.empty; }
			auto front() { return xpos; }

			private auto skipUnseen()
			{
				tallest = range.front;
				do
				{
					range.popFront;
					xpos++;
				} while (!range.empty && range.front <= tallest);
			}

			R range;
			Unqual!(typeof(range.front)) tallest;
			size_t xpos;
		}

		return VisibleTrees(range);
	}

	return chain(visibleTreesImpl(r), visibleTreesImpl(r.retro).map!(i => r.walkLength - (i + 1)));
}

template byVisibleTrees(string pos)
{
	static if (pos == "y")
		alias Coords(Args...) = Args;
	else    // pos == "x"
		alias Coords(Args...) = Reverse!Args;

	/// range that iterates the grid by all visible trees from outside if it
	auto byVisibleTrees(R)(R range)
	{
		return range.map!visibleTrees.enumerate                                         // index every row
					.map!(bind!((n, trees) => trees.map!(i => TreeLoc(Coords!(n, i))))) // locations of all seen trees
					.joiner;                                                            // flatten
	}
}


alias TreeLoc = Tuple!(size_t, size_t); /// Tree Location in (Y, X)

void main()
{
	const grid = stdin.byLineCopy.array;                                   // read input into grid
	auto tgrid = grid.front.length.iota.map!(partial!(transversal, grid)); // transposed grid
	chain(grid.byVisibleTrees!"y", tgrid.byVisibleTrees!"x").redBlackTree  // tallest seen trees into a set of unique positions
	                                                        .length        // number of seen trees outside the grid
	                                                        .writeln;
}
