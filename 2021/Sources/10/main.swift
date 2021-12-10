import Foundation
import DequeModule

/*
 --- Day 10: Syntax Scoring ---
 
 You ask the submarine to determine the best route out of the deep-sea cave, but it only replies:
 
 Syntax error in navigation subsystem on line: all of them
 All of them?! The damage is worse than you thought. You bring up a copy of the navigation subsystem (your puzzle input).
 
 The navigation subsystem syntax is made of several lines containing chunks. There are one or more chunks on each line, and chunks contain zero or more other chunks. Adjacent chunks are not separated by any delimiter; if one chunk stops, the next chunk (if any) can immediately start. Every chunk must open and close with one of four legal pairs of matching characters:
 
 If a chunk opens with (, it must close with ).
 If a chunk opens with [, it must close with ].
 If a chunk opens with {, it must close with }.
 If a chunk opens with <, it must close with >.
 So, () is a legal chunk that contains no other chunks, as is []. More complex but valid chunks include ([]), {()()()}, <([{}])>, [<>({}){}[([])<>]], and even (((((((((()))))))))).
 
 Some lines are incomplete, but others are corrupted. Find and discard the corrupted lines first.
 
 A corrupted line is one where a chunk closes with the wrong character - that is, where the characters it opens and closes with do not form one of the four legal pairs listed above.
 
 Examples of corrupted chunks include (], {()()()>, (((()))}, and <([]){()}[{}]). Such a chunk can appear anywhere within a line, and its presence causes the whole line to be considered corrupted.
 
 For example, consider the following navigation subsystem:
 
 [({(<(())[]>[[{[]{<()<>>
 [(()[<>])]({[<{<<[]>>(
 {([(<{}[<>[]}>{[]{[(<()>
 (((({<>}<{<{<>}{[]{[]{}
 [[<[([]))<([[{}[[()]]]
 [{[{({}]{}}([{[{{{}}([]
 {<[[]]>}<{[{[{[]{()[[[]
 [<(<(<(<{}))><([]([]()
 <{([([[(<>()){}]>(<<{{
 <{([{{}}[<[[[<>{}]]]>[]]
 Some of the lines aren't corrupted, just incomplete; you can ignore these lines for now. The remaining five lines are corrupted:
 
 {([(<{}[<>[]}>{[]{[(<()> - Expected ], but found } instead.
 [[<[([]))<([[{}[[()]]] - Expected ], but found ) instead.
 [{[{({}]{}}([{[{{{}}([] - Expected ), but found ] instead.
 [<(<(<(<{}))><([]([]() - Expected >, but found ) instead.
 <{([([[(<>()){}]>(<<{{ - Expected ], but found > instead.
 Stop at the first incorrect closing character on each corrupted line.
 
 Did you know that syntax checkers actually have contests to see who can get the high score for syntax errors in a file? It's true! To calculate the syntax error score for a line, take the first illegal character on the line and look it up in the following table:
 
 ): 3 points.
 ]: 57 points.
 }: 1197 points.
 >: 25137 points.
 In the above example, an illegal ) was found twice (2*3 = 6 points), an illegal ] was found once (57 points), an illegal } was found once (1197 points), and an illegal > was found once (25137 points). So, the total syntax error score for this file is 6+57+1197+25137 = 26397 points!
 
 Find the first illegal character in each corrupted line of the navigation subsystem. What is the total syntax error score for those errors?
 
 --- Part Two ---

 Now, discard the corrupted lines. The remaining lines are incomplete.

 Incomplete lines don't have any incorrect characters - instead, they're missing some closing characters at the end of the line. To repair the navigation subsystem, you just need to figure out the sequence of closing characters that complete all open chunks in the line.

 You can only use closing characters (), ], }, or >), and you must add them in the correct order so that only legal pairs are formed and all chunks end up closed.

 In the example above, there are five incomplete lines:

 [({(<(())[]>[[{[]{<()<>> - Complete by adding }}]])})].
 [(()[<>])]({[<{<<[]>>( - Complete by adding )}>]}).
 (((({<>}<{<{<>}{[]{[]{} - Complete by adding }}>}>)))).
 {<[[]]>}<{[{[{[]{()[[[] - Complete by adding ]]}}]}]}>.
 <{([{{}}[<[[[<>{}]]]>[]] - Complete by adding ])}>.
 Did you know that autocomplete tools also have contests? It's true! The score is determined by considering the completion string character-by-character. Start with a total score of 0. Then, for each character, multiply the total score by 5 and then increase the total score by the point value given for the character in the following table:

 ): 1 point.
 ]: 2 points.
 }: 3 points.
 >: 4 points.
 So, the last completion string above - ])}> - would be scored as follows:

 Start with a total score of 0.
 Multiply the total score by 5 to get 0, then add the value of ] (2) to get a new total score of 2.
 Multiply the total score by 5 to get 10, then add the value of ) (1) to get a new total score of 11.
 Multiply the total score by 5 to get 55, then add the value of } (3) to get a new total score of 58.
 Multiply the total score by 5 to get 290, then add the value of > (4) to get a new total score of 294.
 The five lines' completion strings have total scores as follows:

 }}]])})] - 288957 total points.
 )}>]}) - 5566 total points.
 }}>}>)))) - 1480781 total points.
 ]]}}]}]}> - 995444 total points.
 ])}> - 294 total points.
 Autocomplete tools are an odd bunch: the winner is found by sorting all of the scores and then taking the middle score. (There will always be an odd number of scores to consider.) In this example, the middle score is 288957 because there are the same number of scores smaller and larger than it.

 Find the completion string for each incomplete line, score the completion strings, and sort the scores. What is the middle score?
 */

