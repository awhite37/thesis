/*
	1. i32: capability
	2. i32: head
	3. i32: tail
*/

Queue :=: prodTy(i32,i32,i32,own(array(i32)))
Option :=: sumTy(bool,i32) 

get   :=: fnTy('a;ref('a,mut,own(ty(Queue))); own(ty(Option)))
put   :=: fnTy('a;i32,ref('a,mut,own(ty(Queue)));bool)
main  :=: fnTy(;;void)
for   :=: fnTy(;ref('a,mut,own(ty(Queue))),i32; void)

fun get(q) newlft
    let return = new(ty(Option)) in {
        if ((*q).(3)-(*q).(2) = (*q).(1)) then { return :=inj 2 (*q).(4).((*q).(2))} else {return :=inj 1 true};
        (*q).(2) := (*q).(2) + 1;
       return
    }

endlft

fun put(e,q) newlft
    let return in {
        if ((*q).(3)-(*q).(2) = 0) then {return := false} else {
	   (*q).(4).((*q).(3) mod q.(0)) := e;
	   (*q).(3) := (*q).(3) + 1;
	   return := true
	};
	return
    }
endlft

fun for(q,i) newlft
    if (i > 0) then {
       call put(i,q);
       call for(q, i - 1)
    } else {
      void
    }
endlft

fun main() newlft

    let mut q = new(ty(Queue)) in {
    	q.(1) := 5;
	q.(2) := 0;
	q.(3) := 0;
	q.(4) := new(i32,5);
	call for(& mut q, 6);
	let re = call get(& mut q) in{
	    case re of {false, re.(1) = 6}
	}
    }
	
endlft




