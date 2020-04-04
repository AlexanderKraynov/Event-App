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
#include "eventData.hpp"

class EaDb
{
public:

  EaDb(const std::string& address, const std::string& user, const std::string& password, const std::string& dbSchema);

  [[nodiscard]] uint32_t              getUserCount()                 const;
  [[nodiscard]] uint32_t              getEventCount()                const;
  [[nodiscard]] std::vector<uint32_t> getUserEvents(uint32_t userId) const;
  [[nodiscard]] std::vector<uint32_t> getCustomEvents()              const;

  [[nodiscard]] uint32_t addUser(UserData userData);
  [[nodiscard]] uint32_t addCustomEvent(const EventData& eventData) const;
  [[nodiscard]] uint32_t addKudagoEvent(uint32_t kudagoId)          const;

  [[nodiscard]] bool userExist(uint32_t userId)   const noexcept;
  [[nodiscard]] bool eventExist(uint32_t eventId) const noexcept;

  void bindUserToEvent(uint32_t userId, uint32_t eventId) const;

private:

  using Result   = std::unique_ptr<sql::ResultSet>;
  using PrepStmt = std::unique_ptr<sql::PreparedStatement>;

  void expect_user_exist_(uint32_t userId, const char* errorMessage)   const;
  void expect_event_exist_(uint32_t eventId, const char* errorMessage) const;
                                           
  sql::Driver*                             driver_;
  std::unique_ptr<sql::Connection>         connection_;
  std::unique_ptr<sql::Statement>          statement_;

  uint32_t                                 top_user_id_;
  uint32_t                                 top_event_id_;
};
