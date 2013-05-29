import std.stdio;
import std.exception : enforce;
import std.json;
import std.array;

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
        JSONValue height_val = toJSONValue(square.height);
        JSONValue val = toJSONValue(["height" : height_val]);
        return val;
    }
    
    override public string freeze(World world) {
        auto sidesize_val = toJSONValue(world.sidesize);
        
        auto app = appender(new JSONValue[0]);
        app.reserve(world.sidesize * world.sidesize);
        
        foreach(int y; 0 .. world.sidesize) {
            foreach(int x; 0 .. world.sidesize) {
                app.put(freezeSquare(world.get(x,y)));
            }
        }
        
        auto squares_val = toJSONValue(app.data);
        auto world_val = toJSONValue(["sidesize" : sidesize_val, "squares" : squares_val]);
        return toJSON(&world_val);
    }
    
    override public World thaw(string data){ return World.generateEmpty(128); }
}

JSONValue toJSONValue(int value) {
    JSONValue jvalue;
    jvalue.type = JSON_TYPE.INTEGER;
    jvalue.integer = value;
    return jvalue;
}

JSONValue toJSONValue(uint value) {
    JSONValue jvalue;
    jvalue.type = JSON_TYPE.UINTEGER;
    jvalue.uinteger = value;
    return jvalue;
}

JSONValue toJSONValue(float value) {
    JSONValue jvalue;
    jvalue.type = JSON_TYPE.FLOAT;
    jvalue.floating = value;
    return jvalue;
}

JSONValue toJSONValue(JSONValue[string] value) {
    JSONValue jvalue;
    jvalue.type = JSON_TYPE.OBJECT;
    jvalue.object = value;
    return jvalue;
}

JSONValue toJSONValue(JSONValue[] value) {
    JSONValue jvalue;
    jvalue.type = JSON_TYPE.ARRAY;
    jvalue.array = value;
    return jvalue;
}

