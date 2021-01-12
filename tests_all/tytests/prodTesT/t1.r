

Point :=: prodTy(i32,ref('a,imm,own(i32)))
f :=: fnTy(;;i32)
fun f()
newlft
	let b = new(i32) in
	{
	  *b := 4;
	let a = new(ty(Point)) in
	{
	  a.1 := 1;
	  a.2 := & imm b;
	  let c = new(ty(Point)) in
	  {
		c.1 := 2;
		let z = new(i32) in{
		    c.2 := & imm z;
		    let x = & imm a in
		    {if (true) then
		       { x := & imm a}
		    else
		       {x := & imm c};
                     let p = (*x).2 in { **p } 
		    }
		    
		}
	  }
	  
	}
	}

endlft

