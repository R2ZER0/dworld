import std.stdio;
import std.exception : enforce;
import std.json;
import std.array;
import json = cuboid.util.json;


void main(string[] args)
{
    writeln("Initialising World...");
    
    World myWorld = World.generateEmpty(4);
    
    auto ws = new JsonWorldSerialiser();
    writeln(ws.freeze(myWorld));
}

struct Square {
    float height = 0.0f;
}


interface World {
    Square get(int x, int y);
    void set(int x, int y, Square square);
    @property uint sidesize();
    
    static World generateEmpty(int sidesize = 128) {
        return new WorldImpl(sidesize);
    }
}

class WorldImpl : World {
    
    private this(uint sidesize) {
        this._sidesize = sidesize;
        squares = new Square[sidesize * sidesize];
    }
    
    immutable private uint _sidesize;
    private Square[] squares;
    
    override public Square get(int x, int y) {
        enforce(x < sidesize && y < sidesize, "Square out of bounds!");
        return squares[y * sidesize + x];
    }
    
    override public void set(int x, int y, Square square) {
        enforce(x < sidesize && y < sidesize, "Square out of bounds!");
        squares[y * sidesize + x] = square;
    }
    
    override @property public uint sidesize() { return this._sidesize; }
}

interface WorldSerialiser {
    public string freeze(World world);
    public World thaw(string data);
}

class JsonWorldSerialiser : WorldSerialiser {
    
    JSONValue freezeSquare(Square square) {
        return json.pack(["height" : json.pack(square.height)]);
    }
    
    override public string freeze(World world) {
        
        auto app = appender(new JSONValue[0]);
        app.reserve(world.sidesize * world.sidesize);
        
        foreach(int y; 0 .. world.sidesize) {
            foreach(int x; 0 .. world.sidesize) {
                app.put(freezeSquare(world.get(x,y)));
            }
        }
        
        auto world_val = json.pack(["sidesize" : json.pack(world.sidesize), "squares" : json.pack(app.data)]);
        return toJSON(&world_val);
    }
    
    override public World thaw(string data){ return World.generateEmpty(128); }
}

