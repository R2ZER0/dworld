module cuboid.util.json;

import std.json;
public import std.json : JSONValue;

private void enforceType(JSON_TYPE type)(ref JSONValue value) {
    if(type != value.type) throw new JSONException("JSON type mismatch.");
}

JSONValue pack(T)(T value) {
    JSONValue jval;
    static if(is(T : string)) {
        jval.type = JSON_TYPE.STRING;
        jval.str = cast(string)value;
    } else static if(is(T : ulong)) {
        jval.type = JSON_TYPE.UINTEGER;
        jval.uinteger = cast(ulong)value;
    } else static if(is(T : long)) {
        jval.type = JSON_TYPE.INTEGER;
        jval.integer = cast(long)value;
    } else static if(is(T : real)) {
        jval.type = JSON_TYPE.FLOAT;
        jval.floating = cast(real)value;
    } else static if(is(T : JSONValue[string])) {
        jval.type = JSON_TYPE.OBJECT;
        jval.object = cast(JSONValue[string])value;
    } else static if(is(T : JSONValue[])) {
        jval.type = JSON_TYPE.ARRAY;
        jval.array = cast(JSONValue[])value;
    } else static if(is(T : bool)) {
        if(value) jval.type = JSON_TYPE.TRUE;
        else jval.type = JSON_TYPE.FALSE;        
    } else {
        jval.type = JSON_TYPE.NULL;
        assert(0, "Packing of this type not implemented.");
    }
    return jval;
}

T unpack(T)(JSONValue jval) {
    T val;
    static if(is(T == bool) || is(T : ulong) || is(T : long) || is(T : real)){
        // primitives
        switch(jval.type) {
            case JSON_TYPE.TRUE:     val = cast(T)true;           break;
            case JSON_TYPE.FALSE:    val = cast(T)false;          break;
            case JSON_TYPE.INTEGER:  val = cast(T)jval.integer;   break;
            case JSON_TYPE.UINTEGER: val = cast(T)jval.uinteger;  break;
            case JSON_TYPE.FLOAT:    val = cast(T)jval.floating;  break;
            case JSON_TYPE.NULL:     val = cast(T)null;           break;
            default:                 enforceType!(JSON_TYPE.NULL)(jval); break;
        }
    } else static if(is(JSONValue[string] : T)) {
        // object
        enforceType!(JSON_TYPE.OBJECT)(jval);
        val = cast(T)jval.object;
    } else static if(is(JSONValue[] : T)) {
        // array
        enforceType!(JSON_TYPE.ARRAY)(jval);
        val = cast(T)jval.array;
    }
    return val;
}

string toJSON(in JSONValue jval) { return std.json.toJSON(&jval); }
JSONValue fromJSON(T)(in T json) { return std.json.parseJSON!T(json); }