import Foundation
import DequeModule

/*
 --- Day 19: Beacon Scanner ---
 
 As your probe drifted down through this area, it released an assortment of beacons and scanners into the water. It's difficult to navigate in the pitch black open waters of the ocean trench, but if you can build a map of the trench using data from the scanners, you should be able to safely reach the bottom.
 
 The beacons and scanners float motionless in the water; they're designed to maintain the same position for long periods of time. Each scanner is capable of detecting all beacons in a large cube centered on the scanner; beacons that are at most 1000 units away from the scanner in each of the three axes (x, y, and z) have their precise position determined relative to the scanner. However, scanners cannot detect other scanners. The submarine has automatically summarized the relative positions of beacons detected by each scanner (your puzzle input).
 
 For example, if a scanner is at x,y,z coordinates 500,0,-500 and there are beacons at -500,1000,-1500 and 1501,0,-500, the scanner could report that the first beacon is at -1000,1000,-1000 (relative to the scanner) but would not detect the second beacon at all.
 
 Unfortunately, while each scanner can report the positions of all detected beacons relative to itself, the scanners do not know their own position. You'll need to determine the positions of the beacons and scanners yourself.
 
 The scanners and beacons map a single contiguous 3d region. This region can be reconstructed by finding pairs of scanners that have overlapping detection regions such that there are at least 12 beacons that both scanners detect within the overlap. By establishing 12 common beacons, you can precisely determine where the scanners are relative to each other, allowing you to reconstruct the beacon map one scanner at a time.
 
 For a moment, consider only two dimensions. Suppose you have the following scanner reports:
 
 --- scanner 0 ---
 0,2
 4,1
 3,3
 
 --- scanner 1 ---
 -1,-1
 -5,0
 -2,1
 Drawing x increasing rightward, y increasing upward, scanners as S, and beacons as B, scanner 0 detects this:
 
 ...B.
 B....
 ....B
 S....
 Scanner 1 detects this:
 
 ...B..
 B....S
 ....B.
 For this example, assume scanners only need 3 overlapping beacons. Then, the beacons visible to both scanners overlap to produce the following complete map:
 
 ...B..
 B....S
 ....B.
 S.....
 Unfortunately, there's a second problem: the scanners also don't know their rotation or facing direction. Due to magnetic alignment, each scanner is rotated some integer number of 90-degree turns around all of the x, y, and z axes. That is, one scanner might call a direction positive x, while another scanner might call that direction negative y. Or, two scanners might agree on which direction is positive x, but one scanner might be upside-down from the perspective of the other scanner. In total, each scanner could be in any of 24 different orientations: facing positive or negative x, y, or z, and considering any of four directions "up" from that facing.
 
 For example, here is an arrangement of beacons as seen from a scanner in the same position but in different orientations:
 
 --- scanner 0 ---
 -1,-1,1
 -2,-2,2
 -3,-3,3
 -2,-3,1
 5,6,-4
 8,0,7
 
 --- scanner 0 ---
 1,-1,1
 2,-2,2
 3,-3,3
 2,-1,3
 -5,4,-6
 -8,-7,0
 
 --- scanner 0 ---
 -1,-1,-1
 -2,-2,-2
 -3,-3,-3
 -1,-3,-2
 4,6,5
 -7,0,8
 
 --- scanner 0 ---
 1,1,-1
 2,2,-2
 3,3,-3
 1,3,-2
 -4,-6,5
 7,0,8
 
 --- scanner 0 ---
 1,1,1
 2,2,2
 3,3,3
 3,1,2
 -6,-4,-5
 0,7,-8
 By finding pairs of scanners that both see at least 12 of the same beacons, you can assemble the entire map. For example, consider the following report:
 
 --- scanner 0 ---
 404,-588,-901
 528,-643,409
 -838,591,734
 390,-675,-793
 -537,-823,-458
 -485,-357,347
 -345,-311,381
 -661,-816,-575
 -876,649,763
 -618,-824,-621
 553,345,-567
 474,580,667
 -447,-329,318
 -584,868,-557
 544,-627,-890
 564,392,-477
 455,729,728
 -892,524,684
 -689,845,-530
 423,-701,434
 7,-33,-71
 630,319,-379
 443,580,662
 -789,900,-551
 459,-707,401
 
 --- scanner 1 ---
 686,422,578
 605,423,415
 515,917,-361
 -336,658,858
 95,138,22
 -476,619,847
 -340,-569,-846
 567,-361,727
 -460,603,-452
 669,-402,600
 729,430,532
 -500,-761,534
 -322,571,750
 -466,-666,-811
 -429,-592,574
 -355,545,-477
 703,-491,-529
 -328,-685,520
 413,935,-424
 -391,539,-444
 586,-435,557
 -364,-763,-893
 807,-499,-711
 755,-354,-619
 553,889,-390
 
 --- scanner 2 ---
 649,640,665
 682,-795,504
 -784,533,-524
 -644,584,-595
 -588,-843,648
 -30,6,44
 -674,560,763
 500,723,-460
 609,671,-379
 -555,-800,653
 -675,-892,-343
 697,-426,-610
 578,704,681
 493,664,-388
 -671,-858,530
 -667,343,800
 571,-461,-707
 -138,-166,112
 -889,563,-600
 646,-828,498
 640,759,510
 -630,509,768
 -681,-892,-333
 673,-379,-804
 -742,-814,-386
 577,-820,562
 
 --- scanner 3 ---
 -589,542,597
 605,-692,669
 -500,565,-823
 -660,373,557
 -458,-679,-417
 -488,449,543
 -626,468,-788
 338,-750,-386
 528,-832,-391
 562,-778,733
 -938,-730,414
 543,643,-506
 -524,371,-870
 407,773,750
 -104,29,83
 378,-903,-323
 -778,-728,485
 426,699,580
 -438,-605,-362
 -469,-447,-387
 509,732,623
 647,635,-688
 -868,-804,481
 614,-800,639
 595,780,-596
 
 --- scanner 4 ---
 727,592,562
 -293,-554,779
 441,611,-461
 -714,465,-776
 -743,427,-804
 -660,-479,-426
 832,-632,460
 927,-485,-438
 408,393,-506
 466,436,-512
 110,16,151
 -258,-428,682
 -393,719,612
 -211,-452,876
 808,-476,-593
 -575,615,604
 -485,667,467
 -680,325,-822
 -627,-443,-432
 872,-547,-609
 833,512,582
 807,604,487
 839,-516,451
 891,-625,532
 -652,-548,-490
 30,-46,-14
 Because all coordinates are relative, in this example, all "absolute" positions will be expressed relative to scanner 0 (using the orientation of scanner 0 and as if scanner 0 is at coordinates 0,0,0).
 
 Scanners 0 and 1 have overlapping detection cubes; the 12 beacons they both detect (relative to scanner 0) are at the following coordinates:
 
 -618,-824,-621
 -537,-823,-458
 -447,-329,318
 404,-588,-901
 544,-627,-890
 528,-643,409
 -661,-816,-575
 390,-675,-793
 423,-701,434
 -345,-311,381
 459,-707,401
 -485,-357,347
 These same 12 beacons (in the same order) but from the perspective of scanner 1 are:
 
 686,422,578
 605,423,415
 515,917,-361
 -336,658,858
 -476,619,847
 -460,603,-452
 729,430,532
 -322,571,750
 -355,545,-477
 413,935,-424
 -391,539,-444
 553,889,-390
 Because of this, scanner 1 must be at 68,-1246,-43 (relative to scanner 0).
 
 Scanner 4 overlaps with scanner 1; the 12 beacons they both detect (relative to scanner 0) are:
 
 459,-707,401
 -739,-1745,668
 -485,-357,347
 432,-2009,850
 528,-643,409
 423,-701,434
 -345,-311,381
 408,-1815,803
 534,-1912,768
 -687,-1600,576
 -447,-329,318
 -635,-1737,486
 So, scanner 4 is at -20,-1133,1061 (relative to scanner 0).
 
 Following this process, scanner 2 must be at 1105,-1205,1229 (relative to scanner 0) and scanner 3 must be at -92,-2380,-20 (relative to scanner 0).
 
 The full list of beacons (relative to scanner 0) is:
 
 -892,524,684
 -876,649,763
 -838,591,734
 -789,900,-551
 -739,-1745,668
 -706,-3180,-659
 -697,-3072,-689
 -689,845,-530
 -687,-1600,576
 -661,-816,-575
 -654,-3158,-753
 -635,-1737,486
 -631,-672,1502
 -624,-1620,1868
 -620,-3212,371
 -618,-824,-621
 -612,-1695,1788
 -601,-1648,-643
 -584,868,-557
 -537,-823,-458
 -532,-1715,1894
 -518,-1681,-600
 -499,-1607,-770
 -485,-357,347
 -470,-3283,303
 -456,-621,1527
 -447,-329,318
 -430,-3130,366
 -413,-627,1469
 -345,-311,381
 -36,-1284,1171
 -27,-1108,-65
 7,-33,-71
 12,-2351,-103
 26,-1119,1091
 346,-2985,342
 366,-3059,397
 377,-2827,367
 390,-675,-793
 396,-1931,-563
 404,-588,-901
 408,-1815,803
 423,-701,434
 432,-2009,850
 443,580,662
 455,729,728
 456,-540,1869
 459,-707,401
 465,-695,1988
 474,580,667
 496,-1584,1900
 497,-1838,-617
 527,-524,1933
 528,-643,409
 534,-1912,768
 544,-627,-890
 553,345,-567
 564,392,-477
 568,-2007,-577
 605,-1665,1952
 612,-1593,1893
 630,319,-379
 686,-3108,-505
 776,-3184,-501
 846,-3110,-434
 1135,-1161,1235
 1243,-1093,1063
 1660,-552,429
 1693,-557,386
 1735,-437,1738
 1749,-1800,1813
 1772,-405,1572
 1776,-675,371
 1779,-442,1789
 1780,-1548,337
 1786,-1538,337
 1847,-1591,415
 1889,-1729,1762
 1994,-1805,1792
 In total, there are 79 beacons.
 
 Assemble the full map of beacons. How many beacons are there?
 */