class Chunk {
  var start: OpenSymbol
  
  var hadEnd: Bool = false
  var end: CloseSymbol {
    start.matching
  }
  
  var subchunks = [Chunk]()
  
  /// parses and returns the first chunk and its subchunks in the given string.
  /// Afterwards `description` contains the remaining substring
  private init(characters: inout Deque<Character>, globalIndex: inout Int) throws {
    guard !characters.isEmpty else {
      throw ParsingError.emptyChunk
    }
    
    let first = characters.removeFirst()
    guard let chunkOpen = OpenSymbol(rawValue: first) else {
      throw ParsingError.illegalStart(first)
    }
    
    self.start = chunkOpen
    globalIndex += 1
    while !characters.isEmpty {
      guard let char = characters.first else {
        throw ParsingError.unexpectedEndOfSequence
      }
      
      if OpenSymbol(rawValue: char) != nil {
        do {
          let subchunk = try Chunk(characters: &characters, globalIndex: &globalIndex)
          subchunks.append(subchunk)
        }
        
      } else if let close = CloseSymbol(rawValue: char) {
        globalIndex += 1
        characters.removeFirst()
        
        if close.matches(chunkOpen) {
          self.hadEnd = true
          break // done with this chunk
        } else {
          throw ParsingError.corrupted(pos: globalIndex, expected: chunkOpen.matching, got: close)
        }
      } else {
        throw ParsingError.illegalSymbol
      }
    }
  }
  
  static func from(description: String) throws -> [Chunk] {
    var deque = Deque(description)
    var chunks: [Chunk] = []
    var index = 0
    
    while !deque.isEmpty {
      chunks.append(try Chunk(characters: &deque, globalIndex: &index))
    }
    
    return chunks
  }
  
  var fixedEnds: [CloseSymbol] {
    subchunks.flatMap { $0.fixedEnds } + (hadEnd ? [] : [end])
  }
  
  var fixScore: Int {
    fixedEnds.reduce(0) { 5 * $0 + $1.fixScore }
  }
  
  enum ParsingError: Error {
    case emptyChunk
    case unexpectedEndOfSequence
    case illegalStart(_ raw: Character)
    case corrupted(pos: Int, expected: CloseSymbol, got: CloseSymbol)
    case illegalSymbol
  }
  
  enum OpenSymbol: Character {
    case round = "("
    case square = "["
    case squiggly = "{"
    case angle = "<"
    
