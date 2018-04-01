import std.algorithm;
import std.file;
import std.stdio;

void forceCoverageBetweenMarks(File fr, File fw)
{
	int forceOff = 0;
	enum noCoveragePrefix = "0000000";
	enum forcedCoveragePrefix = "      1";

	int nextIsOff = 0;

	foreach (line; fr.byLine())
	{

		if (line.canFind("next-line-coverage-off"))
			nextIsOff = 2;
		else if (line.canFind("coverage-off"))
			forceOff++;
		else if (line.canFind("coverage-on"))
			forceOff--;
		
		if ((forceOff > 0 || nextIsOff == 1) && line.startsWith(noCoveragePrefix))
			line = forcedCoveragePrefix ~ line[forcedCoveragePrefix.length..$];

		if (nextIsOff > 0)
			nextIsOff--;

		fw.writeln(line);
	}
}

int main(string argv[])
{
	foreach (string filePath; dirEntries("","*.lst", SpanMode.shallow, false))
	{
		auto tmpPath = filePath ~ "_orig";
		rename(filePath, tmpPath);
		auto fr = File(tmpPath, "r");
		auto fw = File(filePath, "w");
		forceCoverageBetweenMarks(fr, fw);
	}

	return 0;
}
