#include <iostream>

#include "eadb.hpp"

int main()
{
  try {

    EaDb eaDb{ "tcp://127.0.0.1:3306", "root", "", "ea_db" };

    std::cout << eaDb.getUserCount() << "\n";

    auto id = eaDb.addUser({ 333, 1 });

    std::cout << id << " : " << eaDb.getUserCount() << "\n";

    return EXIT_SUCCESS;
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return EXIT_FAILURE;
  }
}