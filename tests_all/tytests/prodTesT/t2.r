
Point :=: prodTy(own(i32),own(i32))
f :=: fnTy(;;i32)
fun f()
newlft
	let a = new(ty(Point)) in {
	let x = new(i32) in {
		a.1 := x;
		* (a.1) := 3 ;
		a.2 := a.1
	}
	;
	let x = 1 in
	{ x }
	}
endlft