enum ParsingError: Error {
  case invalidScanner(_ raw: String)
  case invalidBeacon(_ raw: String)
  case invalidInput
}

enum Axis: CaseIterable, CustomStringConvertible {
  case x
  case y
  case z
  
  var description: String {
    switch self {
    case .x: return "x"
    case .y: return "y"
    case .z: return "z"
    }
  }
}

struct Vector {
  var x: Int
  var y: Int
  var z: Int
  
  func cross(_ other: Vector) -> Vector {
    .init(
      x: y*other.z - z*other.y,
      y: z*other.x - x*other.z,
      z: x*other.y - y*other.x
    )
  }
}

struct DirectedAxis: Hashable, CustomStringConvertible {
  var positive: Bool
  var axis: Axis
  
  var vector: Vector {
    .init(
      x: (positive ? 1 : -1) * (axis == .x ? 1 : 0),
      y: (positive ? 1 : -1) * (axis == .y ? 1 : 0),
      z: (positive ? 1 : -1) * (axis == .z ? 1 : 0)
    )
  }
  
  var description: String {
    "\(positive ? " " : "-")\(axis)"
  }
  
  init(positive: Bool, axis: Axis) {
    self.positive = positive
    self.axis = axis
  }
  
  
  init(_ vector: Vector) {
    precondition(
      (vector.x != 0 && vector.y == 0 && vector.z == 0)
      || (vector.x == 0 && vector.y != 0 && vector.z == 0)
      || (vector.x == 0 && vector.y == 0 && vector.z != 0)
    )
    
    self.positive = vector.x + vector.y + vector.z > 0
    self.axis = vector.x != 0
    ? .x
    : vector.y != 0 ? .y
    : .z
  }
  
