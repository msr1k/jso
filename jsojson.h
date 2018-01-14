#ifndef _JSON_HEADER_
#define _JSON_HEADER_

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    JSO_JSON_FALSE = 0,
    JSO_JSON_TRUE = 1,
} JsoJsonBool;

typedef enum {
    JSO_JSON_INT,  // JSON does not this type, but added for internal convenience
    JSO_JSON_DOUBLE,
    JSO_JSON_STRING,
    JSO_JSON_BOOL,
    JSO_JSON_NULL,
} JsoJsonPremitiveType;

struct JsoJsonPremitiveValue {
    JsoJsonPremitiveType type;
    union {
        long int i;    // For JSO_JSON_INT
        double d;      // For JSO_JSON_DOUBLE
        char* s;       // For JSO_JSON_STRING
        JsoJsonBool b; // For JSO_JSON_BOOL
    } v;
};

struct JsoJsonHandle;

struct JsoJsonHandle* JsoJsonCreate();
void JsoJsonDestroy(struct JsoJsonHandle* h);

JsoJsonBool JsoJsonAddValue(struct JsoJsonHandle* h, const struct JsoJsonPremitiveValue* v);
JsoJsonBool JsoJsonAddKey(struct JsoJsonHandle* h, const char* k);
JsoJsonBool JsoJsonAddKey2(struct JsoJsonHandle* h, const char* k);  // workaround of KEY token string incorrectness

JsoJsonBool JsoJsonEnterArray(struct JsoJsonHandle* h);
JsoJsonBool JsoJsonLeaveArray(struct JsoJsonHandle* h);
JsoJsonBool JsoJsonEnterObject(struct JsoJsonHandle* h);
JsoJsonBool JsoJsonLeaveObject(struct JsoJsonHandle* h);

const char* JsoJsonGetJsonString(struct JsoJsonHandle* h);

#ifdef __cplusplus
}
#endif

#endif //  _JSON_HEADER_
