/*
This exampe from https://rustbyexample.com/scope/borrow.html

Most of the time, we'd like to access data without taking ownership over it. To accomplish this, Rust uses a borrowing mechanism. Instead of passing objects by-value (T), objects can be passed by reference (&T).

*/

eatBox :=: fnTy(; own(i32); void)
borrows :=: fnTy('a;ref('a,imm,own(i32));void)
main  :=: fnTy(;;void)

fun eatBox(a) newlft void endlft

fun borrows(a) newlft void endlft

fun main()
newlft

	let a = new(i32) in {
	    *a := 5;
	    call borrows(& imm a);
	    newlft
		let b = & imm a in {
		    void
		    //call eatBox(a)  //a cannot be eat, since it is borrowed by b
		}
	    endlft;
	    call eatBox(a)
	}

endlft