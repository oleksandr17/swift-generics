//
// Generic Functions

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var a = 0
var b = 9
swapTwoValues(&a, &b)
print(a)
print(b)

var c = "hello"
var d = "world"
swapTwoValues(&c, &d)
print(c)
print(d)
