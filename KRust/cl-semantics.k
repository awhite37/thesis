
require "cl-syntax.k"
require "configuration.k"
require "memory.k"

module CL-SEMANTICS

imports CL-SYNTAX
imports CONFIGURATION
imports MEMORY
imports DOMAINS-SYNTAX

syntax KResult
       ::= Value
         | ValList

syntax FnItem
       ::= fnCalls(Int, FnParams, ValList)  [strict(3)]
         | computeFunBody(KItem)  [strict]
	 | lazyCall(Exp, ExpList)	[strict(1)]
	 | lazyCall1(Int, FnParams, ExpList)	[strict(3)]	


rule <k> fn F:Id ( P:FnParams ) { E:Exp }=> cr(C) ... </k>
     (.Bag => 
     	<closure>
	   <crId> C </crId>
	   <crContext> Rho </crContext>
	   <crParams> P </crParams>
           <crBody> E </crBody>
	</closure>
     )
     <env> Rho:Map </env>
     <closureCnt> C:Int => C +Int 1 </closureCnt>
     <funclosure> .Map => F |-> C ...  </funclosure>

rule <k> fn ( P:FnParams ) { E:Exp } => cr(C) ... </k>
     (.Bag => 
     	<closure>
	   <crId> C </crId>
	   <crContext> Rho </crContext>
	   <crParams> P </crParams>
           <crBody> E </crBody>
	</closure>
     )
     <env> Rho:Map </env>
     <closureCnt> C:Int => C +Int 1 </closureCnt>


rule <k> lazyCall(cr(I:Int),EL:ExpList) => lazyCall1(I,P,EL)  ... </k>
     <crId> I </crId>
     <crParams> P:FnParams </crParams>
     <crContext> Rho:Map </crContext>
     <env> Rho1:Map => Rho </env>
     <clstack> .List => ListItem(Rho1) ... </clstack>


rule lazyCall1(I,P:FnParams,V) => fnCalls(I,P,V)


rule <k> cr(I:Int) (V) => fnCalls(I,P,V)  ... </k>
     <crId> I </crId>
     <crParams> P:FnParams </crParams>
     <crContext> Rho:Map </crContext>
     <env> Rho1:Map => Rho </env>
     <clstack> .List => ListItem(Rho1) ... </clstack> 

syntax ItemFn
       ::= InitParam(Ident,Value)


rule fnCalls(I:Int, (X:Ident, RestP:FnParams), (V:Value, RestVl:ValList)) =>
     	 InitParam(X,V) ~> fnCalls(I,RestP,RestVl)


rule InitParam(#anonymous, _:Value) => .


/*@

 I don't know whether the following two rules can merge
 
*/
rule <k> InitParam(X:Id, V:Value) => . ... </k>
     <env> Rho:Map (.Map => (X |-> V))  </env>
     requires notBool (X in keys(Rho))

rule <k> InitParam(X:Id, V:Value) => . ... </k>
     <env> ... (X |-> (_ => V)) ...  </env>


rule <k> fnCalls(I, .FnParams, .ValList) => computeFunBody(B) ... </k>
     <crId> I </crId>
     <crBody> B:Exp </crBody>
     <env> ME:Map </env>
     <funclosure> FE:Map </funclosure>
     requires (I in values(ME)) orBool (I in values(FE))

rule <k> fnCalls(I, .FnParams, .ValList) => computeFunBody(B) ... </k>
     (<closure>
	<crId> I </crId>
     	<crBody> B:Exp </crBody>
	...
     </closure> => .Bag)
     <env> ME:Map </env>
     <funclosure> FE:Map </funclosure>
     requires notBool ((I in values(ME)) orBool (I in values(FE)))


rule <k> fnCalls(I:Int, (X:Ident, RestP:FnParams), .ValList) => cr(C) ... </k>
     <closure>
	<crId> I </crId>
     	<crBody> E </crBody>
	...
     </closure>
     (.Bag => 
     	<closure>
	   <crId> C </crId>
	   <crContext> Rho </crContext>
	   <crParams> (X,RestP) </crParams>
           <crBody> E </crBody>
	</closure>
     )
     <closureCnt> C:Int => C +Int 1 </closureCnt>
     <env> Rho:Map => Rho1 </env>
     <clstack> ListItem(Rho1) => .List ... </clstack>


rule <k> computeFunBody(V:Value) => V ... </k> 
     <env> _ => Rho </env>
     <clstack> ListItem(Rho) => .List ... </clstack>
    



rule X:Int + Y:Int => X +Int Y
rule X:Int - Y:Int => X -Int Y
rule X:Int <= Y:Int => X <=Int Y
rule X:Int < Y:Int => X <Int Y
rule X:Int == Y:Int => X ==Int Y
rule X:Int > Y:Int => X >Int Y
rule X:Int mod Y:Int => X modInt Y
rule false => 0
rule true  => 1

rule <k> X:Id => V:Value ... </k>
     <env> ... X |-> V ...</env>  [lookup]


rule location(A:Int,0)[ J:Int ] => location(A,J)


rule <k> F:Id => cr(I) ... </k>
     <funclosure>  ... (F |-> I:Int) ...  </funclosure>
     <env> Rho:Map  </env>
     requires notBool (F in keys(Rho))
     


/*@
  The semantics of case
**************************/

syntax CaseItem
       ::= caseItem(Int, ExpList)

rule case I:Int of { EL:ExpList}  => caseItem(I, EL)  

rule <k> caseItem(I:Int,_:Exp,EL:ExpList)
     	    => caseItem(I-Int 1, EL) ...  </k> requires I >Int 0 

rule caseItem(0,E:Exp,EL:ExpList) => E


/*@
  The semantics of fork
**************************/

rule <k> fork { E:Exp } => 0 ... </k>
     <env> R </env>
     (.Bag =>
      <thread>
	  <k> E </k>
	  <env> R </env>
	  <clstack> .List </clstack>
      </thread>
     )

/*@
  The semantics of assignment
*******************************/

//anonymous assignment
/* The following two rules need to reconsidered*/

/*
Heap Assignment
*/
rule <k> #anonymous := _:Order V:Value => unit ... </k>

rule <k> X:Id := O:Order V:Value => location(A,I) := O V  ... </k>
     <env> ... (X |-> location(A:Int,I:Int)) ...  </env>


/*
	Stack Assignment
*/

rule <k> X:Id := V:Value => unit ... </k>
     <env> ... (X |-> (_ => V)) ...  </env>

rule location(A:Int, I:Int) := sc V:Value  => writesc(address(A),I,V)
rule location(A:Int, I:Int) := na V:Value  => writena(address(A),I,V)


/*@
	The Semantics of Dereference
*/

rule  * sc location(A:Int,I:Int) => readsc(address(A),I)
rule  * na location(A:Int,I:Int) => readna(address(A),I)

rule clskip => unit

endmodule