    var matching: CloseSymbol {
      switch self {
      case .round: return .round
      case .square: return .square
      case .squiggly: return .squiggly
      case .angle: return .angle
      }
    }
  }
  
  enum CloseSymbol: Character {
    case round = ")"
    case square = "]"
    case squiggly = "}"
    case angle = ">"
    
    func matches(_ symbol: OpenSymbol) -> Bool {
      self == symbol.matching
    }
    
    var fixScore: Int {
      switch self {
      case .round: return 1
      case .square: return 2
      case .squiggly: return 3
      case .angle: return 4
      }
    }
  }
}

extension Chunk.OpenSymbol: CustomStringConvertible {
  var description: String { "\(rawValue)" }
}

extension Chunk.CloseSymbol: CustomStringConvertible {
  var description: String { "\(rawValue)" }
}

extension Chunk: CustomStringConvertible {
  var description: String {
    "\(start)\(subchunks.map { "\($0)" }.joined())\(end)"
  }
}

struct NavigationSubsystem {
  typealias Line = [Chunk]
  
  let validLines: [Line]
  let corruptionScore: Int
  let fixScore: Int
  
  init(input: String) throws {
    let res = try input
      .split(separator: "\n")
      .map { rawLine -> (validLine: Line?, corruptionScore: Int, corruptionReason: String?) in
        do {
          let chunk = try Chunk.from(description: String(rawLine))
          return (chunk, 0, nil)
        } catch Chunk.ParsingError.corrupted(pos: let pos, expected: let expected, got: let got) {
          let reason = "Expected `\(expected)`, but found `\(got)` instead at column \(pos)"
          switch got {
            case .round: return (nil, 3, reason)
            case .square: return (nil, 57, reason)
            case .squiggly: return (nil, 1197, reason)
            case .angle: return (nil, 25137, reason)
          }
        }
      }
    
    self.validLines = res.compactMap { $0.validLine }
    self.corruptionScore = res.reduce(0) { $0 + $1.corruptionScore }
    self.fixScore = validLines
      .map { $0.reduce(0) { $0 + $1.fixScore } }
      .median()
  }
}


extension Array where Element: BinaryInteger {
  // TODO: implement using quickselect
  /// O(n log n)
  func median() -> Element {
    let l = sorted()
    if l.count & 0x1 == 1 {
      return l[l.count / 2]
    } else {
      return l[l.count / 2] + l[l.count / 2 + 1]
    }
  }
}

let testInput = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

