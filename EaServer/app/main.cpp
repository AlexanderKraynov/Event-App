#include <iostream>

#include "eadb.hpp"

int main()
{
  try {

    EaDb eaDb{ "tcp://127.0.0.1:3306", "root", "", "ea_db" };

    std::cout << eaDb.addCustomEvent({ L"русские", L"вперед" });

    return EXIT_SUCCESS;
  } catch (const std::exception& e) {
    std::cerr << e.what() << std::endl;
    return EXIT_FAILURE;
  }
}