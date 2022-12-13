import std;

void main()
{
	auto input = stdin.byLineCopy.chunkBy!(not!empty).map!"a[1]".filter!"a.front.not!empty"; //read input

	auto stack = input.front                                          // extract first part of the drawing
	                  .map!"a.dropOne.stride(4)"                      // extract characters and numbers
	                  .array                                          // the next call needs a Random Access Range
	                  .transposed!(TransverseOptions.assumeNotJagged) // iterate by columns
	                  .map!(filter!"a >= 'A' && a <= 'Z'")            // keep only [A-Z]
	                  .map!(to!(SList!dchar));                        // store each section into a linked list

	input.dropOne.front                                                   // extract the second part of the drawing
	     .map!(unformatted!("move %s from %s to %s", Repeat!(3, size_t))) // extract digits
	     .map!"tuple(a[0], a[1] - 1, a[2] - 1)"                           // map from & to into offsets
	     .fold!((ref stack, work) {
	         stack[work[2]].insertFront(stack[work[1]][].take(work[0]).array.retro);
	         stack[work[1]].removeFront(work[0]);
	         return stack;
	     })(stack.array)                                                  // perform the operation action by action
	     .map!"a[].front"                                                 // get the top box of each section
	     .writeln;
}

// if merged I'll update this: https://github.com/dlang/phobos/pull/8647
template unformatted(alias fmt, Args...)
{
	Tuple!Args unformatted(Range)(auto ref Range r)
	{
		Tuple!Args args;
		formattedRead!fmt(forward!r, args.expand);
		return args;
	}
}