  func component(_ coord: Coordinate) -> Int {
    var res = coord.a
    switch axis {
    case .y: res = coord.b
    case .z: res = coord.c
    default:
      break
    }
    
    return positive ? res : -res
  }
}

struct Orientation: Hashable, CustomStringConvertible {
  var up: DirectedAxis
  var forward: DirectedAxis
  
  var right: DirectedAxis {
    // forward is determined by right and up
    .init(up.vector.cross(forward.vector))
  }
  
  private init(up: DirectedAxis, forward: DirectedAxis) {
    self.up = up
    self.forward = forward
    
    // expect -y as right axis
    assert(up.axis != right.axis && up.axis != right.axis)
  }
  
  var description: String {
    "\(right):\(up):\(forward)"
  }
  
  public static let allPossible: [Orientation] = {
    (Axis.allCases).flatMap { up in
      (Axis.allCases).flatMap { right -> [Orientation] in
        if up == right { return [] }
        
        return [
          Orientation(up: .init(positive: false, axis: up), forward: .init(positive: false, axis: right)),
          Orientation(up: .init(positive: false, axis: up), forward: .init(positive: true, axis: right)),
          Orientation(up: .init(positive: true, axis: up), forward: .init(positive: false, axis: right)),
          Orientation(up: .init(positive: true, axis: up), forward: .init(positive: true, axis: right)),
        ]
      }
    }
  }()
  
  func transform(_ coordinate: Coordinate) -> Coordinate {
    .init(
      a: right.component(coordinate),
      b: up.component(coordinate),
      c: forward.component(coordinate)
    )
  }
}

struct Coordinate: Hashable, CustomStringConvertible {
  var a: Int
  var b: Int
  var c: Int
  
  var description: String {
    "(\(a), \(b), \(c))"
  }
  
  var absolute: Coordinate {
    .init(a: abs(a), b: abs(b), c: abs(c))
  }
  
  static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
    .init(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c)
  }
  
  static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
    .init(a: lhs.a - rhs.a, b: lhs.b - rhs.b, c: lhs.c - rhs.c)
  }
  
  static func <=<I: SignedInteger>(lhs: Coordinate, rhs: I) -> Bool {
    lhs.a <= rhs && lhs.b <= rhs && lhs.c <= rhs
  }
}

struct Beacon: Hashable {
  /// relative position to scanner in unknown rotation
  var pos: Coordinate
  
  init(pos: Coordinate) {
    self.pos = pos
  }
  
