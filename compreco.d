module compreco;
import std.stdio;
import wad, settings;

void main(string[] args)
{
  if (args.length < 2)
  {
    writeln("Usage: compreco [<flags>] <wad_file>");
    writeln(" -f - explain full reasons");
    return;
  }

  string file;
  Settings settings;

  foreach (arg; args)
  {
    if (arg[0] == '-' && arg.length > 1)
    {
      switch(arg[1])
      {
        case 'f': settings.explain = true; break;
        default: break;
      }
    }
    else
    {
      file = arg;
    }
  }

  writeln("Complevel Recognizer v0.1");

  auto wad = new Wad(settings);
  if (!wad.init(file))
  {
    writeln("File \"", file, "\" doesn't exist");
  }
  else
  {
    writeln(" wad: ", file, "\n");
    auto cl = wad.complevel();
    writeln(" complevel is ", cast(uint)cl, " (", cl, ")");
  }
  
  //readln();
}
