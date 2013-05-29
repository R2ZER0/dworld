module cuboid.world;

import std.exception : enforce;

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