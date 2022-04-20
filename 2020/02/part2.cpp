#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>

#include "../input.hpp"

class PasswordEntry {
  size_t pos1, pos2;
  char character;
  std::string pwd;

 public:
  bool is_valid() const {
    assert(pos1 > 0);
    assert(pos2 > 0);
    assert(pos1 - 1 < pwd.size());
    assert(pos2 - 1 < pwd.size());
    return 1 == ((pwd[pos1 - 1] == character) + (pwd[pos2 - 1] == character));
  }

  static PasswordEntry parse(const std::string& s) {
    std::istringstream ss(s);

    char c;

    PasswordEntry pwd_e;
    ss >> pwd_e.pos1;
    ss >> c;
    assert(c == '-');
    ss >> pwd_e.pos2;
    ss >> pwd_e.character;
    ss >> c;
    assert(c == ':');
    ss >> pwd_e.pwd;

    return pwd_e;
  }
};

int main() {
  auto input =
      aoc::load_input<PasswordEntry>("./02/input.txt", PasswordEntry::parse);

  size_t cnt = 0;
  for (const auto& pwd_e : input) {
    cnt += pwd_e.is_valid();
  }
  std::cout << cnt << std::endl;

  return 0;
}
