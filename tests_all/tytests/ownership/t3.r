/*
This is the program in the book of Rust on page 69

fn take(v:Vec<i32>){
   //what happens here isn't important
}

fn main(){
   let v = vec![1,2,3];
   take(v)
   let k = v; 
}

This exampe cannot pass the type checking, since v is moved in call to take.
Therefore v cannot be moved to k.

*/

take :=: fnTy(;own(array(i32));void)
main :=: fnTy(;;void)

fun take(v) newlft
    void
endlft

fun main() newlft
    let v = new(i32,3) in {
    	v.0 := 1;
	v.1 := 2;
	v.2 := 3;
	call take(v);
	let k = v in {void}
    }
endlft
