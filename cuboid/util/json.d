module cuboid.util.json;
import std.json;

private void enforceType(JSON_TYPE type)(ref JSONValue value) {
    if(type != value.type) throw new JSONException("JSON type mismatch.");
}

template packTempl(JSON_TYPE jtype, string typeparam, T) {
    JSONValue pack(T value) {
        JSONValue jvalue;
        jvalue.type = jtype;
        mixin("jvalue." ~ typeparam ~ " = value;");
        return jvalue;
    }
}

template unpackTempl(JSON_TYPE jtype, string typeparam, T) {
    T unpack(JSONValue jvalue) {
        enforceType!jtype(jvalue);
        mixin("return jvalue." ~ typeparam ~ ";");
    }
}

template bothTempl(JSON_TYPE jtype, string typeparam, T) {
    mixin packTempl!(jtype, typeparam, T);
    mixin unpackTempl!(jtype, typeparam, T);
}

mixin bothTempl!(JSON_TYPE.STRING, "str", string);
mixin unpackTempl!(JSON_TYPE.UINTEGER, "uinteger", ulong);
mixin unpackTempl!(JSON_TYPE.INTEGER, "integer", long);
mixin bothTempl!(JSON_TYPE.FLOAT, "floating", real); 
mixin bothTempl!(JSON_TYPE.OBJECT, "object", JSONValue[string]);
mixin bothTempl!(JSON_TYPE.ARRAY, "array", JSONValue[]);