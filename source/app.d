import std.stdio;
import core.runtime;
import win32;

void main()
{
	auto res = initWindow("App", 800, 600);
	writeln(res);
}
