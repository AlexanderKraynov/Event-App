#include "aseadb.hpp"

#include <utility>

AsyncEaDb::AsyncEaDb(std::string address, std::string user, std::string password, std::string dbSchema):
  hq_thread_([&]() {
    while (true) {
      handler_queue_.waitForData();
      handler_queue_.pop()(ea_db_);
    }
  }),
  ea_db_(std::move(address), std::move(user), std::move(password), std::move(dbSchema))
{
  hq_thread_.detach(); // ToDo: when the object will be deleted, the program will crash. Fix needed.
}

void AsyncEaDb::push(const Handler& handler)
{
  handler_queue_.push(handler);
}
