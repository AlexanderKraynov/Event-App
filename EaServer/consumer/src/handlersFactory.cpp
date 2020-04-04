#include "handlersFactory.hpp"

std::unordered_map<std::string, std::function<HandlersFactory::Handler(const HandlersFactory::Json&)>>
HandlersFactory::producers_ = {
  { "add_user"         , produce_add_user_          },
  { "get_user_events"  , produce_get_user_event_    },
  { "get_custom_events", produce_get_custom_events_ },
  { "add_custom_event" , produce_add_custom_event_  },
  { "add_kudago_event" , produce_add_kudago_event_  },
  { "bind_user_event"  , produce_bind_user_event_   }
};

HandlersFactory::Handler HandlersFactory::produce(const Json& json)
{
  if (!json.contains("from_id") || !json["from_id"].is_number()) {
    return [](EaDb*) {
      std::cout << "no from_id provided.";
    };
  }
  if (!json.contains("command")) {
    return produce_invalid_(json);
  }
  auto command = json["command"].get<std::string>();
  if (producers_.find(command) != producers_.end()) {
    return producers_[command](json);
  }
  return produce_invalid_(json);
}

HandlersFactory::Handler HandlersFactory::produce_get_user_event_(const Json& json)
{
  auto fromId = json["from_id"].get<uint32_t>();
  if (!json.contains("user_id") || !json["user_id"].is_number()) {
    return produce_invalid_(json);
  }
  auto userId = json["user_id"].get<uint32_t>();
  return [=](EaDb* eaDb) {
    auto res = eaDb->getUserEvents(userId);
    std::cout << fromId << " (get_user_event) -> ";
    for (auto& e : res) {
      std::cout << e << " ";
    }
    std::cout << std::endl;
  };
}


HandlersFactory::Handler HandlersFactory::produce_get_custom_events_(const Json& json)
{
  auto fromId = json["from_id"].get<uint32_t>();
  return [=](EaDb* eaDb) {
    auto res = eaDb->getCustomEvents();
    std::cout << fromId << " (get_custom_events) -> ";
    for (auto& e : res) {
      std::cout << e << " ";
    }
    std::cout << std::endl;
  };
}

HandlersFactory::Handler HandlersFactory::produce_add_user_(const Json& json)
{
  if (!json.contains("foreign_id") || !json["foreign_id"].is_number()) {
    return produce_invalid_(json);
  }
  auto foreignId = json["foreign_id"].get<uint32_t>();
  if (!json.contains("foreign_server_id") || !json["foreign_server_id"].is_number()) {
    return produce_invalid_(json);
  }
  auto foreignServerId = json["foreign_server_id"].get<uint32_t>();
  return [=](EaDb* eaDb) {
    auto res = eaDb->addUser({ foreignId, foreignServerId });
    std::cout << "0 (add_user) -> " << res << std::endl;
  };
}

HandlersFactory::Handler HandlersFactory::produce_add_custom_event_(const Json& json)
{
  auto fromId = json["from_id"].get<uint32_t>();
  if (!json.contains("title") || !json["title"].is_string()) {
    return produce_invalid_(json);
  }
  auto title = json["title"].get<std::wstring>();
  if (!json.contains("brief") || !json["brief"].is_string()) {
    return produce_invalid_(json);
  }
  auto brief = json["brief"].get<std::wstring>();
  return [=](EaDb* eaDb) {
    auto res = eaDb->addCustomEvent({ title, brief });
    std::cout << fromId << " (add_custom_event) -> " << res << std::endl;
  };
}

HandlersFactory::Handler HandlersFactory::produce_add_kudago_event_(const Json& json)
{
  auto fromId = json["from_id"].get<uint32_t>();
  if (!json.contains("kudago_id") || !json["kudago_id"].is_number()) {
    return produce_invalid_(json);
  }
  auto kudagoId = json["kudago_id"].get<uint32_t>();
  return [=](EaDb* eaDb) {
    auto res = eaDb->addKudagoEvent(kudagoId);
    std::cout << fromId << " (add_kudago_event) -> " << res << std::endl;
  };
}

HandlersFactory::Handler HandlersFactory::produce_bind_user_event_(const Json& json)
{
  auto fromId = json["from_id"].get<uint32_t>();
  if (!json.contains("user_id") || !json["user_id"].is_number()) {
    return produce_invalid_(json);
  }
  auto userId = json["user_id"].get<uint32_t>();
  if (!json.contains("event_id") || !json["event_id"].is_number()) {
    return produce_invalid_(json);
  }
  auto eventId = json["event_id"].get<uint32_t>();
  return [=](EaDb* eaDb) {
    eaDb->bindUserToEvent(userId, eventId);
    std::cout << fromId << " (bind_user_event) -> none" << std::endl;
  };
}

HandlersFactory::Handler HandlersFactory::produce_invalid_(const Json& json)
{
  auto fromId = json["from_id"].get<uint32_t>();
  return [=](EaDb*) {
    std::cout << fromId << " unknown -> error" << std::endl;
  };
}

