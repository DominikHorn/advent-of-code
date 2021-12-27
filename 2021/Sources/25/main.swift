import Foundation

/*
 --- Day 25: Sea Cucumber ---

 This is it: the bottom of the ocean trench, the last place the sleigh keys could be. Your submarine's experimental antenna still isn't boosted enough to detect the keys, but they must be here. All you need to do is reach the seafloor and find them.

 At least, you'd touch down on the seafloor if you could; unfortunately, it's completely covered by two large herds of sea cucumbers, and there isn't an open space large enough for your submarine.

 You suspect that the Elves must have done this before, because just then you discover the phone number of a deep-sea marine biologist on a handwritten note taped to the wall of the submarine's cockpit.

 "Sea cucumbers? Yeah, they're probably hunting for food. But don't worry, they're predictable critters: they move in perfectly straight lines, only moving forward when there's space to do so. They're actually quite polite!"

 You explain that you'd like to predict when you could land your submarine.

 "Oh that's easy, they'll eventually pile up and leave enough space for-- wait, did you say submarine? And the only place with that many sea cucumbers would be at the very bottom of the Mariana--" You hang up the phone.

 There are two herds of sea cucumbers sharing the same region; one always moves east (>), while the other always moves south (v). Each location can contain at most one sea cucumber; the remaining locations are empty (.). The submarine helpfully generates a map of the situation (your puzzle input). For example:

 v...>>.vv>
 .vv>>.vv..
 >>.>v>...v
 >>v>>.>.v.
 v>v.vv.v..
 >.>>..v...
 .vv..>.>v.
 v.v..>>v.v
 ....v..v.>
 Every step, the sea cucumbers in the east-facing herd attempt to move forward one location, then the sea cucumbers in the south-facing herd attempt to move forward one location. When a herd moves forward, every sea cucumber in the herd first simultaneously considers whether there is a sea cucumber in the adjacent location it's facing (even another sea cucumber facing the same direction), and then every sea cucumber facing an empty location simultaneously moves into that location.

 So, in a situation like this:

 ...>>>>>...
 After one step, only the rightmost sea cucumber would have moved:

 ...>>>>.>..
 After the next step, two sea cucumbers move:

 ...>>>.>.>.
 During a single step, the east-facing herd moves first, then the south-facing herd moves. So, given this situation:

 ..........
 .>v....v..
 .......>..
 ..........
 After a single step, of the sea cucumbers on the left, only the south-facing sea cucumber has moved (as it wasn't out of the way in time for the east-facing cucumber on the left to move), but both sea cucumbers on the right have moved (as the east-facing sea cucumber moved out of the way of the south-facing sea cucumber):

 ..........
 .>........
 ..v....v>.
 ..........
 Due to strong water currents in the area, sea cucumbers that move off the right edge of the map appear on the left edge, and sea cucumbers that move off the bottom edge of the map appear on the top edge. Sea cucumbers always check whether their destination location is empty before moving, even if that destination is on the opposite side of the map:

 Initial state:
 ...>...
 .......
 ......>
 v.....>
 ......>
 .......
 ..vvv..

 After 1 step:
 ..vv>..
 .......
 >......
 v.....>
 >......
 .......
 ....v..

 After 2 steps:
 ....v>.
 ..vv...
 .>.....
 ......>
 v>.....
 .......
 .......

 After 3 steps:
 ......>
 ..v.v..
 ..>v...
 >......
 ..>....
 v......
 .......

 After 4 steps:
 >......
 ..v....
 ..>.v..
 .>.v...
 ...>...
 .......
 v......
 To find a safe place to land your submarine, the sea cucumbers need to stop moving. Again consider the first example:

 Initial state:
 v...>>.vv>
 .vv>>.vv..
 >>.>v>...v
 >>v>>.>.v.
 v>v.vv.v..
 >.>>..v...
 .vv..>.>v.
 v.v..>>v.v
 ....v..v.>

 After 1 step:
 ....>.>v.>
 v.v>.>v.v.
 >v>>..>v..
 >>v>v>.>.v
 .>v.v...v.
 v>>.>vvv..
 ..v...>>..
 vv...>>vv.
 >.v.v..v.v

 After 2 steps:
 >.v.v>>..v
 v.v.>>vv..
 >v>.>.>.v.
 >>v>v.>v>.
 .>..v....v
 .>v>>.v.v.
 v....v>v>.
 .vv..>>v..
 v>.....vv.

 After 3 steps:
 v>v.v>.>v.
 v...>>.v.v
 >vv>.>v>..
 >>v>v.>.v>
 ..>....v..
 .>.>v>v..v
 ..v..v>vv>
 v.v..>>v..
 .v>....v..

 After 4 steps:
 v>..v.>>..
 v.v.>.>.v.
 >vv.>>.v>v
 >>.>..v>.>
 ..v>v...v.
 ..>>.>vv..
 >.v.vv>v.v
 .....>>vv.
 vvv>...v..

 After 5 steps:
 vv>...>v>.
 v.v.v>.>v.
 >.v.>.>.>v
 >v>.>..v>>
 ..v>v.v...
 ..>.>>vvv.
 .>...v>v..
 ..v.v>>v.v
 v.v.>...v.

 ...

 After 10 steps:
 ..>..>>vv.
 v.....>>.v
 ..v.v>>>v>
 v>.>v.>>>.
 ..v>v.vv.v
 .v.>>>.v..
 v.v..>v>..
 ..v...>v.>
 .vv..v>vv.

 ...

 After 20 steps:
 v>.....>>.
 >vv>.....v
 .>v>v.vv>>
 v>>>v.>v.>
 ....vv>v..
 .v.>>>vvv.
 ..v..>>vv.
 v.v...>>.v
 ..v.....v>

 ...

 After 30 steps:
 .vv.v..>>>
 v>...v...>
 >.v>.>vv.>
 >v>.>.>v.>
 .>..v.vv..
 ..v>..>>v.
 ....v>..>v
 v.v...>vv>
 v.v...>vvv

 ...

 After 40 steps:
 >>v>v..v..
 ..>>v..vv.
 ..>>>v.>.v
 ..>>>>vvv>
 v.....>...
 v.v...>v>>
 >vv.....v>
 .>v...v.>v
 vvv.v..v.>

 ...

 After 50 steps:
 ..>>v>vv.v
 ..v.>>vv..
 v.>>v>>v..
 ..>>>>>vv.
 vvv....>vv
 ..v....>>>
 v>.......>
 .vv>....v>
 .>v.vv.v..

 ...

 After 55 steps:
 ..>>v>vv..
 ..v.>>vv..
 ..>>v>>vv.
 ..>>>>>vv.
 v......>vv
 v>v....>>v
 vvv...>..>
 >vv.....>.
 .>v.vv.v..

 After 56 steps:
 ..>>v>vv..
 ..v.>>vv..
 ..>>v>>vv.
 ..>>>>>vv.
 v......>vv
 v>v....>>v
 vvv....>.>
 >vv......>
 .>v.vv.v..

 After 57 steps:
 ..>>v>vv..
 ..v.>>vv..
 ..>>v>>vv.
 ..>>>>>vv.
 v......>vv
 v>v....>>v
 vvv.....>>
 >vv......>
 .>v.vv.v..

 After 58 steps:
 ..>>v>vv..
 ..v.>>vv..
 ..>>v>>vv.
 ..>>>>>vv.
 v......>vv
 v>v....>>v
 vvv.....>>
 >vv......>
 .>v.vv.v..
 In this example, the sea cucumbers stop moving after 58 steps.

 Find somewhere safe to land your submarine. What is the first step on which no sea cucumbers move?
 */

