import Foundation

/*
 --- Day 14: Extended Polymerization ---

 The incredible pressures at this depth are starting to put a strain on your submarine. The submarine has polymerization equipment that would produce suitable materials to reinforce the submarine, and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

 The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

 For example:

 NNCB

 CH -> B
 HH -> N
 CB -> H
 NH -> C
 HB -> C
 HC -> B
 HN -> C
 NN -> C
 BH -> H
 NC -> B
 NB -> B
 BN -> B
 BB -> N
 BC -> B
 CC -> N
 CN -> C
 The first line is the polymer template - this is the starting point of the process.

 The following section defines the pair insertion rules. A rule like AB -> C means that when elements A and B are immediately adjacent, element C should be inserted between them. These insertions all happen simultaneously.

 So, starting with the polymer template NNCB, the first step simultaneously considers all three pairs:

 The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
 The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
 The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.
 Note that these pairs overlap: the second element of one pair is the first element of the next pair. Also, because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.

 After the first step of this process, the polymer becomes NCNBCHB.

 Here are the results of a few steps using the above rules:

 Template:     NNCB
 After step 1: NCNBCHB
 After step 2: NBCCNBBBCBHCB
 After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
 After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB
 This polymer grows quickly. After step 5, it has length 97; After step 10, it has length 3073. After step 10, B occurs 1749 times, C occurs 298 times, H occurs 161 times, and N occurs 865 times; taking the quantity of the most common element (B, 1749) and subtracting the quantity of the least common element (H, 161) produces 1749 - 161 = 1588.

 Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?

 --- Part Two ---

 The resulting polymer isn't nearly strong enough to reinforce the submarine. You'll need to run more steps of the pair insertion process; a total of 40 steps should do it.

 In the above example, the most common element is B (occurring 2192039569602 times) and the least common element is H (occurring 3849876073 times); subtracting these produces 2188189693529.

 Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?
 */

struct Styrene: Hashable {
  var char: Character
  
  init(_ char: Character) throws {
    guard char.isUppercase else { throw ParsingError.invalidStyrene(char) }
    self.char = char
  }
}

extension Styrene: CustomStringConvertible {
  var description: String {
    "\(char)"
  }
}

enum ParsingError: Error {
  case unexpectedEnd
  case invalidEmptyLines
  case invalidStartingState
  case invalidStyrene(_ raw: Character)
  case invalidTransform(_ raw: String)
  case ambiguousTransforms
}

extension Dictionary where Value == Int {
  mutating func insert(_ value: Value, orAddTo key: Key) {
    self[key] = (self[key] ?? 0) + value
  }
}

struct Polymerizer {
  var transforms: [Transform.Input: Transform.Output]
  var start: [Styrene]
  
  struct Transform: Hashable {
    struct Input: Hashable {
      var left: Styrene
      var right: Styrene
    }
    
    typealias Output = Styrene
    
    var input: Input
    var output: Output
    
    init(from description: Substring) throws {
      let parts = description
        .components(separatedBy: " -> ")
        .map { Array(String($0)) }
      
      guard parts.count == 2,
            let leftPart = parts.first, leftPart.count == 2,
            let rightPart = parts.last, rightPart.count == 1
      else {
        throw ParsingError.invalidTransform(.init(description))
      }
      let left = try Styrene(leftPart[0])
      let right = try Styrene(leftPart[1])
      let output = try Styrene(rightPart[0])
      
      self.input = .init(left: left, right: right)
      self.output = output
    }
  }
  
  init(description: String) throws {
    let raw = description.split(separator: "\n", omittingEmptySubsequences: false)
    guard raw.count > 2, let rawStart = raw.first else {
      throw ParsingError.unexpectedEnd
    }
    
    let emptyLines = raw.enumerated().filter{ $0.element.isEmpty }
    guard emptyLines.count == 1, let empty = emptyLines.first, empty.offset == 1 else {
      throw ParsingError.invalidEmptyLines
    }
    
    guard rawStart.count > 1 else {
      throw ParsingError.invalidStartingState
    }
    

    self.start = try rawStart.map { try Styrene($0) }
    self.transforms = .init()
    
    // initialize transforms
    try raw[(empty.offset+1)..<raw.count].forEach {
      let transform = try Transform(from: $0)
      guard transforms[transform.input] == nil else {
        throw ParsingError.ambiguousTransforms
      }
      
      transforms[transform.input] = transform.output
    }
  }
  
