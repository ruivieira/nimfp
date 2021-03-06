import ../../src/fp/list, ../../src/fp/option, unittest, future

suite "List ADT":

  test "List - Initialization and conversion":
    let lst = [1, 2, 3, 4, 5].asList

    check: lst.head == 1
    check: lst.headOption == some(1)
    check: lst.tail.asSeq == @[2, 3, 4, 5]
    check: Nil[int]().headOption == 1.none
    check: $lst == "List(1, 2, 3, 4, 5)"
    check: 1^^2^^3^^4^^5^^Nil[int]() == lst
    check: ["a", "b"].asList != ["a", "b", "c"].asList

  test "List - Fold operations":
    let lst = lc[x|(x <- 1..4),int].asList

    check: lst.foldLeft(0, (x, y) => x + y) == 10
    check: lst.foldLeft(1, (x, y) => x * y) == 24

    check: lst.foldRight(0, (x, y) => x + y) == 10
    check: lst.foldRight(1, (x, y) => x * y) == 24

    check: Nil[int]().foldRight(100, (x, y) => x + y) == 100

  test "List - Transformations":
    check: @[1, 2, 3].asList.traverse((x: int) => x.some) == @[1, 2, 3].asList.some
    check: @[1, 2, 3].asList.traverse((x: int) => (if x > 2: x.none else: x.some)) == List[int].none

    check: @[1.some, 2.some, 3.some].asList.sequence == @[1, 2, 3].asList.some
    check: @[1.some, 2.none, 3.some].asList.sequence == List[int].none

  test "List - Drop operations":
    let lst = lc[x|(x <- 1..100),int].asList

    check: lst.drop(99) == [100].asList
    check: lst.dropWhile((x: int) => x < 100) == [100].asList

  test "List - Misc functions":
    let lst = lc[$x | (x <- 'a'..'z'), string].asList
    check: lst.dup == lst
    check: lst.reverse == lc[$(('z'.int - x).char) | (x <- 0..('z'.int - 'a'.int)), string].asList
    check: asList(2, 4, 6, 8).forAll((x: int) => x mod 2 == 0) == true
    check: asList(2, 4, 6, 9).forAll((x: int) => x mod 2 == 0) == false
    check: asList(1, 2, 3).zip(asList('a', 'b', 'c')) == asList((1, 'a'), (2, 'b'), (3, 'c'))
    check: asList((1, 'a'), (2, 'b'), (3, 'c')).unzip == (asList(1, 2, 3), asList('a', 'b', 'c'))

  test "List - Iterator":
    let lst1 = [1, 2, 3, 4, 5].asList
    var lst2 = Nil[int]()
    for x in lst1:
      lst2 = Cons(x, lst2)
    check: lst2 == lst1.reverse