enum ParsingError: Error {
  case invalidSpace(_ raw: Character)
}

struct Map {
  var state: [[Space]]
  
  init(description: String) throws {
    state = try description.split(separator: "\n").map {
      try $0.map {
        guard let s = Space(rawValue: $0) else { throw ParsingError.invalidSpace($0) }
        return s
      }
    }
  }
    
  func ticked() -> (after: Map, anyMoved: Bool) {
    var anyMoved = false
    
    // move eastbound seacucumbers
    var before = self
    var after = before
    before.state.indices.forEach { y in
      before.state[y].indices.forEach { x in
        let space = before.state[y][x]
        
        if space == .east, before.state[y][(x + 1) % before.state[y].count] == .empty {
          after.state[y][x] = .empty
          after.state[y][(x + 1) % before.state[y].count] = space
          
          anyMoved = true
        }
      }
    }
    
    // move southbound seacucumbers
    before = after
    before.state.indices.forEach { y in
      before.state[y].indices.forEach { x in
        let space = before.state[y][x]
        
        if space == .south, before.state[(y + 1) % before.state.count][x] == .empty {
          after.state[y][x] = .empty
          after.state[(y + 1) % before.state.count][x] = space
          
          anyMoved = true
        }
      }
    }
    
    return (after, anyMoved)
  }
  
  func fixpoint() -> (map: Map, stepCnt: Int) {
    var r = ticked()
    var stepCnt = 1
    while r.anyMoved {
      r = r.after.ticked()
      stepCnt += 1
    }
    
    return (r.after, stepCnt)
  }
  
  enum Space: Character, CustomStringConvertible {
    case empty = "."
    case east = ">"
    case south = "v"
    
    var description: String {
      "\(rawValue)"
    }
  }
}

extension Map: CustomStringConvertible {
  var description: String {
    state.indices.map { y in
      state[y].indices.map { x in
        "\(state[y][x])"
      }
      .joined()
    }
    .joined(separator: "\n")
  }
}

let testInput = """
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
"""

let testStep1 = """
....>.>v.>
v.v>.>v.v.
>v>>..>v..
>>v>v>.>.v
.>v.v...v.
v>>.>vvv..
..v...>>..
vv...>>vv.
>.v.v..v.v
"""

let testStep2 = """
>.v.v>>..v
v.v.>>vv..
>v>.>.>.v.
>>v>v.>v>.
.>..v....v
.>v>>.v.v.
v....v>v>.
.vv..>>v..
v>.....vv.
"""

let testStep58 = """
..>>v>vv..
..v.>>vv..
..>>v>>vv.
..>>>>>vv.
v......>vv
v>v....>>v
vvv.....>>
>vv......>
.>v.vv.v..
"""

let testMap = try Map(description: testInput)
assert(testMap.description == testInput)
assert((0..<1).reduce(testMap) { m, _ in m.ticked().after }.description == testStep1)
assert((0..<2).reduce(testMap) { m, _ in m.ticked().after }.description == testStep2)
assert((0..<58).reduce(testMap) { m, _ in m.ticked().after }.description == testStep58)

assert((0..<57).reduce((after: testMap, anyMoved: true)) { m, _ in m.after.ticked() }.anyMoved == true)
assert((0..<58).reduce((after: testMap, anyMoved: true)) { m, _ in m.after.ticked() }.anyMoved == false)

assert(testMap.fixpoint().stepCnt == 58)

