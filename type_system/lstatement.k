

require "lexpression.k"

module LSTATEMENT

imports LEXPRESSION

syntax TyCKItem
       ::= processLR(KItem,KItem) [strict]

rule 
     let X:Ident = R:RValue in { E:Exp } =>
     	 	 createVar(X,imm) ~> processLR(lhs(X),R) ~> E
		 
rule 
     let X:Ident in { E:Exp } =>
     	 	 createVar(X,imm) ~> E

rule 
     let M X:Ident = R:RValue in { E:Exp }=>
     	 	 createVar(X,M) ~> processLR(lhs(X),R) ~> E

rule 
     let M X:Ident in { E:Exp }=>
     	 	 createVar(X,M) ~> E

rule [Assignment-Decompose]:
     L:LValue := R:RValue =>
                 processLR(lhs(L),R) ~> void 

rule [ProcessLR-Decompose]:
     processLR(L:ExpTy,R:ExpTy) =>
     		 cpbCK(L,R) ~> updateL(L,R) ~> move(R)


/***********************************************************@
	The decomposition of assignment for sum type
************************************************************/

syntax TyCKItem
       ::= processAssignSum(KItem,Int,KItem)	[strict(1,3)]

rule L:LValue :=inj I:Int R:RValue => processAssignSum(lhs(L),I,R) ~> void


rule [decompose-assign-sum]:
     <k> processAssignSum(
			lhsTy(L:RValue,own(ty(T1:Ident))),
			I:Int,
			R:ExpTy
		     )  => cpbCK(lhsTy(L,T3),R)
			       ~> move(R) ...
     </k>
     <typeCtx> ... (ty(T1) |-> A:Int) ... </typeCtx>
     <ctyId> A </ctyId>
     <ctyKind> 1 </ctyKind>
     <ctyElem> ... (I |-> T3:RType) ... </ctyElem>


rule [decompose-seq1]:
     T:RType ; E2:Exp => E2



rule [decompose-seq2]:
     expTy(_,T:RType,_,_,_,_) ; E2:Exp => T; E2

/*************************************************************************@
	           The decomposition of Branch
**************************************************************************/

syntax TyCKItem
       ::= processBranch(Map,Map,K)
	 | combineBrwInfoWith(Map)
	 | combineBrwInfoWith(K,K)
	 | mergeDG(Map)
	 | execBranch(KItem)	[strict]



rule [decompose-if]:
     <k> if expTy(_,bool,_,_,_,_) then { E1:Exp } else { E2:Exp } =>
     	    execBranch(E1) ~> processBranch(Rho1,Rho2,E2) ... </k>
     <varInfo>  Rho1:Map  </varInfo>
     <depGraph> Rho2:Map </depGraph>

rule [decompose-branch]: <k> processBranch(R:Map,G:Map,E) => execBranch(E)
     	 				      ~> combineBrwInfoWith(Rho1)
					      	 ~> mergeDG(Rho2) ~> void ... </k>
     <varInfo> Rho1:Map => R </varInfo>
     <depGraph> Rho2:Map => G </depGraph>

rule execBranch(_:KResult) => .

rule <k> mergeDG(K |-> V Rest:Map) => merge(K,V,getbyKey(K,Rho)) ~> mergeDG(Rest) ... </k>
     <depGraph> Rho:Map </depGraph>

rule mergeDG(.Map) => .

rule combineBrwInfoWith((R:RValue |-> V) Remains:Map) =>
     	 			   combineBrwInfoWith(R,V) ~> combineBrwInfoWith(Remains)


rule <k> combineBrwInfoWith(R:RValue, V) => . ...</k>
     <varInfo> (.Map => R |-> V) Rho:Map </varInfo>
     requires notBool (R in keys(Rho))

rule <k> combineBrwInfoWith(R:RValue, varInfo(_,_,_,I1:Int, J1:Int, F1)) => . ...</k>
     <varInfo> ... R |-> varInfo(_,_,_,(I2:Int => minLft(I1,I2)), (J2:Int => minLft(J1,J2)),
     	       	     	 		       (F2 => (F1 andBool F2))) ... </varInfo>

rule <k> combineBrwInfoWith(R:RValue, varInfo(I1:Int, J1:Int, F1)) => . ...</k>
     <varInfo> ... R |-> varInfo((I2:Int => minLft(I1,I2)), (J2:Int => minLft(J1,J2)),
     	       	     	 		       (F2 => (F1 andBool F2))) ... </varInfo>


rule combineBrwInfoWith(.Map) => .


syntax TyCKItem
       ::= updateImmLabel(K,Int)
         | updateMutLabel(K,Int)
	 | updateMutandImmLabel(K)

rule newlft Exp endlft => newlft ~> execBranch(Exp) ~> endlft ~> void


/**********************************************
	Merge Borrowing Operation
*********************************************/

syntax Int
       ::= minLft(Int,Int)	[function]

rule minLft(-1,L:Int) => L

rule minLft(L:Int,-1) => L
when L =/=Int -1

rule minLft(L1:Int,L2:Int) => minInt(L1,L2)
when (L1 =/=Int -1) andBool (L2 =/=Int -1)




/************************************************
	The case semantics for sum types
************************************************/

syntax TyCKItem
       ::= "caseItem" "(" RValue ";" Int ";" Int ";" CExps ")"
         | rmsumdata(K)

rule <k> case expTy(R,own(T),A,B,C1,D) of {Es:CExps} =>
     	      	   caseItem(R; C; 1; Es) ~> rmsumdata(R.freshInt(1)) ... </k>
     <typeCtx> ... T |-> C:Int ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 1 </ctyKind>
     <cntElem> N </cntElem>
     


rule <k> caseItem(R:RValue; C:Int ; N ; E:Exp, Es:CExps)
     	 		   => execBranch(E) ~> processBranch(Rho1,Rho2,caseItem(R;C;N +Int 1;Es)) ...
     </k>
     <ctyKind> C </ctyKind>
     <ctyElem> ... N |-> T:RType ... </ctyElem>
     <varInfo> Rho1:Map => Rho1 [R.freshInt(1) <- varInfo(0,imm,T,-1,-1,true)] </varInfo>
     <depGraph> Rho2:Map </depGraph>
     

rule caseItem(_;_;_;.CExps) => void
     
rule void ~> rmsumdata(A) =>rmsumdata(A)

rule <k> rmsumdata(R) => void ... </k>
     <varInfo> ... (R |-> _) => .Map ... </varInfo>

endmodule







































