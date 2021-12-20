import Foundation

/*
 --- Day 20: Trench Map ---
 
 With the scanners fully deployed, you turn their attention to mapping the floor of the ocean trench.

 When you get back the image from the scanners, it seems to just be random noise. Perhaps you can combine an image enhancement algorithm and the input image (your puzzle input) to clean it up a little.

 For example:

 ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
 #..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###
 .######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.
 .#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....
 .#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..
 ...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....
 ..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

 #..#.
 #....
 ##..#
 ..#..
 ..###
 The first section is the image enhancement algorithm. It is normally given on a single line, but it has been wrapped to multiple lines in this example for legibility. The second section is the input image, a two-dimensional grid of light pixels (#) and dark pixels (.).

 The image enhancement algorithm describes how to enhance an image by simultaneously converting all pixels in the input image into an output image. Each pixel of the output image is determined by looking at a 3x3 square of pixels centered on the corresponding input image pixel. So, to determine the value of the pixel at (5,10) in the output image, nine pixels from the input image need to be considered: (4,9), (4,10), (4,11), (5,9), (5,10), (5,11), (6,9), (6,10), and (6,11). These nine input pixels are combined into a single binary number that is used as an index in the image enhancement algorithm string.

 For example, to determine the output pixel that corresponds to the very middle pixel of the input image, the nine pixels marked by [...] would need to be considered:

 # . . # .
 #[. . .].
 #[# . .]#
 .[. # .].
 . . # # #
 Starting from the top-left and reading across each row, these pixels are ..., then #.., then .#.; combining these forms ...#...#.. By turning dark pixels (.) into 0 and light pixels (#) into 1, the binary number 000100010 can be formed, which is 34 in decimal.

 The image enhancement algorithm string is exactly 512 characters long, enough to match every possible 9-bit binary number. The first few characters of the string (numbered starting from zero) are as follows:

 0         10        20        30  34    40        50        60        70
 |         |         |         |   |     |         |         |         |
 ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
 In the middle of this first group of characters, the character at index 34 can be found: #. So, the output pixel in the center of the output image should be #, a light pixel.

 This process can then be repeated to calculate every pixel of the output image.

 Through advances in imaging technology, the images being operated on here are infinite in size. Every pixel of the infinite output image needs to be calculated exactly based on the relevant pixels of the input image. The small input image you have is only a small region of the actual infinite input image; the rest of the input image consists of dark pixels (.). For the purposes of the example, to save on space, only a portion of the infinite-sized input and output images will be shown.

 The starting input image, therefore, looks something like this, with more dark pixels (.) extending forever in every direction not shown here:

 ...............
 ...............
 ...............
 ...............
 ...............
 .....#..#......
 .....#.........
 .....##..#.....
 .......#.......
 .......###.....
 ...............
 ...............
 ...............
 ...............
 ...............
 By applying the image enhancement algorithm to every pixel simultaneously, the following output image can be obtained:

 ...............
 ...............
 ...............
 ...............
 .....##.##.....
 ....#..#.#.....
 ....##.#..#....
 ....####..#....
 .....#..##.....
 ......##..#....
 .......#.#.....
 ...............
 ...............
 ...............
 ...............
 Through further advances in imaging technology, the above output image can also be used as an input image! This allows it to be enhanced a second time:

 ...............
 ...............
 ...............
 ..........#....
 ....#..#.#.....
 ...#.#...###...
 ...#...##.#....
 ...#.....#.#...
 ....#.#####....
 .....#.#####...
 ......##.##....
 .......###.....
 ...............
 ...............
 ...............
 Truly incredible - now the small details are really starting to come through. After enhancing the original input image twice, 35 pixels are lit.

 Start with the original input image and apply the image enhancement algorithm twice, being careful to account for the infinite size of the images. How many pixels are lit in the resulting image?
 */

enum ParsingError: Error {
  case missingAlgorithm
  case missingBaseImage
  case pixelError(_ raw: Character)
}

enum PixelValue: Character {
  case lit = "#"
  case unlit = "."
  
  static prefix func !(pixel: PixelValue) -> PixelValue {
    pixel == .lit ? .unlit : .lit
  }
}

struct Coordinate: Hashable {
  var x: Int
  var y: Int
  
  /// nine neighboring pixels (diagonal and straight), including self, ordered
  var neighborhood: [Coordinate] {
    [
      .init(x: x-1, y: y-1),
      .init(x: x  , y: y-1),
      .init(x: x+1, y: y-1),
      .init(x: x-1, y: y  ),
      .init(x: x  , y: y  ),
      .init(x: x+1, y: y  ),
      .init(x: x-1, y: y+1),
      .init(x:   x, y: y+1),
      .init(x: x+1, y: y+1),
    ]
  }
}

