#include "eadb.hpp"

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
  return top_user_id_;
}

std::vector<uint32_t> EaDb::getUserEvents(uint32_t userId) const
{
  static PrepStmt getUserEventsStmt{ connection_->prepareStatement(
    "select event_id from event_participant_table where user_id = ?"
  ) };
  expect_user_exist_(userId, "invalid user id was provided to getUserEvents");
  getUserEventsStmt->setInt(1, userId);
  Result result{ getUserEventsStmt->executeQuery() };
  std::vector<uint32_t> eventIds;
  while (result->next()) {
    eventIds.emplace_back(result->getInt(1));
  }
  return eventIds;
}

std::vector<uint32_t> EaDb::getCustomEvents() const
{
  Result result{ statement_->executeQuery(
  "select id from event_table where kudago_id is null"
  )};
  std::vector<uint32_t> eventIds;
  while (result->next()) {
    eventIds.emplace_back(result->getInt(1));
  }
  return eventIds;
}

uint32_t EaDb::addUser(const UserData userData)
{
  static PrepStmt userInsertStmt{ connection_->prepareStatement(
    "insert into user_table value (null, ?, ?)"
  )};
  userInsertStmt->setInt(1, userData.foreignId);
  userInsertStmt->setInt(2, userData.foreignServerId);
  if (userInsertStmt->execute()) {
    throw std::runtime_error{ "sql error in addUser" };
  }
  ++top_user_id_;
  return top_user_id_;
}

bool EaDb::userExist(uint32_t userId) const noexcept
{
  return userId > 0 && userId <= top_user_id_;
}

bool EaDb::eventExist(uint32_t eventId) const noexcept
{
  return eventId > 0 && eventId <= top_event_id_;
}

void EaDb::bindUserToEvent(uint32_t userId, uint32_t eventId) const
{
  expect_user_exist_(userId, "invalid user id was provided to bindUserToEvent");
  expect_event_exist_(eventId, "invalid event id was provided to bindUserToEvent");
  static PrepStmt bindUserEventStmt{ connection_->prepareStatement(
    "insert into event_participant_table value(? , ? )"
  )};
  bindUserEventStmt->setInt(1, userId);
  bindUserEventStmt->setInt(2, eventId);
  if (bindUserEventStmt->execute()) {
    throw std::runtime_error{ "sql error in bindUserToEvent" };
  }
}

void EaDb::expect_user_exist_(uint32_t userId, const char* errorMessage) const
{
  if (!userExist(userId)) {
    throw std::runtime_error{ errorMessage };
  }
}

void EaDb::expect_event_exist_(uint32_t eventId, const char* errorMessage) const
{
  if (!eventExist(eventId)) {
    throw std::runtime_error{ errorMessage };
  }
}
