// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module sal_auxlib;
/+ Contains helper functions for Salmon base types. +/
import salinterp;
import sal_shared_api;
import std.conv : to;

/** 
 * Returns the value `v` as a D number.
 * Params:
 *   v = SalmonValue()
 * Returns: v.getValue() as an integer
 */
int getArgumentAsNumber(SalmonValue v) {
    if (v.getType() == SalType.number)
        return to!int(v.getValue());
    else {
        err("Could not convert type \033[;1m`" ~ v.getType()
                .to!string ~ "`\033[0m to \033[;1mnumber\033[0m.");
        return -9;
    }
}

/* Convert a SalmonValue() (which has a type of SalType.list) to a string[] */
string[] valArrayToString(SalmonValue va) {
    string[] n;

    foreach (SalmonValue v; va.g) {
        n ~= v.getValue();
    }

    return n;
}

/** 
 * An overload which allows a raw array instead of just a value.
 * Params:
 *   va = Array of SalmonValue.
 * Returns: string[] of va
 */
string[] valArrayToString(SalmonValue[] va) {
    string[] n;

    foreach (SalmonValue v; va) {
        n ~= v.getValue();
    }

    return n;
}

/** 
 * Appends `v` to `thisList`
 * Params:
 *   v = A value.
 *   thisList = To this list.
 */
void listAppendV(SalmonValue v, SalmonValue thisList) {
    thisList.g ~= v;
}

/** 
 * A basic Salmon Value.
 */
class SalmonValue {
public:
    string v = "nil";
    SalType t = SalType.nil;
    SalmonValue[] g; /* unless it's a list */

    // Adds `value` to @v & `type` as the type.
    void returnValue(string value, SalType type) {
        t = type;
        v = value;
    }

    // Comparisons -
    bool equals(SalmonValue v2) {
        return (v2.getType() == this.getType()) && (v2.getValue() == this.getValue());
    }

    bool typeis(SalType t) {
        return (this.getType() == t);
    }

    // Appends @thisValue to the current list (if any)
    void append(SalmonValue thisValue) {
        g ~= thisValue;
    }

    void returnValue(SalmonValue n) {
        if (n.getType() == SalType.list || n.getType() == SalType.pair) {
            g = n.g;
        }
        else
            v = n.v;

        t = n.getType();
    }

    bool numeric() {
        import std.string : n = isNumeric;
        return n(this.getValue());
    }

    template as( T ) {
        T convert() {
            return this.getValue().to!T;
        }
    }

    float asFloat() {
        return (this.numeric()) ? this.getValue().to!float : -1;
    }

    void setType(SalType ty) {
        t = ty;
    }

    void setValue(string value) {
        v = value;
    }

    void setValue(SalmonValue[] value) {
        g = value;
    }

    void returnValue(SalmonValue n, SalType p) {
        v = n.v;
        t = p;
    }

    SalmonValue[] list_members() {
        if (t != SalType.list) {
            note("[From D]: running list_members() on a type \033[;1m" ~ t.to!string ~ "\033[0m",
                    __LINE__, __FILE__);
            return [new SalmonValue()];
        }
        else {
            return this.g;
        }
    }

    SalmonValue[] list_pair() {
        if (this.getType() != SalType.pair) {
            note("[From D]: running list_members() on a type \033[;1m" ~ t.to!string ~ "\033[0m",
                    __LINE__, __FILE__);
            return [new SalmonValue()];
        }
        return this.g;
    }

    void returnList(SalmonValue[] li) {
        g = li;
        t = SalType.list;
    }

    string getValue() {
        return v;
    }

    SalType getType() {
        return t;
    }

    void returnNil() {
        t = SalType.nil;
        v = "nil";
    }

    void flagAsList() {
        t = SalType.list;
    }
}

SalmonValue convertStringToValue(string str) {
    auto v = new SalmonValue();

    v.setValue(str);
    v.setType(SalType.str);

    return v;
}

SalmonValue getEnvironmentVariable(SalmonEnvironment env, string var) {
    return env.env_vars[var];
}

void addDefinition(string definition, string forThisFunction, SalmonEnvironment inThisEnv) {
    inThisEnv.env_definitions[forThisFunction] = definition;
}

/** 
 * Backwards compatible Salmon function class.
 * Use THIS instead of the `SalmonSub` class.
 */
class SalmonSub {
public:
    string[] aA;
    string[] raw;

    SalmonValue[] newArg = [];
    SalmonValue rvalue = new SalmonValue();
    SalType rvaluetype = SalType.nil; /* WARNING: rvaluetype is not used now that we have salmonvalue types. */
    /* it is used as a backward compatibility transition into the new API. */
    /* + whatever else I need */
    void returnValue(SalmonValue value) {
        rvalue = value;
    }

    void returnValue(string value) {
        rvalue = quickRun(value, environ);
    }

    SalmonValue value_at(int pos) {
        return newArg[pos];
    }
    
    /* Essentially the &rest parameter in Common Lisp. */
    /* Gets the args from the @from parameter to the last one. */
    SalmonValue[] rest(int from = 0) {
        return newArg[from..$];
    }

    void returnValue(string value, SalType t) {
        rvalue = quickRun(value, this.environ);
        this.rvaluetype = rvalue.getType();
    }

    SalmonEnvironment environ = new SalmonEnvironment();
}

void populateEnvironment(SalmonEnvironment env) {
    if (!("path" in env.env_vars)) {
        auto samplePath = new SalmonValue();
        samplePath.flagAsList();

        /* set default paths */
        listAppendV(convertStringToValue("./libs/"), samplePath);
        listAppendV(convertStringToValue("/usr/lib/salmon/libs/"), samplePath);
        listAppendV(convertStringToValue("./"), samplePath);

        env.env_vars["path"] = samplePath;
    }
}

SalmonValue salmonThrowError(string thisError, string withThisMessage,
        int thatHasThisErrorCode, int atThisLine = 0) {
    err(thisError ~ ": " ~ withThisMessage, atThisLine, _FILEN);
    import core.stdc.stdlib;

    if (_FILEN != "repl") {
        exit(thatHasThisErrorCode);
    }

    return new SalmonValue();
}

SalmonValue asSBool(bool b) {
    auto n = new SalmonValue();
    n.setType(SalType.boolean);
    n.setValue(to!string(b));
    return n;
}

SalmonValue floatAsValue(float s) {
    auto n = new SalmonValue();
    n.setType(SalType.number);
    n.setValue(s.to!string);
    return n;
}
SalmonValue fromNumber(int s) {
    auto n = new SalmonValue();
    n.setType(SalType.number);
    n.setValue(s.to!string);
    return n;
}

