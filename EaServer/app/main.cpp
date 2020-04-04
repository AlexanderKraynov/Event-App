#include <iostream>

#include "aseadb.hpp"

int main()
{
  try {

    AsyncEaDb asyncEaDb{ "tcp://127.0.0.1:3306", "root", "", "ea_db" };

    asyncEaDb.push([](EaDb* eaDb) { std::cout << eaDb->addKudagoEvent(30032001); });
    asyncEaDb.push([](EaDb* eaDb) { std::cout << eaDb->addCustomEvent({L"test", L"test"}); });

    return EXIT_SUCCESS;
  } catch (const std::exception& e) {
    std::cerr << e.what() << std::endl;
    return EXIT_FAILURE;
  }
}