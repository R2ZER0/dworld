module cuboid.world;

import std.exception : enforce;
import msgpack;

struct Square {
    float height = 0.0f;
    mixin MessagePackable;
}

struct Chunk {   
    enum SIDESIZE = 8;
    enum CHUNKSIZE = SIDESIZE*SIDESIZE;
    
    Square[CHUNKSIZE] squares;
    //Square[] squares;
    alias squares this;
    //mixin MessagePackable;
    
    public void toMsgpack(Packer)(ref Packer packer) {
        packer.beginArray(CHUNKSIZE);
        foreach(ref Square sqr; squares)
            packer.pack(sqr, withFieldName);
    }
    
    public void fromMsgpack(ref Unpacker unpacker) {
        auto len = unpacker.beginArray();
        assert(len == CHUNKSIZE, "Chunksize mismatch.");
        foreach(ref Square sqr; squares)
            unpacker.unpack(sqr);
    }
}

struct World {
    uint xsize, ysize;
    Chunk[] chunks;
    
    Chunk getChunk(uint x, uint y) in {
        assert(x < xsize && y < ysize, "Chunk selection out of range.");
    } body {
        return chunks[y*ysize + x];
    }
    
    Square getSquare(uint x, uint y) const in {
        assert(x < xsize*Chunk.SIDESIZE && y < ysize*Chunk.SIDESIZE, "Square selection out of range.");
    } body {
        return chunks[(y/Chunk.SIDESIZE)*ysize + (x/Chunk.SIDESIZE)][(y%Chunk.SIDESIZE)*Chunk.SIDESIZE + (x%Chunk.SIDESIZE)];
    }
    
    invariant() {
        assert(chunks.length == xsize * ysize, "Chunk size mismatch!");
    }
    
}

class WorldManager {
    
    private this() {}
    private World world;
    
    public static WorldManager generateEmptySquare(uint numchunks) {
        return generateEmpty(numchunks, numchunks);
    }
    
    public static WorldManager generateEmpty(uint xsize, uint ysize) {
        auto manager = new WorldManager();
        manager.world.xsize = xsize;
        manager.world.xsize = xsize;
        manager.world.chunks = new Chunk[xsize * ysize];
        return manager;
    }
    
    auto packWorld() {
        //return pack(this.world);
        Chunk myChunk;
        import std.stdio : stdout;
        myChunk.toMsgpack(Packer!(stdout)());
    }
    
    pure World getWorld() { return this.world; }

}