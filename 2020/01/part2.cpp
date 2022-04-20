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

  // 3sum
  for (size_t j = 0; j < input.size(); j++) {
    const auto rem1 = target - input[j];

    // 2sum
    for (size_t i = j + 1; i < input.size(); i++) {
      const auto rem2 = rem1 - input[i];
      if (m.find(rem2) != m.end()) {
        std::cout << input[j] << " * " << input[i] << " * " << input[m[rem2]]
                  << " = " << input[j] * input[i] * input[m[rem2]] << std::endl;
        return 0;
      }
    }
  }

  return -1;
}
