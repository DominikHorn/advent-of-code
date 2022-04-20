#pragma once

#include <fstream>
#include <functional>
#include <sstream>
#include <string>
#include <vector>

namespace aoc {
template <class T>
T IntParser(const std::string& s) {
  std::stringstream ss;
  ss << s;

  T n;
  ss >> n;
  return n;
}

template <class Row>
std::vector<Row> load_input(
    const std::string& path,
    const std::function<Row(const std::string&)> parser =
        [](const std::string& s) { return s; }) {
  std::ifstream file(path);

  std::vector<Row> res;
  std::string line;
  while (std::getline(file, line)) {
    res.push_back(parser(line));
  }
  return res;
}
}  // namespace aoc