  init(from: Substring) throws {
    let raw = from.split(separator: ",")
    guard raw.count == 3,
          let a = Int(raw[0]),
          let b = Int(raw[1]),
          let c = Int(raw[2])
    else { throw ParsingError.invalidBeacon(.init(from))}
    
    self.pos = .init(a: a, b: b, c: c)
  }
}

struct Scanner: Hashable {
  var id: UInt
  var globalOffset = Coordinate(a: 0, b: 0, c: 0)
  var beacons: Set<Beacon>
  
  private init(id: UInt, beacons: Set<Beacon>, globalOffset: Coordinate) {
    self.id = id
    self.beacons = beacons
    self.globalOffset = globalOffset
  }
  
  init(description: String) throws {
    let raw = description.split(separator: "\n")
    guard !raw.isEmpty, let idRaw = raw.first?.split(separator: " "), idRaw.count == 4, let id = UInt(idRaw[2]) else {
      throw ParsingError.invalidScanner(description)
    }
    
    self.id = id
    self.beacons = .init(
      try raw.dropFirst().map {
        try Beacon(from: $0)
      }
    )
  }
  
  /**
   Attempts to localize `other` given this scanner's frame of reference.
   
   - returns a `other` scanner with correct `globalOffset` and beacons rotated 'right side up' according to self,
      i.e., aligned with orientation of self
   */
  func localize(_ other: Scanner) -> Scanner? {
    // Assert that we are right side up. For each possible `orientation`:
    for orientation in Orientation.allPossible {
      // Assert that transforming `other` using `orientation` yields aligned orientation.
      // TODO: we should maybe cache this depending on overall runtime
      let otherRotated = other.beacons.map { Beacon(pos: orientation.transform($0.pos)) }
      
      for otherBeacon in otherRotated {
        // Test each of our beacons, i.e.:
        for beacon in beacons {
          // Assume 'otherBeacon' and currently tested beacon are aligned.
          // Compute offset of other scanner in our coordinate system
          let otherOffset = beacon.pos - otherBeacon.pos
          
          // Compute offset transform (our scanner vs other scanner)
          let otherTransformed = Set(otherRotated.map { Beacon(pos: $0.pos + otherOffset) })

          // Find 12 matches or a single missmatch
          var visibleCount = 0
          for b in beacons {
            let relToOther = b.pos - otherOffset
            if relToOther.absolute <= 1000 {
              if otherTransformed.contains(b) {
                visibleCount += 1
                if visibleCount >= 12 {
                  return .init(id: other.id, beacons: Set(otherRotated), globalOffset: otherOffset + globalOffset)
                }
              } else {
                break
              }
            }
          }
        }
      }
    }

    return nil
  }
}

func parse(description: String) throws -> [Scanner] {
  let raw = description
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .split(separator: "\n", omittingEmptySubsequences: false)
  let ends = [0] + raw.enumerated().compactMap {
    $1.isEmpty ? $0 : nil
  } + [raw.count]
  guard ends.count > 1 else { throw ParsingError.invalidInput }
  
  return try (1..<ends.count).map { i in
    let str = raw[ends[i-1]..<ends[i]].joined(separator: "\n")
    return try Scanner(description: str)
  }
}

struct Map {
  var locatedScanners = Set<Scanner>()
  var uniqueBeacons: Set<Beacon> {
    locatedScanners.reduce(into: []) { aggr, scanner in
      scanner.beacons.forEach { b in
        aggr.insert(.init(pos: b.pos + scanner.globalOffset))
      }
    }
  }
  
  init(fromScannersDescription scannersDescription: String) throws {
    let scanners = try parse(description: scannersDescription)
    guard !scanners.isEmpty, let s0 = scanners.first(where: { $0.id == 0 }) else { return }
    
    // fix s0 as reference point
    locatedScanners.insert(s0)

    // for each work item, try matching the remaining, yet unlocated scanners.
    // Upon localization, add as work item and
    var workList = Deque([s0])
    var unlocalized = Set(scanners).subtracting(locatedScanners)
    while locatedScanners.count < scanners.count {
      guard let scanner = workList.popFirst() else { throw MappingError.insufficientInfo }
      
      // attempt to match remaining
      unlocalized.forEach { s in
        if let localized = scanner.localize(s) {
          locatedScanners.insert(localized)
          unlocalized.remove(s)
          workList.append(localized)
        }
      }
    }
  }
  
  enum MappingError: Error {
    case insufficientInfo
  }
}

let testInput = """
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
"""

let testScanners = try parse(description: testInput)

let testOverlap0_1 = testScanners[0].localize(testScanners[1])
assert(testOverlap0_1 != nil)
assert(testOverlap0_1?.globalOffset == .init(a: 68, b: -1246, c: -43))

