import Foundation

/*
 --- Day 12: Passage Pathing ---

 With your submarine's subterranean subsystems subsisting suboptimally, the only way you're getting out of this cave anytime soon is by finding a path yourself. Not just a path - the only way to know if you've found the best path is to find all of them.

 Fortunately, the sensors are still mostly working, and so you build a rough map of the remaining caves (your puzzle input). For example:

 start-A
 start-b
 A-c
 A-b
 b-d
 A-end
 b-end
 This is a list of how all of the caves are connected. You start in the cave named start, and your destination is the cave named end. An entry like b-d means that cave b is connected to cave d - that is, you can move between them.

 So, the above cave system looks roughly like this:

     start
     /   \
 c--A-----b--d
     \   /
      end
 Your goal is to find the number of distinct paths that start at start, end at end, and don't visit small caves more than once. There are two types of caves: big caves (written in uppercase, like A) and small caves (written in lowercase, like b). It would be a waste of time to visit any small cave more than once, but big caves are large enough that it might be worth visiting them multiple times. So, all paths you find should visit small caves at most once, and can visit big caves any number of times.

 Given these rules, there are 10 paths through this example cave system:

 start,A,b,A,c,A,end
 start,A,b,A,end
 start,A,b,end
 start,A,c,A,b,A,end
 start,A,c,A,b,end
 start,A,c,A,end
 start,A,end
 start,b,A,c,A,end
 start,b,A,end
 start,b,end
 (Each line in the above list corresponds to a single path; the caves visited by that path are listed in the order they are visited and separated by commas.)

 Note that in this cave system, cave d is never visited by any path: to do so, cave b would need to be visited twice (once on the way to cave d and a second time when returning from cave d), and since cave b is small, this is not allowed.

 Here is a slightly larger example:

 dc-end
 HN-start
 start-kj
 dc-start
 dc-HN
 LN-dc
 HN-end
 kj-sa
 kj-HN
 kj-dc
 The 19 paths through it are as follows:

 start,HN,dc,HN,end
 start,HN,dc,HN,kj,HN,end
 start,HN,dc,end
 start,HN,dc,kj,HN,end
 start,HN,end
 start,HN,kj,HN,dc,HN,end
 start,HN,kj,HN,dc,end
 start,HN,kj,HN,end
 start,HN,kj,dc,HN,end
 start,HN,kj,dc,end
 start,dc,HN,end
 start,dc,HN,kj,HN,end
 start,dc,end
 start,dc,kj,HN,end
 start,kj,HN,dc,HN,end
 start,kj,HN,dc,end
 start,kj,HN,end
 start,kj,dc,HN,end
 start,kj,dc,end
 Finally, this even larger example has 226 paths through it:

 fs-end
 he-DX
 fs-he
 start-DX
 pj-DX
 end-zg
 zg-sl
 zg-pj
 pj-he
 RW-he
 fs-DX
 pj-RW
 zg-RW
 start-pj
 he-WI
 zg-he
 pj-fs
 start-RW
 How many paths through this cave system are there that visit small caves at most once?
 */

struct Cave: Hashable {
  let name: String
  
  private init(name: String) {
    self.name = name
  }
  
  init(from description: Substring) {
    self.init(name: .init(description))
  }
  
  var isLarge: Bool {
    name.allSatisfy { $0.isUppercase }
  }
  
  static var start: Cave {
    .init(name: "start")
  }
  
  static var end: Cave {
    .init(name: "end")
  }
}

extension Cave: CustomStringConvertible {
  var description: String {
    name
  }
}

struct CaveSystem {
  var connections = [Cave: Set<Cave>]()
  
  init(description: String) throws {
    try description
      .split(separator: "\n")
      .forEach {
        let conRaw = $0.split(separator: "-")
        guard conRaw.count == 2 else {
          throw ParsingError.invalidConnection(String($0))
        }
        
        let a = Cave(from: conRaw[0])
        let b = Cave(from: conRaw[1])
        
        var consA = connections[a] ?? .init()
        consA.insert(b)
        connections[a] = consA
        
        var consB = connections[b] ?? .init()
        consB.insert(a)
        connections[b] = consB
      }
  }

  typealias Path = [Cave]

  private func visit(cave: Cave, previousPath: Path = [], previousSeen: Set<Cave> = []) -> Set<Path> {
    guard cave != .end else {
      return [previousPath + [cave]]
    }
    
    let path = previousPath + [cave]
    var seen = previousSeen
    seen.insert(cave)
    
    return connections[cave]?
      .filter { !seen.contains($0) || $0.isLarge }
      .reduce(into: []) { fullPaths, next in
        visit(cave: next, previousPath: path, previousSeen: seen)
          .forEach { fullPaths.insert($0) }
      } ?? []
  }
  
  var allPaths: Set<Path> {
    visit(cave: .start)
  }
  
  enum ParsingError: Error {
    case invalidConnection(_ raw: String)
  }
}

//extension Set where Element == CaveSystem.Path {
//  func description: String {
//    map { "\($0)" }.joined(separator: " -> ")
//  }
//}

let testInput1 = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

let testInput2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

let testInput3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""

let testSystem1 = try CaveSystem(description: testInput1)
print(testSystem1.allPaths.count)

let testSystem2 = try CaveSystem(description: testInput2)
print(testSystem2.allPaths.count)

let testSystem3 = try CaveSystem(description: testInput3)
print(testSystem3.allPaths.count)

let input = """
HF-qu
end-CF
CF-ae
vi-HF
vt-HF
qu-CF
hu-vt
CF-pk
CF-vi
qu-ae
ae-hu
HF-start
vt-end
ae-HF
end-vi
vi-vt
hu-start
start-ae
CS-hu
CF-vt
"""

let system = try CaveSystem(description: input)
print(system.allPaths.count)
