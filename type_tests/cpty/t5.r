
/*
This program cannot pass the type checking, since z is declared after
the declaration of y
*/

main :=: fnTy(;;void)

fun main() newlft


let mut x = new(i32) in {

newlft
	let y = & mut x in {
	let mut z = new(i32) in
	{
		y := & mut z 
	}}
endlft ;

newlft

	let t = x in {
	t}

endlft
}
endlft