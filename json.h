#ifndef _JSON_HEADER_
#define _JSON_HEADER_

#ifdef __cplusplus
extern "C" {
#endif

enum JsoJsonBool {
    JSO_JSON_FALSE,
    JSO_JSON_TRUE,
};

enum JsoJsonPremitiveType {
    JSO_JSON_INT,  // JSON does not this type, but added for internal convenience
    JSO_JSON_DOUBLE,
    JSO_JSON_STRING,
    JSO_JSON_BOOL,
    JSO_JSON_NULL,
};

struct JsoJsonValue {
    JsoJsonPremitiveType type;
    union {
        long int i; // For JSO_JSON_INT and JSO_JSON_BOOL
        double d;   // For JSO_JSON_DOUBLE
        char* s;    // FOr JSO_JSON_STRING
    } val;
};

struct JsoJsonHandle;

struct JsoJsonHandle* JsoJsonCreate();
int JsoJsonDestroy(struct JsoJsonHandle* h);
const char* JsoJsonGetJsonString(struct JsoJsonHandle* h);

int JsoJsonAddValue(struct JsoJsonHandle* h, const JsoJsonValue* v);
int JsoJsonAddKeyValue(struct JsoJsonHandle* h, const char* k, const JsoJsonValue* v);

int JsoJsonEnterArray(struct JsoJsonHandle* h);
int JsoJsonLeaveArray(struct JsoJsonHandle* h);
int JsoJsonEnterObject(struct JsoJsonHandle* h);
int JsoJsonLeaveObject(struct JsoJsonHandle* h);

#ifdef __cplusplus
}
#endif

#endif //  _JSON_HEADER_
