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
  user_insert_stmt_.reset(connection_->prepareStatement(
    "insert into user_table value (null, ?, ?)"
  ));
  top_user_id_ = getUserCount();
}

uint32_t EaDb::getUserCount() const
{
  std::unique_ptr<sql::ResultSet> result{ statement_->executeQuery("select count(1) from user_table") };
  return result->next() ? result->getInt(1) : throw std::runtime_error{"sql error in getUserCount"};
}

uint32_t EaDb::addUser(const UserData userData)
{
  user_insert_stmt_->setInt(1, userData.foreignId);
  user_insert_stmt_->setInt(2, userData.foreignServerId);
  if (user_insert_stmt_->execute()) {
    throw std::runtime_error{ "sql error in addUser" };
  }
  ++top_user_id_;
  return top_user_id_;
}
