#include <iostream>

#include "eadb.hpp"

int main()
{
  try {

    EaDb eaDb{ "tcp://127.0.0.1:3306", "root", "AyanamiRei3", "ea_db" };

    auto events = eaDb.getUserEvents(1);

    std::for_each(events.begin(), events.end(), [&](auto& i) { std::cout << i << " "; });

    return EXIT_SUCCESS;
  } catch (const std::exception& e) {
    std::cerr << e.what() << std::endl;
    return EXIT_FAILURE;
  }
}