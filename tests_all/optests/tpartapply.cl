
fn f(x, y) {(*na x) + (*na y)};
fn f1(f,z) {f(z)};
let x = allocate(1) in
(
	x :=na 1;
	(
		let y = allocate(1) in
		(y :=na 2; f1(f(x),y) )
	)

)

