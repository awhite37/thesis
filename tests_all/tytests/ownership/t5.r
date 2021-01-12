
/*
The book of Rust, page 74
*/

main :=: fnTy(;;void)

fun main()
newlft
	let mut x = new(i32) in {
	*x := 5;
	newlft	
		let y = & mut x in
		{**y = (**y) + 1}
	endlft;
	let z = & imm x in {void}
	}
endlft