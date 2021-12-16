import Foundation

/*
 --- Day 16: Packet Decoder ---
 
 As you leave the cave and reach open waters, you receive a transmission from the Elves back on the ship.
 
 The transmission was sent using the Buoyancy Interchange Transmission System (BITS), a method of packing numeric expressions into a binary sequence. Your submarine's computer has saved the transmission in hexadecimal (your puzzle input).
 
 The first step of decoding the message is to convert the hexadecimal representation into binary. Each character of hexadecimal corresponds to four bits of binary data:
 
 0 = 0000
 1 = 0001
 2 = 0010
 3 = 0011
 4 = 0100
 5 = 0101
 6 = 0110
 7 = 0111
 8 = 1000
 9 = 1001
 A = 1010
 B = 1011
 C = 1100
 D = 1101
 E = 1110
 F = 1111
 The BITS transmission contains a single packet at its outermost layer which itself contains many other packets. The hexadecimal representation of this packet might encode a few extra 0 bits at the end; these are not part of the transmission and should be ignored.
 
 Every packet begins with a standard header: the first three bits encode the packet version, and the next three bits encode the packet type ID. These two values are numbers; all numbers encoded in any packet are represented as binary with the most significant bit first. For example, a version encoded as the binary sequence 100 represents the number 4.
 
 Packets with type ID 4 represent a literal value. Literal value packets encode a single binary number. To do this, the binary number is padded with leading zeroes until its length is a multiple of four bits, and then it is broken into groups of four bits. Each group is prefixed by a 1 bit except the last group, which is prefixed by a 0 bit. These groups of five bits immediately follow the packet header. For example, the hexadecimal string D2FE28 becomes:
 
 110100101111111000101000
 VVVTTTAAAAABBBBBCCCCC
 Below each bit is a label indicating its purpose:
 
 The three bits labeled V (110) are the packet version, 6.
 The three bits labeled T (100) are the packet type ID, 4, which means the packet is a literal value.
 The five bits labeled A (10111) start with a 1 (not the last group, keep reading) and contain the first four bits of the number, 0111.
 The five bits labeled B (11110) start with a 1 (not the last group, keep reading) and contain four more bits of the number, 1110.
 The five bits labeled C (00101) start with a 0 (last group, end of packet) and contain the last four bits of the number, 0101.
 The three unlabeled 0 bits at the end are extra due to the hexadecimal representation and should be ignored.
 So, this packet represents a literal value with binary representation 011111100101, which is 2021 in decimal.
 
 Every other type of packet (any packet with a type ID other than 4) represent an operator that performs some calculation on one or more sub-packets contained within. Right now, the specific operations aren't important; focus on parsing the hierarchy of sub-packets.
 
 An operator packet contains one or more packets. To indicate which subsequent binary data represents its sub-packets, an operator packet can use one of two modes indicated by the bit immediately after the packet header; this is called the length type ID:
 
 If the length type ID is 0, then the next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
 If the length type ID is 1, then the next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
 Finally, after the length type ID bit and the 15-bit or 11-bit field, the sub-packets appear.
 
 For example, here is an operator packet (hexadecimal string 38006F45291200) with length type ID 0 that contains two sub-packets:
 
 00111000000000000110111101000101001010010001001000000000
 VVVTTTILLLLLLLLLLLLLLLAAAAAAAAAAABBBBBBBBBBBBBBBB
 The three bits labeled V (001) are the packet version, 1.
 The three bits labeled T (110) are the packet type ID, 6, which means the packet is an operator.
 The bit labeled I (0) is the length type ID, which indicates that the length is a 15-bit number representing the number of bits in the sub-packets.
 The 15 bits labeled L (000000000011011) contain the length of the sub-packets in bits, 27.
 The 11 bits labeled A contain the first sub-packet, a literal value representing the number 10.
 The 16 bits labeled B contain the second sub-packet, a literal value representing the number 20.
 After reading 11 and 16 bits of sub-packet data, the total length indicated in L (27) is reached, and so parsing of this packet stops.
 
 As another example, here is an operator packet (hexadecimal string EE00D40C823060) with length type ID 1 that contains three sub-packets:
 
 11101110000000001101010000001100100000100011000001100000
 VVVTTTILLLLLLLLLLLAAAAAAAAAAABBBBBBBBBBBCCCCCCCCCCC
 The three bits labeled V (111) are the packet version, 7.
 The three bits labeled T (011) are the packet type ID, 3, which means the packet is an operator.
 The bit labeled I (1) is the length type ID, which indicates that the length is a 11-bit number representing the number of sub-packets.
 The 11 bits labeled L (00000000011) contain the number of sub-packets, 3.
 The 11 bits labeled A contain the first sub-packet, a literal value representing the number 1.
 The 11 bits labeled B contain the second sub-packet, a literal value representing the number 2.
 The 11 bits labeled C contain the third sub-packet, a literal value representing the number 3.
 After reading 3 complete sub-packets, the number of sub-packets indicated in L (3) is reached, and so parsing of this packet stops.
 
 For now, parse the hierarchy of the packets throughout the transmission and add up all of the version numbers.
 
 Here are a few more examples of hexadecimal-encoded transmissions:
 
 8A004A801A8002F478 represents an operator packet (version 4) which contains an operator packet (version 1) which contains an operator packet (version 5) which contains a literal value (version 6); this packet has a version sum of 16.
 620080001611562C8802118E34 represents an operator packet (version 3) which contains two sub-packets; each sub-packet is an operator packet that contains two literal values. This packet has a version sum of 12.
 C0015000016115A2E0802F182340 has the same structure as the previous example, but the outermost packet uses a different length type ID. This packet has a version sum of 23.
 A0016C880162017C3686B18A3D4780 is an operator packet that contains an operator packet that contains an operator packet that contains five literal values; it has a version sum of 31.
 Decode the structure of your hexadecimal-encoded BITS transmission; what do you get if you add up the version numbers in all packets?
 */

