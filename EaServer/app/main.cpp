#include <iostream>

#include "aseadb.hpp"
#include "handlersFactory.hpp"

int main()
{
  try {
    AsyncEaDb asyncEaDb{ "tcp://127.0.0.1:3306", "root", "", "ea_db" };

    asyncEaDb.push(HandlersFactory::produce({
      {"from_id", 1488},
      {"command", "add_kudago_event"},
      {"kudago_id", 30032001}
    }));

    return EXIT_SUCCESS;
  } catch (const std::exception& e) {
    std::cerr << e.what() << std::endl;
    return EXIT_FAILURE;
  }
}