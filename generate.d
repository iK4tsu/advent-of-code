#!/usr/bin/env rdmd

import std.algorithm;
import std.array : array, empty;
import std.conv : to;
import std.datetime.date : Date;
import std.datetime.systime : Clock, SysTime;
import std.file : exists, mkdirRecurse, write;
import std.format : format;
import std.getopt;
import std.net.curl : download, HTTP;
import std.path : buildPath, chainPath, extension, setExtension;
import std.range : only, repeat;
import std.stdio;
import std.string : outdent, strip;
import std.typecons : tuple;

struct Opt
{
	static opCall()
	{
		Opt opt = Opt.init;
		const today = Clock.currTime;
		opt.year = today.year();
		opt.day = today.day();
		return opt;
	}

	bool force;
	string session;
	int year;
	int day;
}

int main(string[] args)
{
	Opt opt = Opt();
	auto options = getopt(
		args,
		"d|day",     "Advent of calendar day to generate",  &opt.day,
		"f|force",   "Override existent files",             &opt.force,
		std.getopt.config.required,
		"s|session", "User's session cookie",               &opt.session,
		"y|year",    "Advent of calendar year to generate", &opt.year,
	);

	if (options.helpWanted)
	{
		// TODO: usefull help output
		options.options.each!writeln;
		return 0;
	}

	with(opt)
	{
		if (year < 2015 || year > Clock.currTime.year())
		{
			stderr.writefln!"Year '%s' is not a valid Advent of Code year"(year);
			return 1;
		}

		if (day > 25)
		{
			stderr.writefln!"Advent of code only runs until December 25th";
			return 1;
		}

		if (Clock.currTime < SysTime(Date(year, 12, day)))
		{
			stderr.writefln!"Invalid Advent of Code date '%s'"(Clock.currTime.toString.until!"a == ' '".array);
			stderr.writefln!"Please until December!";
			return 1;
		}

		if (force) writefln!"[Warning] Files will not be preserved";

		const yearstr = year.to!string;
		const daystr = day.to!string;

		const path = buildPath(yearstr, "day"~daystr);

		auto files = [
			path.buildPath("part1", "app".setExtension("d")),
			path.buildPath("part1", "dub".setExtension("json")),
			path.buildPath("part2", "app".setExtension("d")),
			path.buildPath("part2", "dub".setExtension("json")),
		];

		if (files.any!exists)
		{
			if(force) files.filter!exists.each!(a => a.writefln!"[Warning] File '%s' will be overwritten");
			else
			{
				files.filter!exists.each!(a => a.writefln!"[Info] File '%s' will be preserved");
				files = files.filter!(a => !a.exists).array;
				if (files.empty)
				{
					writefln!"[Info] All files preserved, no files left to write";
					return 0;
				}
			}
		}

		writefln!"[Info] Preparing app.d content...";
		const appfile = q{
			import std;

			void main()
			{

			}
		}.outdent.strip;

		writefln!"[Info] Preparing dub.json content...";
		const dubargs = (string part) => tuple(yearstr, daystr, part);
		const dubfile = (string part) => format!q{
			{
				"name": "%s-day%s-%s",
				"targetName": "aoc%s-day%s-%s",
				"targetPath": "../../bin",
				"sourcePaths": ["."],
				"targetType": "executable"
			}
		}(dubargs(part).expand, dubargs(part).expand).outdent.strip;

		path.buildPath("part1").mkdirRecurse;
		path.buildPath("part2").mkdirRecurse;

		files.filter!(f => f.extension == ".d").each!((f) {
			f.writefln!"[Trace] Writting to '%s'";
			f.write(appfile);
		});

		files.filter!(f => f.extension == ".json").each!((f) {
			f.writefln!"[Trace] Writting to '%s'";
			f.write(dubfile(f.canFind("part1") ? "part1" : "part2"));
		});

		auto http = HTTP(format!"https://adventofcode.com/%s/day/%s/input"(year.to!string, day.to!string));
		http.setCookie(session.format!"session=%s");
		http.onReceive = (ubyte[] data) {
			path.buildPath("input").writefln!"[Trace] Writting to '%s'";
			path.buildPath("input").write(data);
			return data.length;
		};
		writefln!"[Info] Fetching puzzle input...";
		http.perform();
	}
	return 0;
}
