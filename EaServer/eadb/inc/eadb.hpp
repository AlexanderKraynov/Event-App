#pragma once

#include <memory>
#include <string>

#include "mysql_connection.h"

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

#include "userData.hpp"

class EaDb
{
public:

  EaDb(std::string address, std::string user, std::string password, std::string dbSchema);

  [[nodiscard]] uint32_t              getUserCount()                 const;
  [[nodiscard]] uint32_t              getEventCount()                const;
  [[nodiscard]] std::vector<uint32_t> getUserEvents(uint32_t userId) const;
  [[nodiscard]] std::vector<uint32_t> getCustomEvents()              const;

  [[nodiscard]] uint32_t addUser(UserData userData);

  [[nodiscard]] bool userExist(uint32_t userId)   const noexcept;
  [[nodiscard]] bool eventExist(uint32_t eventId) const noexcept;

  void bindUserToEvent(uint32_t userId, uint32_t eventId) const;

private:

  using Result   = std::unique_ptr<sql::ResultSet>;
  using PrepStmt = std::unique_ptr<sql::PreparedStatement>;

  void expect_user_exist_(uint32_t userId, const char* errorMessage)   const;
  void expect_event_exist_(uint32_t eventId, const char* errorMessage) const;

  std::string                              address_;
  std::string                              user_;
  std::string                              password_;
  std::string                              db_schema_;
                                           
  sql::Driver*                             driver_;
  std::unique_ptr<sql::Connection>         connection_;
  std::unique_ptr<sql::Statement>          statement_;

  uint32_t                                 top_user_id_;
  uint32_t                                 top_event_id_;
};
