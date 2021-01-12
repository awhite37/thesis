
fn f() {
   let x = allocate(1) in
       ( x := na 1;
       	 case * na x of {x :=na 3, x :=na 2, x:=na 4, x:=na 1 };
	 fork { x := na 3}
       )
};

f()
