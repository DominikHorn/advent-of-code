import Foundation

/*
 --- Day 23: Amphipod ---

 A group of amphipods notice your fancy submarine and flag you down. "With such an impressive shell," one amphipod says, "surely you can help us with a question that has stumped our best scientists."

 They go on to explain that a group of timid, stubborn amphipods live in a nearby burrow. Four types of amphipods live there: Amber (A), Bronze (B), Copper (C), and Desert (D). They live in a burrow that consists of a hallway and four side rooms. The side rooms are initially full of amphipods, and the hallway is initially empty.

 They give you a diagram of the situation (your puzzle input), including locations of each amphipod (A, B, C, or D, each of which is occupying an otherwise open space), walls (#), and open space (.).

 For example:

 #############
 #...........#
 ###B#C#B#D###
   #A#D#C#A#
   #########
 The amphipods would like a method to organize every amphipod into side rooms so that each side room contains one type of amphipod and the types are sorted A-D going left to right, like this:

 #############
 #...........#
 ###A#B#C#D###
   #A#B#C#D#
   #########
 Amphipods can move up, down, left, or right so long as they are moving into an unoccupied open space. Each type of amphipod requires a different amount of energy to move one step: Amber amphipods require 1 energy per step, Bronze amphipods require 10 energy, Copper amphipods require 100, and Desert ones require 1000. The amphipods would like you to find a way to organize the amphipods that requires the least total energy.

 However, because they are timid and stubborn, the amphipods have some extra rules:

 Amphipods will never stop on the space immediately outside any room. They can move into that space so long as they immediately continue moving. (Specifically, this refers to the four open spaces in the hallway that are directly above an amphipod starting position.)
 Amphipods will never move from the hallway into a room unless that room is their destination room and that room contains no amphipods which do not also have that room as their own destination. If an amphipod's starting room is not its destination room, it can stay in that room until it leaves the room. (For example, an Amber amphipod will not move from the hallway into the right three rooms, and will only move into the leftmost room if that room is empty or if it only contains other Amber amphipods.)
 Once an amphipod stops moving in the hallway, it will stay in that spot until it can move into a room. (That is, once any amphipod starts moving, any other amphipods currently in the hallway are locked in place and will not move again until they can move fully into a room.)
 In the above example, the amphipods can be organized using a minimum of 12521 energy. One way to do this is shown below.

 Starting configuration:

 #############
 #...........#
 ###B#C#B#D###
   #A#D#C#A#
   #########
 One Bronze amphipod moves into the hallway, taking 4 steps and using 40 energy:

 #############
 #...B.......#
 ###B#C#.#D###
   #A#D#C#A#
   #########
 The only Copper amphipod not in its side room moves there, taking 4 steps and using 400 energy:

 #############
 #...B.......#
 ###B#.#C#D###
   #A#D#C#A#
   #########
 A Desert amphipod moves out of the way, taking 3 steps and using 3000 energy, and then the Bronze amphipod takes its place, taking 3 steps and using 30 energy:

 #############
 #.....D.....#
 ###B#.#C#D###
   #A#B#C#A#
   #########
 The leftmost Bronze amphipod moves to its room using 40 energy:

 #############
 #.....D.....#
 ###.#B#C#D###
   #A#B#C#A#
   #########
 Both amphipods in the rightmost room move into the hallway, using 2003 energy in total:

 #############
 #.....D.D.A.#
 ###.#B#C#.###
   #A#B#C#.#
   #########
 Both Desert amphipods move into the rightmost room using 7000 energy:

 #############
 #.........A.#
 ###.#B#C#D###
   #A#B#C#D#
   #########
 Finally, the last Amber amphipod moves into its room, using 8 energy:

 #############
 #...........#
 ###A#B#C#D###
   #A#B#C#D#
   #########
 What is the least energy required to organize the amphipods?
 */

enum ParsingError: Error {
  case invalidInput
  case missingStarts
}

