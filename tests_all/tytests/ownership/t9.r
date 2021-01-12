
main :=: fnTy(;;void)

fun main()
newlft
let a1 = new(i32) in {
let a2 = new(i32) in {
let a3 = new(i32) in {
let y in {
if ( *a3 <= 1) then
       { y := & imm a1}  else { y := & imm a2};
       let q = y in {let p = & mut y in {void}}
}}}}

endlft