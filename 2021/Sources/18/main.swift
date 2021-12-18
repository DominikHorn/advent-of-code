import Foundation
import AppKit

/*
 --- Day 18: Snailfish ---
 
 You descend into the ocean trench and encounter some snailfish. They say they saw the sleigh keys! They'll even tell you which direction the keys went if you help one of the smaller snailfish with his math homework.
 
 Snailfish numbers aren't like regular numbers. Instead, every snailfish number is a pair - an ordered list of two elements. Each element of the pair can be either a regular number or another pair.
 
 Pairs are written as [x,y], where x and y are the elements within the pair. Here are some example snailfish numbers, one snailfish number per line:
 
 [1,2]
 [[1,2],3]
 [9,[8,7]]
 [[1,9],[8,5]]
 [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
 [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
 [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
 This snailfish homework is about addition. To add two snailfish numbers, form a pair from the left and right parameters of the addition operator. For example, [1,2] + [[3,4],5] becomes [[1,2],[[3,4],5]].
 
 There's only one problem: snailfish numbers must always be reduced, and the process of adding two snailfish numbers can result in snailfish numbers that need to be reduced.
 
 To reduce a snailfish number, you must repeatedly do the first action in this list that applies to the snailfish number:
 
 If any pair is nested inside four pairs, the leftmost such pair explodes.
 If any regular number is 10 or greater, the leftmost such regular number splits.
 Once no action in the above list applies, the snailfish number is reduced.
 
 During reduction, at most one action applies, after which the process returns to the top of the list of actions. For example, if split produces a pair that meets the explode criteria, that pair explodes before other splits occur.
 
 To explode a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any), and the pair's right value is added to the first regular number to the right of the exploding pair (if any). Exploding pairs will always consist of two regular numbers. Then, the entire exploding pair is replaced with the regular number 0.
 
 Here are some examples of a single explode action:
 
 [[[[[9,8],1],2],3],4] becomes [[[[0,9],2],3],4] (the 9 has no regular number to its left, so it is not added to any regular number).
 [7,[6,[5,[4,[3,2]]]]] becomes [7,[6,[5,[7,0]]]] (the 2 has no regular number to its right, and so it is not added to any regular number).
 [[6,[5,[4,[3,2]]]],1] becomes [[6,[5,[7,0]]],3].
 [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] (the pair [3,2] is unaffected because the pair [7,3] is further to the left; [3,2] would explode on the next action).
 [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[7,0]]]].
 To split a regular number, replace it with a pair; the left element of the pair should be the regular number divided by two and rounded down, while the right element of the pair should be the regular number divided by two and rounded up. For example, 10 becomes [5,5], 11 becomes [5,6], 12 becomes [6,6], and so on.
 
 Here is the process of finding the reduced result of [[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]:
 
 after addition: [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
 after explode:  [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
 after explode:  [[[[0,7],4],[15,[0,13]]],[1,1]]
 after split:    [[[[0,7],4],[[7,8],[0,13]]],[1,1]]
 after split:    [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
 after explode:  [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
 Once no reduce actions apply, the snailfish number that remains is the actual result of the addition operation: [[[[0,7],4],[[7,8],[6,0]]],[8,1]].
 
 The homework assignment involves adding up a list of snailfish numbers (your puzzle input). The snailfish numbers are each listed on a separate line. Add the first snailfish number and the second, then add that result and the third, then add that result and the fourth, and so on until all numbers in the list have been used once.
 
 For example, the final sum of this list is [[[[1,1],[2,2]],[3,3]],[4,4]]:
 
 [1,1]
 [2,2]
 [3,3]
 [4,4]
 The final sum of this list is [[[[3,0],[5,3]],[4,4]],[5,5]]:
 
 [1,1]
 [2,2]
 [3,3]
 [4,4]
 [5,5]
 The final sum of this list is [[[[5,0],[7,4]],[5,5]],[6,6]]:
 
 [1,1]
 [2,2]
 [3,3]
 [4,4]
 [5,5]
 [6,6]
 Here's a slightly larger example:
 
 [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
 [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
 [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
 [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
 [7,[5,[[3,8],[1,4]]]]
 [[2,[2,2]],[8,[8,1]]]
 [2,9]
 [1,[[[9,3],9],[[9,0],[0,7]]]]
 [[[5,[7,4]],7],1]
 [[[[4,2],2],6],[8,7]]
 The final sum [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] is found after adding up the above snailfish numbers:
 
 [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
 + [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
 = [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
 
 [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
 + [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
 = [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
 
 [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
 + [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
 = [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
 
 [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
 + [7,[5,[[3,8],[1,4]]]]
 = [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
 
 [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
 + [[2,[2,2]],[8,[8,1]]]
 = [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
 
 [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
 + [2,9]
 = [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
 
 [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
 + [1,[[[9,3],9],[[9,0],[0,7]]]]
 = [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
 
 [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
 + [[[5,[7,4]],7],1]
 = [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
 
 [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
 + [[[[4,2],2],6],[8,7]]
 = [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]
 To check whether it's the right answer, the snailfish teacher only checks the magnitude of the final sum. The magnitude of a pair is 3 times the magnitude of its left element plus 2 times the magnitude of its right element. The magnitude of a regular number is just that number.
 
 For example, the magnitude of [9,1] is 3*9 + 2*1 = 29; the magnitude of [1,9] is 3*1 + 2*9 = 21. Magnitude calculations are recursive: the magnitude of [[9,1],[1,9]] is 3*29 + 2*21 = 129.
 
 Here are a few more magnitude examples:
 
 [[1,2],[[3,4],5]] becomes 143.
 [[[[0,7],4],[[7,8],[6,0]]],[8,1]] becomes 1384.
 [[[[1,1],[2,2]],[3,3]],[4,4]] becomes 445.
 [[[[3,0],[5,3]],[4,4]],[5,5]] becomes 791.
 [[[[5,0],[7,4]],[5,5]],[6,6]] becomes 1137.
 [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] becomes 3488.
 So, given this example homework assignment:
 
 [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
 [[[5,[2,8]],4],[5,[[9,9],0]]]
 [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
 [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
 [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
 [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
 [[[[5,4],[7,7]],8],[[8,3],8]]
 [[9,3],[[9,9],[6,[4,9]]]]
 [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
 [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
 The final sum is:
 
 [[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]
 The magnitude of this final sum is 4140.
 
 Add up all of the snailfish numbers from the homework assignment in the order they appear. What is the magnitude of the final sum?
 */