enum Amphipod: Character, CaseIterable {
  case amber = "A"
  case bronze = "B"
  case copper = "C"
  case desert = "D"
  
  var stepEnergy: UInt {
    switch self {
    case .amber: return 1
    case .bronze: return 10
    case .copper: return 100
    case .desert: return 1000
    }
  }
}

struct Burrow {
  /// The burrow consists of a hallway ...
  var hallway: Hallway = .init(spaces: 11)
  
  /// ... and a few siderooms
  var sideRooms: [Room] = Amphipod
    .allCases
    .sorted { $0.rawValue < $1.rawValue }
    .map { .init(designatedFor: $0, front: nil, back: nil)}
  
  var isFinished: Bool {
    hallway.amphipods.isEmpty && sideRooms.allSatisfy { $0.isFinished }
  }
  
  /// debug test if invariants hold
  private var invariantsHold: Bool {
    var cnts = [Amphipod: Int]()
    sideRooms.forEach {
      if let a = $0.front { cnts[a] = (cnts[a] ?? 0) + 1 }
      if let a = $0.back { cnts[a] = (cnts[a] ?? 0) + 1 }
    }
    hallway.amphipods.forEach {
      cnts[$0.value] = (cnts[$0.value] ?? 0) + 1
    }
    
    return cnts.allSatisfy { $0.value == 2 }
  }
  
  /// internal cost metrics not part of Equatable/Hashable consideration
  var costToReach: UInt = 0
  var estimatedCostToFinish: UInt = 0
  
  /// Each room has two available spaces for amphipods
  struct Room: Hashable {
    let designatedFor: Amphipod
    
    var front: Amphipod?
    var back: Amphipod?
    
    var isFinished: Bool {
      front == designatedFor && back == designatedFor
    }
    
    func available() -> Bool {
      front == nil && (back == nil || back == designatedFor)
    }
  }
  
  /// Hallway is represented as a list of spaces (optionaly) connected to
  /// rooms as well as a map associating Amphipods to these spaces
  struct Hallway: Hashable {
    let spaces: Int
    var amphipods = [Int: Amphipod]()
    
    /// Hallway space index right in front of a room
    func spaceIndex(inFrontOf roomIndex: Int) -> Int {
      2 * (1 + roomIndex)
    }
  }
  
  init(description: String) throws {
    let raw = description.split(separator: "\n")
    guard raw.count == 5 else { throw ParsingError.invalidInput }
    
    let fronts = raw[2].compactMap { Amphipod(rawValue: $0) }
    let backs = raw[3].compactMap { Amphipod(rawValue: $0) }
    
    guard fronts.count == sideRooms.count, backs.count == sideRooms.count else { throw ParsingError.missingStarts }
    
    sideRooms.indices.forEach { i in
      sideRooms[i].front = fronts[i]
      sideRooms[i].back = backs[i]
    }
    
    estimatedCostToFinish = estimateCostToFinish()
  }
  
  private func designatedIndices() -> [Amphipod: Int] {
    let designatedIndices = sideRooms.enumerated().reduce(into: [:]) {
      $0[$1.element.designatedFor] = $1.offset
    }
    precondition(Amphipod.allCases.allSatisfy { designatedIndices[$0] != nil })
    return designatedIndices
  }
  
  /// Never overestimates actual cost
  private func estimateCostToFinish() -> UInt {
    let designatedIndices = designatedIndices()
    
    // sum of each amphipods min cost to reach destination.
    return sideRooms.enumerated().reduce(into: 0) { aggr, curr in
      let (i, room) = curr
      if let a = room.front, room.designatedFor != a {
        let hallwayDistance = UInt(abs(hallway.spaceIndex(inFrontOf: designatedIndices[a]!) - hallway.spaceIndex(inFrontOf: i)))
        
        // move out of this room and into next room (2 steps), assuming we end at front of target
        aggr += a.stepEnergy * (2 + hallwayDistance)
      }
      if let a = room.back, room.designatedFor != a {
        let hallwayDistance = UInt(abs(hallway.spaceIndex(inFrontOf: designatedIndices[a]!) - hallway.spaceIndex(inFrontOf: i)))
        
        // move out of this room and into next room (2 + 1 steps_, assuming we end at front of target
        aggr += a.stepEnergy * (3 + hallwayDistance)
      }
    }
    +
    hallway.amphipods.reduce(0) {
      // move in front of and then into designated room
      $0 + $1.value.stepEnergy * (1 + UInt(abs(hallway.spaceIndex(inFrontOf: designatedIndices[$1.value]!) - $1.key)))
    }
  }
  
