#include <cassert>
#include <cstdint>
#include <iostream>
#include <sstream>
#include <vector>

#include "../input.hpp"

class Map {
 public:
  enum Tile { EMPTY, TREE };

 private:
  const std::vector<std::vector<Tile>> tiles;

  static std::vector<Tile> parseRow(const std::string& row) {
    std::vector<Tile> tiles(row.size(), Tile::EMPTY);
    for (size_t i = 0; i < row.size(); i++) {
      const auto& t = row[i];
      switch (t) {
        case '.':
          tiles[i] = Tile::EMPTY;
          break;
        case '#':
          tiles[i] = Tile::TREE;
          break;
      }
    }
    return tiles;
  }

 public:
  explicit Map(const std::string& input_file)
      : tiles(aoc::load_input<std::vector<Tile>>(input_file, Map::parseRow)) {
    // catch parsing errors early
    for (const auto& row : tiles) assert(row.size() == tiles.front().size());
  }

  Tile at(int x, int y) const {
    assert(y >= 0);
    assert(y < tiles.size());

    const auto cols = tiles.front().size();
    return tiles[y][x % cols];
  }

  size_t height() const { return tiles.size(); }
};

int main() {
  auto map = Map("./03/input.txt");
  std::uint64_t multipliedTreeCnts = 1;
  for (const auto& traj : std::vector<std::pair<int, int>>{
           {1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}}) {
    int posX = 0, posY = 0;

    int trajX = traj.first, trajY = traj.second;
    int treeCnt = 0;
    while (posY < map.height()) {
      const auto tile = map.at(posX, posY);

      treeCnt += tile == Map::Tile::TREE;

      posX += trajX;
      posY += trajY;
    }

    multipliedTreeCnts *= treeCnt;
  }

  std::cout << "multiplied tree counts: " << multipliedTreeCnts << std::endl;

  return 0;
}
