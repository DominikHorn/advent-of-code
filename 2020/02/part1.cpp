#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>

#include "../input.hpp"

class PasswordEntry {
  size_t min, max;
  char character;
  std::string pwd;

 public:
  bool is_valid() const {
    size_t cnt = 0;
    for (const auto& c : pwd) {
      cnt += c == character;
    }

    return cnt >= min && cnt <= max;
  }

  static PasswordEntry parse(const std::string& s) {
    std::istringstream ss(s);

    char c;

    PasswordEntry pwd_e;
    ss >> pwd_e.min;
    ss >> c;
    assert(c == '-');
    ss >> pwd_e.max;
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
