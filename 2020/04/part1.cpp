#include <iostream>
#include <ostream>
#include <unordered_map>

#include "../input.hpp"

class Passport {
  std::unordered_map<std::string, std::string> fields_;

  void reset() { fields_.clear(); }

 public:
  static std::vector<Passport> parse(const std::string& path) {
    std::ifstream file(path);

    std::vector<Passport> res;
    Passport lastPass;
    std::string line;
    while (std::getline(file, line)) {
      if (line.empty()) {
        res.push_back(lastPass);
        lastPass.reset();
        continue;
      }

      std::string::size_type beg = 0;
      do {
        auto end = line.find(' ', beg);
        if (end == std::string::npos) end = line.size() - 1;

        auto colon_pos = beg;
        while (line[colon_pos] != ':') colon_pos++;

        const auto field_name = line.substr(beg, colon_pos - beg);
        const auto field_val =
            line.substr(colon_pos + 1, end - (colon_pos + 1));
        assert(lastPass.fields_.find(field_name) == lastPass.fields_.end());
        lastPass.fields_[field_name] = field_val;

        beg = end + 1;
      } while (beg < line.size());
    }
    res.push_back(lastPass);

    return res;
  }

  bool valid() const {
    return fields_.contains("byr") && fields_.contains("iyr") &&
           fields_.contains("eyr") && fields_.contains("hgt") &&
           fields_.contains("hcl") && fields_.contains("ecl") &&
           fields_.contains("pid") /*&& fields_.contains("cid") */;
  }

  friend std::ostream& operator<<(std::ostream& os, const Passport& pp) {
    os << "{";
    size_t i = 0;
    for (const auto& field : pp.fields_) {
      os << "'" << field.first << "': " << field.second;
      if (++i < pp.fields_.size()) os << ", ";
    }
    os << "}";
    return os;
  }
};

int main() {
  const auto passports = Passport::parse("04/input.txt");

  int valid_cnt = 0;
  for (const auto& passport : passports) {
    // std::cout << "  pp: " << passport << std::endl;
    valid_cnt += passport.valid();
  }

  std::cout << "valid passports: " << valid_cnt << std::endl;

  return 0;
}
