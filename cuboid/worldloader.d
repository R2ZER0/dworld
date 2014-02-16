module cuboid.worldloader;

import std.stdio, std.array, std.stream;
import cuboid.world;

string resolveAssetPath(string name) {
    return "/scratch/" ~ name ~ ".yaml";
}
    
    