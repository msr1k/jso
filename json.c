#include <string>
#include <vector>
#include <map>

#include "json.h"

struct JsoJsonValue;

enum class JsoJsonType {
	NONE,
	INT,
	DOUBLE,
	STRING,
	BOOL,
	NUL,
	OBJECT,
	ARRAY,
};

typedef JsoJsonObject std::map<std::string, JsoJsonValue>;
typedef JsoJsonArray std::vector<JsoJsonValue>;

struct JsoJsonValue {
	JsoJsonType type = JsoJsonType::NONE;
	union {
		long int i;
		double d;
		std::string s;
		bool b;
		JsoJsonObject o;
		JsoJsonArray a;
	} val;
};

struct JsoJsonHandle {
	std::vector<JsoJsonValue*> stack;
	JsoJsonValue head;
	JsoJsonHandle() : head(), stack(1, head) {}
};

struct JsoJsonHandle* JsoJsonCreate()
{
	return new JsoJsonHandle();
}

int JsoJsonDestroy(struct JsoJsonHandle* h)
{
	delete h;
}

const char * JsoJsonGetJsonString(struct JsoJsonHandle* h)
{
	// TODO
	return "";
}

int JsoJsonAddValue(struct JsoJsonHandle* h, const JsoJsonPremitiveValue p)
{
}
