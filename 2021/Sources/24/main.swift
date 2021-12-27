import Foundation

/*
 --- Day 24: Arithmetic Logic Unit ---

 Magic smoke starts leaking from the submarine's arithmetic logic unit (ALU). Without the ability to perform basic arithmetic and logic functions, the submarine can't produce cool patterns with its Christmas lights!

 It also can't navigate. Or run the oxygen system.

 Don't worry, though - you probably have enough oxygen left to give you enough time to build a new ALU.

 The ALU is a four-dimensional processing unit: it has integer variables w, x, y, and z. These variables all start with the value 0. The ALU also supports six instructions:

 inp a - Read an input value and write it to variable a.
 add a b - Add the value of a to the value of b, then store the result in variable a.
 mul a b - Multiply the value of a by the value of b, then store the result in variable a.
 div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
 mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
 eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
 In all of these instructions, a and b are placeholders; a will always be the variable where the result of the operation is stored (one of w, x, y, or z), while b can be either a variable or a number. Numbers can be positive or negative, but will always be integers.

 The ALU has no jump instructions; in an ALU program, every instruction is run exactly once in order from top to bottom. The program halts after the last instruction has finished executing.

 (Program authors should be especially cautious; attempting to execute div with b=0 or attempting to execute mod with a<0 or b<=0 will cause the program to crash and might even damage the ALU. These operations are never intended in any serious ALU program.)

 For example, here is an ALU program which takes an input number, negates it, and stores it in x:

 inp x
 mul x -1
 Here is an ALU program which takes two input numbers, then sets z to 1 if the second input number is three times larger than the first input number, or sets z to 0 otherwise:

 inp z
 inp x
 mul z 3
 eql z x
 Here is an ALU program which takes a non-negative integer as input, converts it into binary, and stores the lowest (1's) bit in z, the second-lowest (2's) bit in y, the third-lowest (4's) bit in x, and the fourth-lowest (8's) bit in w:

 inp w
 add z w
 mod z 2
 div w 2
 add y w
 mod y 2
 div w 2
 add x w
 mod x 2
 div w 2
 mod w 2
 Once you have built a replacement ALU, you can install it in the submarine, which will immediately resume what it was doing when the ALU failed: validating the submarine's model number. To do this, the ALU will run the MOdel Number Automatic Detector program (MONAD, your puzzle input).

 Submarine model numbers are always fourteen-digit numbers consisting only of digits 1 through 9. The digit 0 cannot appear in a model number.

 When MONAD checks a hypothetical fourteen-digit model number, it uses fourteen separate inp instructions, each expecting a single digit of the model number in order of most to least significant. (So, to check the model number 13579246899999, you would give 1 to the first inp instruction, 3 to the second inp instruction, 5 to the third inp instruction, and so on.) This means that when operating MONAD, each input instruction should only ever be given an integer value of at least 1 and at most 9.

 Then, after MONAD has finished running all of its instructions, it will indicate that the model number was valid by leaving a 0 in variable z. However, if the model number was invalid, it will leave some other non-zero value in z.

 MONAD imposes additional, mysterious restrictions on model numbers, and legend says the last copy of the MONAD documentation was eaten by a tanuki. You'll need to figure out what MONAD does some other way.

 To enable as many submarine features as possible, find the largest valid fourteen-digit model number that contains no 0 digits. What is the largest model number accepted by MONAD?
 
 --- Part Two ---

 As the submarine starts booting up things like the Retro Encabulator, you realize that maybe you don't need all these submarine features after all.

 What is the smallest model number accepted by MONAD?
 */

enum ParsingError: Error {
  case invalidInstruction(_ raw: String)
}

enum ComputeError: Error {
  case missing(input: Input)
}

protocol Expression: CustomStringConvertible {
  func simplified(withInputs inputs: [Input: Constant]) -> Expression
  func bounds() -> (min: Int, max: Int)
}

typealias Constant = Int
extension Constant: Expression {
  func simplified(withInputs inputs: [Input: Constant]) -> Expression { self }
  