enum ParsingError: Error {
  case invalidRegular(_ raw: String)
  case invalidPair(_ raw: String)
  case invalidInput
}

protocol SnailfishNumber: CustomStringConvertible {
  static func from(remaining: inout Substring, indent: Int) throws -> Self
  
  func adding(_ other: SnailfishNumber) throws -> SnailfishNumber
  
  func addingToRightmost(_: UInt) -> SnailfishNumber
  
  var magnitude: UInt { get }
}

struct Regular: SnailfishNumber {
  var num: UInt
  
  static func from(remaining: inout Substring, indent: Int) throws -> Regular {
    let end = remaining.firstIndex {
      !CharacterSet(charactersIn: "\($0)").isSubset(of: .decimalDigits)
    } ?? remaining.endIndex
    
    guard remaining.startIndex < end, let num = UInt(remaining[remaining.startIndex..<end]) else {
      throw ParsingError.invalidRegular(.init(remaining))
    }
    
    remaining = end < remaining.endIndex ? remaining[end..<remaining.endIndex] : .init()
    return .init(num: num)
  }
  
  func adding(_ other: SnailfishNumber) throws -> SnailfishNumber {
    throw RegularError.addingUnsupported
  }
  
  func addingToRightmost(_ val: UInt) -> SnailfishNumber {
    Regular(num: num + val)
  }
 
  var magnitude: UInt { num }
  
  enum RegularError: Error {
    case addingUnsupported
  }
}

struct Pair: SnailfishNumber {
  var left: SnailfishNumber
  var right: SnailfishNumber
  
  static func from(remaining: inout Substring, indent: Int) throws -> Pair {
    guard remaining.first == "[" else {
      throw ParsingError.invalidPair(.init(remaining))
    }
    var toParse = remaining.dropFirst()
    
    var left: SnailfishNumber
    var right: SnailfishNumber
    
    if toParse.starts(with: "[") {
      left = try Pair.from(remaining: &toParse, indent: indent + 1)
    } else {
      left = try Regular.from(remaining: &toParse, indent: indent + 1)
    }
    
    guard toParse.first == "," else { throw ParsingError.invalidPair(.init(remaining)) }
    toParse = toParse.dropFirst()
    
    if toParse.starts(with: "[") {
      right = try Pair.from(remaining: &toParse, indent: indent + 1)
    } else {
      right = try Regular.from(remaining: &toParse, indent: indent + 1)
    }
    
    guard toParse.first == "]" else { throw ParsingError.invalidPair(.init(remaining)) }
    toParse = toParse.dropFirst()
    
    remaining = toParse
    return .init(left: left, right: right)
  }
  