  private func possibleHallwayMoves() -> Set<Burrow> {
    let designatedIndices = designatedIndices()
    
    return hallway.amphipods.reduce(into: .init()) { res, curr in
      let (pos, a) = curr
      
      let designatedIndex = designatedIndices[a]!
      let designated = sideRooms[designatedIndex]
      
      /*
       Amphipods will never move from the hallway into a room unless that room is their destination room and that room contains no amphipods which do not also have that room as their own destination. If an amphipod's starting room is not its destination room, it can stay in that room until it leaves the room. (For example, an Amber amphipod will not move from the hallway into the right three rooms, and will only move into the leftmost room if that room is empty or if it only contains other Amber amphipods.)
       */
      guard designated.available() else { return }
        
      /*
       Once an amphipod stops moving in the hallway, it will stay in that spot until it can move into a room. (That is, once any amphipod starts moving, any other amphipods currently in the hallway are locked in place and will not move again until they can move fully into a room.), i.e., if path is free, move to room!
       
       1. check if path is free
       2. move there
       */
      let targetHallwaySpace = hallway.spaceIndex(inFrontOf: designatedIndex)
      let firstStep = pos + (pos < targetHallwaySpace ? +1 : -1)
      let pathSpaces = min(firstStep, targetHallwaySpace)...max(firstStep, targetHallwaySpace)
      let pathClear = pathSpaces.allSatisfy({ hallway.amphipods[$0] == nil })
      guard pathClear else { return }
      
      // apply planned move
      var burrow = self
      burrow.hallway.amphipods.removeValue(forKey: pos)
      burrow.costToReach += a.stepEnergy * UInt(pathSpaces.count)
      if burrow.sideRooms[designatedIndex].back == nil {
        burrow.sideRooms[designatedIndex].back = a
        burrow.costToReach += a.stepEnergy * 2
      } else {
        burrow.sideRooms[designatedIndex].front = a
        burrow.costToReach += a.stepEnergy * 1
      }
      burrow.estimatedCostToFinish = burrow.estimateCostToFinish()
      
      precondition(burrow.invariantsHold)
      res.insert(burrow)
    }
  }
  