struct Rectangle: Hashable {
  var origin: Coordinate = .init(x: 0, y: 0)
  var width: Int = 0
  var height: Int = 0
  
  func contains(_ coord: Coordinate) -> Bool {
    coord.x >= origin.x && coord.x <= origin.x + width
    && coord.y >= origin.y && coord.y <= origin.y + height
  }
}

struct Image {
  // compact O(1) access representation of the bitvector
  private let enhanceToLit: Set<UInt16>
  
  private var touchedPixels = Set<Coordinate>()
  private var backgroundColor = PixelValue.unlit
  
  var litPixelCount: Int {
    backgroundColor == .lit ? .max : touchedPixels.count
  }
  
  private init(enhanceToLit: Set<UInt16>) {
    self.enhanceToLit = enhanceToLit
  }
  
  init(description: String) throws {
    let raw = description.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
    guard !raw.isEmpty, let rawEnhance = raw.first else { throw ParsingError.missingAlgorithm }
    
    // only retain lit pixels
    self.enhanceToLit = .init(
      rawEnhance
        .enumerated()
        .filter { PixelValue(rawValue: $0.element) == .lit }
        .map { UInt16($0.offset) }
    )
  
    guard raw.count > 1 else { throw ParsingError.missingBaseImage }
    
    try raw[1..<raw.count].enumerated().forEach { y, row in
      try row.enumerated().forEach { x, rawPixel in
        guard let pixel = PixelValue(rawValue: rawPixel) else { throw ParsingError.pixelError(rawPixel) }
        
        if pixel == .lit {
          touchedPixels.insert(.init(x: x, y: y))
        }
      }
    }
  }
  
  /// value of pixel at specific coordinate
  func pixelValue(at coord: Coordinate) -> PixelValue {
    touchedPixels.contains(coord) ? !backgroundColor : backgroundColor
  }
  
  /// 3 x 3 grid value around given center, i.e., 9 bit unsigned int
  func gridValue(centeredAt coord: Coordinate) -> UInt16 {
    coord.neighborhood.reduce(into: 0) {
      $0 <<= 1
      $0 |= pixelValue(at: $1) == .lit ? 0x1 : 0x0
    }
  }
  
  func enhance(_ index: UInt16) -> PixelValue {
    enhanceToLit.contains(index) ? .lit : .unlit
  }
  
  /// performs one 'enhancement' algorithm pass over the image
  func applyingAlgorithm() -> Image {
    var res = Image(enhanceToLit: enhanceToLit)
    res.backgroundColor = backgroundColor == .lit ? enhance(512) : enhance(0)
    
    // only go over relevant pixels
    touchedPixels
      .flatMap { $0.neighborhood }
      .forEach { pixel in
        let newPixelValue = enhance(gridValue(centeredAt: pixel))
        if newPixelValue != res.backgroundColor {
          res.touchedPixels.insert(pixel)
        }
      }

    return res
  }
}

extension Image: CustomStringConvertible {
  var description: String {
    var minX = Int.max
    var minY = Int.max
    var maxX = Int.min
    var maxY = Int.min
    
    touchedPixels.forEach {
      minX = min(minX, $0.x-1)
      minY = min(minY, $0.y-1)
      maxX = max(maxX, $0.x+1)
      maxY = max(maxY, $0.y+1)
    }
    
    return (minX...maxX).map { y in
      (minY...maxY).map { x in
        "\(pixelValue(at: .init(x: x, y: y)).rawValue)"
      }.joined()
    }.joined(separator: "\n")
  }
}

let testInput = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
"""

let testImage = try Image(description: testInput).applyingAlgorithm().applyingAlgorithm()
assert(testImage.litPixelCount == 35)

let input = """
###.#....#.....##....#..#####.###..#...#.####....#..##.#.#...#..###.#####..####.#.#######.#.##..#.#..##.###...###....####.####..#.#.#...##..##.#..#####..###...###.....#..#.#..##....##..#...#.#........####...#.#...##....##..###.#.#..##.#.####..##........##.##.#.#.#.#.#.#...#...###.####.#.######..#.#.##....#.##.....##.#.#.#.##...#...#.#..#..##.#######.###............####...###.#..#.###.#...#.......#.##.##...##..####.##....#####....#..#...#.#.##.#......#####....#####..#..#.##...#.#....##.##..###....##.#....##.

