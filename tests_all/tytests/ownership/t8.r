
/*
   This is an example that cannot the passy the ownership checking.
   Because x is borrowed in the reference, but the binding try
   to move the ownership of x to y
*/

main :=: fnTy(;;void)

fun main()
newlft
	let mut x = new(i32) in {
	    let y = * ( & mut x) in {void}
	}
endlft