  private func possibleMoves(roomIndex i: Int, spot: WritableKeyPath<Room, Amphipod?>) -> Set<Burrow> {
    let room = sideRooms[i]
    
    var res = Set<Burrow>()
    guard let a = room[keyPath: spot] else { return res }
    
    let designatedIndices = designatedIndices()
    let hallwaySpace = hallway.spaceIndex(inFrontOf: i)
    
    // test if we can exit room
    guard hallway.amphipods[hallwaySpace] == nil else { return res }
    
    let targetRoomIndex = designatedIndices[a]!
    let targetRoomSpace = hallway.spaceIndex(inFrontOf: targetRoomIndex)
    var minLegal = hallwaySpace
    var maxLegal = hallwaySpace
    while minLegal > 0, hallway.amphipods[minLegal-1] == nil {
      minLegal -= 1
    }
    while maxLegal + 1 < hallway.spaces, hallway.amphipods[maxLegal+1] == nil {
      maxLegal += 1
    }
    
    /*
       Amphipods will never stop on the space immediately outside any room. They can move into that space so long as they immediately continue moving. (Specifically, this refers to the four open spaces in the hallway that are directly above an amphipod starting position.)
     */
    guard minLegal < hallwaySpace || maxLegal > hallwaySpace else { return res }
    
    // special case: move directly to target (if possible, i.e., if room is available and path is clear)
    if sideRooms[targetRoomIndex].available(), minLegal == targetRoomSpace || maxLegal == targetRoomSpace {
      var burrow = self
      burrow.costToReach += a.stepEnergy * ((spot == \.front ? 1 : 2) + UInt(abs(targetRoomSpace - hallwaySpace)))
      burrow.sideRooms[i][keyPath: spot] = nil
      
      // prefer moving to back
      if burrow.sideRooms[targetRoomIndex].back == nil {
        burrow.sideRooms[targetRoomIndex].back = a
        burrow.costToReach += 2 * a.stepEnergy
      } else {
        assert(burrow.sideRooms[targetRoomIndex].front == nil)
        burrow.sideRooms[targetRoomIndex].front = a
        burrow.costToReach += a.stepEnergy
      }

      burrow.estimatedCostToFinish = burrow.estimateCostToFinish()
      
      precondition(burrow.invariantsHold)
      res.insert(burrow)
    } else {
      (minLegal...maxLegal).forEach { space in
        // Amphipods will never stop on the space immediately outside any room.
        guard space != hallwaySpace else { return }
        
        var burrow = self
        burrow.costToReach += a.stepEnergy * ((spot == \.front ? 1 : 2) + UInt(abs(space - hallwaySpace)))
        burrow.sideRooms[i][keyPath: spot] = nil
        burrow.hallway.amphipods[space] = a
        burrow.estimatedCostToFinish = burrow.estimateCostToFinish()
        
        precondition(burrow.invariantsHold)
        res.insert(burrow)
      }
    }
    
    return res
  }
  
  private func possibleSideRoomMoves() -> Set<Burrow> {
    sideRooms.enumerated().reduce(into: .init()) { res, curr in
      let (i, room) = curr
      // only move front if it is not in correct room or we have to make way for back to escape
      if let a = room.front, room.designatedFor != a || (room.back != nil && room.back != room.designatedFor) {
        res = res.union(possibleMoves(roomIndex: i, spot: \.front))
      }
      
      // only move back if it is not in correct room and front is clear
      if let a = room.back, room.designatedFor != a, room.front == nil {
        res = res.union(possibleMoves(roomIndex: i, spot: \.back))
      }
    }
  }
  
  /// All states reachable in one move from this current state
  private func possibleMoves() -> Set<Burrow> {
    let hallwayMoves = possibleHallwayMoves()
    let sideRoomMoves = possibleSideRoomMoves()
    
    return hallwayMoves.union(sideRoomMoves)
  }
  
  /// Heap/Priority Queue (mix) for A\* algorithm
  struct BurrowHeap {
    private var elements = [Burrow]()
    private var index = [Burrow: Int]()
    
    /// swaps two elements and updates index
    private mutating func swap(_ i1: Int, _ i2: Int) {
      precondition(
        i1 >= 0
        && i2 >= 0
        && i1 < elements.count
        && i2 < elements.count
      )
      
      // update index
      index[elements[i1]] = i2
      index[elements[i2]] = i1
      
      // update elements
      let swap = elements[i1]
      elements[i1] = elements[i2]
      elements[i2] = swap
    }
    
    /// sift element at  `index` up until heap invariant is restored. Returns final index
    private mutating func siftUp(_ index: Int) {
      guard index >= 0 && index < elements.count else { return }
      
      var i = index
      while elements[i] < elements[(i - 1) / 2] {
        swap((i - 1) / 2, i)
        i = (i - 1) / 2
      }
    }
    
    /// sift element at `index` down until heap invariant is restored. Returns final index
    private mutating func siftDown(_ index: Int) -> Int {
      guard index >= 0 && index < elements.count else { return index }
      
      var i = index
      var smallest = i
      
      repeat {
        swap(i, smallest)
        i = smallest
        
        let left = 2 * i + 1
        let right = 2 * i + 2
        
        if left < elements.count && elements[left] < elements[i] {
          smallest = left
        }
        if right < elements.count && elements[right] < elements[smallest] {
          smallest = right
        }
      } while smallest != i
      
      return i
    }
    