.......#............#.##...##..#...##.#..####.#..#.##..#.##.##..#.#....#.#####.#.##..#..#..##..#.###
.#.####.......#....##....#####.##...######.###.##....####..####.#....#..####..#....#.##..##.##..##..
.###.##.#.##.#......#...##.#.#.##..##..##....##...#####...#####..###......####...###.#.###.##.##.##.
###.##.....###.##...###..#..##.#.#....####..###.###..###..###.#..#..#..##...#....##..#..####..#...#.
..#######..#...##..####.#.#.#.##.#.##.######..#.##.#..####.#.##.####.#.#..##.#.....#.#...###.###....
#.###.#....#.###..#.....##....#..##.....#####..###.#..#.####..#....#......#.#.##.#...#####..#.#.####
.###.##.##.##..#...#.#.###.#.#####.########.....#####.#.......##...##....#.#.###...#..#...##.#.#.#..
.###..###....###.###.###.##.###...##.##.....####.#.##.##..#####.#.#.##..##....##.#..#.#..#..#..#.#..
###.#.....#.##.#..#...###.###..##..##...##..#.#.####.#.###.##.#.###..##..#.##.#.#.#..#####..#.#.#..#
###.#....#.#...######.##..#.####..##.....#.###.....###...##....###.#######..#......#....####.#..#..#
..#...#...#.##.#....###.#######....###..###.#####.###.#..#.....#.#.###.#...#.###..##.#.#.##.##.##...
##...#.....##.#.##.##..#..#...#........##....#.#.#....#..##..####..#....#####.##.##..###.###.####.##
.#.###.....#...##...#..#..###..#.##..#.##..##.#.##.#.##.#.###...####.#.#...##...####.#....#.#....#.#
########.#.#.#.....##.##..###.#..#.#####.##.##.##.##.#..#..#.#.###.##########..##...#..###..#.##..#.
......##.##..##.###.####...###.#..##.#.##.####.####...#######..#..#.###..##...###.###.#.#.#.######.#
.###.####.#####.#.#.#...##.#.##....#..##.#####.####....#.....##.#.#..##....##..#.#.####...#.##...#.#
##....######...#..##..#.#####.##.#####..#......#.#.#..#######.#...##.##..##..#..#.###.#.#......##.#.
.##......#..#...#..##..#.#.###..##.#..###.###.##.##.#...#.#.##.#.###....#####....##...##...####.###.
####.###....###..###.###......####.#..#####.#......##....#...##..#####....#.#######.##...##.##.##.##
#....##.####....#####...##......####.#.#.#.##....#.###.#...##.##...#.#.##.#....#..#.##.#.#..#.#..##.
#.##.#.##..##.#.##...#####.###.#..##.....###...#.##.###....#.###..###.####....###..##.###.#..######.
..#...##...#...#...#..###..#..#.#......##.#...#...#..#.#..#..#.##.#####...#..##..###...#.###..#....#
.##...#.#.....#.###...###....#####...##.#.###..##..###.#...######.#####.#..####.#....###.####..#...#
#.##.##.#.#.#..#.#####.###.###.#.###..#.#.##..####.#.######.#.###.#.##...#..#..#..#.#.#..#.#.#..##..
#####.####.##.#..##.......#....#...#.#.....#..#.#...#.......##.#######.#.##....#.....##...##...###.#
##.#...#.#..####.##.###.####..###..###..#...#.######.##.##.#.#.#..###.#.##.#.#.#..#####..###.##....#
.#.##.#.#......#......###.#.####..#.#..###....#####..###..#.######....##..##.##.##....#..#........#.
.##.##..#####.....#.###.....#.##....#.....#.#.#..#..#######..#####.....##.###.###.##..##..###...##.#
#..#.#.#.####..###.#.##.......#.#.#.#.##.#.#.#.#..##.##.##.......#.#.#..#..###...#.##.#.#..#....###.
.#####.#.##.#..#.#...####...###.####.#.#.....####..#...#.###...#....#.#..####.####...#....#.##.###..
.....##..#.##.#######....###...##...#.#.##.#..###....#.##..###....##..##.#.###.##..#####........#.##
##.#.#.#########..##....#..#.##.#...#..#....##..#.###.#.#.#.###.#.....#......##.##....#.....#.#...##
..##..#..#.##...#.....##.##....##.####....#...###..##...##.#......#...#.....#....##...###.###....#..
##.#.##.....#.#.##..#......#...####....#.##.#.##..####.##.#.###.#...#..#..##..###..#.###.####.####.#
.#.#..####.##.#.###..##.#.###..##.##..#...##..#..#.##..####..####..#...###.######....###.#..#####..#
#.##..##.##...#....##...###..#.##...##....#.....#..##.#.###....#......##.##..###.#..######....##.#..
#.####.....##.###.##...###.###.#....#.....####.#####......#.#......#..##...##.#....###.##.#....#..#.
...###..###.#.#.###.#.#.##.####.#.######.#.##..#...#..##.#.#.#.#.............#..#.#.###.....##.###..
#...###.#.##.####..##...###.##...####.##....######.....######.##.##.#..#.##.##.#......#.###.#.#...##
####.#.########.##...##.############...###.##...#...######....##.########.##.##..#...##..#.#...##.##
###.#..#..##.##....#..#..#..##.#.##.##.......##..#...#.###.#.#....##.#.#.##.#####.##.......#.#.#..##
..#######.####.##...#####.#.####.#...#...#..#..##.###.#########....#..###.##..#.##..##.....###.#..#.
###.#.#..#.#..###.#.#..#.##...##....#.#..#.......#.###.#.#.#.#####...#...######.##.#....##.#..#.#.#.
.##....#.#.###...#.#...####..###.#.#.#..##.##.#..##...#...####..#......#####..####..##.##.##...##..#
...##.##..#.#.....##...#..##.#.#.####..##.........##..##.....#.###.##...##.##..#..#...#..#......####
......#..#####.....#....##..#####...#.#.##......##....####...#...####.###.#.#.##..#..#...##...###...
...###....###.####.#....###......#.#...#.##.#..#######..#....#####.##.#####..###....##.##..##....#.#
##...###.####..#...#.##....#..#.#.#..#.#....#.#...#.##..#..######.....##..#.#.######.#.#....##.#.#.#
#..##...#..#.##.....####.##.##.#.#.##.#..##..##..#...#####.###.###........#.#.#..#.#.##.#...##..#.#.
#####..##....#.#..##.#.##..#.###..##..#.#.###.####.#.#..#.....#..##.####..#.####.###..#.....##....##
.##..###.#.#.#.#.####.#.##...###..#####.####.###.##.###.##.#....#.#.#..#.#.##.#..####...###.####.##.
#.#.#......#.###.#...###..###...#...#.#..######.###.##.#.####.....#...##.#..##..##.#..##.#.#....#.##
#...##...##.#...##....######.########....#..#######.#.####....#..##..##.##.#.###.####.####..###.####
#.##..##...#.####.#.#..####.#.##.#.#...####...####.#.#....####..##...#......#........##........####.
..##.#..######...#####.#.##.###.##.......#..###..###...#....#..####..#..#..#...##.#.##.####.#.##.#..
#..#...###..#..#.#...###.#..#.#...#.....##..#.#...#####...##....##.......####.##..####..##.#..######
.##.####..###..##.#.####.###.##...##..###.#.#.##...##.....#..#..#.####..###...##...#######.....##.#.
.####.#.#.##...##...###.....####.##..####....##....#...##.##...##.####.###.##...#####..#...#.#...#..
....#.#...#..#.#.#....####.##..#.#....#........#...####..###..###.###...#..###.#..#.##.#..#...#.####
#..#..##..##.#...#####...#.......#..##..###.#.#.####..###.#...##......##.##.#..#.#.##.#..##.#.#...#.
.#####...#.##.###.#.##..###.##.#.#...##..#.#...###.....##.#.##.#..#..####...#.######....#..#.##..#..
#.#...#.....#.....######.##.##.##.##.#.#..#..#.#.####..#...#####.##.####..###.##.#.#.#.#..#.#...####
##.##.#.#...##.#.###.#####.#...##.........#......#.##.....#.......##....#.#.##..#.#..#.#..##..#.###.
....#.#.##.###.##..##.#..#.##.#..#.######.###.##..#..#.#...###.#........###.###.##..####.#...###..#.
#####..####.#.###..#####...#.......#.##.#.....#.###.####.......##.#.#.##.#...#....#....#....##...##.
.##.#..####...##...##.....##..#.####.#...#..##..#....####.#..#..#.#..#...#.#.#.##.####..######..#.#.
#.#.##.##.#.....#...#..#...#.#.#..#.#.#####..#.##..#.##.#......##.#..#.#.#...#...####.#.#.#.#....#..
.##..###.##..##...#..##...#..#......#.#####.####.####.#.......##.#.#..#..#.#.##.#..#..###.#.#..##..#
#..##...#........##..#...###########.#.###...##.##...##.#.###...####..########..#...##..####..###...
.#.#..###.#.##.#.#..#######......####.#....#####...##...#.###.##....#####.#...#######.######..######
.#.###..###.##...#...###.########...#.#.#.#..#...#..#.#.....####..#...####......#.#...##.#.###..##.#
#.###.###...#..#####.###.#...###..#..#..###.#..#..###.#..##.####..#####..#....#....##.##.#..#.####.#
..#.###.#.#.#.#...####.#.##.#...#.##...#.###.##.#.#######.#####.##..####....###.###.##.#.##....##.##
#..#.....#..#.##.#....#.####..#.##..####.#..#.#.###..##..#..#..##.####........#..#....#.#.#.###.##..
#.##.#.#..##.#####...##.#...#..#...#.#.##.#..##.....##.##.#.#.#.###......#.###.###..###.###..#######
##.###.###...#..##.....#######..##.#.##..#.#.....###.#....####.####.#..##.#..#..#..##.....#..###..##
#....#..#.#.#..#.#....#.##.#.#.#.###.###.###.##..##.####..####.#.#....#.#######..###.#.....####.#..#
###.....#.#####..###.#.#....#.....#.###....##..###.#..#.#.#...###.##....#....#..#......#..#....#..#.
.#.#.#.#####........#.#######...#.####...#...#.###..#....#.#.###.##.....##.#.##..#.#.....#.#..##..##
...###..#....#.###.#.#.#..##.##.....##.##...#.#........#.#.#####.#...####.#...##..##......#####.###.
##.###..#.#...#......#######.#..##....###.#.##.#..###.#..###.#...#..######..........##.#.#.#..#..##.
#..###.#...##..#######..#..#.###..#.###.##.######.##.###.##..#######.#..###.##.##...###....##..#.#.#
#.#....#..#.###.#.##...#####.##....#...#.##.#..#.##..#...#...##.#..#..#.#.#..#####..##.###....#.#.##
###...#.#.#..####.....##.#.##.##..#.####...###....###.#.##.########..#####.##.##.#..#....###..###.##
##.###...#.#.#.#.##...##.#.##.#.#..#.#.#.###.##.#.##.##....########.#..#####..##.#.#.#..#####.#..###
##..##.##.###.#######.##.......#.#.##.###..##...#...##...#####.#....#.#.#...#.#..#.#.#..####.###.#.#
###..#.#..#..#..####.#.#.####..#....######...####..######.##.##..#####....####...##########..#####.#
...#####.#.##....##.##....#...##...##.#.#.#.#.......#.##.#...####.##..####.....#...##..##.#...##...#
#####.#.###..#..###.#..#..##..##.#.#.#.#..#...###...#.###.###.###..#.#.##.#####...#.#.##.#....#####.
###.#..###.#.####.#.#..#.##.##.#.#.##......##.####..#...#....##..#....#.#..#..##...###...##.##.#.#..
..#.#..#...##.#....###.##...#...##.##..###..#.#.#.......##.#.#..#.##.#......#.#..#..#...#...#.#.#.##
#.#.#.#..###.##.#.#####.###.#.#..###....###...###....#.#..#.......##.#.###..##..#...###.#.##....#..#
.#..##......#.#.....##.#...##....####....##.####..#....#...##.######.#..#.#.#....#.#######.....####.
..#..###....##.##..##..#.#..####..##...#.####..........##.#.#.#..##..#..#.##....###.####.....#..##.#
....#.#.....#.#..#....#..#.###.####..#..##.####....##....#.#..#.#.####.##.......##.##.###.#.##..#.#.
..###.##....#.##......####..###..#..##.########.###.##...###.#.....#...###.#..#..#.#....#..#.######.
.##.#.........#..#.#..#.#.##.####.#..##...#.###....#..#...##..##.#..#..####.#...#...####.....##...##
##..#.#.##.##.#...######..##.##.#.#.#.###..#.#.#....###......##...#.#....#...##.########.##..####.##
.#......##.###...##..##..###.####.#....##.#.#.#....##.#....##...######.....##..##....#.###..#..#.##.
#...#...#.......#.#.#####.#..###..#..#...###...###..#.#.......###.#..##.#####...##.#####...#.#.####.
"""

let image = try Image(description: input)
print(image.applyingAlgorithm().applyingAlgorithm().litPixelCount)
