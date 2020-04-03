#pragma once

#include <queue>
#include <thread>
#include <mutex>

#include "eadb.hpp"
#include "threadSafeQueue.hpp"

class AsyncEaDb
{
public:

  using Handler = std::function<void(EaDb&)>;

  AsyncEaDb(std::string address, std::string user, std::string password, std::string dbSchema);

  void push(const Handler& handler);

private:

  ThreadSafeQueue<Handler> handler_queue_;
  std::thread              hq_thread_;
  EaDb                     ea_db_;
};
