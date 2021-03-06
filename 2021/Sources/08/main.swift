import Foundation

/*
 --- Day 8: Seven Segment Search ---
 
 You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.
 
 As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays in your submarine are malfunctioning; they must have been damaged during the escape. You'll be in a lot of trouble without them, so you'd better figure out what's wrong.
 
 Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:
 
 0:      1:      2:      3:      4:
  aaaa    ....    aaaa    aaaa    ....
 b    c  .    c  .    c  .    c  b    c
 b    c  .    c  .    c  .    c  b    c
  ....    ....    dddd    dddd    dddd
 e    f  .    f  e    .  .    f  .    f
 e    f  .    f  e    .  .    f  .    f
  gggg    ....    gggg    gggg    ....
 
 5:      6:      7:      8:      9:
  aaaa    aaaa    aaaa    aaaa    aaaa
 b    .  b    .  .    c  b    c  b    c
 b    .  b    .  .    c  b    c  b    c
  dddd    dddd    ....    dddd    dddd
 .    f  e    f  .    f  e    f  .    f
 .    f  e    f  .    f  e    f  .    f
  gggg    gggg    ....    gggg    gggg
 So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.
 
 The problem is that the signals which control the segments have been mixed up on each display. The submarine is still trying to display numbers by producing output on signal wires a through g, but those wires are connected to segments randomly. Worse, the wire/segment connections are mixed up separately for each four-digit display! (All of the digits within a display use the same connections, though.)
 
 So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on: the only digit that uses two segments is 1, so it must mean segments c and f are meant to be on. With just that information, you still can't tell which wire (b/g) goes to which segment (c/f). For that, you'll need to collect more information.
 
 For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see, and then write down a single four digit output value (your puzzle input). Using the signal patterns, you should be able to work out which pattern corresponds to which digit.
 
 For example, here is what you might see in a single entry in your notes:
 
 acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
 cdfeb fcadb cdfeb cdbaf
 (The entry is wrapped here to two lines so it fits; in your notes, it will all be on a single line.)
 
 Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that to render a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means that to render a 4, signal lines e, a, f, and b are on.
 
 Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits. Then, you can decode the four digit output value. Unfortunately, in the above example, all of the digits in the output value (cdfeb fcadb cdfeb cdbaf) use five segments and are more difficult to deduce.
 
 For now, focus on the easy digits. Consider this larger example:
 
 be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
 fdgacbe cefdb cefbgd gcbe
 edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
 fcgedb cgb dgebacf gc
 fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
 cg cg fdcagb cbg
 fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
 efabcd cedba gadfec cb
 aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
 gecf egdcabf bgf bfgea
 fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
 gebdcfa ecba ca fadegcb
 dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
 cefg dcbef fcge gbcadfe
 bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
 ed bcgafe cdgba cbgef
 egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
 gbdfcae bgc cg cgb
 gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
 fgae cfgab fg bagce
 Because the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations of signals correspond to those digits. Counting only digits in the output values (the part after | on each line), in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).
 
 In the output values, how many times do digits 1, 4, 7, or 8 appear?
 
 --- Part Two ---
 
 Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:
 
 acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
 cdfeb fcadb cdfeb cdbaf
 After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:
 
  dddd
 e    a
 e    a
  ffff
 g    b
 g    b
  cccc
 So, the unique signal patterns would correspond to the following digits:
 
 acedgfb: 8
 cdfbe: 5
 gcdfa: 2
 fbcad: 3
 dab: 7
 cefabd: 9
 cdfgeb: 6
 eafb: 4
 cagedb: 0
 ab: 1
 Then, the four digits of the output value can be decoded:
 
 cdfeb: 5
 fcadb: 3
 cdfeb: 5
 cdbaf: 3
 Therefore, the output value for this entry is 5353.
 
 Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:
 
 fdgacbe cefdb cefbgd gcbe: 8394
 fcgedb cgb dgebacf gc: 9781
 cg cg fdcagb cbg: 1197
 efabcd cedba gadfec cb: 9361
 gecf egdcabf bgf bfgea: 4873
 gebdcfa ecba ca fadegcb: 8418
 cefg dcbef fcge gbcadfe: 4548
 ed bcgafe cdgba cbgef: 1625
 gbdfcae bgc cg cgb: 8717
 fgae cfgab fg bagce: 4315
 Adding all of the output values in this larger example produces 61229.
 
 For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?
 */

enum ParsingError: Error {
  case invalidMeasurement
  case invalidObservations
  case invalidOutput
  case invalidSignal(_ raw: Character)
}

enum Signal: Character, CaseIterable {
  case a = "a"
  case b = "b"
  case c = "c"
  case d = "d"
  case e = "e"
  case f = "f"
  case g = "g"
  
  static var all: Set<Signal> {
    Set(Self.allCases)
  }
}

extension Signal: CustomStringConvertible {
  var description: String {
    String(rawValue)
  }
}

typealias Observation = Set<Signal>
extension Observation {
  init(description: Substring) throws {
    try self.init(description.map {
      guard let signal = Signal(rawValue: $0) else {
        throw ParsingError.invalidSignal($0)
      }
      return signal
    })
  }
}

infix operator ???: MultiplicationPrecedence
infix operator ???: AdditionPrecedence
extension SetAlgebra {
  static func -(lhs: Self, rhs: Self) -> Self {
    lhs.subtracting(rhs)
  }
  
  static func ???(lhs: Self, rhs: Self) -> Self {
    lhs.union(rhs)
  }
  
  static func ???(lhs: Self, rhs: Self) -> Self {
    lhs.intersection(rhs)
  }
}

extension Sequence where Element == Observation {
  var unambiguousCount: Int {
    filter { Digit.candidates(forSignalCount: $0.count).count == 1 }.count
  }
}

