/*This program cannot pass type checking, since x is firstly mutable borrowed*/

main :=: fnTy(;;own(i32))

fun main() newlft

    let x = new(i32) in {
    let y = * ( & mut x) in {y} }

endlft