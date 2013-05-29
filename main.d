import std.stdio;
import cuboid.world;


void main(string[] args)
{
    writeln("Initialising World...");
    
    auto test = to!RichInt(cast(int)123);
    
    World myWorld = World.generateEmpty(4);
    
    auto ws = new JsonWorldSerialiser();
    writeln(ws.freeze(myWorld));
}

