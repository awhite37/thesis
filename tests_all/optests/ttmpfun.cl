

fn f(x) { ((fn f1(x){ (* na x) + 1 })(x)) };
let x = allocate(1) in (x :=na 1; f(x))