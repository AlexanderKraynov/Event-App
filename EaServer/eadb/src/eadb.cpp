#include "eadb.hpp"

#include <sstream>

#include <windows.h>
#include <stringapiset.h>

std::string utf8Encode(const std::wstring& wstr)
{
  if (wstr.empty()) return std::string();
  auto sizeNeeded = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], static_cast<int>(wstr.size()),
                                        nullptr, 0, nullptr, nullptr);
  std::string strTo(sizeNeeded, 0);
  WideCharToMultiByte(CP_UTF8, 0, &wstr[0], static_cast<int>(wstr.size()), 
    &strTo[0], sizeNeeded, nullptr, nullptr);
  return strTo;
}

std::wstring utf8Decode(const std::string& str)
{
  if (str.empty()) return std::wstring();
  auto sizeNeeded = MultiByteToWideChar(CP_UTF8, 0, &str[0], static_cast<int>(str.size()),
                                        nullptr, 0);
  std::wstring wstrTo(sizeNeeded, 0);
  MultiByteToWideChar(CP_UTF8, 0, &str[0], static_cast<int>(str.size()), 
    &wstrTo[0], sizeNeeded);
  return wstrTo;
}

EaDb::EaDb(std::string address, std::string user, std::string password, std::string dbSchema):
  address_(std::move(address)),
  user_(std::move(user)),
  password_(std::move(password)),
  db_schema_(std::move(dbSchema)),
  driver_(get_driver_instance()),
  connection_(driver_->connect(address_, user_, password_))
{
  connection_->setSchema(db_schema_);
  statement_.reset(connection_->createStatement());
  top_user_id_ = getUserCount();
  top_event_id_ = getEventCount();
}

uint32_t EaDb::getUserCount() const
{
  std::unique_ptr<sql::ResultSet> result{ statement_->executeQuery("select count(1) from user_table") };
  return result->next() ? result->getInt(1) : throw std::runtime_error{"sql error in getUserCount"};
}

uint32_t EaDb::getEventCount() const
{
  std::unique_ptr<sql::ResultSet> result{ statement_->executeQuery("select count(1) from event_table") };
  return result->next() ? result->getInt(1) : throw std::runtime_error{ "sql error in getEventCount" };
}

std::vector<uint32_t> EaDb::getUserEvents(const uint32_t userId) const
{
  expect_user_exist_(userId, "invalid user id was provided to getUserEvents");
  static PrepStmt getUserEventsStmt{ connection_->prepareStatement(
    "select get_user_events(?)"
  ) };
  getUserEventsStmt->setUInt(1, userId);
  Result result{ getUserEventsStmt->executeQuery() };
  std::vector<uint32_t> eventIds(result->rowsCount());
  for (auto& id : eventIds) {
    result->next();
    id = result->getUInt(1);
  }
  return eventIds;
}

std::vector<uint32_t> EaDb::getCustomEvents() const
{
  Result result{ statement_->executeQuery(
  "call get_custom_events()"
  )};
  std::vector<uint32_t> eventIds(result->rowsCount());
  for (auto& id : eventIds) {
    result->next();
    id = result->getUInt(1);
  }
  return eventIds;
}

uint32_t EaDb::addUser(const UserData userData)
{
  static PrepStmt userInsertStmt{ connection_->prepareStatement(
    "select add_user(?, ?)"
  )};
  userInsertStmt->setInt(1, userData.foreignId);
  userInsertStmt->setInt(2, userData.foreignServerId);
  Result result{ userInsertStmt->executeQuery() };
  result->next();
  auto newIndex = result->getUInt(1);
  top_user_id_ = newIndex ? newIndex : top_user_id_;
  return newIndex;
}

uint32_t EaDb::addCustomEvent(const EventData& eventData) const
{
  static PrepStmt createCustomEventStmt{ connection_->prepareStatement(
    "select create_custom_event(?, ?)"
  ) };
 
  std::stringstream td{ utf8Encode(eventData.title) };
  std::stringstream bd{ utf8Encode(eventData.brief) };

  createCustomEventStmt->setBlob(1, &td);
  createCustomEventStmt->setBlob(2, &bd);
  Result result{ createCustomEventStmt->executeQuery() };
  result->next();
  return result->getUInt(1);
}

uint32_t EaDb::addKudagoEvent(const uint32_t kudagoId) const
{
  static PrepStmt getEventFromKudagoStmt{ connection_->prepareStatement(
    "select get_event_from_kudago(?)"
  ) };
  getEventFromKudagoStmt->setUInt(1, kudagoId);
  Result result{ getEventFromKudagoStmt->executeQuery() };
  result->next();
  return result->getUInt(1);
}

bool EaDb::userExist(const uint32_t userId) const noexcept
{
  return userId > 0 && userId <= top_user_id_;
}

bool EaDb::eventExist(const uint32_t eventId) const noexcept
{
  return eventId > 0 && eventId <= top_event_id_;
}

void EaDb::bindUserToEvent(const uint32_t userId, const uint32_t eventId) const
{
  expect_user_exist_(userId, "invalid user id was provided to bindUserToEvent");
  expect_event_exist_(eventId, "invalid event id was provided to bindUserToEvent");
  static PrepStmt bindUserEventStmt{ connection_->prepareStatement(
    "call bind_user_to_event(?, ?)"
  )};
  bindUserEventStmt->setInt(1, userId);
  bindUserEventStmt->setInt(2, eventId);
  bindUserEventStmt->execute();
}

void EaDb::expect_user_exist_(const uint32_t userId, const char* errorMessage) const
{
  if (!userExist(userId)) {
    throw std::runtime_error{ errorMessage };
  }
}

void EaDb::expect_event_exist_(const uint32_t eventId, const char* errorMessage) const
{
  if (!eventExist(eventId)) {
    throw std::runtime_error{ errorMessage };
  }
}
