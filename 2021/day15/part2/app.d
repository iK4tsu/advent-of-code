import std;

void main()
{
	struct Point { size_t x; size_t y; }
	struct Node  { Point to; size_t cost; }

	auto input = stdin.byLineCopy
		.map!`a.map!"(a - '0').to!size_t".array`
		.map!`a.repeat(5).enumerate`
		.map!(arr => arr.map!(a => a.value.map!(d => (d + a.index - 1) % 9 + 1).array))
		.map!join.array.repeat(5).enumerate
		.map!(arr => arr.value.map!(inner => inner.map!(d => (d + arr.index - 1) % 9 + 1).array))
		.join;

	const limit = size_t(9).repeat(input.front.length + 2).array;
	auto costs = [limit].chain(input.map!`[size_t(9)]~a~[size_t(9)]`).chain([limit]).array;

	alias neighborsOf = (Point point) { with(point)
		return only(Point(x-1, y), Point(x+1, y), Point(x, y-1), Point(x, y+1))
			.filter!(p => !(p.x%limit.length).among(0, limit.length - 1))
			.filter!(p => !(p.y%costs.length).among(0, costs.length - 1));
	};

	() {
		auto path = tuple!("begin", "end")(Point(1, 1), Point(limit.length-2, costs.length-2));
		size_t[Point] risks = [path.begin: 0];
		auto priorityQueue = heapify!((a, b) => risks[a] > risks[b])([path.begin]);

		import std.datetime.stopwatch : AutoStart, StopWatch;
		auto sw = StopWatch(AutoStart.yes);
		scope(exit) writefln!"Duration %sms"(sw.peek.total!"msecs");
		scope(exit) sw.stop();

		while (!priorityQueue.empty) {
			alias pop = () { with(priorityQueue) { scope(exit) popFront(); return front; } };
			auto cur = pop();
			neighborsOf(cur).each!((n) {
				const cost = risks[cur] + costs[n.y][n.x];
				if (n !in risks || cost < risks[n]) {
					risks[n] = cost;
					priorityQueue.insert(n);
				}
			});

			if (priorityQueue.front == path.end) return risks[path.end];
		}

		assert(0);
	} ().writeln;
}
