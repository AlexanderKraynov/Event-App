#pragma once

#include <thread>

#include "eadb.hpp"
#include "threadSafeQueue.hpp"

class AsyncEaDb : public std::enable_shared_from_this<AsyncEaDb>
{
public:

  using Handler = std::function<void(EaDb*)>;

  AsyncEaDb(std::string address, std::string user, std::string password, std::string dbSchema);

  ~AsyncEaDb();

  void push(const Handler& handler);

private:

  void handle_();

  bool                          exit_{ false };

  EaDb                          ea_db_;
  std::thread                   handler_thread_;
  ThreadSafeQueue<Handler>      handler_queue_;
};
