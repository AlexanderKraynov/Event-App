#pragma once

#include "aseadb.hpp"
#include "nlohmann/json.hpp"

#define DEF_PRODUCER(kind) static Handler produce_##kind##_(const Json& json)

class HandlersFactory
{
public:

  using Handler = AsyncEaDb::Handler;
  using Json = nlohmann::json;

  static Handler produce(const Json& json);

private:

  DEF_PRODUCER(get_user_event);
  DEF_PRODUCER(get_custom_events);
  DEF_PRODUCER(add_user);
  DEF_PRODUCER(add_custom_event);
  DEF_PRODUCER(add_kudago_event);
  DEF_PRODUCER(bind_user_event);
  DEF_PRODUCER(invalid);

  static std::unordered_map<std::string, std::function<Handler(const Json&)>> producers_;
};

#undef DEF_PRODUCER
