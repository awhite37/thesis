 Y   :=: prodTy( own(i32))
 X   :=: prodTy(own(i32),own(ty(Y)))
Point :=: prodTy(own(i32),own(ty(X)))
f :=: fnTy(;;i32)
fun f()
newlft
	let i = new(i32) in {
	let j = new(ty(Y)) in {
	let b = new(ty(X)) in {
	  j.(1) := new(i32);
	  b.(1) := i;
	  b.(2) := j;
	let mut a = new(ty(Point)) in {
	  a.(1) := new(i32);
	  a.(2) := b;
	  let x = & mut a.(1) in {
	  let p = & imm ((a.(2)).(2)).(1) in { **p }}
	}
      }}}

endlft

