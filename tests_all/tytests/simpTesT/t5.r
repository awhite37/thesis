

f :=: fnTy('a ;
	   ref('a,imm,own(i32)),
	   own(i32) 	        ;
	   ref('a,imm,own(i32)))
fun f(x,y)
newlft
	let a = new(i32) in {
	let mut b = a in {
	let c = & mut b in  {x }}}
	
endlft