let input = """
([<{(<{(({<{{{[]<>}<<>()>}<<()()>[()()])}{({()[]}[<>{}])<(<><>)<[]{}>>}>{{((()<>)<[]()>)[{[]<>}(()[])]
<<[[<[(<[<[[[{()<>}(<>{})]]][{(<{}{}>(<>))[[<>](<><>)]}[({{}<>}<[]()>){<{}{}>[{}[]]}]]><{(<([][]
{<([[[({{(<[([{}<>]<{}{}>)[[<>[]]]]{{(()<>)[()]}}>){((([{}<>]{[]{}})<<[][]><<>{}>>){([[]{}]<<>()>){
{{[{({{(({<[<{[]{}](<>)>][<(()[])(()[])>[[<>{}](<>())]]><<([{}]{{}{}})[{[]}{{}[]}]>[{<()<>><<>>}]>
(<<<[(({[[[{<[{}<>]{<><>}><({})>}{{{()}{(){}}}}][{[({}{})[<><>]]<({}[])[()()]>}(<([]<>)<[](
<[{[((<<[[<[({[]()}{(){}})[{<>[]}<()()>]]>]]<[{{[[[][]]<[]()>][<<>{}><<><>>]}}({[<[]()><{}[]>]{<[]
(({((({{[[(([<[]<>>(())]{{()<>}<<>[]>}))]]([<([{{}()}(<>{})][({}<>)])>](({{<()<>>[{}())}{((){}){[]()}}})
({{({(<<{<<([<{}>])(<[()<>][{}[])>{[()()][{}{}]})>[[[{{}[]}[(){}]][{<>{}}{()<>}]]({<<>[]>{{
<[<<{[(<{[{({({}[])(()[])}[{{}<>}{{}<>}]){<{<>[]}[<>()]>{<{}()>}}}{{{{()()}}[{{}<>}({}<>)]}}}}>{{[[{<[
[{([<{{<<<[([<[]()>])]([{{<>{}}}{(()[])[<>[]]}])><[(<{()<>}{<>}>[([]{})<<>{}>]}([{()<>}({}[])]<<{}[]>({}{}
<([<([{{<<{<(([]<>)<{}{}>)>({[(){}]}((<>[])<{}[]>))}<{<(()[])<[]>>({[][]}(()[]))}(<{()[]}{[]()}})>>[([({()[
{{{[({(<[{[[{{()<>}[<>()]}{({}<>)<{}()>}]{{[()()][(){}]}[{<>()}]}]}]>)(({<<(({{}<>}([]<>))({<>[]}<[]{
({{({<([{[{{[[[]()><{}[]>]({{}[]}[{}()])}}<{[{[]()}[<>]]<[{}<>]<()<>>>}>]{<<(((){}){<>()})[[[][]]]>[([<><>]{
(<[[{{[(([{{<((){}){<>{}}>{<{}[]><<>[]>}}(({<>[]}<<><>>)({()[]}<()<>>))}<{(<()()>[{}{}]){{
{{{[{<<(<<[{({(){}}[{}{}])}[{[<>[]]{()()}}{[()]{(){}}}]]>>)><{((<<{<[]{}>([]{})}{{{}{}}}><([{}[]](()()))>
[<(<<<[(([((<<<><>>>[<[]<>>(()[])])[{((){}){<><>}}<<{}{}>(()[])>]){(([[]<>]<[]>)<{[]}[[]<>]>)<<{{}{}}[[
<(<<({(([[({[[[])(()[])][<[]()>{{}[]}]}{({{}}{(){}})(((){})([]<>))})([[([][])<{}<>>]<<()><<>()>>](
[{[[<{<<{<{<{<()()><{}[]>}([(){}](<>()))>(<{<>[]}([])><[[][]](<>{})>)}(({<[]<>>{()()}}<<[][]>>){({()[]
<([<{((({({[<(()[])[{}]>({[]()})]<<[[]]>>}<[[{[]{}}[{}{}]]([{}[]]{(){}})]({(<>())})>)}({<[{{{}
({{([(<<{({(<(<><>)<{}<>>><<{}()>[()()]>){<{{}()}(<>[]>>}})}>>[<<<{(({{}<>}(()[])){<[][]><{}>})
[<((<<{{<[[[[{[]()}][{[]{}}(<>())]]]]{<<{(()<>)((){})}<[<>[]]{[][]}>>(<(()())(()[])><{{}<>}({}())>)>[<<[(
[(<<(<<[(([{((()())<<><>>}[{()<>}({}<>)]}]{{<(<>[]){(){}}>([<>()]({}{}))}})<<(<[[][]][[][]]>[([][]){(){
<[([[<<[{(<([([]{}){{}<>}][{()}([][])])>)({<({(){}}){[[]{}][()()]}>{{{[]()}({}{})}(<[]{}><<>()>)}}[{[<[]()><
{<{<[[{({<[<<({})<()[]>>((<>{})<[]{}>)>]>})}((<[[(<<{}{}>{[][]}>)<<[()[]]{<>{}}>{{()[]}[()]}>]<({[
[({({(<<<<<[[<[]{}>]{<<>{}><[]{}>}]><<<([]{})<{}[]>><[{}[]][()<>]>>[[<{}[]>{[]}](<{}()>[{}<>])]>>>>{<{([((
<({[({<{[<({{<()[]]}[{()[]}[{}<>]]}{[{()<>}{<><>}]([[][]]<[]<>>)})>[[[(<()<>>({}[]))<[(){}]<<><>>>]][[<({}{}
{<(<<(([[{(<[[()[]]<()[]>]{<()<>><()[]>}><{<[]{}>{()()}}>)([([(){}]{<>{}})[{<>{}}[<>{}]]]<<[[]{}]{()
{[([[{[<[<{(<<[]{}]>({<><>}({})))([{{}<>}]<{()<>}[{}[]]>)}<([(()[])<()()>])<{{[]{}}[{}()]}(<<><>>[()()]
<<[{<[({((<<({{}()}{()[]})>[<<{}{}>{<><>}>]>){{<[{[]()}[[]()]]{[{}[]]}>[{<{}{}>{[]<>}}([{}[]]((){}))]}(
<<{((([[({<{[(()<>)<()[]>]({()[]}({}<>))}{{{[]<>}[{}[]]}[{<><>}]}>}<[[([{}()]{(){}})<({}<>)[[]()
{(([({{(([<{{{<>()}<<>()>}[{<>()}(()())]}>]{(<([()<>]{()<>}){{()<>}}><<{{}}{[][]}>(<(){}><{
{<(({{[<([(<<([][])(<>()]>{{{}{}}{[]<>}}>)[{(<()[]>{<>{}})[{()[]}<[]<>>]}{<{{}[]}><<{}>[{}<>
(<{{([<[[{{[{[[]()][()()]}{<<>{}>}][{{<>()}<()()>}(((){}){<>{}})]}{<(({}()))<[(){}]<(){}>>>(<({}[]>[[][]]>)}}
(({({[({<{{{[[()()]({}())]}[([{}]<{}()>)([{}()]{{}{}})]}[((<{}<>><()()>))]}[{{{(<>{}){<><>)}[<()()
(<({{<([{[([[({}<>)][([]<>){[]{}]]][[<()[]>]])][<{[[{}[]](())]<<()[]>(())>}{<{{}[]}[<>{}]>{<[]<>>
(([[([([<[{[(({}[])<[]{}>)]}][[{({()<>}[{}[]])(([]())(()<>))}<[<[]{}>({}<>)]{{{}{}}{[][]}}>]{{{
<[{[{<<{[[<{(({})(<>{}]){([]())[[]()]}}{(<()()>([]())){([]{})<[][]>}}>]{({[[<><>]{[]()}](<{}[]><[]<>>)}
([{<({{([([[{{()[]}}({(){}}[<>{}])>]({{(())([]<>)}<[()<>][[]()]>}([{()[]}{()()}])))](([[[{<>{}}[<>(
<[[[(<[{{[[{{{<>[]><<>>}[{()[]}({}())]}[<[{}<>]<[][]>>]]]}{{({{{<>()}{()<>}}<<{}[]>({}[])>}[[(<><
[[<[<({<[({{[[<>{}][[]{}]]{<()()>{<>{}}}}[<<<>{}><[]<>>><<{}<>>(()[])>]}){<[(([]())[<>()))[({}[])<
<<(<<<<((([[<<{}[]>(<>())>]]<{{[[]<>]<[]>}{[{}()]{<>[]}}}<[[<>{}]({}())]>>)){{([(({}[])({}[]
([{<([<[[[{[[{<>[]}{[]()}>([[]])]<({{}{}}({}[])){(<>{})<()()>}>}<{(([]()){()<>})[{<>{}}{<>()}]}<(([]
<{[<(({([[((((<>[])[[]{}])({[][]}))(<[()<>]{<><>}>)){<<{<>[]}<<>()}>>{({{}{}}(()()))}}]][{
({<{<<<{{{(((([]())[<>]){<(){}><{}[]>})<{([]<>)[<><>]}[{()<>}({}<>)]>){((<[]()>[<>{}]){<()<>>(
[{<(([(<[((([[(){}]{[]()}])))]>)[<{(<<[<<>[]><()()>]>>){[<{{(){}}({}[])}([{}()][<>])><((()<>)[[]])[[{}()](<>
{<<[<{[(<{<([{()[]}({}<>)]{[{}<>][{}()]})([{<>{}}<<>>])>{(<{{}())<{}()>>(({}[])<<>()>))[({<>()}[()[]])<<{}<>
[<([<<<[({([<<(){}><{}[]>>[[<>{}][{}<>]]]<[<()[]><(){}>]([<>{}][<>[]])>)<<{<[]<>>[[]{}]}<({}(
<[[(<[{[[({{{<<>[]][{}[]]}[[[]{}]]}}){{[[(<>{})(()<>)]({<>()})]({({}{})<[]{}>}[<()<>>])}{<{[()[]]}[<
<(<(<((<[((([[<>()]]){<[<>[]]><([]{})>})[<<{<>()}{{}<>}>(((){})[<>[]])>{[[<>()][{}[]]](([][])([]))}])((
[(<{{<(((<<{[[<>[]]]{([]<>)<{}[]>}}[<{{}{}}[{}()]><{[]()}[{}]>]>{[<{{}[]}([]<>)>[[(){}][()()]]]
<(<(([[{[<<<(({}))[{[][]}]>[[([]{})({}[])]]>[<<(<>[]){<>[]}><[()<>]>)<[{{}<>}(<>{})]{[<>()]{{}{}}}>]>{[{<{
({<({{{[[(([<<()[]><<><>>>])(<((<>()))(<<><>><[]<>>)>)){{({[[]()]{[]<>}}[[{}[]]<[]()>])}({({()()}<[]()
{{{<[<{<{[<(<{[]()}><[()[]]{[][]}>){<<[]>[<><>]>([<>()][<>()])}>)<<<(([]())[<>[]]){[[][]](<>{})}><([(){}]{{}{
<[((<<<({<[((<{}<>>[[]{}})((<>[])))({<()()>{<><>}}{(<><>){(){}}})][[<<[]>>[{<>[]}{[]()}]]([{
(((<<{<({<[[[{()()}(()<>))(<()[]>((){}))][{({}[])[{}()]}<<{}{}>{()()}>]]>})<<{{<[[<>{}]<[][]>]((<><
[<[{[[{{<{[(<<<>[]><{}()>>)({[{}[]]}((<>())<()[]]))]{{({()[]}([]<>)){{<>[]}[[][]]}}}}{({(<<>[]>{[]})[[{}
<<[({[[[[([<(<<>[]>{()[]})>{<[()<>]>[[[]<>]({})]}]<(<{{}}([])>[<{}()>])[{{<>()}<(){}>}<<<>{}}[{}{}]>]
([(((([[<[{({<{}>})<([{}<>][(){}])<<[]()><()[]>>>]{[([<>[]](()()))[{{}[]}[{}<>]]]({({}<>)[<>()]}<{()<>}{[]{
[[<{[{<{{(<(<[<>{}]><([]{})[{}<>]>)>{{[{<>[]}[{}()]]<<()>{[]}>}[[((){})([])]{<<>()>([][])}]})
{<[{{{<{([<[<{{}{}}[[]{}]><{{}[]}>]{(<{}<>><{}[]>)(<(){}><()()>)}>]<<<({{}}(<>()))[<{}[]>(<>{})]>({<[]>{()<
{<[{[<(({[{{({{}[]}[()[]]}}<(([]())[()[]]){(()){<>()}}>}[<<{<><>}>[([]{}){{}<>}]>[{{<>{}}{()[]}}
<{[{([<{<((<[<()[]>{[][]}]<<()[]><<>{}>>><([<><>]<()()>)({{}()}<(){}>)>){<(([][]){[][]})(<[]><{}{}>)>
(([<((((({{{[<()[]]{{}<>}]{<()()>({}<>)}}([[{}()]<<>>][((){})<<>[]>])}}(<{{[(){}]{()()}}}{([{}()
<<<((<[[{[<([<{}<>>(<><>)]<{[]<>}<[]<>>>)>]{([{[[]<>][<>()]}({[]<>}<<>[]>)])[[{{<>[]}(()())}
{<(<<<(({{(((([]<>)(<>[]))))}[(([[[][]][{}()]])<<(<>{}><{}{}>>{(()[])([]())}>)]}([({((<>){[]<>}){<[][]
({(([[[[<{[{(<{}[]>[{}<>])(<[]<>>({}[]))}{([<><>]{{}{}}){{{}[]}[[][]]}}]<[((()[])([]<>))[{[][]
[<([[([[<({({<[]()>}<[[]()]([]<>)>)([[()[]]]{[<>{}][()()]})))>]<({{[{<{}{}>}{{()()}[<>[]]}]{([{
({<<{{({[{[{{[[]<>]<(){}>}<<<>{}>({}{})>}<{[{}<>]}(<[]>[()[]]))]}]<<<<<{(){}}<<>[]>>{<[]{}>{(){}}
(({<([<((<((({{}[]}[[]()])){{[[]()]<[]{}>}(<[][]>{<>})})({{[()()]{{}<>}}(({}{})[<><>])}[[([]{})[
({{[(<{{<<<<[{{}{}}{{}{}}][<[]()>[[]()]]>([{{}}<[]<>>][<[]{}>{()<>}])>[<{({}{})({}<>>}[<{}<>>[<>()]]>]><<
{[((({{(<(<{[{[]()}}<<[][]>(<>[])>}<(<[]()><()<>>){[<><>]<<>()>}>><[{<()[]>}{[{}[]](<>{})}]>)<({<{<><>}>}{
[(([{([<<<([[(()())][([]{})[<>{}]]]({((){})((){})}(([][])[()<>])))[<((<>())[<>{}])>{{[[]<>](
<(({<([(<<<{([{}[]]<[]>)}({{<>{}}[[]{}]}(<{}[]>(()<>)))>>({<{<<>()>((){})}((()())[<>{}])><[<[]()>]{<
[<[{({<[({[(<[{}[]]{[]<>}>(({}{}){{}[]}))(<{()[]}>)]{<([[][]][{}<>])<<<>{}>>>{{((){}){()()}}<{{}}
[<([{<(<(<<{([[]<>]{(){}})((()<>)[[]])}<[<{}()>]<{<><>}<{}{}>>>>([{({}<>){{}()}}]<((()()))<<[][]>
({[{((<{[{([<{()()}{<>()}>[[()[]]]])}[{([[{}]{<>{}}]({[]()}[{}[]]))<{<{}<>>}>}]][[[(<({}{}){{}
[[<{{<{[([(<([[]<>][()<>]))[[[<>[]]]({()()}([][]))])(([[[][]]([]())])<{{{}<>}([]{})}<{[][]}{
<<({<[{[<{<<([<>()]({}<>))][([{}()][{}[]])]>}>]}{[<[[[[[[]{}]<{}>]<<{}()>{()[]}>]][<{({}())
(<<[({[([([[(<<>{}>){[(){}][()]}][[[(){}]{[]<>}]]]<[([<>[]]([]))[{{}<>}{()()}]]<[<{}[]>(()())]<<<><>>{{}[]
{([[[<[(<({<{{{}{}}[[]<>]}<[()[]]{<>[]}>>}<<<(()())<{}[]>>[([][])<<><>>]>[(((){})(()[])){<{}()>(()[])
{[<{[[[((<{[{[[]<>]{{}()}}[{{}<>}{<><>}]][<<()<>>{<>{}}>[{[]{}}((){})>]}(<[<[][]>({}())]<[<>[]](()[])
{({(<<{({({([<(){}>[()()]](<[]><[]<>>))([{<>()}<{}<>>]{<[]<>>[[][]]})})({[(([]<>)[[]])]{([[]{}]{{}()}
{{[<{<<{<{({(({}()))[<<>{}]{()()}]}({{[]{}}([][])}[<<>()>{[]<>}]))}>(<<[{<[]()><<>{}>}]{((<>[]))<(
{{[<[{<(([({([{}{}]({}[]))<<()>(<>[])>})[<<{[][]}<[]()>><{{}[]}<<>{}>>>{{{{}{}}{<>{}}}([{}
[[([(<{{[{{{{{()()}[[][]]}([{}()](<>))}<{<<>[]>[{}[]]}<<{}()>>>}}]<<[{[<{}>({})](<()[]>)}](<<<[][]>(
{<[([{{{((<{((<>())){<[]<>>}}<<{<><>}[<>{}]>{{()[]}(()[])}>>{{{<()()>[[]{}]}[[<><>]<[]()>]}([{{}}{()()}][(<>[
[{<{[([((<(<(((){})[<>]){({}[])<{}<>>}>(((()())([]{}))<[()()]{[]{}}>))([((()<>)<{}()})<{{}[]}<<>
{(({{{<[<({([<{}()>]{<<><>>{<><>}})}){<(((<>[])<[][]>)(<[]<>>{{}<>}))(<{<>{}}<()[]>>[[{}[]]({}())])>
{<([{(<{<<{(<{()}{<>[]}>)([[{}()]{<>{}}]<({}{})>)}[<<<()[]>({}<>)>[<[]>[<>{}]]><(<{}()>[<>{}])>]
<{{{{(({{{[{<[[][]]<()<>>>}[({{}[]}([]<>))({{}{}}{<>()>)]]}}}([{<{{<{}<>><<><>>}}{([{}<>]<<>{}>)
{<[<<{<([[[[[[<>[]](()[])]({{}[]}<{}>)][((()())({}()))<{{}[]}(<>())>]]([<[{}[]][<>[]]>]<{([]{})}{(
{<{[[([<([[[(<()()>({}[]))[{()[]}]]((({}[]><()()>)[({}){[]<>}])]]{<<{<()[]>}{<<>[]>{<>()}}>><[{(()<>)({}<
[[<[[<{{{{<<{{[][]}<(){}>}><{([]())[[]<>]}<<{}[]>(<>())>>>}<{{[[(){}]<<>()>]<{{}()}[[][]]>}}<(<<(
<[[(({({(({{{([]{}){<>{}}}{[<><>]{[]<>}}}}))[({[[({}<>){<><>}]{<<>{}><<><>>}]}[<{<{}<>>(<>{})}(([
({<<([{[<[<([((){})([]())][(()<>)({}[])]){{[{}()]({}[])}[{{}()}{{}()}]}>{{({<>[]}{<>})[<(){}>
<(<{<[<{({{[<{{}[]}{[]<>)>][{[{}{}][()<>]}(<[]<>>[[]{}])]}(([[[]<>]{()()}]<[{}[]]{<>{}}>)((([][]))
<{<(<<((<<[[{<()()><<><>>}<(()<>)({}<>)>>[<<[][]>(<><>)>{(<>[])}]](<{<()[]>([]())}[{<><>}<{}[]>]>)>>{(
{(({(<(<<[[[{<<>()><{}()>}[[<><>]{()<>>]]{[{(){}}]}]]>>)(<<(<({([]())<<><>>}({[]()}({}<>)))>
<{<<[<<{[<([[(()())<<><>>][<<>[]>(<>())]]({<{}{}><<><>>}{[{}]<<>[]>})){[{{[]}<{}[]>}[[(){}]{[]<>}]]
({[[{<[([[[{[[(){}]{[][]}]<({}[])({}())>}{{<()[]>{<><>}}<{<>}>}]{<<<()<>]{<>{}}>[<[]<>>{{}()}]><[<<
<{{{([({<{{([{()}[()<>]][(<>())(())])([({}[])[{}{}]]({{}{})([]())))}{(<[<>()]{()<>}><[()<>][<>[]]
((<[(<[(({{(<<(){}>{(){}}>({()[]}[<>[]]))<(((){})({}()))<<[]{}><()[]>>>}})<[{([<<>{}>]){<{<>{}}{()<>}>}}{{(
"""

let testNavSystem = try NavigationSubsystem(input: testInput)
print(testNavSystem.corruptionScore)
print(testNavSystem.fixScore)

let navSystem = try NavigationSubsystem(input: input)
print(navSystem.corruptionScore)
print(navSystem.fixScore)
