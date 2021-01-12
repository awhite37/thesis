
require "tydef.k"
require "configuration.k"
require "lang.k"

module WELLFORM

imports TYDEF
imports CONFIGURATION
imports LANG

syntax WellFormItem
       ::= wellform(RType)
         | wellform(Int,RType)
         | wellform(RType,List)
	 | wellform(RValue,RType)

/*
rule <k> wellform(X:Ident,own(_,T:RType)) => wellform(var(I),own(_,T)) ... </k>
     <env> ... X |-> I:Int ... </env>

rule wellform(_,ref(L,_,_),Ls:List) => .
     require (L in Ls)
*/

rule <k> wellform(_,ty(T:Ident)) => . ...</k>
     <typeCtx> ... T |-> C ... </typeCtx> 

rule wellform(ref(L:Lftvar,_,_),Ls:List) => . 
     requires (L in Ls)

/*
rule wellform(i32) => .
rule wellform(own(T:RType)) => .
*/
rule wellform(_,i32) => .


endmodule