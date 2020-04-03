#pragma once

#include <queue>
#include <mutex>
#include <condition_variable>

template <typename T>
class ThreadSafeQueue
{
public:

  void push(const T&);
  T    pop();

  void waitForData();

private:

  std::queue<T>            queue_;
  std::mutex               queue_mutex_;
  std::condition_variable  condition_;
};

template <typename T>
void ThreadSafeQueue<T>::push(const T& t)
{
  std::lock_guard lock{ queue_mutex_ };
  queue_.push(t);
  if (queue_.size() == 1) {
    condition_.notify_one();
  }
}

template <typename T>
T ThreadSafeQueue<T>::pop()
{
  std::lock_guard lock{ queue_mutex_ };
  auto top = queue_.front();
  queue_.pop();
  return top;
}

template <typename T>
void ThreadSafeQueue<T>::waitForData()
{
  std::unique_lock lock{ queue_mutex_ };
  while (queue_.empty()) {
    condition_.wait(lock);
  }
}
