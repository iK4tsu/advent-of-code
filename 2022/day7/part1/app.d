import std;

void main()
{
	alias File = Tuple!(string, "name", size_t, "size"); /// file representation
	alias Content = SumType!(File, string); /// file or directory name
	alias Dir = Tuple!(string, "path", Content[], "content"); /// directory representation

	stdin.byLineCopy.map!split.fold!((treeBuild, line)                  // build the file tree
	{
		with (treeBuild) switch (line[0])
		{
			case "$": if (line[1] == "cd")                // it is a 'cd' command
			{
				auto newPath = line[2] == ".."            // second arg names the directory
							 ? fileTree[path].path        // move out one level
							 : buildPath(path, line[2]);  // move in one level or '/'

				fileTree.require(newPath, Dir(path, [])); // make sure tree knows 'newPath'
				path = newPath;                           // update current path
			} break; // 'ls' can be ignored

			// this is an 'ls' command
			case "dir": fileTree[path].content ~= line[1].to!Content; break;                // add directory name
			default: fileTree[path].content ~= File(line[1], line[0].to!size_t).to!Content; // add file
		}

		return treeBuild;
	})(tuple!("path", "fileTree")("", new Dir[string])) // initial seed
	.fileTree.only                                                       // extract the completed tree as a range
	.map!(fileTree => fileTree.byKey.map!(delegate size_t(string path) { // calculate each directory size
		alias self = memoize!(__traits(parent, (){}));    // recursive helper
		return fileTree[path].content.map!(match!(        // size of the iterated directory
			(File f) => f.size,                           // for files return the size
			(string name) => self(buildPath(path, name)), // for directories calculate its size by recursing
		)).sum;
	})).front                                                            // extract the sizes
	.filter!"a <= 100_000"                                               // at most 100_000
	.sum                                                                 // total amount
	.writeln;
}
