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

struct Polymerizer {
  var transforms: [Transform.Input: Transform.Output]
  
  private var _state: Node
  var state: Node {
    mutating get {
      // copy on write
      if !isKnownUniquelyReferenced(&_state) {
        _state = _state.copy() as! Node
      }
      return _state
    }
    set {
      _state = newValue
    }
  }
  
  class Node: NSCopying {
    var styrene: Styrene
    var next: Node?
    
    init(styrene: Styrene, next: Node? = nil) {
      self.styrene = styrene
      self.next = next
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
      let copy = Node(styrene: styrene)
      copy.next = next?.copy(with: zone) as? Node
      return copy
    }
  }
  
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
    

    // create nodes
    let nodes: [Node] = try rawStart.map {
      Node(styrene: try Styrene($0))
    }
    // link up nodes
    (1..<nodes.count).forEach { i in nodes[i-1].next = nodes[i] }
    
    // retain first node
    self._state = nodes[0]
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
  
  mutating func step() {
    var previous = state
    
    while let current = previous.next {
      if let output = transforms[.init(left: previous.styrene, right: current.styrene)] {
        previous.next = .init(styrene: output, next: current)
      }
      
      previous = current
    }
  }
  
  func after(step: Int) -> Polymerizer {
    var res = self
    
    (0..<step).forEach { _ in
      res.step()
    }
    
    return res
  }
  
  // counts how often each styrene appears
  func counts() -> [Styrene: Int] {
    var res = [Styrene: Int]()
    
    var node: Node? = _state
    while let current = node {
      res[current.styrene] = (res[current.styrene] ?? 0) + 1
      
      node = current.next
    }
    
    return res
  }
}

extension Polymerizer: CustomStringConvertible {
  var description: String {
    var res = ""
    var current: Node? = _state
    while let node = current {
      res = "\(res)\(node.styrene)"
      current = node.next
    }
    
    return res
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

let testPolymerizer = try Polymerizer(description: testInput)
guard testPolymerizer.description == "NNCB",
      testPolymerizer.after(step: 1).description == "NCNBCHB",
      testPolymerizer.after(step: 2).description == "NBCCNBBBCBHCB",
      testPolymerizer.after(step: 3).description == "NBBBCNCCNBBNBNBBCHBHHBCHB",
      testPolymerizer.after(step: 4).description == "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"
else {
  throw ImplementationError.wrongStep
}
let testCounts = testPolymerizer.after(step: 10).counts().sorted { $0.value > $1.value }
print(testCounts.first!.value - testCounts.last!.value)

let polymerizer = try Polymerizer(description: input)
let counts = polymerizer.after(step: 10).counts().sorted { $0.value > $1.value }
print(counts.first!.value - counts.last!.value)
