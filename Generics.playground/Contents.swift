/*
 Generic Functions
*/

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
print(someInt, anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
print(someString, anotherString)

/*
 Generic Types
 */

struct Stack<Element> {
    private var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
let fromTheTop = stackOfStrings.pop()

/*
 Extending a Generic Type
*/

extension Stack {
    var topItem: Element? {
        return items.last
    }
}

print(String(describing: stackOfStrings.topItem))

/*
 Type Constraints
 */

func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])

/*
 Associated Types
 */

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct IntStack {
    private var items = [Int]()
    private mutating func push(_ item: Int) {
        items.append(item)
    }
    private mutating func pop() -> Int {
        return items.removeLast()
    }
}

extension IntStack: Container {
    typealias Item = Int
    mutating func append(_ item: Item) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Item {
        return items[i]
    }
}

var stackOfInts = IntStack()
stackOfInts.append(1)
stackOfInts.append(2)
stackOfInts.append(3)
print(stackOfInts.count)

// Conform Generic Type to Associated Type
extension Stack: Container {
    typealias Item = Element
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

print(stackOfStrings.count)

// Extending an Existing Type to Specify an Associated Type
extension Array: Container {}

// Adding Constraints to an Associated Type
protocol EqualityCheckable {
    associatedtype Item: Equatable
    func equal(lhs: Item, rhs: Item) -> Bool
}

struct EqualityChecker<Item: Equatable>: EqualityCheckable {
    func equal(lhs: Item, rhs: Item) -> Bool {
        return lhs == rhs
    }
}

let equalityChecker = EqualityChecker<Int>()
print(equalityChecker.equal(lhs: 5, rhs: 5))
print(equalityChecker.equal(lhs: 5, rhs: 100))

// Using a Protocol in Its Associated Type’s Constraints
protocol SuffixableContainer {
    associatedtype Suffix: SuffixableContainer
    func suffix(_ size: Int) -> Suffix
}

extension Stack: SuffixableContainer {
    typealias Suffix = Stack
    func suffix(_ size: Int) -> Suffix {
        var newStack = Stack<Element>()
        newStack.items = Array<Element>(self.items.suffix(size))
        return newStack
    }
}

let stackSuffix = stackOfStrings.suffix(2)
print(stackOfStrings)
print(stackSuffix)

/*
 Generic Where Clauses
 */

func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {
        
        // Check that both containers contain the same number of items.
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // Check each pair of items to see if they're equivalent.
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // All items match, so return true.
        return true
}

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}

// Extensions with a Generic Where Clause
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

if stackOfStrings.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element is something else.")
}

//
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}

//
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
print([1260.0, 1200.0, 98.6, 37.0].average())

// Associated Types with a Generic Where Clause
protocol List {
    associatedtype Item
    func add(item: Item)
    func remove(item: Item)
    
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

/*
 Generic Subscripts
*/

extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
