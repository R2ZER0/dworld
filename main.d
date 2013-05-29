import std.stdio;
import std.exception : enforce;

void main(string[] args)
{
    writeln("Initialising World...");
    
    World myWorld = World.generateEmpty();
}

struct Square {
    float height = 0.0f;
}


interface World {
    Square get(int x, int y);
    void set(int x, int y, Square square);
    
    static World generateEmpty(int sidesize = 128) {
        return new WorldImpl(sidesize);
    }
}

class WorldImpl : World {
    
    private this(uint sidesize) {
        this.sidesize = sidesize;
        squares = new Square[sidesize * sidesize];
    }
    
    immutable private uint sidesize;
    private Square[] squares;
    
    override public Square get(int x, int y) {
        enforce(x < sidesize && y < sidesize, "Square out of bounds!");
        return squares[y * sidesize + x];
    }
    
    override public void set(int x, int y, Square square) {
        enforce(x < sidesize && y < sidesize, "Square out of bounds!");
        squares[y * sidesize + x] = square;
    }
}