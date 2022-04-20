#include <iostream>
#include <unordered_map>
#include <vector>

#include "../input.hpp"

int main() {
  using T = int;
  const T target = 2020;
  auto input = aoc::load_input<T>("./01/input.txt", aoc::IntParser<T>);

  // Build index over input (O(n)). Since there are exactly two numbers that
  // work, this is sufficient!
  std::unordered_map<T, size_t> m;
  for (size_t i = 0; i < input.size(); i++) m[input[i]] = i;

  // find matching pair using index
  for (size_t i = 0; i < input.size(); i++) {
    const auto rem = target - input[i];
    if (m.find(rem) != m.end()) {
      std::cout << input[i] << " * " << input[m[rem]] << " = "
                << input[i] * input[m[rem]] << std::endl;
      return 0;
    }
  }

  return -1;
}