  func bounds() -> (min: Int, max: Int) {
    (self, self)
  }
  
  var description: String {
    "\(self)"
  }
}

enum Variable: String, CustomStringConvertible {
  case w = "w"
  case x = "x"
  case y = "y"
  case z = "z"
  
  var description: String {
    rawValue
  }
}

struct Input: Expression, Hashable {
  var id: Int
  
  internal init(id: Int) {
    self.id = id
  }
  
  struct Generator {
    private var state = 0
    
    mutating func next() -> Input {
      state += 1
      return .init(id: state)
    }
  }
  
  func simplified(withInputs inputs: [Input: Constant]) -> Expression {
    inputs[self] ?? self
  }
  
  func bounds() -> (min: Int, max: Int) {
    (0, 9)
  }
  
  func compute(withInputs inputs: [Input : Constant]) throws -> Constant {
    guard let c = inputs[self] else { throw ComputeError.missing(input: self) }
    return c
  }
  
  var description: String {
    "i\(id)"
  }
}

struct Negate: Expression {
  var negatee: Expression
  
  init(_ negatee: Expression) {
    self.negatee = negatee
  }
  
  func simplified(withInputs inputs: [Input : Constant]) -> Expression {
    let negatee = negatee.simplified(withInputs: inputs)
    
    if let c = negatee as? Constant {
      return -c
    }
    
    if let n = negatee as? Negate {
      return n.negatee
    }
    
    return Negate(negatee)
  }
  
  func bounds() -> (min: Int, max: Int) {
    let sub = negatee.bounds()
    let a: Int = -sub.min
    let b: Int = -sub.max
    
    return (min(a, b), max(a, b))
  }
  
  var description: String {
    "-\(negatee)"
  }
}

struct Add: Expression {
  var constant: Constant = 0
  var other = [Expression]()
  
  internal init(constant: Constant = 0, other: [Expression] = []) {
    self.constant = constant
    self.other = other
  }
  
  init(_ expressions: Expression...) {
    other = expressions
  }
  
  func simplified(withInputs inputs: [Input : Constant]) -> Expression {
    let res = other.reduce(into: Add(constant: constant)) { aggr, sub in
      let e = sub.simplified(withInputs: inputs)
      
      if let c = e as? Constant {
        aggr.constant += c
      } else if let a = e as? Add {
        aggr.constant += a.constant
        aggr.other += a.other
      } else {
        aggr.other += [e]
      }
    }
    
    if res.other.isEmpty { return res.constant }
    if res.constant == 0, res.other.count == 1, let e = res.other.first { return e }
    
    return res
  }
  
  func bounds() -> (min: Int, max: Int) {
    other.reduce(into: (min: constant, max: constant)) {
      $0.min += $1.bounds().min
      $0.max += $1.bounds().max
    }
  }
  
  var description: String {
    "(\(constant) + \(other.map { "\($0)" }.joined(separator: " + ")))"
  }
}

struct Multiply: Expression {
  var constant: Constant = 1
  var other = [Expression]()
  
  internal init(constant: Constant = 1, other: [Expression] = []) {
    self.constant = constant
    self.other = other
  }
  
  init(_ expressions: Expression...) {
    other = expressions
  }
  
  func simplified(withInputs inputs: [Input: Constant]) -> Expression {
    var res = other.reduce(into: Multiply(constant: constant)) { aggr, sub in
      let e = sub.simplified(withInputs: inputs)
      
      if let c = e as? Constant {
        aggr.constant *= c
      } else if let a = e as? Multiply {
        aggr.constant *= a.constant
        aggr.other += a.other
      } else {
        aggr.other += [e]
      }
    }
    
    if res.constant == 0 { return 0 }
    
    // distribute mul into add
    if res.constant != 1, let ai = res.other.firstIndex(where: { $0 is Add }), let a = res.other[ai] as? Add {
      res.other.remove(at: ai)
      res.other.append(
        Add(
          constant: a.constant * res.constant,
          other: a.other.map { Multiply(constant: res.constant, other: [$0]).simplified(withInputs: inputs) }
        ).simplified(withInputs: inputs)
      )
      res.constant = 1
    }
    
    if res.other.isEmpty { return res.constant }
    if res.constant == 1, res.other.count == 1, let e = res.other.first { return e }
    
    
    return res
  }
  
