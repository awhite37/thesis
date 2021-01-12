
sumvec :=: fnTy('a;ref('a,imm,own(array(i32))),i32; i32)

foo    :=: fnTy('a;ref('a,imm,array(i32)),i32,ref('a,imm,own(array(i32))),i32; i32)

main   :=: fnTy(;;void)

fun sumvec(v,i) newlft
   let r in {
   if (i = 0) then {
      r := (*v).i
   }else{
      r := (*v).i + call sumvec(v,i - 1)
   };
      r
   }
endlft

fun foo(v1,i1,v2,i2) newlft
    let s1 = (call sumvec(v1,i1)) in {
    	let s2 = call sumvec(v2,i2) in
	    { s1 + s2 }
    }
endlft

fun main()newlft
    let v1 = new(i32,3) in {
    	v1.(0) := 1;
	v1.(1) := 2;
	v1.(3) := 3;
	let v2 = new(i32,3) in {
	    v2.(0) := 4;
	    v2.(1) := 5;
	    v2.(1) := 6;
	    let answer = call foo(& imm v1, 3, & imm v2, 3) in {void}
	}
    }
endlft

