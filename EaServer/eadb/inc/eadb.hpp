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

  [[nodiscard]] uint32_t getUserCount() const;
  [[nodiscard]] uint32_t addUser(UserData userData);

private:

  std::string                              address_;
  std::string                              user_;
  std::string                              password_;
  std::string                              db_schema_;
                                           
  sql::Driver*                             driver_;
  std::unique_ptr<sql::Connection>         connection_;
  std::unique_ptr<sql::Statement>          statement_;
  std::unique_ptr<sql::PreparedStatement>  user_insert_stmt_;

  uint32_t                                 top_user_id_;
};