enum ParsingError: Error {
  case invalidDigit(_ raw: Character)
  case invalidPacketHeader
  case invalidVersion(_ raw: UInt8)
  case invalidTypeID(_ raw: UInt8)
  case brokenLiteralPacket
  case brokenOperatorPacket
}

struct BitQueue {
  var data: [HexDigit]
  var bitOffset: Int
  
  init(from: String) throws {
    self.bitOffset = 0
    self.data = try from.map {
      guard let digit = HexDigit($0) else {
        throw ParsingError.invalidDigit($0)
      }
      return digit
    }
  }
  
  func peek(_ k: Int = 1) -> UInt64? {
    precondition(k > 0)
    precondition(k <= MemoryLayout<UInt64>.size * 8)
    
    let nibbleSize = 4
    var res: UInt64 = 0x0
    
    var current = bitOffset
    while current - bitOffset < k {
      let blockOffset = current / nibbleSize
      let bitIndex = current % nibbleSize
      
      guard blockOffset < data.count else { return nil }
      
      let block = data[blockOffset]
      
      // extract bits from block (at most k)
      let bitsToRead = min(nibbleSize - bitIndex, k - (current - bitOffset))
      let mask = (UInt64(0x1) << (nibbleSize - bitIndex)) - 1
      let shift = max(0, nibbleSize - bitsToRead - bitIndex)
      let bits = (UInt64(block.value) & mask) >> shift
      
      // append to output
      res <<= bitsToRead
      res |= bits
      
      // update internal pointer
      current += bitsToRead
    }
    
    return res
  }
  
  // read the next (at most 64) bits
  mutating func pop(_ k: Int = 1) -> UInt64? {
    precondition(k > 0)
    precondition(k <= MemoryLayout<UInt64>.size * 8)
    
    guard let res = peek(k) else { return nil }
    
    bitOffset += k
    return res
  }
  
  struct HexDigit {
    var value: UInt8
    
    init?(_ char: Character) {
      guard let val = UInt8("\(char)", radix: 16) else {
        return nil
      }
      
      self.value = val
    }
  }
}

enum Version: UInt8 { 
  case zero  = 0b000
  case one   = 0b001
  case two   = 0b010
  case three = 0b011
  case four  = 0b100
  case five  = 0b101
  case six   = 0b110
  case seven = 0b111
}
enum TypeID: UInt8 {
  case literal = 0b0100
  
  case operator0 = 0b0000
  case operator1 = 0b0001
  case operator2 = 0b0010
  case operator3 = 0b0011
  case operator5 = 0b0101
  case operator6 = 0b0110
  case operator7 = 0b0111
}

protocol Packet {
  var version: Version { get }
  
  var versionSum: UInt { get }
  
  init(version: Version, typeID: TypeID, bits: inout BitQueue) throws
}

struct LiteralValue: Packet {
  var version: Version
  var value: UInt64
  
  var versionSum: UInt { UInt(version.rawValue) }
  
  init(version: Version, typeID: TypeID, bits: inout BitQueue) throws {
    self.version = version
    self.value = 0
    
    var flag: UInt64 = 0x0
    let nibbleSize = 4
    repeat {
      guard let f = bits.pop(), let n = bits.pop(nibbleSize) else { throw ParsingError.brokenLiteralPacket }
      flag = f
      
      self.value <<= nibbleSize
      self.value |= n
    } while flag != 0x0
  }
}

extension LiteralValue: CustomStringConvertible {
  var description: String {
    "Literal<\(value)> (v: \(version.rawValue))"
  }
}

struct Operator: Packet {
  var version: Version
  var sub: [Packet]
  // var operation: Operation
  
  var versionSum: UInt {
    UInt(version.rawValue) + sub.reduce(0) { $0 + $1.versionSum }
  }
  