extension Set where Element == Signal {
  var description: String {
    """
    \(contains(.a) ? " aaaa" : " ....")
    \(contains(.b) ? "b" : ".")    \(contains(.c) ? "c" : ".")
    \(contains(.b) ? "b" : ".")    \(contains(.c) ? "c" : ".")
    \(contains(.d) ? " dddd" : " ....")
    \(contains(.e) ? "e" : ".")    \(contains(.f) ? "f" : ".")
    \(contains(.e) ? "e" : ".")    \(contains(.f) ? "f" : ".")
    \(contains(.d) ? " gggg" : " ....")
    """
  }
}

enum Digit: Character, CaseIterable {
  case zero = "0"
  case one = "1"
  case two = "2"
  case three = "3"
  case four = "4"
  case five = "5"
  case six = "6"
  case seven = "7"
  case eight = "8"
  case nine = "9"
  
  var intValue: Int {
    switch self {
    case .zero: return 0
    case .one: return 1
    case .two: return 2
    case .three: return 3
    case .four: return 4
    case .five: return 5
    case .six: return 6
    case .seven: return 7
    case .eight: return 8
    case .nine: return 9
    }
  }
  
  var signals: Set<Signal> {
    switch self {
    case .zero:
      return [.a, .b, .c, .e, .f, .g]
    case .one:
      return [.c, .f]
    case .two:
      return [.a, .c, .d, .e, .g]
    case .three:
      return [.a, .c, .d, .f, .g]
    case .four:
      return [.b, .c, .d, .f]
    case .five:
      return [.a, .b, .d, .f, .g]
    case .six:
      return [.a, .b, .d, .e, .f, .g]
    case .seven:
      return [.a, .c, .f]
    case .eight:
      return [.a, .b, .c, .d, .e, .f, .g]
    case .nine:
      return [.a, .b, .c, .d, .f, .g]
    }
  }
  
  static func from(signals: Set<Signal>) -> Digit? {
    Self.allCases.first { $0.signals == signals }
  }
  
  private static var digitsForSignalCount = [Int: Set<Digit>]()
  static func candidates(forSignalCount signalCount: Int) -> Set<Digit> {
    // try load result from cache
    if let result = digitsForSignalCount[signalCount] {
      return result
    }
    
    // compute result
    let result = Set(allCases.filter { $0.signals.count == signalCount })
    digitsForSignalCount[signalCount] = result
    return result
  }
  
  static var all: Set<Digit> {
    Set(Self.allCases)
  }
}

extension Digit: CustomStringConvertible {
  var description: String {
    "\(rawValue)"
  }
}

struct SignalMapping {
  private var inputMap: [Signal: Set<Signal>]
  private var targetOutputs: [Observation]
  
  /// initializes with no knowledge, i.e., all mappings possible
  init(targetOutputs: [Observation]) {
    self.inputMap = Signal.allCases.reduce(into: [:]) { $0[$1] = Set(Signal.allCases) }
    self.targetOutputs = targetOutputs
  }
  
  func outputs(forInput input: Signal) -> Set<Signal> {
    // this is one of the rare cases where this is legal
    // since inputs are all \in Signal and we initialize
    // inputMap using the compiler synthesized allCases!
    return inputMap[input]!
  }
  
  func output(forInput input: Signal) -> Signal {
    return inputMap[input]!.first!
  }
  
  mutating func set(_ s: Set<Signal>, forInput input: Signal) {
    guard !isContradiction else { return }
    
    if s.count == 1, let output = s.first {
      solve(input: input, output: output)
    } else {
      let existingOutputs = outputs(forInput: input)
      s.forEach { newOutput in
        precondition(existingOutputs.contains(newOutput))
      }
      inputMap[input] = s
    }
  }
  
  mutating func solve(input: Signal, output: Signal) {
    guard !isContradiction, outputs(forInput: input).contains(output) else { return }
    
    let currentOutputs = outputs(forInput: input)
    precondition(currentOutputs.count > 0)
    if currentOutputs.count == 1 && currentOutputs.first == output {
      // unnecessary work -> see if we can eliminate this
      return
    }
    
    // solving one might solve the next etc
    var solvedQueue = [(input, output)]
    while !solvedQueue.isEmpty {
      let solved = solvedQueue.first!
      solvedQueue = .init(solvedQueue.dropFirst())
      
      inputMap[solved.0] = [solved.1]
      Signal.all.forEach { signal in
        // don't touch already solved outputs
        var outputs = outputs(forInput: signal)
        guard outputs.count > 1 else { return }
        
        outputs.remove(solved.1)
        inputMap[signal] = outputs
        
        if outputs.count == 1 {
          solvedQueue.append((signal, outputs.first!))
        }
      }
    }
  }
 
  var isContradiction: Bool {
    for m1 in inputMap {
      // empty assignment is contradiction
      if m1.value.count == 0 { return true }
      
      // assignments such that no solution may be found is contradiction
      if inputMap.filter({ $0.value == m1.value }).count > m1.value.count {
        return true
      }
    }
    
    return false
  }
  
  var isSolved: Bool {
    // solution -> each has unique! mapping
    for m1 in inputMap {
      if m1.value.count != 1 { return false }
      
      for m2 in inputMap where m1.key != m2.key {
        if m2.value == m1.value { return false }
      }
    }
    
    // solution has to also solve the puzzle
    if targetOutputs.compactMap(read(observation:)).count != targetOutputs.count {
      return false
    }
    
    return true
  }
  
  func read(observation: Observation) -> Digit? {
    Digit.from(signals: Set(observation.map { output(forInput: $0) }))
  }
}

