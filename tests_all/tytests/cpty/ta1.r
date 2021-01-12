
main :=: fnTy(;;own(i32))

fun main()
newlft
let x = new(i32) in { *x := 1;
let y = x in
 {
 y
 }
}
endlft