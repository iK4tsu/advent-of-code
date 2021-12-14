import std;

void main()
{
	auto input = stdin.byLine.map!`a.map!"(a - '0').to!int".array`.joiner.array;
	auto safe = [9.repeat(11).array].chain(input.chunks(10).map!"9~a").chain([9.repeat(11).array]);
	generate!(() {
		size_t[] next = input.enumerate.filter!"a.value == 9".map!"a.index".array;
		while (!next.empty) {
			next = next.map!"a+12+a/10".map!((i) {
				const arr = safe.array.join;
				return (i-12).iota(i-9).chain([i-1, i+1], (i+10).iota(i+13)) // adjacent
					.filter!"a < 132".filter!(i => arr[i] != 9)              // ignore adjacent with '9'
					.map!"a-12".map!"a-a/11"                                 // map to input layout
					.filter!(i => ++input[i] == 9).array;                    // aquire next adjacent
			}).array.join.map!"a.to!size_t".array;                           // update next adjacents
		}
		input.each!((ref i) => i += i >= 9 ? -i : 1);
		return input;
	}).take(100).map!`a.filter!"!a".walkLength`.sum.writeln;
}