extension SignalMapping: CustomStringConvertible {
  var description: String {
    """
    a -> \(outputs(forInput: .a).sorted(by: {$0.rawValue < $1.rawValue}))
    b -> \(outputs(forInput: .b).sorted(by: {$0.rawValue < $1.rawValue}))
    c -> \(outputs(forInput: .c).sorted(by: {$0.rawValue < $1.rawValue}))
    d -> \(outputs(forInput: .d).sorted(by: {$0.rawValue < $1.rawValue}))
    e -> \(outputs(forInput: .e).sorted(by: {$0.rawValue < $1.rawValue}))
    f -> \(outputs(forInput: .f).sorted(by: {$0.rawValue < $1.rawValue}))
    g -> \(outputs(forInput: .g).sorted(by: {$0.rawValue < $1.rawValue}))
    """
  }
}

struct Measurement {
  var observations: [Observation]
  var outputs: [Observation]
  
  init(description: Substring) throws {
    let raw = description.split(separator: "|")
    guard raw.count == 2 else {
      throw ParsingError.invalidMeasurement
    }
    
    let rawObservations = raw[0].split(separator: " ")
    guard rawObservations.count == 10 else {
      throw ParsingError.invalidObservations
    }
    observations = try rawObservations.map { try .init(description: $0) }
    
    let rawOutputs = raw[1].split(separator: " ")
    guard rawOutputs.count == 4 else {
      throw ParsingError.invalidOutput
    }
    outputs = try rawOutputs.map { try .init(description: $0) }
  }
  
  /// Solves, may be sped up by starting from a well known position
  private func computeWireMapping(currentMapping: SignalMapping, possibleDigits: Set<Digit> = Digit.all, remainingObservations: Set<Observation>) -> SignalMapping? {
    precondition(possibleDigits.count == remainingObservations.count)
    
    for observation in remainingObservations {
      let conceivableSolutions = Digit.candidates(forSignalCount: observation.count) ??? possibleDigits
      for digit in conceivableSolutions {
        var updatedMap = currentMapping
        observation.forEach { inputSignal in
          updatedMap.set(digit.signals ??? updatedMap.outputs(forInput: inputSignal), forInput: inputSignal)
        }
        
        if !updatedMap.isContradiction {
          if updatedMap.isSolved {
            return updatedMap
          }
          
          // no contradiction so far, assume this is actually our assignment
          var digits = possibleDigits
          digits.remove(digit)
          var observations = remainingObservations
          observations.remove(observation)
          if let mapping = computeWireMapping(currentMapping: updatedMap, possibleDigits: digits, remainingObservations: observations) {
            // mapping should be solved at this point (right?)
            return mapping
          }
        }
      }
    }
    
    return nil
  }
  
  /// Use inherent system knowledge to prune the search space as much as possible
  func applySystemKnowledge(mapping: inout SignalMapping, digits: inout Set<Digit>, observations: inout Set<Observation>) throws {
    guard let obs1 = observations.first(where: { $0.count == Digit.one.signals.count }),
          let obs4 = observations.first(where: { $0.count == Digit.four.signals.count }),
          let obs7 = observations.first(where: { $0.count == Digit.seven.signals.count }),
          let obs8 = observations.first(where: { $0.count == Digit.eight.signals.count })
    else {
      throw PuzzleError.invalidInput
    }
    /*
     1 -> c, f
     4 -> b, c, d, f
     7 -> a, c, f
     8 -> a, b, c, d, e, f, g
     */
    
    
    // (1) uniquely identifiable observations 1,4,7,8 and their digits can be eliminated
    [obs1, obs4, obs7, obs8].forEach { observations.remove($0) }
    [.one, .four, .seven, .eight].forEach { digits.remove($0) }

    // (2) signals not enabled in one, four and seven's combined observation are either 'e' or 'g'
    (Signal.all - (obs1 ??? obs4 ??? obs7)).forEach { mapping.set([.e, .g], forInput: $0) }
    
    // (3) signal in seven but not in one is 'a'
    (obs7 - obs1).forEach { mapping.set([.a], forInput: $0) }
    
    // (4) signals not enabled in one but in four are either 'b' or 'd'
    (obs4 - obs1).forEach { mapping.set([.b, .d], forInput: $0) }
    
    if mapping.isContradiction {
      throw PuzzleError.invalidAssumptions
    }
  }
  
  func demangle() throws -> SignalMapping? {
    var digits = Digit.all
    var observations = Set(observations)
    var map = SignalMapping(targetOutputs: outputs)
    
    // prune search tree with system knowledge
    try applySystemKnowledge(mapping: &map, digits: &digits, observations: &observations)
    
    guard let solvedMap = computeWireMapping(
      currentMapping: map,
      possibleDigits: digits,
      remainingObservations: observations
    ) else {
      throw PuzzleError.invalidInput
    }
    
    precondition(solvedMap.isSolved && !solvedMap.isContradiction)
    return solvedMap
  }
  
  func demangleAndRead() throws -> [Digit] {
    guard let mapping = try demangle() else {
      throw PuzzleError.noMappingFound
    }
    
    let digits = outputs.compactMap(mapping.read(observation:))
    guard digits.count == outputs.count else {
      throw PuzzleError.invalidMapping
    }
    
    return digits
  }
  
  enum PuzzleError: Error {
    case invalidInput
    case invalidAssumptions
    case noMappingFound
    case invalidMapping
  }
}

struct DisplayRepairer {
  var measurements: [Measurement]
  init(description: String) throws {
    measurements = try description
      .split(separator: "\n")
      .map { try .init(description: $0) }
  }
  
  func countUnambiguousOutputs() -> Int {
    measurements
      .reduce(0) { aggr, measurement in
        aggr + measurement.outputs.unambiguousCount
      }
  }
  
