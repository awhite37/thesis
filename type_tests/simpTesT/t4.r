
/*
This program cannot pass, since b is not mutable, therefore it cannot be mutable borrowed
*/

f :=: fnTy('a ;
	   ref('a,imm,own(i32)),
	   own(i32) 	        ;
	   ref('a,imm,own(i32)))
fun f(x,y)
newlft
	let a = new(i32) in {
	let b = new(i32) in {
	let c = & mut a in
	{
		c := & mut b;
		let d = a in
		{x}
	} }}
	
endlft
