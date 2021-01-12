
OptionInt :=: sumTy(own(i32),own(i32))
main 	  :=: fnTy(;;void)

fun main()
newlft
let y = new(ty(OptionInt)) in{
let t = new(i32) in {
let k = new(i32) in
{
	y :=inj 1 t;
	y :=inj 2 k
}}}
endlft
