// 
// Rust Program
// let v = vec![1,2,3,4,5];
// for i in v {
//     ....
// }
// for i in v {
//     ....
// }
 

 main1 :=: fnTy( ; ;void)
 
 for :=: fnTy(;own(array(i32)),i32;void)

 fun for (v,i)
 newlft
	if(i <= 5) then
	{
		let k = v.i in {
		call for(v,i+1)}
	}
	else { 1 }
 endlft
 
 
 fun main1()
 newlft
    let v = new(i32,5) in {
    	v.1 := 1;
	v.2 := 2;
	v.3 := 3;
	v.4 := 4;
	v.5 := 5;
	call for(v,1);
	call for(v,1)
    }
 endlft 
