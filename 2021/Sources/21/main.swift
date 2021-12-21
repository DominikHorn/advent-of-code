import Foundation
import DequeModule

/*
 --- Day 21: Dirac Dice ---

 There's not much to do as you slowly descend to the bottom of the ocean. The submarine computer challenges you to a nice game of Dirac Dice.

 This game consists of a single die, two pawns, and a game board with a circular track containing ten spaces marked 1 through 10 clockwise. Each player's starting space is chosen randomly (your puzzle input). Player 1 goes first.

 Players take turns moving. On each player's turn, the player rolls the die three times and adds up the results. Then, the player moves their pawn that many times forward around the track (that is, moving clockwise on spaces in order of increasing value, wrapping back around to 1 after 10). So, if a player is on space 7 and they roll 2, 2, and 1, they would move forward 5 times, to spaces 8, 9, 10, 1, and finally stopping on 2.

 After each player moves, they increase their score by the value of the space their pawn stopped on. Players' scores start at 0. So, if the first player starts on space 7 and rolls a total of 5, they would stop on space 2 and add 2 to their score (for a total score of 2). The game immediately ends as a win for any player whose score reaches at least 1000.

 Since the first game is a practice game, the submarine opens a compartment labeled deterministic dice and a 100-sided die falls out. This die always rolls 1 first, then 2, then 3, and so on up to 100, after which it starts over at 1 again. Play using this die.

 For example, given these starting positions:

 Player 1 starting position: 4
 Player 2 starting position: 8
 This is how the game would go:

 Player 1 rolls 1+2+3 and moves to space 10 for a total score of 10.
 Player 2 rolls 4+5+6 and moves to space 3 for a total score of 3.
 Player 1 rolls 7+8+9 and moves to space 4 for a total score of 14.
 Player 2 rolls 10+11+12 and moves to space 6 for a total score of 9.
 Player 1 rolls 13+14+15 and moves to space 6 for a total score of 20.
 Player 2 rolls 16+17+18 and moves to space 7 for a total score of 16.
 Player 1 rolls 19+20+21 and moves to space 6 for a total score of 26.
 Player 2 rolls 22+23+24 and moves to space 6 for a total score of 22.
 ...after many turns...

 Player 2 rolls 82+83+84 and moves to space 6 for a total score of 742.
 Player 1 rolls 85+86+87 and moves to space 4 for a total score of 990.
 Player 2 rolls 88+89+90 and moves to space 3 for a total score of 745.
 Player 1 rolls 91+92+93 and moves to space 10 for a final score, 1000.
 Since player 1 has at least 1000 points, player 1 wins and the game ends. At this point, the losing player had 745 points and the die had been rolled a total of 993 times; 745 * 993 = 739785.

 Play a practice game using the deterministic 100-sided die. The moment either player wins, what do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?
 */

enum ParsingError: Error {
  case invalidInput
  case invalidPlayerOrder
  case invalidPlayerPos
}

struct DeterministicDice {
  private var state = 0
  private(set) var rollCount = 0
  
  mutating func next() -> Int {
    let next = state + 1
    
    state = next % 100
    rollCount += 1
    
    return next
  }
}

struct Player {
  var id: Int
  var pos: Int
  var score: Int = 0
}

struct DiracDiceGame {
  private var turnDeque: Deque<Player>
  
  init(description: String) throws {
    let raw = description.split(separator: "\n").map { $0.split(separator: " ") }
    guard raw.allSatisfy({ $0.count == 5}) else { throw ParsingError.invalidInput }
    
    turnDeque = .init(
      try raw.enumerated().map { i, rawPlayer -> Player in
        guard let id = Int(rawPlayer[1]), i + 1 == id else { throw ParsingError.invalidPlayerOrder }
        guard let pos = Int(rawPlayer[4]) else { throw ParsingError.invalidPlayerPos }
        
        return Player(id: id, pos: pos)
      }
    )
  }
  