  init(version: Version, typeID: TypeID, bits: inout BitQueue) throws {
    self.version = version
    self.sub = []
    
    guard let bit = bits.pop(), let lengthTypeId = LengthTypeID(rawValue: .init(bit)) else {
      throw ParsingError.brokenOperatorPacket
    }
    
    switch lengthTypeId {
    case .totalLength:
      guard let totalLength = bits.pop(15) else { throw ParsingError.brokenOperatorPacket }
      
      let start = bits.bitOffset
      while bits.bitOffset - start < totalLength {
        sub.append(try Parser.parseNext(bits: &bits))
      }
      
      guard bits.bitOffset - start == totalLength else { throw ParsingError.brokenOperatorPacket }
    case .subPacketCount:
      guard let subPackets = bits.pop(11) else { throw ParsingError.brokenOperatorPacket }
      sub = try (0..<subPackets).map { _ in try Parser.parseNext(bits: &bits) }
    }
  }
  
  enum LengthTypeID: UInt8 {
    case totalLength = 0b0
    case subPacketCount = 0b1
  }
}

extension Operator: CustomStringConvertible {
  var description: String {
    "Operator<?> (v: \(version.rawValue), sum: \(versionSum))\n"
    + sub.map { "  \($0)".replacingOccurrences(of: "\n", with: "\n  ") }.joined(separator: "\n")
  }
}

struct Parser {
  private init() {}
  
  static func parseNext(bits: inout BitQueue) throws -> Packet {
    guard let versionRaw = bits.pop(3), let typeIDRaw = bits.pop(3) else {
      throw ParsingError.invalidPacketHeader
    }
    guard let version = Version(rawValue: UInt8(versionRaw)) else {
      throw ParsingError.invalidVersion(.init(versionRaw))
    }
    guard let typeID = TypeID(rawValue: UInt8(typeIDRaw)) else {
      throw ParsingError.invalidTypeID(.init(typeIDRaw))
    }
    
    switch typeID {
    case .literal:
      return try LiteralValue(version: version, typeID: typeID, bits: &bits)
    default:
      return try Operator(version: version, typeID: typeID, bits: &bits)
    }
  }
  
  static func parse(hexString: String) throws -> Packet {
    var bits = try BitQueue(from: hexString)
    return try parseNext(bits: &bits)
  }
}

let testInput1 = "D2FE28"
let testInput2 = "38006F45291200"
let testInput3 = "EE00D40C823060"
let testInput4 = "8A004A801A8002F478"
let testInput5 = "620080001611562C8802118E34"
let testInput6 = "C0015000016115A2E0802F182340"
let testInput7 = "A0016C880162017C3686B18A3D4780"

let input = "020D790050D26C13EC1348326D336ACE00EC299E6A8B929ED59C880502E00A526B969F62BF35CB4FB15B93A6311F67F813300470037500043E2D4218FA000864538E905A39CAF77386E35AB01802FC01BA00021118617C1F00043A3F4748A53CF66008D00481272D73308334EDB0ED304E200D4E94CF612A49B40036C98A7CF24A53CA94C6370FBDCC9018029600ACD529CA9A4F62ACD2B5F928802F0D2665CA7D6CC013919E78A3800D3CF7794A8FC938280473057394AFF15099BA23CDD37A08400E2A5F7297F916C9F97F82D2DFA734BC600D4E3BC89CCBABCBE2B77D200412599244D4C0138C780120CC67E9D351C5AB4E1D4C981802980080CDB84E034C5767C60124F3BC984CD1E479201232C016100662D45089A00087C1084F12A724752BEFEA9C51500566759BF9BE6C5080217910CD00525B6350E8C00E9272200DCE4EF4C1DD003952F7059BCF675443005680103976997699795E830C02E4CBCE72EFC6A6218C88C9DF2F3351FCEF2D83CADB779F59A052801F2BAACDAE7F52A8190073937FE1D700439234DBB4F7374DC0CC804CF1006A0D47B8A4200F445865170401F8251662D100909401AB8803313217C680004320D43F871308D140C010E0069E7EDD1796AFC8255800052E20043E0F42A8B6400864258E51088010B85910A0F4ECE1DFE069C0229AE63D0B8DC6F82529403203305C00E1002C80AF5602908400A20240100852401E98400830021400D30029004B6100294008400B9D0023240061C000D19CACCD9005F694AEF6493D3F9948DEB3B4CC273FFD5E9AD85CFDFF6978B80050392AC3D98D796449BE304FE7F0C13CD716656BD0A6002A67E61A400F6E8029300B300B11480463D004C401889B1CA31800211162204679621200FCAC01791CF6B1AFCF2473DAC6BF3A9F1700016A3D90064D359B35D003430727A7DC464E6401594A57C93A0084CC56A662B8C00AA424989F2A9112"

let p1 = try Parser.parse(hexString: testInput1)
let p2 = try Parser.parse(hexString: testInput2)
let p3 = try Parser.parse(hexString: testInput3)
let p4 = try Parser.parse(hexString: testInput4)
let p5 = try Parser.parse(hexString: testInput5)
let p6 = try Parser.parse(hexString: testInput6)
let p7 = try Parser.parse(hexString: testInput7)

print("part 1:")
print(p4.versionSum)
print(p5.versionSum)
print(p6.versionSum)
print(p7.versionSum)

let p = try Parser.parse(hexString: input)
print(p.versionSum)
