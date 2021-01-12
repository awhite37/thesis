
/*
This program cannot pass the type checking,
a1 is moved in the if-then-else,
therefore it cannot move to q
*/

main :=: fnTy(;;void)

fun main() newlft
let a1 = new(i32) in {
let a2 = new(i32) in {
let a3 = new(i32) in {
let y in {
if ( *a3 <= 1) then
       { y := a1}  else { y := a2};
        let q = a1 in {void} 
}}}}

endlft