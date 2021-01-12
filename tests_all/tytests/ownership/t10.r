
/*
This example is to check that even though x is borrowed by y.
It can still be moved by t since y is dead
*/

main :=: fnTy(;;void)

fun main() newlft

    let mut x = new(i32) in {
    newlft
	let mut z = new(i32) in
	{
	let y = & mut x in {
		y := & mut z		
	}
	}
    endlft ;

    newlft
	let t = x in {void}
    endlft
    }
    
endlft