  func bounds() -> (min: Int, max: Int) {
    other.reduce(into: (min: constant, max: constant)) {
      $0.min *= $1.bounds().min
      $0.max *= $1.bounds().max
    }
  }
  
  var description: String {
    "(\(constant) * \(other.map { "\($0)" }.joined(separator: " * ")))"
  }
}

struct Divide: Expression {
  var dividend: Expression
  var divisor: Expression
  
  func simplified(withInputs inputs: [Input: Constant]) -> Expression {
    let dividend = dividend.simplified(withInputs: inputs)
    let divisor = divisor.simplified(withInputs: inputs)
    
    if let c1 = dividend as? Constant {
      if let c2 = divisor as? Constant { return c1 / c2 }
      if c1 == 0 { return 0 }
    }
    
    if let c = divisor as? Constant {
      if c == 1 { return dividend }
      if abs(max(dividend.bounds().min, dividend.bounds().max)) < c { return 0 }
      if let m = dividend as? Multiply {
        return Multiply(constant: m.constant / c, other: m.other).simplified(withInputs: inputs)
      }
      if let a = dividend as? Add {
        return Add(constant: a.constant / c, other: a.other.map { Divide(dividend: $0, divisor: c).simplified(withInputs: inputs) })
      }
    }
    
    return Divide(dividend: dividend, divisor: divisor)
  }
  
  func bounds() -> (min: Int, max: Int) {
    let dividendBounds = dividend.bounds()
    let divisorBounds = divisor.bounds()
    
    let min = min(
      dividendBounds.min / divisorBounds.min,
      dividendBounds.min / divisorBounds.max,
      dividendBounds.max / divisorBounds.min,
      dividendBounds.max / divisorBounds.max
    )
    let max = max(
      dividendBounds.min / divisorBounds.min,
      dividendBounds.min / divisorBounds.max,
      dividendBounds.max / divisorBounds.min,
      dividendBounds.max / divisorBounds.max
    )
    
    return (min, max)
  }
  
  var description: String {
    "(\(dividend) / \(divisor))"
  }
}

struct Modulo: Expression {
  var modulee: Expression
  var modulus: Expression
  
  func simplified(withInputs inputs: [Input: Constant]) -> Expression {
    let modulee = modulee.simplified(withInputs: inputs)
    let modulus = modulus.simplified(withInputs: inputs)
    
    if let c1 = modulee as? Constant, let c2 = modulus as? Constant {
      return c1 % c2
    }
    
    return Modulo(modulee: modulee, modulus: modulus)
  }
  
  func bounds() -> (min: Int, max: Int) {
    (0, modulus.bounds().max)
  }
  
  var description: String {
    "(\(modulee) % \(modulus))"
  }
}

enum ExpressionError: Error {
  case invalidParameter(_ parameter: Parameter)
}

protocol Assumption: CustomStringConvertible {
  func holds(forInputs inputs: [Input: Constant]) -> Bool
}

struct Equals: Assumption {
  var left: Expression
  var right: Expression

  func holds(forInputs inputs: [Input: Constant]) -> Bool {
    let l = left.simplified(withInputs: inputs)
    let r = right.simplified(withInputs: inputs)
    
    if let c1 = l as? Constant, let c2 = r as? Constant { return c1 == c2 }
    if l.bounds().max < r.bounds().min || l.bounds().min > r.bounds().max { return false }
    
    // it could possibly hold, pursue
    return true
  }
  
  var description: String {
    "\(left) == \(right)"
  }
}

struct NotEquals: Assumption {
  var left: Expression
  var right: Expression

  func holds(forInputs inputs: [Input: Constant]) -> Bool {
    let l = left.simplified(withInputs: inputs)
    let r = right.simplified(withInputs: inputs)
    
    if let c1 = l as? Constant, let c2 = r as? Constant { return c1 != c2 }
    if l.bounds().max < r.bounds().min || l.bounds().min > r.bounds().max { return true }
    
    // it could possibly hold, pursue
    return true
  }
  
