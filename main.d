import std.stdio;

void main(string[] args)
{
    writeln("Initialising...");
}

struct Square {
    float height;
}


interface World {
    Square get(int x, int y);
    void set(int x, int y, Square square);
}

class WorldImpl(int sidesize) : World {
    
    private Square[sidesize*sidesize] squares;
    
    override public Square get(int x, int y) {
        enforce(x < sidesize && y < sidesize, "Square out of bounds!");
        return squares[y * sidesize + x];
    }
    
    override public void set(int x, int y, Square square) {
        enforce(x < sidesize && y < sidesize, "Square out of bounds!");
        squares[y * sidesize + x] = square;
    }
}