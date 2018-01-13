#ifndef _JSON_HEADER_
#define _JSON_HEADER_

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    JSO_JSON_FALSE,
    JSO_JSON_TRUE,
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
        long int i; // For JSO_JSON_INT and JSO_JSON_BOOL
        double d;   // For JSO_JSON_DOUBLE
        char* s;    // FOr JSO_JSON_STRING
    } v;
};

struct JsoJsonHandle;

struct JsoJsonHandle* JsoJsonCreate();
void JsoJsonDestroy(struct JsoJsonHandle* h);

JsoJsonBool JsoJsonAddValue(struct JsoJsonHandle* h, const struct JsoJsonPremitiveValue* v);
JsoJsonBool JsoJsonAddKey(struct JsoJsonHandle* h, const char* k);

JsoJsonBool JsoJsonEnterArray(struct JsoJsonHandle* h);
JsoJsonBool JsoJsonLeaveArray(struct JsoJsonHandle* h);
JsoJsonBool JsoJsonEnterObject(struct JsoJsonHandle* h);
JsoJsonBool JsoJsonLeaveObject(struct JsoJsonHandle* h);

const char* JsoJsonGetJsonString(struct JsoJsonHandle* h);

#ifdef __cplusplus
}
#endif

#endif //  _JSON_HEADER_