  var description: String {
    "\(left) != \(right)"
  }
}

protocol Parameter {}

extension Constant: Parameter {}
extension Variable: Parameter {}
extension Input: Parameter {}

enum Instruction {
  /// Read an input value and write it to variable a
  case inp(_ a: Variable)
  
  /// Add the value of a to the value of b, then store the result in variable a
  case add(_ a: Variable, _ b: Parameter)
  
  /// Multiply the value of a by the value of b, then store the result in variable a.
  case mul(_ a: Variable, _ b: Parameter)
  
  /// Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
  case div(_ a: Variable, _ b: Parameter)
  
  /// Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
  case mod(_ a: Variable, _ b: Parameter)
  
  /// If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
  case eql(_ a: Variable, _ b: Parameter)
}

func parse(program: String) throws -> [Instruction] {
  try program.split(separator: "\n").map {
    let parts = $0.split(separator: " ")
    
    if parts.first == "inp" {
      guard parts.count == 2,
            let variable = Variable(rawValue: .init(parts[1]))
      else { throw ParsingError.invalidInstruction(.init($0)) }
      
      return .inp(variable)
    }
    
    guard parts.count == 3,
          let a = Variable(rawValue: .init(parts[1])),
          let b: Parameter = Variable(rawValue: .init(parts[2])) ?? Constant(.init(parts[2]))
    else { throw ParsingError.invalidInstruction(.init($0)) }
    
    switch parts.first {
    case "add":
      return .add(a, b)
    case "mul":
      return .mul(a, b)
    case "div":
      return .div(a, b)
    case "mod":
      return .mod(a, b)
    case "eql":
      return .eql(a, b)
    default:
      throw ParsingError.invalidInstruction(.init($0))
    }
  }
}

struct ALU {
  func execute(program: [Instruction], input: [Constant]) -> [Variable: Constant] {
    var register: [Variable: Constant] = [.w: 0, .x: 0, .y: 0, .z: 0]
    var inputPtr = 0
    
    let value = { (p: Parameter) -> Constant in
      if let v = p as? Variable {
        return register[v]!
      }
      return p as! Constant
    }
    
    program.forEach {
      switch $0 {
      case .inp(let a):
        precondition(inputPtr < input.count)
        register[a] = input[inputPtr]
        inputPtr += 1
      case .add(let a, let b):
        register[a] = value(a) + value(b)
      case .mul(let a, let b):
        register[a] = value(a) * value(b)
      case .div(let a, let b):
        register[a] = value(a) / value(b)
      case .mod(let a, let b):
        register[a] = value(a) % value(b)
      case .eql(let a, let b):
        register[a] = value(a) == value(b) ? 1 : 0
      }
    }
    
    return register
  }
  
  struct FlowPossibility: CustomStringConvertible {
    var finishState: [Variable: Expression]
    var assumptions: [Assumption]
    
    /// picks the next input that's not yet set (starting with msb) and attempts to find the maximum value for it
    private func greedyPick(_ existing: [Input: Constant] = [:], from picks: [Int]) -> [Input: Constant]? {
      guard existing.count < 14 else { return existing }
      
      let inp = Input(id: existing.count + 1)
      for attempt in picks {
        var inputs = existing
        inputs[inp] = attempt
        
        // only continue if assumptions hold
        guard assumptions.allSatisfy({ $0.holds(forInputs: inputs)}) else { continue }
        
        // immediately return if we find a solution
        if let solution = greedyPick(inputs, from: picks) {
          return solution
        }
      }
      
      return nil
    }
    
    /// maximum inputs to finish at z = 0
    func maxInputsToFinishAtZero() -> [Input: Constant]? {
      guard let b = finishState[.z]?.bounds(), b.min <= 0, b.max >= 0 else { return nil }
      
      return greedyPick([:], from: (1...9).reversed())
    }
    
