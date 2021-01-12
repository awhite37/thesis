

XT    :=: prodTy(own(i32))
Point :=: prodTy(own(ty(XT)),own(i32))
f     :=: fnTy(;;i32)
f1    :=: fnTy(;i32;i32)
K     :=: contTy(i32)

fun f()
newlft

	let p = new(ty(Point)) in {
	let x = new(ty(XT)) in
	{
		p.1 := x;
		let z = p.1.1 in 
		{ z }
	};
	5
	}
endlft

