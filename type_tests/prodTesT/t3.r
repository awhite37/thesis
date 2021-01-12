
Point :=: prodTy(own(i32),own(i32))
f :=: fnTy(;;i32)
fun f()
newlft

	let mut a = new(ty(Point)) in {
	newlft
	   let x = new(i32) in {
	   let y = new(i32) in {
	   a.(1) := x;
	   a.(2) := y;
	   newlft
		let q = & mut a.(1) in {
		let z = a.(2) in { z } }
	   endlft
	   }}
	endlft;
	newlft
		let z = & imm a.(1) in { z }
	endlft;
	*(a.(1))
	}
endlft

