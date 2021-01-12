//This is equal the Rust program
// fn f(X:Box<i32>,Y:Box<i32>) { match X {1 => x + 1; 2 => x + y; 3 => x - y}}
// let x = Box::new(1);
// let y = Box::new(3);
// f(x,y)

fn f(X,Y) {  case (*sc X) of
	     {
		(*sc X)+1 ,
		(*sc X) + (*sc Y),
		(*sc X) - (*sc Y)
	     }
	  };
let x = allocate(1) in
 (  x := na 1;
    let y = allocate(1) in
    (y :=na 3;
    f(x,y))
  )



