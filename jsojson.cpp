#include <string>
#include <vector>
#include <map>
#include <memory>

#include "jsojson.h"

namespace JsoJson {

struct value;

enum class Type {
	NONE,
	INT,
	DOUBLE,
	STRING,
	BOOL,
	NUL,
	OBJECT,
	ARRAY,
};

typedef std::map<std::string, std::shared_ptr<value>> object;
typedef std::vector<std::shared_ptr<value>> array;

struct value {
    static const Type type = Type::NONE;
    virtual ~value() {};
};

struct valueInt : value {
    static const Type type = Type::INT;
    long int v;
    valueInt(const long int v) : v(v) {}
};

struct valueDouble : value {
    static const Type type = Type::DOUBLE;
    double v;
    valueDouble(const double v) : v(v) {}
};

struct valueString : value {
    static const Type type = Type::STRING;
    std::string v;
    valueString(const char* v) : v(v) {}
};

struct valueBool : value {
    static const Type type = Type::BOOL;
    bool v;
    valueBool(const bool v) : v(v) {}
};

struct valueNull : value {
    static const Type type = Type::NUL;
    valueNull() {}
};

struct valueObject : value {
    static const Type type = Type::OBJECT;
    object v;
    valueObject() : v() {}
};

struct valueArray : value {
    static const Type type = Type::ARRAY;
    array v;
    valueArray() : v() {}
};

std::shared_ptr<value> CreatePremitiveValue(const JsoJsonPremitiveValue* pv) {
    switch (pv->type) {
        case JSO_JSON_INT:    return std::make_shared<valueInt>(pv->v.i);
        case JSO_JSON_DOUBLE: return std::make_shared<valueDouble>(pv->v.d);
        case JSO_JSON_STRING: return std::make_shared<valueString>(pv->v.s);
        case JSO_JSON_BOOL:   return std::make_shared<valueBool>(pv->v.i ? true : false);
        case JSO_JSON_NULL:   return std::make_shared<valueNull>();
        default:              return nullptr;
    }
}

template <class T> auto cast(const std::shared_ptr<value> v) -> std::shared_ptr<T> {
    return std::dynamic_pointer_cast<T>(v);
}

} // namespace JsoJson

struct JsoJsonHandle {
    std::shared_ptr<JsoJson::value> head;
    std::vector<std::shared_ptr<JsoJson::value>> stack; // use std::stack?
    JsoJsonHandle() : head(std::make_shared<JsoJson::value>()), stack(1, head) {}
};

struct JsoJsonHandle* JsoJsonCreate()
{
    return new JsoJsonHandle();
}

void JsoJsonDestroy(struct JsoJsonHandle* h)
{
    delete h;
}

JsoJsonBool JsoJsonAddValue(struct JsoJsonHandle* h, const struct JsoJsonPremitiveValue* pv)
{
    JsoJsonBool ret = JSO_JSON_TRUE;

    auto v = JsoJson::CreatePremitiveValue(pv);
    auto latest = h->stack.back();

    if (latest->type == JsoJson::Type::NONE) {
        // JSON which consists of only one premitive value
        h->head = latest = v;
    } else if (latest->type == JsoJson::Type::OBJECT) {
        // push v to stack which is poped when JsoJsonAddKey called
        h->stack.emplace_back(v);
    } else if (latest->type == JsoJson::Type::ARRAY) {
        // push v to latest array value directry
        auto array = JsoJson::cast<JsoJson::valueArray>(latest);
        if (array) {
            array->v.emplace_back(v);
        }
    } else {
        ret = JSO_JSON_FALSE;
    }

    return ret;
}

JsoJsonBool JsoJsonAddKey(struct JsoJsonHandle* h, const char* k)
{
    JsoJsonBool ret = JSO_JSON_TRUE;

    std::shared_ptr<JsoJson::value> v = h->stack.back();
    h->stack.pop_back();
    auto parent = h->stack.back();

    if (parent->type == JsoJson::Type::OBJECT) {
        auto o = JsoJson::cast<JsoJson::valueObject>(parent);
        if (o) {
            o->v[k] = v;
        }
    } else {
        ret = JSO_JSON_FALSE;
    }

    return ret;
}

JsoJsonBool JsoJsonEnterArray(struct JsoJsonHandle* h)
{
    auto v = std::make_shared<JsoJson::valueArray>();
    auto latest = h->stack.back();

    if (latest->type == JsoJson::Type::NONE) {
        h->head = latest = v;
    } else if (latest->type == JsoJson::Type::OBJECT) {
        h->stack.emplace_back(v);
    } else if (latest->type == JsoJson::Type::ARRAY) {
        h->stack.emplace_back(v);
        auto array = JsoJson::cast<JsoJson::valueArray>(latest);
        if (array) {
            array->v.emplace_back(v);
        }
    }
    return JSO_JSON_TRUE;
}

JsoJsonBool JsoJsonLeaveArray(struct JsoJsonHandle* h)
{
    h->stack.pop_back();
    return JSO_JSON_TRUE;
}

JsoJsonBool JsoJsonEnterObject(struct JsoJsonHandle* h)
{
    auto v = std::make_shared<JsoJson::valueObject>();
    auto latest = h->stack.back();

    if (latest->type == JsoJson::Type::NONE) {
        h->head = latest = v;
    } else if (latest->type == JsoJson::Type::OBJECT) {
        h->stack.emplace_back(v);
    } else if (latest->type == JsoJson::Type::ARRAY) {
        h->stack.emplace_back(v);
        auto array = JsoJson::cast<JsoJson::valueArray>(latest);
        if (array) {
            array->v.emplace_back(v);
        }
    }
    return JSO_JSON_TRUE;
}

JsoJsonBool JsoJsonLeaveObject(struct JsoJsonHandle* h)
{
    h->stack.pop_back();
    return JSO_JSON_TRUE;
}

const char * JsoJsonGetJsonString(struct JsoJsonHandle* h)
{
    // TODO
    return "";
}