let input = """
v>...>>>.>v.v..v.>.>.>>>..v..v.>.v.vv>.....>>>>v...>>.>..v>.>vv.>.v.>vv..v.v.v.>.v.....v..v>v>.v....vvvv>v.v.v>v.v>vv..>.v...>>>vv.v.v.>>..
v>.>.v....>...v..v.>.>..>.v.>..>vv.....>..>..vv..vvvvvv.>v>.>.>.>vv....>.v.vv...>..v.....v......v>.v..>v.v>..>.>.v.vvvv>..vv.>v>v.v.vv.v.vv
...vv...vv.>.v..v..>.>....v.>..>...v>...v>...vv>......>>vvv>.>v>.>>vvvv>...v..>>.v..v.>vv..........>v>v>...>.>v.>v>.v..>....v..>>>>...vv..>
>>...>.>....vv.v..>>..v...>>...>.v.>vvv...>v..>>v.vv>..>...v..v.v>vv..>vv..>.v..v..>v.v..>........>.v>v..vvv.v...vvv.>..vvv.>>.v..v.....vv.
>v.>.vv>>...>>v...>..>.>.v.v>.v..v.>>.v.>.v..>.v.v.vv>.v.vv>>vv..>..>..>v.v.....>.v..v>>.v.>vv...>.>.>>>.vv>>>>...v.>..vv.v...v......v...v>
.v...v>.>v.v..v.v...v>v.v>vvv>..>..vv.vv>v.v.....vvv....vv>....>.....v>v.>.v>..v...>>v>v....>>v.>.>v..v>.v.v.vv>v.>v.>v..vv..>v.....>..>..v
.vv.>.>>....>v>v.......>..>.>>......v.v..>>...v.>v>..v>.>..>.>>vv>>...>>..v.v.v....v.>..v..>....>.........vvv...>.>.>..v>>v>..v>.v..v>.v>>.
.v>...vv>v.>v...>vv.v.>.>v.v..>.v.>>>..v...>>>.>.v...........>v..>v>v.>vv....vvv.v.v>..>v>.>>..vv.>..v>>v.v......>.>>vv>.v>v.v.>>..>v>>>v.v
.v......v>>>v>v..v.>>v>.v..v>.>>>.v.>>>....v.....v..v..>.>>>v.>v......v....>v.>...v>.v.>.>v..>>.v.>v>v>...>vvvv...>v>..>vv.>....>.v.v.v....
v....>.>v>.>..>...>v..v.>v..vv.>.>v>vv..>vv>>>>>v.v>..>v..>.>...v>v..>>>>.>.v.v..>.>..v.v>...>..>.>>v..>v..>vv>.v>>...>>>.>vv>v...>...>>>>.
>.>v.v.vv>v..vv.v..v>v..v>......>v.>>>.>>>v..v.v.v>..v.vv....v..>v.v>v>.>.>v.v>>.>.v....v.....>v.>v.vv.>......v...v...>...>vvv.......>>.v..
.v..v.v.>>v...v>>...>vv.>.vvv>.v>vv.>vv>.>v.v>>>>>....>v.v>vvv>v.v>.>..>...>..>.vv..v>>.>...v>v..v...v.v>v.>>.>.v>....v.v.v..>>>.vvv>.vv>>>
.vvv>...vv.v>.>>v.>v>>>v>vv........>v..v.>..>...v..v..v..v>...v.>......>>v>>.>v..>>vv>....>.>vvv.vvv...v.>..v.>>.>>.>...>.vv.....v..>v>.v>>
>>>.v.v.v.v>.v>.>.>v.>.>.....>.v>.>..>.>..v.>>v..>...v...>>.....>v.>..vvv..>v..>...vv>..v>.v.v>>v.vv>.>v..>..>>.v>.v..>..v.>v>v.>v..>>>vv.v
.v.....>..>v>>vv...>.v.....vvv>.v>..vv.....>..>.............>..>.v>v>vv.>.>.>.v.>...>>.>>.>.>v..>>v.>...>v...v>.v..vv..>>v>.>..v>.vvv...v.v
v.>v..>v>.>v>v...vv.vvvvv.>.vvv...v..>>v.......>vv.v.vv.v.v.vv>..>>>v>>.v>.>>>.>vv.v>>v.vv..>>.v>.v>.v...v...v..>..v...v>v>.v...v.>>vv.v.>>
v>.v.v.>.>...>v.v..v..vv..vv>.v>.vv..>......>>vv>>..>..>v>.>>v.....vv>.>.>v>..>v.>.>>.....>.v>..v....v....>v.v>....v.>.v.v.vvv>.....>v.>.v.
....>>>v.>>.v.>..v...>.v.>..>.>v.>....>v..v.>....v...>...v....>.v>>v.>>v>vv..v>v....>v...>>v.v>>....>..>.vv.v.vv>v>>>>>.v.>v>v.v..>..>v....
...>>v>v.>>...>..vvvvv>.v.vv.>.v.>>v>..v.vv>v.>vv.....>.vvv>>>v.v..vvvvvvv.>>vvv>v...>..>.v>>v>...vv>..>..>......v..>.v..>v>>.>>>>..v.>>v.v
..vvvv..v.>>.>.>>>.v.v..v.>v.>.v>v.v>..>.v.v.v.>..v>>.>...vvv.v..>...v....v.v>vv>...v.vv>..>vv.v>v>v...>.vv....>.v>...>v...>>>>..>>....vvvv
v..v.>>>>v..>vvvv>.>v.>v...>>..>v>v...v.>......>>>.......vv.vv>..>...v..>vvv.>.>.v>v.v>.v>......>...v.>..>.v.>.>v>..>....vv.>....vvv...v...
.v.v>....>.>..>...v>..v>>..>>.v.v>v.>.>..>.>.v....>v......vvv>..>>.....>.v..v>.v>v..>.v..v..vvv.v>..>.>.v...>..vv.>v.>v>..v>..>...>.>>.vv.>
v.vv>v.vv...>..>..>..>..>vv>v.>..>.>..>v..>>v>.vvvv>v.>v>vv.>v...vv.v.v.v...vv>.>.....vvvv..>v..v..vv.>v>v.v.>..>.v..>.....vv>>.....vv>...v
..v..v.>>.>v..v>..>...v...>v>>.vv>.>>.v..v>...>..>>..vv.>.v.>>..v>vv>..vv>vv>.v>...vv...v.>>.v..v>.v>>.v.....v..vv>>v>>v>...>v...>.....>.>>
..v....>vv>v.vv..........vv..>>.vv......v..vvv..v>>>v.v.>>.v>>..v..>..vv>v..>>>..>......>v>vv>.>>v....v.v>>.v.>....>>..>v>>.>...>..>vv..>v>
>...>.>>>.>.v..>v>>..v.....>>......v>>..v....>.>v>.>v.>>>vv....>v.v...v..>.>.v.v..>vv>.v>>..v.>vv>.>>...v..>vv.v>.>>.....>.v.v..v...v..>v>>
v....v>.>>>vv>..v>>v....>>>..vvv.>.>..vv...v..>>v.>...>>....>>>.>.>.v.v.......>.v..vv>vv...>v.>v>v.v>v.>>v>v>v>.....>.v>..>...>v>v>...>.v.v
v...>.>.....>.v>vv>>.v..vv..v.v.v.vvvvv.v...v>>.v>...v.v....vv....v>v.>v.>v..>..v.v>>..v>vv>vv.v.>>>.>...v.v..>.v>v>v..v>....v>>..vv>.>>.>v
.v>>..v.vvv......vv...v>.>>v....v....v...>>.>v.>...v.v>>..>>.>v..>.v.........vv.>>>>vv.>..vvv...v....>.>v..v.....v.v..v>.v.............vv>v
v..v.vv..>>....v.>...vvvvvv.v>.....>..v.>>>.v.v>..v.>vv..>.....>v.>v.v.v>......v..>>.>v...vvv>.v>v..>>>>v.>...>...v>.>v.>.>>.....vvv....vv.
....>>..>...>v.>>...v..v.>..>vvv>>v.v>>.vv>...v>....>vv>.vv.>v>>>v..>>>..>.>v..>>v.>vv.>......v>>v.vvv.v.v>.v.v...vv>>vv..>....v>....vv..vv
.>vv>.....vv>.v...>>..>>vv.>>v>...>v..>>.v>v....>....v......>v..v>...v.vv.vv..>v.>.v.>>...>.v..v.v.vv..>.>>vv.>>...>.>..>.v>..v>>v.vv.v.vvv
v.vv.v>>vv>vvv..v.......>>....>v..v>..v.v>v>.>v.v..>v>.v>v.v...>...vv...>.>.>>......v...>...v>..>.v>..vvv>.vvv>vv>>>>...v.vv.>.v.v..v.v>.>v
..>>>..>>v.v...>..>..vvv.v.>>.>.>.v.v..vv>>..>>.v.v.......vvv.>.v..>v>........>.v.>v...>..v>v...>.......>>..>v>.....>vv.v>v.v..>>...v....>.
v.>>>>..>..>>>.vv..>.>..vv..vv..v...>v>...v.>v.>.vv>..v>.....>.>v>.vvv.>.>>v.>..v..v.v...vv.>...>..>>>.>..>.v.>.>..v.v..v>>.v...>v>>.>.v..v
>v.v>v>.v>>v>....v.v>v.>.v..>>....v>v.>>>.vv>.vv....>..v>.vv.>.vvv.v..>....v.......vvv.v>v>v..v..v....v>v>v>.v..v.>..>....>>>..>..v.v.>...v
>>...v>vv>>...vv>>..>.vvvvv>.>.vv.>v>.>.>>>v..>>v..>vv.>>>>..>v...v.v>.......>vv>>...v>.v..>>.>.>v>..>>.....>.>..>vv..>.>..>vvv>.vv.vv>v.>.
...>.>v.>>vvv>vv>>...v.>v...vv>.>.>v.>....>...v.>v.vv.>vv>.>.>.>...>...>>>.v......>.....v.vv.....v.>>..>..v...vvv.>...v..vv>v>..v.>..v..>.v
v>v>>..v>v...>.>vv.>...>>v.>vvv..vv>.>v.....v>v.>v..>v...>..>.>.>v.>.....>..>vv>v..>...v.vv>.v>>v.>v....v>.....v......>..>.........>>...>v.
v.>.>>>.>v>.......v..>v>v....>..v....v.>.....vv.>.>.>>>v..>v..>.v.vv>...v>vv.>v.>...>>..>>>>v..>v.....>.>>>v..>.>>v.>>>......v.>.>vv..vv.>.
.v..v>vv..>..>.vv..v>.>..>>...>>v>..v.....v....v..v.>.v....vv>.v>...v>.vv.>..v>..>vvv.v>.>.v>..>.>...>..v>.vv.>.>.v>v>v..>.vv.>.>v..v>.>>>.
v....>>.>.vv..>v>.v.>..v>.>vv..>.>>.vv.>.v...>v.>.>v....v...vv>..>.>.vv>vv..>...v.>.....>.>..v...>>..vv......>v>vv>v>v..>v>>.>v..v...v..>..
>...>.>v>...>v.>vv.v>.>v.....v.>.>...v>v.v....>.v>..>..v.v>.....vv.vv.>...>vv.>..>.v>.v.....>>.>v.vv>>..v>..>...>v>vv.>v>.>..v>v...>>v.v..v
v>>v>>.vv..vv>vvv.>vv.>.v..vvvv.v>v>..v..vvv>.....>..>.>v..>....>.v>v..>>>..vv.v>v..>v.>>>>.>.vv.v..vvv>>.vv...>.>.>....>>v..>.v>..vvvv>..v
v..>>>.vv....v.v........v>>>..>>..v>..v...>..v>v>.>v......v..vv.v...v.v..>vv>>vv>v>.>>v>.>>>>.v>.....vv..v..>v..>..>vv>>.vv....>>.vv>v>....
.>...vvv......vvv....v...>....v.v.>>.v...>>v>...v>v>v>v.>>v>v>vv.>v.>>>...>.>v>v.v..v.vvv..>vvv..v.>>..vv.......>vvv.vv.vv....v.vvv.>v>..>v
..>.vv>...>>.v.v.v.>.>>..v..v.>..>v.v.v..v>>.>.vv>...vv>>vv.....>vv.>>>vv>>>>>.>.v>........vv.v>>..v.v>..v....>>....>....>>....>v..v>v>>vv.
.....v.v..v....>v...v.v>>.>...>.>>v.>..>>.>>...>>>v.v...v>>>..>v.v...vv.vv..>.>.>>>.v>..>>v>v>........>.vv.>.>v..>>>..>>.>v..>...vv.>..>v..
.v...v>..>.>v.v.v>>.v..>v>>v>>vv.>vv.v.v>v.v...>>.>.>.>>.>v.>..>>>v..v>>.......v>...vv.....>.>v.>v>v...v.>...>>>.v....>.>v....>.>..>..>>.v.
>>v>vv.>.v>.>v.vv>....v>>...v.vv..v....vv>.v....v>.>...v>.vv.v.>.v.>>>.vv.v>>..v.>.....>.>.v>vvv>>vv.v...v...v.>.v..>.v..>.>...v.>......>vv
.v..v..>.vv>..>vv..v>>...v>v.>.>..v>vv.v>vv.vvv.v>...v>v>...v...>v>......>.>v>>v..v.v.>v..vv......v.>.>....v.>.v..v>..>..>.vv..v..>>...>.vv
v>.v...>.v..>.>>.v..>v>.v.>v.v.>>>.v>.v>v.vv.v.>.>.>.v..v.v....v..>.v.v..v..>>.>v.>...v....>.vv..vv.v.>.>..vv>..v.v..v.>.>.v>.v.vvvvv..v.v>
...>.vvvv..v.>v...>v.>v.>...>>>.v>.>.>v>...>>>>>>.v.>>.......v>>v..v.vv.vvv.>.vvvv.vv>.>v>..v.>...vv.vvvv>>>v.>..>v.>...v>vvv.v.....v.vvvv.
>..>..v......>.>>...>v.>v....>.v>..>...>.>...>.>.vv.>>.v.>>.>>>>.vv.vv....>..vvvv...v>.>.>>.>>.>>.v..v>.>..>.vv...>....v>v..>.....v>..v>..>
>..>....v.....v..v.....v...v.>..v....v......>v>..v>.....>>>>..vv.v...>>>....v.>>v....v.v.>>...>>.>>...v..>>>.v..>>.>..>.v.>.vv..v..>.v>...>
.v>>.>>..>vvv.v..>v>..>.v.v..>v......v>>.>>v>>>...>..>>v.vvvv.>.....v..vv.v...>vv>>>v.v..v>..>.v>.>...>>....v>.>..>>>>>.v>>>vv..>>....v.v.>
..v.vv...>.vvv..v.>...>v.......>..v>>>>>.v.>......>v.v>..v.>.>.>>>v......>.v>..v.v>.>.v..v>>..>>>v>>.v..>..v.>...v.....>.vv>...v...>...v...
.v>>v>vv>...>..>.v>.v....v>.vv.v...>.>..>v.....>...>>.>...>>v>vvv.v>>..>..v>>v>..>..vv..>..>v...v...v>..>>..v.v.>vvv....v.v>vvv..>>vv...v.v
.>v>..v.>>.vv....v>..>>>>>>.>.>>..v>.v>..>.....v>>v..v..>..v.v>>vvv..>..>.>.>.vvv.>..vvv...vv>>>..>>..v>>>>>vvv.v.>>...>....vv..vv.v>..vvv>
..v..>.v>>...>.>>>.>v>>v.v.>..>>..>>>v.....>.>>>v>.v.>.v....>v.>>v...>v.v.>..>.>.v>vvvv...vvvvv...v..>>.v..v>......>.>>>...v.>.v...>.....vv
vvvv.v...>v....>>>>.....vv>>>>..vvv.v..v.vv....>v.v..vvv.v..>v>>..v...v.v.>v.vv.v.>>vv>..>..v..>>...v>..v>>>.vv.v.vv..v..vv......v>v.>vv...
.v>>>..vv..>..>..v..>>>vv.>.>.v.>>v..........vv.>..>.>>.v.....>v>v.v.....>.v.v..vvvv>>...>>..v.v>v.v.v...v.....>>>..v.vv...>>...v>v.>>>>.v.
..vvv.>...vv..>vvv.v>>.vv>vv.v..vv....>...>v>>.>.>...v>..>.vv...>>...>v.>...v.>v......vv...v>>>.>.>...>v....vvv>..>>>>v>v>vv>vv..>.v>.v>>..
v>.>v......v...>v.>>v.v>>...>v>>..>.>...>..v.>.v..v.>.>v>vv>>.v..v.>...>v..v.....v>v...>vv.>....>v....v..>v.>vv..>>v..>>.v..>>.v>..>v..v>..
v>.vv.....v>>vv.>>...v..>..>>.vv.v..vv.>vvvv...v.vvv>v>>.....>vvv..v>.v.>.......>>vv>...vvv>v>vv..>vvv...>.vv>>.v.>>.v..>>.....v....>.>>..v
>..>.>v.v..>...v..>>..>.v.>v..v.>.v>>.>.>v>vv>.v.>>..vv>v>..>vv.......>......v>.>>>v...>..>.v>.>v.v..v.>v....>.>.v>.v>v>>v.v.v>>>.vv...vvv>
......v.v...>...v.>>.>v..>.>v....>.>>>...v>v...v.vv.vv>.v..v>>.>v..vv...>.vvvv...v.>>>.v>>.v..>.v>v..>..>.>.vv..v>.>.v.v>>>v>.>..>.>..>>>..
v....v.vv..>>>>..vv>>v...v>.>vv.>v>>.>..>.>>>...v..v.v.>v....>>v.vvv.v.>>...v.v>.vv..v.v.v.>.>>....vv>v.>>.>.>.v>.v>>>.....>.v>.>v>...>.>..
...>>..vv.>.v.v....>>..>.v..>v>.v...>...>v>v>v.>.v.vv>v....>v....>>>v..>>..>....>.>>>v.>.>...v..>>>.>vv..v>v....>....>..vvv>v>v.v>v..vv....
>vv>..>.vv.>>.v...>.>.>>.>v..v>vv...>v....v.vv>....v>...v.vv>...>>>.vv...>...v....>.v....>...v.vv..>.>v..>...>>>..>.v.v.v>>...>..>..>..v.>>
..vv>v>v>>>vvv>.vv>>vv..>>v>>..>v.>>.......>vv.v.vv....>v>..>.v>vv>>.vv.>>..vv.v>>>v.>...>....>>v>.......v>>>>.v>>>>>v.>>...>v.>vv.>.vv.>.v
>v>.v.>.>..>>>.v..>.v..>v..vvv.>..v>.>>.....v....vv.>..>.v.vv...v.v>.>.vv.>....>v..v>.v..>..>....>.v..v..>v>.>>..vv...>..v....>>v..>.v>>.v>
.>..>.....>vvv>.>..v>v.v..>vvv....>v>>>...>..>.>vvv..v.vv.>...>>v.....v.v..v>>>.v.>>vv..v.v..v......vv>v.>>.v.>v.>>>>..>v..v>.....v>.>v.v..
vv>.....>v>>v.>.>.>vv....v>..v.>.v.>vv>v......v.>>..>>.v>>>>.v>....v..>..v>.v.....>>.>....v.>...>v>>>>>.v.>.......>>v>...v..>>vv..>..>v.>vv
>>vv>..v.....v.v>vv.>..v>..vv>...>>>....>..v>v...>...vv.>>.>v>v>>..v.>...v...>.vvv.>>.>.v>v>.>>>...>..v.v>.vv>v.>.v..>...v..v..>..v..v.v>v>
v>....v.v>...vv...>v..v>v...>.>vvv....>.v...>>>v...>...v>>.v>v>>v>..>>>v.>..v.v.v>.v.vv>>..v.>.>..>>.v>v.>>>>...v>>.v.v>.>.v...>vv.vvvv.>v.
...vv...v.>.>.vvvv..v>.vv>.v.>.v>.>v>v......v...>v>>v...v>.>..>..>.>.>>>vv..>..>>.>v..>>>.>v>...>>>.>.>>v.v..v>...v>..v..v.>..vv.v.....>.>.
.>..>.>...........>.>.>v.>>>>v>.>v>.vv...v..>v.vv>..vv.>v.>>>..v.vv.....>>.v...>vv>.>>.v..v.....>v.....>vv.>vv...vv.vv>v.v....v......v..>vv
>v>..v>>>v>>vvv.....v..>>>v..>>>v..>>v>vv.>...v>.>>>.v.vv...v...v>>.....v.>vv..>..>>.vv.>..>......v.>....vv.>vv.....>>v...v>>v.vv>>..>.vv..
>.>v>>v..>.v..vv>.>....v..>>v....>...v>vv>.....vv.v...>v>.v>>..vvv......>...v...>v.v..>.>>.v>...>>>.vv.v>v...v.>...v..v.>v..>>v>>v..>...v..
>.>.>vvv>>.v...v..>v..>>.....>v.....>>vv.v>..>v...>v...>.v.v>>.v>......>>v...>..>.>......>.>..>...vvv>vv>.v.v.v>..vvv>.>.......v.v.>>>v>v>.
...v.v.>.v.>.>.v.>.>>v>v..>>..>>.vv..>>.>>.v>v>>.>...>>>.v.vv>..vv>...>>vv....v.>.v...>>..vv>.>..v>v...>..v..>>....>>>v.vv>>v..>.v....>.>.v
>>v.>>.v>>....>..vvv>v>>v..>vv....>.....vv.vvv>........>v.v.vv>>.v..>v.vv>vv.>>...>..>.v>.>.>>.v.v>v>...vv..v.v>..v>.v>....>vv>>....vv>...v
v.v...v.v.vvv>vv>.vvv.vv.>v>v.v....>.....>>..>.vv.>.>..v....v..v.v...vv.vvvvv......>v.vv..v>v>vv.v...v.>...v>>>v.v>v>.>..vvv.>.v.>v.>.>>v..
...>>>>.v..v.>..v.>v.v>..vv.>.>vv.>>.v>.>....v..v...>.>..vv.>..v.>.v>>...>.>...v.>>.>.vv>v>.>.>..>vv.>vv>...>.v.>.v..>>..>..v>vv.v.v.v.....
.>..vv...vvv>.....vvv>.>v.>vv.v..>.>vv.v.v..>>>..>v.v..vv..>..>v.v>>v...>>.>>.v>>v>..>...>>vv>>..v>......v>.>.v.v...v..v.v.v.v...vv..v>..v.
...v......vv>v.vv>>>.v.>.v.v.....v..>>v.>v.vv>v>>....>......v...>>..>....>>vvv.>v..>....>..v>>>>.>>v>v..>>>.>>v>>v....v.>v.vv>.>....v.>...>
..>>>>v>...v.v..vv>...v>>>>.>..v>.........v.>.>...v.>>...>..v>.>...v..vv.v>>.v..>.....>..>vv.v.v.>.>v>..v>>v.v>v>v>.....>vvv.>>>>>>vvv>.v.>
.v..v....v.vv.v.v..vv>..>>v....v.vv...>.>...>>.v.vv....v>.v.v.>>v>....vv>>..v...v....>.>>.>v......>>.v>v..>..v>vv.>..>>>....v..>...vvv.>>v>
..v>.v....v.>.>v>.>.v...vv>>..>.v...>>v.v...>>..vv>.....v.vv.>>>v>.>..v.>>v......vv>>v.>v..v>>..>..>>..>...>vv....v.vv..v>v.vv...>...>.>v>>
>.vvv.......>.>>...v>v..>.>>v..v.vvv..v.v..>..>>vv>.vv>..v..>...v.v....v.v........>v>>>.vv..v.....>.>v.>v.>v.v........>>v>.v>..>.>..>v>v...
....>vv...v.>>...vv>.....v....v>v.>..vv>.v.vv>>..v>v.v.v.v>vv..v..>v>.v....>v>...>v.....>v...v..v.>.>v>....>....v.v..>>v>>v..>>>>v>>>.>>...
.....v>v>.>.v...v.>>..v>>>>vvv.vv...vv>>.>..v..>v>..>..>..>vv>v....>>v..vv>..v>..>.v..>>vv>>v.v>...>>>.vv.>>.>..vvv>>v>..>v..v.>v.>..v.>...
v..>.>v>.v....v>>>.>...v...v.>>>>..vv...>.>>.>>v.>.>v..v>..>v>....>v>.v>>v.v..v>>.v.>...>..>v...>>>....>vv..v>>v.>>...>v.v.>v...>....>.>v..
...v>>.v.v.....v......>v.....vv>>.>.v.v>.>>>.vv>>.vv..>...>....v>..v>>>>.v..v>>>v>.v>>..>.>...>v...vvvv.>.v...>.>v.>v.>..vv.....>>>>..v..v.
..>>.>>..v>..>vv>>.>.v.vv....>v.v.>>>v>v.v>vv>>>vv...vv.>>...>.v.....v.>.>>.>.vv.v.>>v...vv..vvvv.>....v..>>.>>v.>.v>v.>...v.>.vv.v>>...v>v
..vvvv.v..>v.....>..v.>.>>v.v...>>..>.>.vv...v>v..>.>....>.v.v..v>.....vv...v....>....>...>v..vv>vv...v...>.>..>....>.v.>>v.v.>v.v>.vv>>vv>
.v..>vv>>>.v.>v..>v.>>.v.v...>.v..v.v.....>vv.v.>>vv...v>.>.>....vv.>..vvv.>...v>v>>.>...>>>>..v..v..vv...>.>.v..vv>.>v..>..v.....v.>...v.v
>.v...v.vv>>......>>>>v....>v.>vv>.>>.>v>v..v...>>v..>....v.v.....>...>v....vv.v>....>.>..v.vv..v>v>.>v....vv..v..>v........>.v>.v.........
v.>..vv>...>>.v.vv..>.>v>....v..>.vv..>..>>.>..>vv...v..vvvv>....v..>v.v.>.>.v>....v..>>v>>...v.>>v.v..v.v...>v.v>..v..v>.......>.v...v.vv.
v.>v>v>v>>>...v>.>>..v.>vv>.v..>.vv.>>v>v..>>vvv>.v.....>>.>v.v..>....v.>v.>v.....v>.v>>...v>..>..v.v....v..v...>.v..v....>>.>vvv>..>>.vv..
>v>>.>..v....>v.v...>>>v.>.>..v.>.vvv>v..vv.>vvv.v.>>>v>vvv.>>.>.v.......>>.>.>v>..vv>......v.>>>..v>vv..>..>>..v>vv>>vv.vv.vv.v...v...v.>>
.>.v..v.vv>.>.v..........vv...vvv.v.v.>........>....v>v.vvv.v..v>.....vvv>..v...>..>v>v>>v.>v>v..>.>v>v..v.>.v.>v.>..vvv>.>>>>.vv>>..>v>>.v
.....>vvvv..vv.vvv...vvv...vv>vv.v>>>.v>..v>.v...vv.vv>vv>.>vvvv...>vv...vv>.vv>>>..>.>>>.>vv..>...v.>...vv.>>>...v...vv.>vv.>vvv....>v>>.v
v>..>..v>>>v.>>v.vv>v>..vv>.>....>>>......>..>>..v.>..vv.v...v.>.vv.>>.>>.>..v.......>v.v.>.v.v>.v.v>>.v..vv>.vv.>>>v.v>...>...vv..v.>v>.v.
v.vvvvv..v.>.>.v.>..>>>..vv.>>>vv.......vv..v.....v.vv...v.v>.....>>.vv..>.>>.v..>v.v.v>.>>..v.>........>.v>..>v>>>>>>v.>..>..>v>.vv.vvv...
>..v>v.>>v>v.>..>>vvv>..>v>>v>..>.v.>>.vvv>.>vv.>vv.v........v>v.v..>...>v....v...>.v.>...>vv...v..vv........>...>v.v>..v..v>>..v.>>.v.vv>.
..v.v>.v.v.v>v....>.>>>.>.v>>..vvv>v>.v.>vv.>..>.v>v>v.>vv.vv.v.v.vv..v>.vv.vv.vv.>>...vvv.>..>.>v>......v.>.v>vv.>.v..vv>.v>.v>>.....v.>.>
v.v....>>..v...v>v>vvv....>>....>v>vv.vv>v.>>.vv..>.v.>....>>v..>>>vv..>.......>>....vv.>v>v.v.....v.>.>.>v>>>>..>>..v.>...>>>...vv>v>..>v.
.>.>..vv>>>...vvv.v>..>>v>v.v.v>vv..vv>v>>.vv....v>>v....v>>.vv>v...v..>v>v>.>.>.>>>....>.>.>..vv>v.v.>>...>v>..>.>vv.>..vv..>v..>v.v.....v
>v........>>v....v..>v.v..>.vv>..>v.v.v>>>>v>>vvv>.v>v.>.>.v.v.vvv..vv>..>..>v>.v>..>v.v...>.>.v>..>vvv.....v......>>>.>.v>.>vvv..v>.>v>vv>
..v.>>>>.>v.>>>.....>v>.>..vv..>>v..v.>.....>vv...>>..v..v.v..v>.>..>vv.>...v.v....v.>v.>.>...vvv.vv>.....v.....>.v>.v>.>..>....vv.>v.v....
.v>>.......v.v.v..>>..>v..>vv....>vvvvv.>.>..>...vv.>>v..vv....>v>.>>.>.vvv.>.v....vv>v.vv.>vv......>.>>>>.>.>vvv>vv.v.v..>.v..>..>.......>
.vv..>>..>....vv.vv..>.>.....>>.>.>..vv...>v>.vv>..>v.v>.>...>..v.vv..>.>v>>...>v..v...v...v>.>>>>..>.>>v....>.v..v.v.....>>v.....v.vv....v
..vv>vv...v.>>>v....v>.vv..v>v.>.v>.>v>>.>.v..>.vv...>.v.>.>.v..v.>..v.>>>..>..vv.>..>..>v>..>.>v...v>...>>>....>v...v.vv.>>.vv.>vv>v>>>.>>
>..vv>>vvv..>vvv..v>v.>...>..v>>vv.>v..>.v>.>.>.>v.>vvv>>.>.......v...>>v..>...vvvv>>v>.v..>>vvvvv.v..v>.>..>v....>..v>...>vv>>v.>vvv>...>.
v.v..>..>v...v..>>>v..v>.vvv....>v.v...v.v.>...vv.>v>.v>...>vv>vv.v>vv.v.v..vvv>..>>v.v>v>..>.>v..v..>vv>v.......>.>.v.>..vv.v.v>>.>.>...vv
...>>>v..>v..>>v.>.vvv.v.>>..>..vv>v.......>v.>.>....>v.vv.>..v>...v..>..v>...v>v.....v..v.>>>>>.>.>vv..>vv>vvv.>>>>..>.>v.v.v.>>>.v...>v>.
..vvv..>vv>.vv>v>.>>.>v.>vvv......>..>v...v.v.>.v..>vv>.vv.vvv>.......>.>...v>v.>v..v.>v.>v>vv...v>.>v.>v.v.....v.>>>v.>.v.v>.v..v>.vv....>
>v..v.v..v>>.>..>>...v.>.>......>..>.v.vvvv>vv>v..v>vvvv.>v..v>.....>..>>>...>.v..vv>v>.>..>v..v..v>>.....>.>>>...v>......>.vv..vvv>>......
.>>.v........vv.>.>.v>....v......v.>.>>..>v.v..>....>>.>.....>vv..>.>>.>v.vv..vv....>>..v.vv.>..>.>...>vv..v....>>>...>.v..v..v.>>...v>v...
>v..v.>>>>>....v...>..vv>.>.>>..>vv>vv.>>..>.>..v.vv>v.>>.>..v..v..>>vv.v>...v>v>v..>.>v.vvv...>>.v..>.>>.>>.....>.v>.>v.vv..vvv>......>v>.
....>.>>>>v>>.v>>...v..>>>.vv..v>>..>>.v.v>.v.v.>...v.>>...>v..v....vv.v.....v....>......>.....vv.>.vvvvv>....>vv..>>>v>vv>>v.....>>...v...
.>.....>v>...>v.>>..>v.>v>....vv..v>>..>.vv.v...v>..>..vv.v>..v..>v...>>v..v..v>v.v>.>v>v....v>.v>.vv..v....v.>>..>v..vv.v..>v>>.>>>..vvv.>
>v>>>v...>.>>vvv....v>vv...>...>v..>...>.>....v.v..>>..v>..vv>>>.........>v.v...>v......>>.>vv.......>.>.>..>..>>v>v.v..vv...>>v..>v>.>vv>>
..>v>v>v.vvv.v>.v>>>..>>v>....>.v.>...v>...>v.vv.vv>v..>.>v>vv.v.v.>...vv...v>>>>>vvv.>.v>.vv...>v....v.>...v..>..v..v.v...v>v.v.>v.>v..v..
.v.v.v.v>>.>.>.>>..v.v..v..v.v.>.>.>v>>.v....>>>....>>v>..>v....v......vv.>>..>...>...>>>.>.>>..v.>..>....>..v..vv.vvv>vvv...>>v>>.vv>v>v..
..>.v.>v.>>>>>>....vvv.v>.v.vv.>..v>v.........vv>.>v.v>v.vvv....>v>vv.>>..............v.v>>>..v>..>.>..vv....>.v>...>...v.....>>.vv>.v>..vv
.v...v.>.>.>>vv..>v>.>..>..vv>.>v...v>v.v..>v>.>>...v>v>...v...>..v>>........>v.>..v>..vv.v>v.>.vv>>.>vvv>v.>>>>>.v.v........>>>>..>.vv>v.v
>..v>v...>........v..>.>......v..v.>v.vv>>>>.>.>v.v>..>v.>>>vv....>....>v..>.>.>.v.vvv..>vv>..>v.......v>>>..vv..v..>v>>>...>v.>v.v>...vv>>
>.>....vv.vv.vv.vvv...v>>..>..>.>v.v>>.v.>v.v..>..>....>v..>>>>v.>..v..>>>v.v..v>>....v....v..>>>.>.v.>..>v..>...v...>v..v.>.v......v>.v.v.
.v.v..>....v..>v>vv.v>v>.v>.vvv......>.v..v.v.....>>.v...>..>..vv.>>.>.v..>....>.v>vv>..v>...>.>>vv>.vvvv.v.v>...>....>...>v.v...vvvv>....>
......v>v.vv..>v...vv..v>v....>.>v.>....>....>.>.>.>>...>>.v.>.>.>>v.v>.vv.v>>..>.>.v..>..>.v.....v.v.vv>.vvv....v.>..>.v.......v>.>..vv.v.
>>>...>.>vv>>>>>.>..........>vv>>...v....v.....v>vv.vv>..v>>..v...v>v.....vv>...vv.v..>.v..vv.v>.v.v.>.vvv.vv.>.>...>v>v..>.v>...>v...v.>.v
..>vv.....v.>.>>....vv........vv..>v..v.>.>.....>v>v>>.v.v.>>..v..vv.>v.>vv>v.>.>.vvv.>vv..v.vv.>.>>v....v..v.....v.v>v...v.>.vvv..v..>.>>.
v>vv>>v>.....v..v>v>v...v..>v..v>>.>v.vv>v>>.>..v.v...v>...>v.v.vv.>.v>v>.v...v.>vv>..>..>v.....v.>>...v>vvv>vv....>.v..>v....>..v>>v.>.>.>
.>.>.>.>>.>v.>.v.v..v.v..>v>>..v...>....v>v...v.v..v>.v...v>>v>>.vv...>>.>>>.>...v>vv>....>>..v.>v.v..>.....>>..>>>....v.>>..v..v.v.>..vv..
"""

let map = try Map(description: input)
let res = map.fixpoint()

print(res.map)
print("part 1: \(res.stepCnt)")
