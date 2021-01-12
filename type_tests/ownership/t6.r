
/*
This program come from The book of Rust, page 78

It cannot pass the owership system, because it is a "used after free" error.

x is freed and y try borrow it

*/


main :=: fnTy(;;void)

fun main()
newlft

	let y in
	{
           newlft
	     let x = new(i32) in {
	     	 *x := 5;
		  y := & imm x
	     }
	   endlft;
	   let print = & imm y in {void}
 	}

endlft