  func playDeterministic() -> Int {
    var dice = DeterministicDice()
    var turnQueue = turnDeque
    
    var gameEnded = false
    while !gameEnded {
      guard var current = turnQueue.popFirst() else { return -1 }
      
      let roll1 = dice.next()
      let roll2 = dice.next()
      let roll3 = dice.next()
      
      current.pos = ((current.pos - 1 + roll1 + roll2 + roll3) % 10) + 1
      current.score += current.pos
      
      turnQueue.append(current)
      
      gameEnded = current.score >= 1000
    }
    
    guard let firstLooser = turnQueue.popFirst() else { return -2 }
    
    // TODO: what happens if both finish in the same turn?
    return firstLooser.score * dice.rollCount
  }
  
  private let diractTurnDeltas =
    (1...3).reduce(into: [Int: UInt]()) { aggr, roll1 in
      (1...3).forEach { roll2 in
        (1...3).forEach { roll3 in
          aggr[roll1 + roll2 + roll3] = (aggr[roll1 + roll2 + roll3] ?? 0) + 1
        }
      }
    }
  
  /// given a position and current score, count how many universes
  /// require how many steps to cross threshold of 21, e.g., 100 universes
  /// need a single step, 200 universes need two steps, ...
  private func countDiracWins(
    p1Pos: Int, p1Score: Int,
    p2Pos: Int, p2Score: Int,
    p1Turn: Bool,
    step: Int, universesCount: UInt, res: inout [Int: (p1Wins: UInt, p2Wins: UInt)]
  ) {
//    print("\(Array(repeating: "  ", count: step-1).joined())Before \(p1Turn ? "P1" : "P2"): \(universesCount) x (\(p1Score), \(p2Score))")
    
    // simulate a single turn
    let pos = p1Turn ? p1Pos : p2Pos
    let score = p1Turn ? p1Score : p2Score
    diractTurnDeltas.forEach { delta in
      let newPos = ((pos - 1 + delta.key) % 10) + 1
      let newScore = score + newPos
      
      if newScore >= 21 {
        // a player has won, tally up how many universes exist where this happens
        var old = res[step] ?? (0, 0)
        
        // check which player won and tally
        if p1Turn {
          old.p1Wins += delta.value * universesCount
        } else {
          old.p2Wins += delta.value * universesCount
        }
        res[step] = old
      } else {
        // Recurse into next player's turn
        if p1Turn {
          countDiracWins(p1Pos: newPos, p1Score: newScore, p2Pos: p2Pos, p2Score: p2Score, p1Turn: false, step: step, universesCount: universesCount * delta.value, res: &res)
        } else {
          countDiracWins(p1Pos: p1Pos, p1Score: p1Score, p2Pos: newPos, p2Score: newScore, p1Turn: true, step: step + 1, universesCount: universesCount * delta.value, res: &res)
        }
      }
    }
  }
  
  func playDirac() -> UInt {
    let p1 = turnDeque.first!
    let p2 = turnDeque.last!
    
    var wins = [Int: (p1Wins: UInt, p2Wins: UInt)]()
    countDiracWins(p1Pos: p1.pos, p1Score: 0, p2Pos: p2.pos, p2Score: 0, p1Turn: true, step: 1, universesCount: 1, res: &wins)

    let totalP1Wins = wins.reduce(0) { $0 + $1.value.p1Wins }
    let totalP2Wins = wins.reduce(0) { $0 + $1.value.p2Wins }
    
//    print("There are \(totalP1Wins) universes where P1 wins and \(totalP2Wins) universes she looses")
    
    return max(totalP1Wins, totalP2Wins)
  }
}

let testInput = """
Player 1 starting position: 4
Player 2 starting position: 8
"""

let testGame = try DiracDiceGame(description: testInput)
assert(testGame.playDeterministic() == 739785)
assert(testGame.playDirac() == 444356092776315)

let input = """
Player 1 starting position: 8
Player 2 starting position: 10
"""

let game = try DiracDiceGame(description: input)
print("part 1: \(game.playDeterministic())")
print("part 2: \(game.playDirac())")