    func minInputsToFinishAtZero() -> [Input: Constant]? {
      guard let b = finishState[.z]?.bounds(), b.min <= 0, b.max >= 0 else { return nil }
      
      return greedyPick([:], from: Array(1...9))
    }
    
    var description: String {
      finishState
        .sorted { $0.key.rawValue < $1.key.rawValue }
        .map { "\($0.key) <- \($0.value)" }
        .joined(separator: "\n")
      + "\n"
      + assumptions
        .enumerated()
        .map { i, ass in "\(i). \(ass)" }
        .joined(separator: "\n")
    }
  }
  
  func analyse(
    program: [Instruction],
    inputs: Input.Generator = .init(),
    startState: [Variable: Expression] = [.w: 0, .x: 0, .y: 0, .z: 0]
  ) throws -> [FlowPossibility] {
    var register = startState
    var inputs = inputs
    
    let value = { (p: Parameter) -> Expression in
      if let v = p as? Variable {
        return register[v]!
      }
      guard let e = p as? Expression else { throw ExpressionError.invalidParameter(p) }
      return e
    }
    
    var step = 0
    for inst in program {
      step += 1
      
      switch inst {
      case .inp(let a):
        register[a] = inputs.next()
      case .add(let a, let b):
        register[a] = try Add(value(a), value(b)).simplified(withInputs: [:])
      case .mul(let a, let b):
        register[a] = try Multiply(value(a), value(b)).simplified(withInputs: [:])
      case .div(let a, let b):
        register[a] = try Divide(dividend: value(a), divisor: value(b)).simplified(withInputs: [:])
      case .mod(let a, let b):
        register[a] = try Modulo(modulee: value(a), modulus: value(b)).simplified(withInputs: [:])
      case .eql(let a, let b):
        // immediatelly decide equals if possible
        let left = try value(a).simplified(withInputs: [:])
        let right = try value(b).simplified(withInputs: [:])
        
        if let c1 = left as? Constant, let c2 = right as? Constant {
          register[a] = c1 == c2 ? 1 : 0
          continue
        }
        
        let lBounds = left.bounds()
        let rBounds = right.bounds()
        if lBounds.max < rBounds.min || lBounds.min > rBounds.max {
          register[a] = 0
          continue
        }
        
        // sadly, deciding was not possible. Split into two realities with opposing assumptions:
        let remainingProgram = Array(program[step..<program.count])
        var r = register
        r[a] = 1
        let isEqualRes = try analyse(
          program: remainingProgram,
          inputs: inputs,
          startState: r
        )
        r[a] = 0
        let isNotEqualRes = try analyse(
          program: remainingProgram,
          inputs: inputs,
          startState: r
        )
        
        return isEqualRes.map { .init(finishState: $0.finishState, assumptions: [Equals(left: left, right: right)] + $0.assumptions) }
        + isNotEqualRes.map { .init(finishState: $0.finishState, assumptions: [NotEquals(left: left, right: right)] + $0.assumptions) }
      }
    }

    return [.init(finishState: register, assumptions: [])]
  }
}

let monad = try parse(program: """
inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 7
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -3
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 14
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -9
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -7
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 1
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -4
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 12
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -8
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y
""")

let alu = ALU()
let analysis = try alu
  .analyse(program: monad)

let maxInput = analysis
  .compactMap {
    guard let inputs = $0.maxInputsToFinishAtZero() else { return nil }
    return inputs.sorted { $0.key.id < $1.key.id }.map { "\($0.value)" }.joined()
  }
  .sorted { (a: String, b: String) in a.lexicographicallyPrecedes(b) }
  .last

guard let max = maxInput else { exit(-1) }
print("part 1: \(max)")

let minInput = analysis
  .compactMap {
    guard let inputs = $0.minInputsToFinishAtZero() else { return nil }
    return inputs.sorted { $0.key.id < $1.key.id }.map { "\($0.value)" }.joined()
  }
  .sorted { (a: String, b: String) in a.lexicographicallyPrecedes(b) }
  .first

guard let min = minInput else { exit(-1) }
print("part 2: \(min)")