let testOverlap1_4 = testOverlap0_1?.localize(testScanners[4])
assert(testOverlap1_4 != nil)
assert(testOverlap1_4?.globalOffset == .init(a: -20, b: -1133, c: 1061))

let testMap = try Map(fromScannersDescription: testInput)
let expectedMapping: [UInt: Coordinate] = [
  0: .init(a: 0, b: 0, c: 0),
  1: .init(a: 68, b: -1246, c: -43),
  2: .init(a: 1105, b: -1205, c: 1229),
  3: .init(a: -92, b: -2380, c: -20),
  4: .init(a: -20, b: -1133, c: 1061)
]

assert(testMap.locatedScanners.allSatisfy { expectedMapping[$0.id] == $0.globalOffset })
assert(testMap.uniqueBeacons.count == 79)

let input = """
--- scanner 0 ---
-812,-728,-591
-259,678,-532
735,-470,492
-808,-734,-657
518,-635,-807
-487,402,391
722,545,-708
-529,-401,536
-326,616,-504
-330,707,-663
878,574,-722
670,-614,-747
533,-501,495
-508,406,332
-797,-541,-583
114,15,-132
-522,-438,589
587,-480,480
-639,-447,471
687,564,-674
896,574,424
-449,386,511
652,-513,-789
819,586,254
836,538,409

--- scanner 1 ---
670,487,-847
-432,537,-395
-521,374,359
-666,441,313
740,701,863
-432,701,-383
721,-698,-623
818,605,871
-282,-564,-496
766,577,737
-375,-596,-489
-433,-537,-427
745,-562,-653
650,-523,785
24,36,8
608,-417,733
-386,-616,490
453,-460,776
745,-802,-648
-454,633,-472
-403,-500,596
693,557,-710
669,547,-874
-462,-478,508
-529,539,346

--- scanner 2 ---
-566,-825,-742
-662,-843,343
640,-448,544
-593,-867,362
-570,753,323
-17,-6,-139
757,831,503
525,605,-563
-549,694,319
-591,549,-484
763,-859,-617
471,590,-584
673,593,-553
-701,614,-530
-458,-744,-723
-511,574,303
-658,-773,306
554,-488,396
-584,496,-521
646,-875,-525
-522,-801,-721
834,661,491
620,-847,-523
774,676,455
535,-509,628

--- scanner 3 ---
-407,-676,-904
734,-560,435
-693,-416,552
399,882,-572
548,-513,-819
11,183,-89
519,898,-534
432,710,811
-700,739,637
-703,-449,648
-496,668,-411
-469,-604,-856
597,-462,-696
-524,606,-344
-738,-466,683
386,-489,-727
690,-596,610
-407,-650,-695
262,698,734
-151,184,58
-714,710,793
-666,720,602
340,878,-593
-655,577,-415
417,746,751
-173,51,-105
711,-649,610

--- scanner 4 ---
-685,686,-551
-793,-850,-533
506,696,563
527,750,548
-601,581,-490
-402,-590,371
-841,-861,-490
800,-826,791
830,-666,749
892,-712,744
-418,-589,365
466,601,-889
-489,-491,464
679,-648,-544
-24,2,-135
496,548,551
765,-778,-494
745,-758,-567
-453,667,-530
-548,387,619
-512,447,634
-683,-770,-496
-560,464,789
468,575,-917
560,458,-901

--- scanner 5 ---
732,615,-695
-377,610,685
-495,-902,-457
-505,433,-576
759,628,545
-517,-805,-466
-580,496,-693
665,747,-728
857,-888,591
177,-41,-4
-459,-809,-623
-337,660,590
485,-555,-387
849,-900,646
-644,-838,551
-614,-772,389
785,-859,453
685,-519,-419
613,-405,-367
877,738,569
-460,592,573
-512,326,-661
726,794,-640
864,609,696
-542,-810,573

--- scanner 6 ---
368,683,-372
-857,-729,708
457,760,741
-3,99,-25
545,663,-382
480,897,862
-905,509,-355
-916,663,-479
-906,-735,758
422,-243,537
606,-464,-412
441,812,817
273,-327,570
-562,815,894
-798,-679,712
-905,559,-596
-540,877,853
-737,-434,-303
439,538,-369
-181,108,134
-679,818,855
-740,-438,-319
-794,-617,-290
695,-432,-474
369,-298,651
574,-454,-602

--- scanner 7 ---
-709,-537,525
599,400,517
663,-549,-537
673,-739,-569
-701,443,-586
89,-29,-107
-634,281,431
-730,-492,-645
695,-611,-448
-777,425,-724
-105,-82,14
-788,-554,-704
496,-458,611
-731,-460,429
418,-461,417
-497,248,333
598,545,385
492,501,528
800,433,-870
-881,-561,-672
884,400,-721
829,514,-774
-642,294,266
362,-418,539
-731,-448,593
-760,531,-608

--- scanner 8 ---
868,710,-814
690,-331,685
565,-365,-644
-685,583,-647
-697,-418,-635
-349,-747,573
-493,633,703
586,-389,-600
773,450,395
-744,575,-732
9,-31,-170
-518,485,615
801,717,-874
784,-343,542
782,-315,568
-818,-396,-542
-517,527,665
729,413,317
-465,-739,603
-770,385,-662
88,113,15
584,-446,-536
-315,-721,499
-829,-468,-584
901,814,-873
680,344,371

--- scanner 9 ---
-653,928,-587
346,683,280
358,723,474
480,663,-657
620,-449,-847
396,-500,338
590,-425,-711
-590,784,464
-363,-702,598
375,797,-631
433,643,397
-56,55,-65
-695,917,-515
-701,-485,-565
-575,869,266
-423,-769,591
-505,843,456
-364,-802,695
104,143,-139
369,-501,398
533,-477,408
595,-425,-951
-637,-487,-508
-602,796,-537
396,701,-702
-593,-466,-484

--- scanner 10 ---
756,-811,536
-758,-858,-662
739,715,624
806,663,-794
-652,507,398
667,-661,-781
743,656,645
725,-602,-719
756,812,-753
818,-634,-712
759,536,683
-107,-5,-89
-726,-769,-724
-601,458,521
803,740,-620
-628,669,490
-692,-753,567
-573,631,-846
39,-141,-38
-736,-737,-534
-756,574,-833
-795,-724,606
-638,-667,644
700,-905,601
-752,577,-817
719,-881,532

--- scanner 11 ---
613,-415,-869
445,-621,752
634,-608,-805
372,329,-516
-678,-535,350
-108,-6,-44
366,608,735
-754,574,571
-410,-728,-442
424,549,797
-754,814,576
391,305,-585
-477,-735,-382
-694,428,-720
423,-525,829
-377,-832,-383
273,576,728
-702,-545,514
-730,710,601
335,399,-520
619,-438,-850
-679,-475,377
-141,-123,113
423,-689,841
-692,371,-656
-713,347,-612

--- scanner 12 ---
505,-657,846
-749,-804,321
-402,829,-859
-697,-747,-878
-40,16,-16
6,-145,-110
-736,362,736
430,-544,830
-695,382,662
551,368,-797
396,305,-817
392,-594,853
-692,-755,-648
-659,-810,-829
326,-775,-453
674,256,394
-430,828,-824
-461,791,-808
601,418,407
-608,-913,341
390,-836,-416
378,-759,-593
478,378,-719
-664,-796,330
-723,300,759
719,347,368

--- scanner 13 ---
-683,-433,912
-412,754,548
875,592,853
632,746,-671
-762,-449,-503
-404,724,432
644,598,-661
-786,-493,-482
-430,650,398
-808,693,-701
-755,-391,901
535,-511,-703
872,-418,739
-820,836,-607
-733,-484,780
629,544,-640
29,142,144
720,-392,823
86,15,19
-836,719,-699
776,-433,907
653,-628,-694
-705,-385,-501
785,426,889
588,-518,-740
907,419,813

--- scanner 14 ---
628,-598,-362
-516,-802,-652
686,-755,-366
-286,494,718
897,579,-580
-250,670,-377
-444,-854,-766
-349,-780,795
785,406,633
723,-849,884
165,-54,23
631,462,682
-370,-774,635
644,-742,800
551,427,609
760,-750,817
964,535,-476
-315,583,-430
-316,-834,-616
-258,493,644
664,-764,-269
-276,636,663
-421,632,-340
24,-5,137
-428,-673,723
854,601,-573

--- scanner 15 ---
-749,785,-618
417,-330,-362
-443,-804,-604
-753,865,-519
375,468,-886
-761,-303,467
-680,-231,339
641,-312,702
586,758,698
410,496,-885
-534,-806,-420
-319,870,752
405,725,753
-389,795,893
437,-485,-425
515,-412,-435
40,131,60
-418,-812,-408
426,527,-848
-287,937,853
818,-324,779
781,-260,718
-788,804,-653
356,763,690
-78,-6,-26
-617,-318,414

--- scanner 16 ---
-431,706,-288
-482,756,-420
756,435,-652
-431,-753,-293
-390,-697,-377
705,-334,838
421,-884,-387
-541,-560,789
-389,778,-299
-437,-612,830
133,-7,158
-480,-698,721
548,-356,897
654,534,888
726,427,-768
-526,459,526
636,632,763
45,93,2
538,505,792
682,-308,868
594,-852,-347
-428,368,530
652,453,-802
428,-762,-311
-632,372,515
-416,-849,-461

--- scanner 17 ---
613,752,-489
-669,-401,471
830,-871,458
465,-966,-607
633,-880,521
538,558,560
562,528,696
675,-828,415
-550,668,506
-638,-446,546
-459,-792,-782
543,-958,-703
-610,790,-625
-684,773,480
-19,-95,-128
614,779,-549
590,615,-559
-377,-719,-724
-530,715,-548
-637,-466,507
-570,802,-431
-588,752,551
538,553,800
-452,-883,-717
517,-832,-579

--- scanner 18 ---
-652,609,-485
-553,629,-400
-797,-625,803
742,693,613
-747,-626,845
-87,12,81
-449,621,917
-835,-601,697
682,760,620
16,-138,21
337,-818,-760
-608,761,-388
483,615,-340
489,-772,-735
-527,665,880
-661,-558,-657
352,675,-367
515,-793,747
530,-878,945
-773,-582,-587
600,-852,755
-710,-428,-598
741,793,516
378,-876,-798
-503,572,986
299,530,-336

--- scanner 19 ---
544,633,786
-897,723,-366
428,527,803
378,616,-803
704,-509,-669
-817,-377,895
-731,-354,-663
-894,-551,892
566,545,727
282,535,-774
-789,677,-422
583,-637,-647
-653,827,834
480,-459,907
-848,673,-372
-23,-27,114
-966,-418,845
615,-447,-637
507,-390,756
-785,-325,-484
448,-452,814
-590,914,909
-120,107,-57
431,502,-858
-509,842,781
-728,-338,-667

--- scanner 20 ---
468,632,619
-457,496,524
186,-93,14
-220,695,-807
769,-571,-448
766,-674,566
647,638,564
774,-341,-456
936,-606,598
-249,-766,-428
-445,-529,681
-573,-584,726
515,571,531
806,404,-253
-313,-803,-367
-301,-626,-444
736,-390,-393
829,-599,683
881,334,-394
-292,776,-679
0,27,-3
-610,-564,710
-307,632,-732
-461,437,474
948,302,-293
-411,388,468
117,78,152

--- scanner 21 ---
826,-509,-542
-398,-562,-530
51,60,-92
-421,734,361
-319,-733,428
808,-359,-646
-349,-606,427
752,461,756
775,527,646
-546,-537,-442
795,-572,422
834,-393,-572
-257,636,-774
-326,685,-828
-365,849,387
418,646,-460
825,441,776
-294,-548,435
-363,729,-750
879,-444,392
145,-98,74
849,-457,429
-440,-561,-480
-453,767,334
430,740,-603
402,738,-577

--- scanner 22 ---
-308,534,801
-633,-448,-329
-861,475,-605
345,-401,879
482,-523,877
-598,-646,511
-612,-389,-333
675,430,949
-7,103,77
-481,-528,520
877,402,-744
-671,-568,-313
898,564,-789
505,-336,806
670,428,929
-591,-593,474
765,-292,-316
842,447,-767
-790,606,-634
632,-364,-269
782,481,847
-312,600,807
-794,447,-543
806,-441,-266
-323,526,614

--- scanner 23 ---
496,-729,710
825,723,-386
-613,-891,470
557,406,738
-33,-165,-85
-666,-651,-848
-813,321,308
-751,428,-367
-644,-658,-805
-710,-755,-915
-814,466,-416
824,695,-421
-914,254,276
758,-857,-383
533,-814,583
-173,-2,-88
-575,-854,299
-759,433,-597
578,-771,-404
-662,-801,364
787,664,-437
579,-920,-389
592,387,777
-954,396,378
458,326,742
479,-829,713

--- scanner 24 ---
-369,-585,-682
-848,-535,620
-359,838,803
-367,813,607
532,547,-468
585,-256,525
652,908,492
590,-496,525
-796,-641,662
-434,-549,-650
-414,-510,-651
515,434,-573
-24,114,10
502,387,-427
805,-576,-697
560,-360,549
812,843,419
-365,722,791
675,721,421
700,-550,-563
-839,-598,817
-620,728,-861
784,-505,-601
-579,729,-733
-686,686,-703

--- scanner 25 ---
-634,465,-978
836,-736,352
-114,-56,-6
-557,844,715
443,386,-469
784,-720,492
684,417,618
772,-797,315
-355,-849,743
770,-555,-954
-641,-533,-791
657,-618,-947
766,344,716
-681,-571,-903
23,49,-124
488,295,-495
-334,-894,581
-736,-561,-685
732,-505,-931
-601,313,-932
-565,523,-890
-390,-872,698
-562,824,717
-450,742,664
561,457,-508
611,407,696

--- scanner 26 ---
-634,-845,-463
709,-612,-774
747,568,-391
779,368,-427
700,-634,-677
-638,367,-613
-549,-364,616
473,-697,624
526,609,922
-487,311,509
-346,381,584
-38,59,151
590,-622,561
505,-629,454
471,615,743
799,496,-277
543,-576,-681
438,548,875
-541,-594,621
14,-42,-3
-725,302,-666
-386,279,442
-687,473,-703
-486,-413,654
-656,-802,-470
-590,-912,-567

--- scanner 27 ---
942,-325,-622
653,572,551
852,-309,-551
-496,443,-571
562,392,-533
406,-302,686
-44,118,134
-492,627,839
73,75,-10
822,-297,-709
435,582,606
-775,-518,-455
-479,664,944
-648,443,-676
547,544,646
-400,-520,429
-503,375,-727
626,414,-598
-605,-531,-394
-492,620,722
360,-454,653
-689,-603,-505
448,-512,722
559,418,-683
-461,-522,488
-256,-497,436

--- scanner 28 ---
632,274,-680
367,-616,715
32,-122,-3
-833,742,839
808,-415,-420
838,541,794
834,632,635
-854,787,677
697,296,-616
-623,-630,-794
-547,426,-695
352,-803,707
-452,454,-589
905,603,766
-631,-951,811
-798,765,794
-587,-420,-836
-626,-931,813
356,-809,641
-554,-572,-882
-507,464,-807
721,-443,-300
650,-427,-390
-738,-849,760
782,300,-683

--- scanner 29 ---
650,-462,893
-474,-732,-757
696,-400,888
408,486,-380
632,-613,-400
762,-527,-350
-766,-765,692
-712,-786,707
-564,-796,695
44,-15,-7
-617,-826,-745
616,563,781
-556,423,-349
378,358,-296
810,-492,935
742,-547,-423
-660,273,-367
-586,307,-341
415,371,-326
-884,764,848
-591,-824,-773
-718,728,938
-91,-120,132
782,510,743
-891,688,970
706,715,738

--- scanner 30 ---
-413,599,524
-666,-613,-524
767,-832,-734
-675,-495,-641
65,-17,-99
929,795,-761
809,679,309
-307,-740,302
675,653,414
-5,49,68
580,-444,582
-454,826,-659
539,-284,612
-475,802,-703
940,723,-719
-380,-805,462
685,-331,599
-712,-548,-634
-309,-618,439
851,-680,-760
-437,463,554
808,773,-668
-413,359,529
713,608,330
-473,745,-767
935,-736,-719

--- scanner 31 ---
600,-425,411
-761,-790,-561
-437,353,-479
854,339,-706
-738,-719,-374
273,-408,-444
761,779,792
-573,-842,390
281,-604,-469
-898,-792,-439
-478,403,-330
773,702,615
767,414,-643
-401,854,409
782,467,-787
-345,876,526
755,-362,391
-611,356,-402
673,-435,489
825,718,755
-461,-760,443
-366,831,364
-40,-18,45
279,-420,-560
-568,-862,392

--- scanner 32 ---
375,548,-471
-561,629,-647
520,522,-443
-635,-398,564
424,-582,-461
-303,-450,-754
450,503,-445
585,584,438
-502,810,505
-492,619,553
-544,-394,723
-473,654,519
105,-30,-137
806,-876,570
-3,-96,14
613,-865,644
800,-880,636
-522,534,-587
707,450,420
412,-424,-491
-277,-600,-751
-299,-535,-687
-516,573,-732
-606,-327,695
686,602,480
440,-511,-371

--- scanner 33 ---
-772,-465,-547
-457,472,-525
-752,565,511
908,-813,712
681,286,606
-743,628,314
-563,588,-542
118,45,-42
447,-773,-433
-271,-783,524
23,-105,-104
656,390,582
-263,-808,328
748,-878,639
-475,610,-601
621,-850,-436
771,-691,710
-700,671,469
-844,-546,-419
529,524,-421
-757,-609,-494
-269,-692,340
522,492,-514
686,526,606
460,551,-572
488,-922,-483

--- scanner 34 ---
528,907,-644
219,-657,839
-670,-313,-652
677,-838,-586
-39,71,118
652,576,852
358,-618,879
-573,428,-654
-727,725,447
-676,-436,739
720,513,703
625,-704,-614
-595,505,-558
731,625,767
-595,822,433
-597,-481,743
281,-683,880
-726,872,547
529,880,-704
-807,-280,-750
552,743,-634
-573,416,-490
599,-830,-490
-662,-326,-817
-612,-453,767

--- scanner 35 ---
-663,869,837
930,-557,831
-393,792,-453
499,-533,-282
-480,-609,-256
-741,906,793
421,779,875
448,811,842
-687,975,744
474,867,957
515,913,-625
577,-545,-247
-443,834,-454
-582,-399,933
61,29,150
-355,686,-429
-538,-496,781
-417,-598,-410
-18,124,10
485,-532,-307
514,883,-498
853,-608,733
-637,-411,801
-529,-668,-386
522,938,-440
956,-549,611
"""

let map = try Map(fromScannersDescription: input)
print("part 1: \(map.uniqueBeacons.count)")
