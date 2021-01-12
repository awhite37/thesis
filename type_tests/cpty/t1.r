
main :=: fnTy(;;void)

fun main() newlft
    let x = new(i32) in
    { let y = & imm x in { 
      let z = & imm x in { * * z := 3} }}
endlft