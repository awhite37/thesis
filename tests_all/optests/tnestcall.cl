
fn sumfromOne(n) {case n == 0 of {
   n + (let n1 = 0 in (n1 := n - 1; sumfromOne(n1))), 0}
};

let x = 100 in (sumfromOne(x))