  struct CacheKey: Hashable {
    var left: Styrene
    var right: Styrene
    var remainingSteps: Int
  }
  
  /// counts after a single step
  private func count(left: Styrene, right: Styrene, remainingSteps: Int, cache: inout [CacheKey: [Styrene: Int]]) -> [Styrene: Int] {
    if let cachedRes = cache[.init(left: left, right: right, remainingSteps: remainingSteps)] {
      return cachedRes
    }
    
    guard remainingSteps > 0 else {
      return [:]
    }
      
    var res = [Styrene: Int]()
    
    if let out = transforms[.init(left: left, right: right)] {
      res.insert(1, orAddTo: out)
    
      count(left: left, right: out, remainingSteps: remainingSteps-1, cache: &cache)
        .forEach { res.insert($0.value, orAddTo: $0.key) }
      count(left: out, right: right, remainingSteps: remainingSteps-1, cache: &cache)
        .forEach { res.insert($0.value, orAddTo: $0.key) }
    }
    
    cache[.init(left: left, right: right, remainingSteps: remainingSteps)] = res
    
    return res
  }
  
  func counts(afterStep step: Int) -> [Styrene: Int] {
    var res = [Styrene: Int]()
    var cache = [CacheKey: [Styrene: Int]]()
    
    res.insert(1, orAddTo: start[0])
    (1..<start.count).forEach { i in
      let left = start[i-1]
      let right = start[i]

      res.insert(1, orAddTo: right)
      
      count(left: left, right: right, remainingSteps: step, cache: &cache)
        .forEach { res.insert($0.value, orAddTo: $0.key) }
    }
    
    return res
  }
}

extension Polymerizer: CustomStringConvertible {
  var description: String {
    start.map { $0.description }.joined()
  }
}

let testInput = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

let input = """
VNVVKSNNFPBBBVSCVBBC

SV -> C
SF -> P
BP -> V
HC -> B
PK -> B
NF -> C
SN -> N
PF -> S
ON -> S
FC -> C
PN -> P
SC -> B
KS -> V
OS -> S
NC -> C
VH -> N
OH -> C
BB -> H
KV -> V
HP -> S
CP -> H
SO -> F
KK -> N
OO -> C
SH -> O
PB -> S
KP -> H
OC -> K
BN -> F
HH -> S
CH -> B
PC -> V
SB -> N
KO -> H
BH -> B
SK -> K
KF -> S
NH -> O
HN -> V
VN -> F
BC -> V
VP -> C
KN -> H
PV -> S
HB -> V
VV -> O
PO -> B
FN -> H
PP -> B
BF -> S
CB -> S
NK -> F
NO -> B
CC -> S
OF -> C
HS -> H
SP -> C
VB -> V
BK -> S
CO -> O
NS -> K
PH -> O
BV -> B
CK -> F
VC -> S
HK -> B
BO -> K
HV -> F
KC -> V
CN -> H
FS -> V
VS -> N
CF -> K
VO -> F
FH -> H
NB -> N
PS -> P
OK -> N
CV -> O
CS -> K
HO -> C
KB -> P
NN -> V
KH -> C
OB -> V
BS -> O
FB -> H
FF -> K
HF -> P
FO -> F
VF -> F
OP -> S
VK -> K
OV -> N
FK -> H
FP -> H
NV -> H
NP -> N
SS -> C
FV -> N
"""

enum ImplementationError: Error {
  case wrongStep
}

var testPolymerizer = try Polymerizer(description: testInput)
let testCounts1 = testPolymerizer.counts(afterStep: 10).sorted { $0.value > $1.value }
print(testCounts1.first!.value - testCounts1.last!.value)

var polymerizer = try Polymerizer(description: input)
let counts1 = polymerizer.counts(afterStep: 10).sorted { $0.value > $1.value }
print(counts1.first!.value - counts1.last!.value)

let testCounts2 = testPolymerizer.counts(afterStep: 40).sorted { $0.value > $1.value }
print(testCounts2.first!.value - testCounts2.last!.value)

let counts2 = polymerizer.counts(afterStep: 40).sorted { $0.value > $1.value }
print(counts2.first!.value - counts2.last!.value)