  func readAndSum() throws -> Int {
    let nums = try measurements
      .map { measurement -> Int in
        let digits = try measurement.demangleAndRead()
        return digits.reduce(0) { 10 * $0 + $1.intValue }
      }
    print(nums)
    
    return nums.reduce(0) { $0 + $1 }
  }
}

let testInput1 = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"

let testInput2 = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""

let input = """
gbcead cfgaeb beadf adb egafd fbeac dbfegca fdaceb dbfc bd | dfcb gedaf dcfb bcfdea
dgfcb gcdeafb eg egb fcdebg cegf becad dfbcag fbgdea gecdb | dbfcge dacbe bge fgdbca
bgdacf ga egab bfeacdg bfaec agc efbcda agfec cfedg abfceg | bega cga febac aebg
cbgfad ed ecdgfb dge deabg fgdab geacb gabfced dfae dbgfea | afed dfea de eabgc
fdaegb fae acedgfb dgbae fedcb daefb gebadc af bcfgae gafd | egadb afdbe eaf af
cfg cegbdf fecgb fg cdageb fbgcad egfd gdcbe eafcb abdgcfe | gdbace fbgce gecfb bdfcge
bgcfed aebgdcf gcbd edbcf ecdfag ebc efcdg bc befacg daefb | dfabe edbfc cdebf gbcfea
dbfge cfebd dega facbge adbgcfe bfage fgdeba gfdbac gd dgb | bgd eabcfg bcdfega egafdcb
ae egca gdeabf gcfba fcdbag dafcbge dbcfe efa ebgcaf fbcae | cdebgfa gecdfba dabcgef bfceag
dagcfb fdegacb cbgad bedcg cbgeda cfbeg aefgdc abde ed gde | egdbfca gcbdae gde gecdaf
fcdaeb gecaf eabcdfg efcbgd bge cadeb gbad becga cbeadg bg | ebg beg edabfc cbeda
ed cdbfaeg ecadgf bcfde agcdfb cedbfg gedb cgdbf def acfeb | abfcdge ed bdge ed
gfdac afg ecgfba af ecadbg bfda adcgb dbcfaeg bdcagf cgfed | gabcef bfad gbecda degbca
faedg ba cbdgf ceadgf gdbfea adbgf aecdgb efab agcdebf dba | fedagc bgdfc ab afbdg
eadfb ecbdg ebgadc bfc gcef egbcfd fbcdega bcefd gcbdaf cf | bagdecf bgceda beadcg fecg
begdac eabdc cabef de facdbg acegdfb adcgb edcg dbegfa ead | gabfdc gbcfda daegfb ed
dfgcb ef fce gcdef bcgafe gdaefcb dcgebf dfbe agcde gdafbc | ceagbf fbgdc cfged gecfd
gefcd fcdeba bf fbgedac egadbc aedcb fcb bdecf fbeagc afbd | fbc fgabdec ebcdf gcdef
cagdeb bed gcbfe fdae cgdfbea dgfeb eafdgb ed agfbd cgfbda | dgbef gbfdeac fgbdace ed
bdgea eabcdf efbgc edfgcba fed df ecgdbf bedgf egacbf fdgc | efd fdbaec befcg ebcgfa
ced edgaf gacebd ce fdabc fgcdab cdaef cefgbda fcaebd ebfc | ec fdbcae fedag aecfd
fcgdb cfbdge agdefb af abgcfed decga cdbfag fcab dfgac dfa | agefdb adgcfb adceg cafb
cfag fgbedac gedfc cfead cgdafe gef fdebac ebdgc fg agefbd | fg egf egdcb gcaf
baecdg gec gefdab gcfead agcb gc acdgfbe edgbc dbcef gbade | cagb acefgd gc cabg
cgefb bgdface ecgbfd gcebaf bface egbfad ae fea gcea bcdaf | dbcfa fea aedbcfg ae
dfgabc cdfgeb ce gefcba fcbde degc cfbdg bce feadb defgbac | fdcbe bdfgce cfbdg abefdgc
dageb dcbfga dg eadcgfb edcg bgcead eafbd gad fceabg egcba | bgaecf acdgbe dg dag
edfacbg bgcadf adebgf gbdca fb becagd bfgdc cefgd dbf bafc | fb agebfd dfacgeb cbgafd
bedgafc cbd cefdgb ebca dbeafg dfbea bdafc cb dgfac dbaecf | bfadc adfeb fcabegd fcbda
gb ebgfdac fbag fbaecd fbdage ecfdg dceabg bdg gdbef afdbe | ecfabd bg gdb bgaf
ebdfcag dbfgae abcf bdegfc bgfdc abd edgca bdacg ba dabcfg | bagcefd gafcdb caefbgd dcefgab
cgfd fcbae geafd egc cg bgdcea fedbag acedfg fgeca dabegcf | caegf fcgd faegbd ecdgba
dacefgb gdcab cbeg ge dabecg afcde daecg dfeabg fbdcga gae | egdabc deabcg ebfcdga aeg
bgaced ebdg cgd abegfc gdfbcae bgace dg cfeda cgdea adfcgb | cfbage bgde dg aecgb
gfedabc bc gebad facgd ebcg edcgba dfabeg cdb dbagc abdcef | gaedb abdfce gbec gecb
ecfgd adgbcfe adgcbe bdfegc gefa dbacf cfgda ga acg fadceg | ag ga adbfc faeg
ced edbgf afebgcd dfegbc bgfead cfge ce gbcde abedfc cbagd | cdbag ecgf edc dce
aefcgb fbdcage bdfe cefdgb bcgde ef fgcad efdgc efc edacgb | dfacg cgabfe ecf dfcga
aed cgbaedf eacdg dfgac dfaebc gbde bcaegd aecgb ed fagbce | ed feadbc dbeafc de
decbaf bdeafg acbf gceda bcdgfea af afdce fgbecd fad cfbde | af bagfed eadbfc fdcae
ebacgd fagdb dgcefa ebg fedgcba adbeg eb abce fgdbec cdage | gcdeba ecab bcae ebfdgc
cfdb daf gacfe dfagbc ecfbagd dcbag fd adecbg fagdc dafgbe | cdfb dfa ceafg fgabed
bgfedc beadc gecdb dcegafb gb edgacf begcaf fdgb gefcd geb | ecbadgf ebcafg fgedc ebg
bde afcegd beadgc fcaebd edgbfac aefcd dfabe bfce gafbd be | eafdbc bcef efgdac gfabd
bdfgae ebfad fbc bdefc afec dbagcf cgefbda acefbd fc cgbde | cebfd fgbaed gfcadb bfdagce
abgf dabfec ebacg gdeac ebg bface egcabfd fgcbde bg eagfcb | agecd gcaebf beg fabcde
adecb aedbgc geabc gcabef fabed afbcdg cd dbc dgabfec ecgd | beacfg dcge dceg cgde
agcdfe egabcd cfgaedb bcgea fcgdeb eac deba agcfb ae cgbde | bfcegd fdacbeg bedcfg cfedag
fdebagc gdefb dfabg gcabdf ba acegdf acedgb adfcg bad abcf | fgdac fgadc bdgaec abfc
cbfd bc fdgeb eagcd becgd bce gbfecd dgeabf befgac ecgbdaf | bfgced cedgbf cb cegfbd
fedbg ebdcf aefgd fcgeda bg ebagcf bge bdefag dbga afegcdb | bfecd gdab gbad debcf
gcfeab bd dbe ecgabdf edfba gbacde bdfg gbaefd bgaef edfac | cefad db aecdf bfcage
fcedba edc dc fcda gefcab ebcaf efgbdca cbeda dfbgec gebda | ced dbgfec gdebcf aebcf
fgce eacdbf cbdfga gbfae deacfgb eagbd gaf feabc fbceag fg | afcgbd cfegba bagef fdcbea
dfabge dge cbdfea cbgd gd fdceb gfdebac agcef edgfc bfcdeg | fcdbge dg cdefg fcadbe
gbeca fbg cdfeb dbaceg fdacbg fgae cfegb aegcfb gf dfgbeac | abegfc fecdb efag gbeafcd
gacfeb cd cdbaegf aebcg dgebf bdcafe adgc bdcge aebgcd bcd | fbceda edcbg edbacg befdca
dgaeb afegdcb adfgce cabde gb gfaed gebf gbd dbagfe fbgcad | gbd gbdefa cgfadeb becda
efg gdfa ecadf eagfc cgaeb febdcg gf edcfga befadc gebfcda | gdfa ebdacf abgce fg
dbg cbadf gefbc egfadb bgcfd efdbgac gd ebfcgd bcgefa ecdg | dbfcg dgb fcgbd dbg
dbfecg facdeb fbadc gf gbdfa gfb ebdag dbafcg egdfbac gcaf | dcfbag gfca gbf fgcdbe
cefgab fgdb dge aegbf cbgaed gd bfdgcae dfega abfdeg deafc | feacd bdgf gbdfae eafcd
dcae ea facbged efa fagbc cefab aefbdc afgebd edbcfg edfcb | fbgdce cbfga efgbcda eadc
geafbcd fecbag fba dgbfc dbface bceadg cbdfa fa bdace eadf | af dabcfe cafdb cbaed
efbgdc dga gcbfd agfb gfcdab dbgfeca fegdca abedc ag badgc | cbdgf febacdg cfdbg gedbfca
edagfb gcda ebfadgc dgcbef bgc gc gbcadf gabfc agbdf abecf | ebgdcf cdga bafdg afcbg
daebg cfaegdb fgabe agedcb bda bd fcdabg aedgc eadcfg cebd | cdeb ecdga db geabf
dgef fcbged ef bfcage dbfcg cefdb caefbgd daceb fbe gfbadc | gdef dcgbf daefcgb dbgcf
ga bcfeagd afbg fgead fegabd becfdg age edbgf bgdeca dface | eag ga bgfa gfdeab
adge fbgcead dabcf de cdbfeg fbega fcaebg bed fabde faegbd | abfed gdea fbdae ebd
gae ae gcefbd bcaefgd edbgc gdfab debag dfecga gbdcea abce | egdbca afgdb ae cdeagb
cabgef ed fbadg ecbd edcbfa cfdaeg afedb ade ecdgabf afbec | fcgbeda cebd dabfg cafebg
fdbcae ceadf dcgbfe cad ebdcfag ecfbd eafcg deba ad gcfabd | fecag daeb cad ebcdf
cf egbfc cfbgeda gfc gbdce begafd facbge afbeg fcea gcdafb | fc fc afce cf
abdecg deg gcbd efgbda gacdfeb ecagf badce dg dafbce dgcea | dcaeb abcfed efacg gd
cbgefa dcbage abecgdf cdga fgebcd ca cbdeg eac dbcae eafdb | ace dgecb befcga cea
gef fg dgaebf bfeac cgfea ecfbgad bgfaec acefbd cgdae bfcg | fdaegcb dceag edbgaf fadebc
gbafde adefbcg fbaeg ged dg abgd dfbge gfedca caegfb cdebf | dgab baegf agfced bgfae
eb caefdg dacfe baed dgfbce efbdac efcdbag baecf ebc gcbaf | cbe fcbade adcef ecb
db deacg fabge bcagde bedc bfdagc adgbe cdeafgb bda cfgead | agdec becd abd bd
agcdb fcba efdacg gca bgdec fagdb bafgcd beafdg ca caefbdg | dgaebcf acdfeg cedagf fdcgba
bacdgfe ge dgeca ecdba bdcage cebafd efabdg egbc dfgac egd | egd gbce abecd afbdecg
bdfa aegcfb gfa daefg fa gaedc dcgebf bacefgd abdefg gebfd | fadb fga dgeabf bafgec
dfecb adcefgb dcbea bagc dfbeag bea ab degcba efgacd dcaeg | bae cfdgae daceg bfced
fbcde fdgb deg cdfega dg cageb gbedc afdebcg bcdfeg cebdfa | bfdec dbecf abecfd cegbd
fagdebc eafgcd gbaefc def abcde fdcgeb afgec fadg df dafce | fdagec deafgc df adceb
bcfaegd begfda bdaef efbgca cba bdec fgcda dfebac bdcfa bc | bafdc fabdceg cebd eafcbd
acbeg fgdbca ecdbgf abg eadgc ba adgbfce bcefga cgfeb afbe | fbgdac fadcgb cdfgba gfcbe
fbdceg af ebadcf aedbf fbcega dfca fea fadcbeg gaedb dbcfe | abgfce dacf fa bfegacd
ged abegfd aegbcd gaec fecbd decbg fgcdba egbdfca dgcab eg | eg gfedba efdcb gebafd
gfb begdaf cbadf fcgedab fgec fbcedg gebdca fg gcbdf degbc | gcbdf fg bgdfc fgb
dcgaef gca cgdabf ac gcdab fabc gfbad adefbg bgcde dbeafcg | cgbed dafegb ac ac
fgeacb bc bfdge bcg dfgcb dacegf badcgf cadb fcbaged gafcd | fcgad cb afgcd bgdcf
fadecg fb fcb gefb dgfcab adefcgb ebacfg cabfe becad gcafe | fcb cgefba caedgbf gdacfe
edcab fgce dgfcbea aebfc abgfdc efa fe bcagfe dbgfae abfcg | baedc facgb acgfb ceafb
bae aefbg dfbag afed bdcgfa fegcb afegbd agcdfbe ae bdcega | fegbc febag acgdbe fgdba
gea dagebc efadg adcfg cfgdba edacgfb caef ea gdbef geafdc | ea gfade feac fcae
gadc acfdb ag bfdge fbgad fbdcage abcfed agf bcdgfa cafbge | cdag cagd dbcaf gfedb
gacedb abfced fdcbe gdfbce ea fcdga eacfd dbcafge afbe aed | edcfbg faced becadg cagdf
dbcaf bdcfe fdgcab ca agfbd acgbed abgfedc acfg gafdeb bac | dbgecaf bfcda fgac bgdcaf
gbaef dbagef fab fagd bedgf bdgacfe gfdebc fcdbea af acbeg | gafd cdbgaef eacdbgf fba
gecd beacg bec badfce gbeacd bgcad gedfcab ce dbacgf fegab | ce acbgd ecabdf afbced
cfdbae bdfcage ecdfb gfebca cagbd ge cfegdb egcdb gedf geb | ge gbaecf bfcdage cbgedaf
fag cagefbd agce bcdfge ag fabed cgdef degfac geafd gafdbc | edfcg fcdge cegdbf gfaecdb
gdf bacgde eabdfcg ebadg fd caegf fecdgb adfb fgade bagefd | adbfeg ceagdb baefgdc gfead
cadgf cfabdg bfgaedc gbade cgdeaf cgef acdefb efd gaefd fe | def beagcfd deabg gecf
ag aeg bfegacd badec badg gdecaf afbced gcaeb bfegc cbeadg | baced gabd becad egcfad
bgad eabcdg acedfb gdfecb ab eba bcgeafd bcega edgbc gefca | egcaf gbedc ba ecbgad
gbacf cegfab fdbcea gaec fgc fdabg cdfbgae cg egbdfc cefab | cfg fcbgdea fabdec fbceag
debfg bdefga db gebfa gedcf bcafde edb cfaebg gbda cdbeagf | edafgb aegbdf egdcf bdga
fabdegc eacdb baceg afdceb bdefc gfbead dab fgecdb cfda da | cbage da ecfdb dceafb
gcfdba gacdb gabdf efbcdg cafd cbdafge dc aefbgd cdb agecb | cdegbf acbdg bcdag facd
ebd bfacge aegfb de edfa fdgeb aefdgbc abfged gdfbc dgbeca | fbgcd ed ed de
cdaef acfegd bfce eabfd fgdabec egcbad be gdfba bde eafdbc | be bed eb eb
de bedf bcgaed fedgbca cabgef ead cadebf cbfea fcead dfacg | geabfc eda eacbdg bgecfa
dfaec egfcd egc cg egfcad ebcgaf dcfbae gbfde fcebagd acdg | ceg dacfgbe begfd dbcafe
cdbg gacfd gb ebfad agefcb efacdg cfdeagb gdfba gbdacf bga | bdfga gdcb bfgace dbcafg
abfdeg fadec dagcbf gecadbf egabfc abefg befda edgb bdf db | dbeg db bdge dbfecag
ebdafc gbdcf geabcfd caedf gdecf fage gce bgeadc ge egfdca | egc gec gfdec adbfce
afdc fgdaeb dba ad acebf ecagbf daegbcf edacb eadfbc bedgc | cgeafb dgceb dba edbgaf
ebd be cafgde gfcbed gdaef gbcad bdfaeg efab efbgdca ebgda | edcfga dafeg cefbagd gfdae
cdefa fdceag gabefc afdb caebd ba begcd ebdcgaf dcebfa acb | cadfbe dacbe bca fabd
edga fcbade fea egfab gebfc ae dfcagb dgbaf adgfbec dfbgea | bdfagc fbceagd fae gbcfaed
ebgaf fgadc becfdg caeb dbfage cb gbc gadfbce bgacf gbacef | abdfeg bc begcdf ceba
dfgac feda ecabfgd eacfg fbdgc gad aefgdc cegbaf ad egdcba | febdgca aefd fdcga cfdag
daecb gdcabe bgdcfae decbfa efdcg cdbge dabg bg bcg bgfcea | ebcgd aecbfd debcfa bfeagc
gf dbfcg acbdf fdbeacg dgebac gedf aefcgb cfg fgcdeb cgbed | dgfe efdg defg bedgc
afgbdce fgcbe dgbe bcfdea gbcfd dbc febcga gecbdf dgcfa db | gacebf ebdg bcd dgeb
fcadge geadfbc db gdcae gebcd bdg gafbde gcbfe dbgcae abdc | abegdc gfecb begafdc bd
fc dacebf befcd fbegdca feca dafeb fedbag dbcge fadbgc fdc | ecfdb cfd acef edagbf
aeg gfebac dbcfea fgde gadcb ge fecdag egcad cfead bgedfca | fdgcae edfg dafec dfcae
gedca fcabdg fcabeg dgfbae eb becf fcbga eacgb bae faecgbd | fgbac fdcbgea aeb fgacb
fbcegd badfg fdeab agdefc abecgfd dgfbc adg ga bagc gbfcad | ga abgc efacbgd agfbd
acfebdg gbc gc cgbfae dgbea adgbc bdafc dgbeca bfgade gdce | dabfecg dagbe ebgad egcd
cgfe gdbfae bfaecd adgcbfe bgdca fg deacf gcfad fcgead dfg | faebdg fdcaeb fg gfce
cdebgf gb gfbe dgcbf bagced fcdge bdg bdfac fdcega dbagcfe | fgedc gdcef bcdegf cdfgae
fgcd cfa edcfab dafcge efgab gbceda daebcfg agfce cf adecg | gafce fcgaed fac afc
cedgba ac cabf egadf fbegcd aebfcd ecdbf dca cgadfbe dcefa | ac bgfced fecbd cbfadge
dagb ebcgd ad bcegdfa dbcea edgfac dgceab cgbfed bcfea acd | bdfgce bcaef da bgedfc
fgdea fgcade ebcagf cg eagbfd gce ecfgd cdebagf dcga cdebf | gc gc bfadge adcg
fbe debg fgced fcbdae gcfab dcgfae egcbf cgabedf cdefbg eb | ebf debacf be cafbg
fcegba cebadf efgd gaefc adfceg ade fcegabd aedgc dgabc de | aegbfc faegdbc egfd dgfe
df bfcdag dacbefg fagdbe begaf ceadb adf afbde gdef ecbfga | geafb faebcg ebadf df
ecfdab dcfba debfa ecfd dbacegf bcf fgcbae cbdga agedbf cf | dcbag eagbdfc edbgfa cafdb
fed bgdfac edbafc egfab gdcfb de fgedbac gced bgedf bdcefg | defcgb gbfdec cedg ed
gbfcdae dcab ba bgfedc ecbafd agfedb fcebd abfce cfega baf | bfa gebcdaf bfedag ebfgdc
afdceg eacfg cbgfaed gc dceg fgdcab egfda gbeadf abcfe fgc | gdcaef gfc fdgaec gc
bfdaegc bcaefd edfgcb edfgc fdgac faeg af cfa afgdce bagcd | geadcf fdabec acf agdcb
ebfdc dbag eabcdfg gcd gfbaec agcfbd dagfec abfcg gd cgbfd | fgabc bgad adgb fbdgc
efgdcb dacbg afcbe cfd fd gadceb agfd acdfb ebagfcd dgcbaf | cebgdf gdaf bfcdeg afbdcg
defgb bfce dgeab ef dcbgf gcefad bfecgd dfgabc eacdbfg def | bfdgc fgcbeda ecafgd fdcbge
edg bfdgeac bagce gbdae egadfb ed dfbe cbgfad dgfab gfcade | ed dcgaef acbeg ged
abedc gafbed bgaecd beadfgc bf dfb gdcfa abfcd ecfabd ebcf | dcafg fceb dbacfe fbdgace
eagfc acebg abedfgc feadbg adgef dfca edgacf fcg cf dfgebc | fcdgeb fgc cdbfge gdcbafe
bcde dcafgbe ecf debfa ec bgfca bcfae bcdfae gbfdea caegdf | cef edfab cfbdae cfgab
fdecag cd cbfage aedbcg gbcaedf cabdg dgc bagec bgfad dbce | fcbgae gbafd cgd bcfgae
feba agfdceb gbfedc gbfca ab bca cadgf gbcfe debagc cgbaef | cadgf cfaegb gbacf dcabeg
adceb cdgbaef cefdab ec edc dafbeg ecfbgd gdacb feca aedfb | bdfegac eafc badfe ec
bacdfg fcbeag afdc fabegcd acgbf agbdf dag ebdfg ad edbgca | gedbf bgdcaf fdac dcfa
aefg dgecb eafgdc gefdc afcdbe befcdga cdfag cef gbcadf fe | ebadfc efcbda efgcda bfgadce
decf fbgdca ecbgfd gbdae df bcfeg dgbef dbf becgfad acgebf | fdb fbgec dbgfac fcgdbea
gcaefd decab cbfea egfdbca dafb efgcb bcdega ebacfd afc fa | ecbfad caf dbeca caf
abfdgc gebaf cb bca fdabceg becf ecadg bacge afedgb agcefb | daceg dgfeba bc cgdea
cefgdb edfagc gc fdgbc aebcdf ebcdf fgc gbadf deagcfb gecb | gfc efacdb cg bacefd
gbead cgdeb cg fbegcad bcefd cbfdeg ecfbga gec dgcf fecbad | cg geadb gce gc
agebf cafeg dbfagc gecd cg gfceadb cga gafcde defac fbdcea | edcaf efdac eagcf cagfbd
gbdefa eb cbfdag cdeb bcaefdg dcbfae febac feb gcafe adfbc | eafgc beacf gadfeb ebf
abcfe ecgbfad ebda eca gfacb aecfgd dgfceb ea fbcde fdabec | acdbef deab ebcdf dbae
cdaf abgfed ebcdgaf deabc fbcea cefabd edgbac fa afe fgbce | acbfe bcgeda acbef abdcge
eabcf cd gdbecf gfcaedb dcfg gafdeb fdbge cadebg edbfc dcb | bdcegf badcegf dbc gfecbd
dagfb bfecga efdcb ebfcagd cg cbg ebcdaf cdgbf dcbgef egcd | agfdbec gc ebfcad edcg
cfaeg fd bgead efcbgd gdefa fcda cgeadbf gfd gfbeac adegfc | facd dfgae fd degba
egfbd cagde fbeagcd fa aedfg ceagfd daf cfag cfedba abgdce | afcg af af fdega
gcdfae aebdfg gfc abgec dcbf abfcg fc bdfceag fbdag bacgfd | afbged cf cfabg gfc
fcbaged bafce cfag gbcdfe abecg cfb gbafce dgcabe dbefa cf | cf cgfa bcf fc
cfed bdgfc bcd fcbegd eagcfb bdfag cd efcgb bdcgae dfcaegb | cbfge dcb gcdabe gcdbf
cdg afbcg adec adgefb gebdfc dc gafde adgcf fgdeac gdfbcea | caed fadge ecbdfg ceda
ba gfbca fdcgba egdcabf agbdce fgeacd agb cfadg fecgb fdab | gcdbfa fadb agb ba
cbfda ga cfbag adbcge acg aefg abfgce gefbc gdbecf cadebgf | ag dbfac agc bcgeaf
bgcdea fgdce cg cfga defcb gadfeb gacfedb gcd edagf gafdce | fagecdb gedfab gbecda facg
fcbeg gcabe bcfed gf gfbedc cfabed bfcgead gefd fgb fgcbad | acbeg adebfc bgf bgf
bgcfed gedbf gf egf bgeacd decbg bcfgea cdgf bfcgade bafed | bgfdce dbaef gebcd bfcgae
abecd bfcda gcdeba dfbe efgbac fcagd bcf fgebdac fdbace fb | fgcbea cfb bfc decab
fc cadebf acgfb dfgabc bfgae gcdf fbceagd adcgb cbf adecgb | fdbagec fc aedcgb cf
fe abgdef daefg bgcadfe dagbf dfbegc bfae gdbafc acedg gef | dagcfb baef cgedfb cabfgd
gef fegacd cbefd daecbg agfd cdefg fg gecbafd dceag cfebag | ecgad acbdeg dcfbe gdecba
cae fdeag gdcbae cagdfbe ce daefcg fgce acfdb egafbd acfde | gbdaec gafdce ce eac
fdaegc dbefgca dcfa fedag fdbegc fd dcagbe edf fgeba cedag | efdcag fed dcgbfea df
afcegb cadbef efb beadc fcdgb ef fbdce dfea agdcbfe gceabd | dcafbe eadf fcebga baced
cbdfgae cfaeg ebgdfa eg gbafc decg gea cbafed afgdce fcade | dceafg bdaefc ge faced
acbdfg bfc bc dbcg afbcd bfcdgea abdgf cfeagb fcead dfabeg | egcbaf egafdb agfbd egafcb
aefgdc bcfde gacb cgf bacefgd baegf ebfdga agcbfe cg ecgfb | fecadg bgfae aegdcf egfcba
fdgcaeb facdbg dfc dgcab cf caefbd cebdga edgfa afcdg fbgc | dfc cf dfcga bfgc
cdgebf fbegc cgfdea ecagfb gfbac aedbfcg ac fbagd eabc cga | faegcb ca abgcf ebfcg
acbgfd fecgdb bcagf abeg ecdfa gcfae ge ecg cgbadfe fgbace | gec ge cgfba dfcae
aef efadgc cagedb cfde dagef ef aedcg ecbagf dcfabeg afdbg | ceagd afe fae gefad
dbacfe cbf acefg abecdg fdbgcae bdfe bfeca bf fgdacb bdcae | cedab cefadb edfb fcbgaed
ebgf acdbfe adfgc baf fb fgeabc adfbecg abecg bgafc cedabg | fb bf gceadb dafgc
fbcead gadb adebgfc ba aegcb caegf cab ecgfdb cbdeg aegbdc | decabg edcgb cgbfde dcgeb
bafegdc becgdf cdebfa ecg bfedc gc fcbge eafgdc cdbg aefgb | fbecd acfedb gbcd cfagde
"""

// test part 1
let testDisplayRepairer = try DisplayRepairer(description: testInput2)
print(testDisplayRepairer.countUnambiguousOutputs())

// solve part 1
let displayRepairer = try DisplayRepairer(description: input)
print(displayRepairer.countUnambiguousOutputs())

// test part 2
let testMeasurement = try Measurement(description: testInput1[testInput1.startIndex..<testInput1.endIndex])
print(try testMeasurement.demangleAndRead())
print(try testDisplayRepairer.readAndSum())

// solve part 2
print(try displayRepairer.readAndSum())
