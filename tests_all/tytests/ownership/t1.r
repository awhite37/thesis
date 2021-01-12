// 
// Rust Program
// let v = vec![1,2,3,4,5];
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
    	v.0 := 1;
	v.1 := 2;
	v.2 := 3;
	v.3 := 4;
	v.4 := 5;
	call for(v,0)
    }
 endlft 
