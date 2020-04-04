#include <iostream>

#include "aseadb.hpp"
#include "handlersFactory.hpp"

int main()
{
  try {
    AsyncEaDb asyncEaDb{ "tcp://127.0.0.1:3306", "root", "AyanamiRei3", "ea_db" };

    /*asyncEaDb.push(HandlersFactory::produce({
      {"from_id", 1},
      {"command", "get_user_events"},
      {"user_id", 1}
    }));*/

    /*asyncEaDb.push([](EaDb* eaDb) {
      auto res = eaDb->getUserEvents(1);
      std::cout << 1 << " (get_user_event) -> ";
      for (auto& e : res) {
        std::cout << e << " ";
      }
      std::cout << std::endl;
    });

    asyncEaDb.push([](EaDb*) { std::cout << "fuck!\n"; });*/

    asyncEaDb.push([](EaDb* eaDb) { std::cout << eaDb->addKudagoEvent(30032001); });

    return EXIT_SUCCESS;
  } catch (const std::exception& e) {
    std::cerr << e.what() << std::endl;
    return EXIT_FAILURE;
  }
}