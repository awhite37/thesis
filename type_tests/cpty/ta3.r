
main :=: fnTy(;;void)
Point :=: prodTy(i32,i32)

fun main()
newlft
let x = new(ty(Point)) in
{
   x.(1) := 2;
   x.(2) := 3
}
endlft
