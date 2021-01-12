
/*
The book of Rust, page 74

This is the wrong example corresponding to t5.r
In t5.r let y = & mut x is wrapped in a new lifetime,

*/

main :=: fnTy(;;void)

fun main()
newlft
	let mut x = new(i32) in {
	*x := 5;
	let y = & mut x in
	{**y = (**y) + 1};
	let z = & imm x in {void}
	}
endlft