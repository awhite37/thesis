/*
This example from https://rustbyexample.com/scope/move.html
Because variables are in charge of freeing their own resources, resources can only have one owner. This also prevents resources from being freed more than once. Note that not all variables own resources (e.g. references).

When doing assignments (let x = y) or passing function arguments by value (foo(x)), the ownership of the resources is transferred. In Rust-speak, this is known as a move.

After moving resources, the previous owner can no longer be used. This avoids creating dangling pointers.
*/

destroy :=: fnTy(;own(i32);void)
main :=: fnTy(;;void)

/*This function do nothing, but move the argument*/
fun destroy(c)
newlft
	void 
endlft

fun main()
newlft

  let x = 5 in {
       x ;
       let a = new(i32) in {
       	   *a := 4;
	   let b = a in {
	       call destroy(b)
	       //;let t = b in {void} //error b is moved in destroy
	   }
       }
  }



endlft