  var magnitude: UInt { 3*left.magnitude + 2*right.magnitude }
  
  func adding(_ other: SnailfishNumber) throws -> SnailfishNumber {
    try Pair(left: self, right: other).reduced()
  }
  
  private typealias Leaf = (left: UInt, right: UInt)
  
  private var asLeaf: Leaf? {
    guard let l = (left as? Regular)?.num, let r = (right as? Regular)?.num else {
      return nil
    }
    
    return (l, r)
  }
  
  func addingToRightmost(_ val: UInt) -> SnailfishNumber {
    Pair(left: left, right: right.addingToRightmost(val))
  }
  
  private func explode(depth: Int = 0, bubbling: UInt = 0) throws -> (new: SnailfishNumber, bubblingLeft: UInt, bubblingRight: UInt) {
    precondition(depth <= 4)
    
    // explode current pair
    if depth == 4 {
      guard let leaf = self.asLeaf else {
        throw ReductionError.invalidSnailfishNumber
      }
      let lnum = leaf.left + bubbling
      return (Regular(num: 0), lnum, leaf.right)
    }
    
    var newLeft = left
    var newRight = right
    var bubblingLeft: UInt = 0
    var bubblingRight: UInt = 0
    
    if let lchild = newLeft as? Pair {
      (newLeft, bubblingLeft, bubblingRight) = try lchild.explode(depth: depth + 1, bubbling: bubbling)
      
      if bubblingRight > 0, let rchild = newRight as? Regular {
        newRight = Regular(num: rchild.num + bubblingRight)
        bubblingRight = 0
      }
    } else if bubbling > 0, let lchild = newLeft as? Regular {
      let lnum = lchild.num + bubbling
      newLeft = Regular(num: lnum)
    }
    
    if let rchild = newRight as? Pair {
      let res = try rchild.explode(depth: depth + 1, bubbling: bubblingRight)
      newRight = res.new
      bubblingRight = res.bubblingRight
      
      if res.bubblingLeft > 0 {
        newLeft = newLeft.addingToRightmost(res.bubblingLeft)
      }
    } else if let rchild = newRight as? Regular {
      newRight = Regular(num: rchild.num + bubblingRight)
      bubblingRight = 0
    }
    
    return (Pair(left: newLeft, right: newRight), bubblingLeft, bubblingRight)
  }
  
  private func split(depth: UInt = 0) -> (new: Pair, explodeNecessary: Bool) {
    precondition(depth <= 3)
    
    var newLeft = left
    var newRight = right
    var explodeNecessary = false
    
    if let lchild = left as? Regular, lchild.num > 9 {
      let lnum = lchild.num / 2
      let rnum = (lchild.num + 1) / 2
      
      // splitting at depth 3 ==> we have a new pair at depth 4
      explodeNecessary = depth == 3
      newLeft = Pair(left: Regular(num: lnum), right: Regular(num: rnum))
      if !explodeNecessary {
        (newLeft, explodeNecessary) = (newLeft as! Pair).split(depth: depth + 1)
      }
    } else if let lchild = left as? Pair {
      (newLeft, explodeNecessary) = lchild.split(depth: depth + 1)
    }
    
    // immediatelly explode according to rules
    guard !explodeNecessary else { return (Pair(left: newLeft, right: newRight), true) }
    
    if let rchild = right as? Regular, rchild.num > 9 {
      let lnum = rchild.num / 2
      let rnum = (rchild.num + 1) / 2
      
      // splitting at depth 3 ==> we have a new pair at depth 4
      explodeNecessary = depth == 3
      newRight = Pair(left: Regular(num: lnum), right: Regular(num: rnum))
      if !explodeNecessary {
        (newRight, explodeNecessary) = (newRight as! Pair).split(depth: depth + 1)
      }
    } else if let rchild = right as? Pair {
      (newRight, explodeNecessary) = rchild.split(depth: depth + 1)
    }
    
    return (Pair(left: newLeft, right: newRight), explodeNecessary)
  }
  