    /// inserts burrow or updates it's cost if better. Returns whether insert happened or not
    mutating func insertOrUpdateIfBetter(_ burrow: Burrow) -> Bool {
      if let i = index[burrow] {
        if elements[i].costToReach > burrow.costToReach {
          elements[i] = burrow
          siftUp(siftDown(i))
          return true
        }
      } else {
        elements.append(burrow)
        index[burrow] = elements.count - 1
        siftUp(elements.count-1)
        return true
      }
      
      return false
    }
    
    /// reveals the top element without modifying the heap
    func peek() -> Burrow? { elements.first }
    
    /// removes the min element from the Heap
    mutating func pop() -> Burrow? {
      guard elements.count > 0, let first = elements.first else {
        return nil
      }
      
      let last = elements.removeLast()
      index.removeValue(forKey: first)
      index.removeValue(forKey: last)
      guard first != last else { return first }
      
      elements[0] = last
      index.removeValue(forKey: last)
      index[last] = 0
      _ = siftDown(0)
      
      return first
    }
    
    /// true if this heap does not contain any elements
    var isEmpty: Bool { elements.isEmpty }
  }
  
  /// A\* like path search through possible states until cheapest is found
  func organized() -> Burrow? {
    var previous = [Burrow: Burrow]()
    var openList = BurrowHeap()
    var closedList = Set<Burrow>()
    
    _ = openList.insertOrUpdateIfBetter(self)
    
    while let current = openList.pop() {
      if current.isFinished {
//        print("PATH:")
//        var tmp: Burrow? = current
//        while let b = tmp {
//          print(b)
//          print(b.costToReach)
//          tmp = previous[b]
//        }
        
        return current
      }
      
      // finish current
      closedList.insert(current)
      
      // expand current
      current.possibleMoves().forEach { next in
        precondition(current != next)
        
        guard !closedList.contains(next) else { return }
        if openList.insertOrUpdateIfBetter(next) {
          previous[next] = current
        }
      }
    }
    
    // no way to organize
    return nil
  }
}

extension Burrow: Comparable {
  static func <(lhs: Burrow, rhs: Burrow) -> Bool {
    lhs.costToReach + lhs.estimatedCostToFinish < rhs.costToReach + rhs.estimatedCostToFinish
  }
}

/// custom hashable implementation to ignore cost values
extension Burrow: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(sideRooms)
    hasher.combine(hallway)
  }
  
  static func ==(lhs: Burrow, rhs: Burrow) -> Bool {
    lhs.sideRooms == rhs.sideRooms && lhs.hallway == rhs.hallway
  }
}

extension Amphipod: CustomStringConvertible {
  var description: String {
    "\(rawValue)"
  }
}

extension Burrow.Hallway: CustomStringConvertible {
  var description: String {
    (0..<spaces).map { amphipods[$0]?.description ?? "." }.joined()
  }
}

extension Burrow: CustomStringConvertible {
  var description: String {
    """
    #############
    #\(hallway)#
    ###\(sideRooms.map { $0.front?.description ?? "." }.joined(separator: "#"))###
      #\(sideRooms.map { $0.back?.description ?? "." }.joined(separator: "#"))#
      #########
    """
  }
}

let testInput = """
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
"""

let testBurrow = try Burrow(description: testInput)
guard let testOrganized = testBurrow.organized() else {
  exit(-1)
}
assert(testOrganized.costToReach == 12521)

let input = """
#############
#...........#
###D#C#B#C###
  #D#A#A#B#
  #########
"""

let burrow = try Burrow(description: input)
guard let organized = burrow.organized() else {
  exit(-1)
}
print("part 1: \(organized.costToReach)")
