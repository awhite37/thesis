

f :=: fnTy('a ;
	   ref('a,imm,own(i32)),
	   own(i32) 	        ;
	   ref('a,imm,own(i32)));
funrec f(x,y) ret C
newlft

	let y = new(i32) in
	let a = & imm y in
	let b = & imm a in
	let c = & imm b in
	let p = & mut c in
	let tt = & imm p in
	let q = * p in
	x

endlft