  func reduced() throws -> SnailfishNumber {
    var old = self
    var new = self
    
    repeat {
      old = new
      guard let r = try new.explode().new as? Pair else {
        throw ReductionError.invalidExplode
      }
      
      new = r.split().new
    } while new.description != old.description
    
    return new
  }
  
  enum ReductionError: Error {
    case invalidSnailfishNumber
    case invalidExplode
  }
}

extension Regular: CustomStringConvertible {
  var description: String {
    "\(num)"
  }
}

extension Pair: CustomStringConvertible {
  var description: String {
    "[\(left),\(right)]"
  }
}

func parse(description: String) throws -> SnailfishNumber {
  let raw = description
    .replacingOccurrences(of: " ", with: "")
    .replacingOccurrences(of: "\n", with: "")
  
  var rem = raw[raw.startIndex..<raw.endIndex]
  return try Pair.from(remaining: &rem, indent: 1)
}

func sum(_ list: String, partialSums: String = "") throws -> SnailfishNumber {
  let nums = try list.split(separator: "\n").map {
    try parse(description: .init($0))
  }
  let partial = try partialSums.split(separator: "\n").map {
    try parse(description: .init($0))
  }
  
  guard !nums.isEmpty else { throw ParsingError.invalidInput }
  
  return try nums[1..<nums.count]
    .enumerated()
    .reduce(nums[0]) {
      let res = try $0.adding($1.1)
      
      if $1.0 < partial.count {
        let expected = partial[$1.0]
        assert(res.description == expected.description)
      }
      
      return res
    }
}

//// test string input parsing
//try ["[1,2]", "[[1,2],3]", "[9,[8,7]]", "[[1,9],[8,5]]", "[[[[1,2],[3,4]],[[5,6],[7,8]]],9]", "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]", "[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]"].forEach {
//  let x = try parse(description: $0)
//  assert(x.description == $0)
//}
//
//// test exploding
//let test1 = try (parse(description: "[[[[[9,8],1],2],3],4]") as! Pair).reduced()
//assert(test1.description == "[[[[0,9],2],3],4]")
//let test2 = try (parse(description: "[7,[6,[5,[4,[3,2]]]]]") as! Pair).reduced()
//assert(test2.description == "[7,[6,[5,[7,0]]]]")
//let test3 = try (parse(description: "[[6,[5,[4,[3,2]]]],1]") as! Pair).reduced()
//assert(test3.description == "[[6,[5,[7,0]]],3]")
//let test4 = try (parse(description: "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]") as! Pair).reduced()
//assert(test4.description == "[[3,[2,[8,0]]],[9,[5,[7,0]]]]")
//
//// test addition
//let testAdd1 = try parse(description: "[[[[4,3],4],4],[7,[[8,4],9]]]")
//let testAdd2 = try parse(description: "[1,1]")
//let testAdd12Res = try testAdd1.adding(testAdd2)
//assert(testAdd12Res.description == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
//
//// test summing multiple
//let testSum1 = try sum("""
//[1,1]
//[2,2]
//[3,3]
//[4,4]
//""")
//assert(testSum1.description == "[[[[1,1],[2,2]],[3,3]],[4,4]]")
//
//let testSum2 = try sum("""
//[1,1]
//[2,2]
//[3,3]
//[4,4]
//[5,5]
//""")
//assert(testSum2.description == "[[[[3,0],[5,3]],[4,4]],[5,5]]")
//
//let testSum3 = try sum("""
//[1,1]
//[2,2]
//[3,3]
//[4,4]
//[5,5]
//[6,6]
//""")
//assert(testSum3.description == "[[[[5,0],[7,4]],[5,5]],[6,6]]")

let testAdd3 = try parse(description: "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]")
let testAdd4 = try parse(description: "[7,[5,[[3,8],[1,4]]]]")
let testAdd3_4Res = try testAdd3.adding(testAdd4)
assert(testAdd3_4Res.description == "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]")

