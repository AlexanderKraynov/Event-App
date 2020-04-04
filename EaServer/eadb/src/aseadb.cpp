#include "aseadb.hpp"

#include <utility>

AsyncEaDb::AsyncEaDb(std::string address, std::string user, std::string password, std::string dbSchema):
  ea_db_(std::move(address), std::move(user), std::move(password), std::move(dbSchema)),
  handler_thread_(&AsyncEaDb::handle_, this)
{
}

AsyncEaDb::~AsyncEaDb()
{
  exit_ = true;
  handler_queue_.notifyAll();
  handler_thread_.join();
}

void AsyncEaDb::push(const Handler& handler)
{
  handler_queue_.push(handler);
}

void AsyncEaDb::handle_()
{
  while (true) {
    if (!exit_) {
      handler_queue_.waitForData();
    }
    if (!exit_ || !handler_queue_.empty()) {
      handler_queue_.pop()(&ea_db_);
    }
    if (exit_ && handler_queue_.empty()) {
      break;
    }
  }
}