let testSum4 = try sum("""
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
""", partialSums: """
[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]
""")
assert(testSum4.description == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")

let testMag1 = try parse(description: "[9,1]")
assert(testMag1.magnitude == 29)
let testMag2 = try parse(description: "[1,9]")
assert(testMag2.magnitude == 21)
let testMag3 = try parse(description: "[[9,1],[1,9]]")
assert(testMag3.magnitude == 129)
let testMag4 = try parse(description: "[[1,2],[[3,4],5]]")
assert(testMag4.magnitude == 143)
let testMag5 = try parse(description: "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
assert(testMag5.magnitude == 1384)
let testMag6 = try parse(description: "[[[[1,1],[2,2]],[3,3]],[4,4]]")
assert(testMag6.magnitude == 445)
let testMag7 = try parse(description: "[[[[3,0],[5,3]],[4,4]],[5,5]]")
assert(testMag7.magnitude == 791)
let testMag8 = try parse(description: "[[[[5,0],[7,4]],[5,5]],[6,6]]")
assert(testMag8.magnitude == 1137)
let testMag9 = try parse(description: "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
assert(testMag9.magnitude == 3488)

let testHomework = try sum("""
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""")
assert(testHomework.description == "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
assert(testHomework.magnitude == 4140)

let input = """
[[[[3,0],[0,0]],1],4]
[[[[3,4],0],[7,7]],[1,6]]
[[[[2,0],5],7],[[[3,1],[2,6]],[[0,8],6]]]
[[[[5,5],0],1],[[[0,0],1],[[0,6],[0,9]]]]
[[0,[0,[1,7]]],[3,[1,[7,6]]]]
[[[9,[5,2]],[[5,2],[6,8]]],[[[7,0],7],[[2,3],[9,4]]]]
[[[[3,8],7],[[0,7],[2,0]]],[0,[[2,9],0]]]
[[[7,[2,2]],[3,4]],[6,7]]
[8,[[[3,3],8],[[7,1],[6,7]]]]
[[9,[9,8]],[[1,[9,1]],[2,5]]]
[[[7,8],[[1,2],[2,6]]],[[9,7],[6,[7,0]]]]
[[[3,3],[[5,6],5]],[[[2,8],1],9]]
[[[2,[5,0]],[[9,9],[4,0]]],[0,5]]
[[[9,3],[[9,4],[5,8]]],[[[3,2],[7,1]],[[3,8],1]]]
[[3,2],[[6,[0,9]],[8,3]]]
[[[5,7],[[7,4],[4,6]]],[[[9,8],3],3]]
[[[4,[2,8]],9],[[[8,5],[9,7]],[[8,9],[2,6]]]]
[[[1,[2,4]],6],[[8,[5,2]],[[0,7],[4,1]]]]
[[[[4,3],6],[[6,4],[4,2]]],[[9,0],[[5,9],9]]]
[[[[3,0],6],[4,[7,5]]],4]
[[[[1,0],[7,1]],0],[[[8,5],8],2]]
[[[[2,9],[4,1]],[[8,9],[3,3]]],[9,[[0,7],2]]]
[[1,[4,[4,2]]],[[[3,5],[8,8]],2]]
[[[8,[1,4]],[[6,5],5]],[[7,[4,7]],4]]
[[[[0,5],2],[[9,2],0]],0]
[[[[6,2],[2,4]],[0,[7,3]]],[9,[8,[5,9]]]]
[[8,0],2]
[[[[0,2],2],[[9,2],[8,1]]],[[[7,6],[5,3]],6]]
[[[[8,7],[5,3]],[[3,0],8]],[[[8,4],[2,2]],[[8,1],2]]]
[[[[1,5],[4,6]],[[4,0],[2,4]]],[[1,1],[[0,7],[7,3]]]]
[[7,2],[[7,[6,7]],[8,5]]]
[[[9,7],[[6,6],9]],8]
[[4,2],[[[1,0],[9,1]],[[0,7],[8,0]]]]
[[[[5,9],5],[8,9]],[[2,4],[[5,2],[8,3]]]]
[[[[4,5],[7,0]],[4,5]],[[7,[6,4]],[[1,7],[6,3]]]]
[[2,0],4]
[[2,[[5,1],[2,1]]],[[5,[7,2]],[[2,3],[7,0]]]]
[[4,[4,9]],[9,[6,8]]]
[[[[6,1],[1,5]],[0,[4,0]]],[[[7,0],2],4]]
[[[[3,3],[2,2]],[[2,4],2]],[[8,[1,1]],4]]
[[[[1,5],8],[[9,4],[7,7]]],[[[8,7],[7,2]],[0,[7,3]]]]
[9,[[7,[0,4]],4]]
[4,[0,8]]
[[[[2,6],1],[8,[8,4]]],[[8,2],[1,[8,4]]]]
[[7,[8,[8,8]]],[4,1]]
[[0,6],[[7,[5,9]],[[7,1],8]]]
[4,6]
[[[[3,2],[5,6]],[0,7]],[8,[7,[9,5]]]]
[[[3,7],[4,5]],6]
[[[0,[3,9]],[9,1]],6]
[[[[7,3],8],[6,7]],[[1,0],[1,7]]]
[[[5,[4,8]],2],[[[7,1],6],[[0,3],2]]]
[[1,0],[[1,2],[[2,0],1]]]
[[8,[[6,1],[7,1]]],0]
[[9,[2,0]],[[7,[6,2]],4]]
[[[9,[9,4]],[[4,8],3]],[[9,0],[[2,2],[0,6]]]]
[[[7,5],[[2,9],6]],[[2,4],[[1,1],[8,2]]]]
[[[1,[6,3]],[[2,2],[1,8]]],[[[7,3],[6,0]],[4,[7,6]]]]
[6,5]
[[3,[9,[4,4]]],[[6,9],[4,5]]]
[[[4,[1,8]],[[4,0],6]],[[[9,0],[8,3]],[[8,6],[3,2]]]]
[[[8,[1,2]],[[3,9],6]],[[3,0],1]]
[[1,[2,[4,0]]],6]
[0,[[[1,3],[9,1]],[[3,8],[9,4]]]]
[2,[2,[[2,7],[7,8]]]]
[[[3,0],[[4,6],2]],[9,2]]
[[[5,[2,2]],[[2,7],[9,9]]],[[3,[4,4]],[8,[9,8]]]]
[[[[7,5],[7,9]],[[8,5],6]],[[1,[8,4]],[8,2]]]
[[[6,4],[5,5]],[[[8,1],5],[[6,4],[6,9]]]]
[[[[8,9],0],[[4,6],7]],[[[3,9],[6,4]],[8,[7,4]]]]
[4,[[7,7],4]]
[[[[4,9],[1,2]],[8,[4,7]]],[[8,[4,8]],[0,[5,4]]]]
[1,[7,9]]
[[[5,[2,0]],[[4,3],[6,8]]],[9,9]]
[[[[3,9],9],[4,3]],[1,[3,[8,1]]]]
[[[[8,7],[6,1]],[3,9]],[5,[[8,0],4]]]
[[[[8,2],[4,6]],[6,[9,9]]],[1,[[7,7],4]]]
[[7,5],[[5,0],[0,3]]]
[[[6,0],[9,1]],[[[4,3],[5,0]],[[9,5],[0,0]]]]
[8,[[3,6],3]]
[[[[9,3],7],[1,3]],[[[6,4],[8,4]],[1,5]]]
[[[[3,8],2],[5,4]],[[[1,8],5],[2,[2,7]]]]
[[2,9],[6,[0,2]]]
[[2,[7,9]],[[4,1],[[9,2],[0,7]]]]
[[0,[6,4]],[[9,2],[0,[0,7]]]]
[[[[7,2],[8,6]],[6,2]],[[[1,6],[2,2]],1]]
[[1,6],[[[4,3],[8,2]],[3,[9,4]]]]
[[9,[7,3]],[[[7,0],4],[[1,7],[2,2]]]]
[[7,[5,[9,8]]],[[[7,5],[7,6]],[7,[9,8]]]]
[[[[6,1],[4,3]],4],[[[5,9],4],2]]
[[[[5,1],[2,5]],0],[[7,[5,7]],[[4,4],9]]]
[9,2]
[4,[[[6,6],5],7]]
[[8,[[7,3],[0,7]]],8]
[[[3,4],[[2,3],0]],[[[9,6],[1,1]],[4,[0,4]]]]
[[[[3,3],[2,3]],[2,5]],[[4,[2,7]],3]]
[[[8,[0,3]],2],[4,4]]
[[[3,5],[[2,1],[3,4]]],[[0,3],4]]
[[[[4,1],4],2],[[[3,7],2],[[8,1],3]]]
[[[[0,6],[7,3]],[5,[3,9]]],[7,[[4,1],8]]]
"""

let res = try sum(input)
print(res.magnitude)
