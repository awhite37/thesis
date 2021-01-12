
require "tydef.k"
require "lang.k"
require "llifetime.k"
require "wellform.k"

module COMPOSETY

imports TYDEF
imports LANG
imports LLIFETIME
imports WELLFORM

syntax TypeItem
       ::= buildCType(Int,Int,RTypes)
         | tyBind(K,K)

rule X:Ident :=: prodTy(RTs:RTypes) => X :=: prodTy(.LftVars,RTs)
rule X:Ident :=: sumTy(RTs:RTypes) => X :=: sumTy(.LftVars,RTs)

rule <k> X:Ident :=: prodTy(Ls:LftVars,RTs:RTypes) => setLftVars(Ls) ~>
     	      buildCType(C,1,RTs) ~> tyBind(ty(X),C) ... </k>
     <ctyCnt> C:Int => C +Int 1 </ctyCnt>
     <comtypes> ...
      (.Bag => <comtype>
	 <ctyId> C </ctyId>
	 <ctyKind> 0 </ctyKind>
	 <ctyElem> .Map </ctyElem>
	 <cntElem> 0 </cntElem>
       </comtype>) ... </comtypes>

rule <k> X:Ident :=: sumTy(Ls:LftVars,RTs:RTypes) => setLftVars(Ls) ~>
     	      buildCType(C,1,RTs) ~> tyBind(ty(X),C) ... </k>
     <ctyCnt> C:Int => C +Int 1 </ctyCnt>
     <comtypes> ...
       (.Bag => <comtype>
	 <ctyId> C </ctyId>
	 <ctyKind> 1 </ctyKind>
	 <ctyElem> .Map </ctyElem>
	 <cntElem> 0 </cntElem>
       </comtype>) ...</comtypes>

rule <k> buildCType(C:Int,I:Int,(T:RType, RestT:RTypes)) => //wellform(T) ~>
     				      buildCType(C,I +Int 1, RestT) ... </k>
      <comtypes> ...
       <comtype>
    <ctyId> C </ctyId>
     <ctyElem> (.Map => I |-> T) ... </ctyElem>...
       </comtype> ...</comtypes>
     


rule <k> buildCType(C:Int,N:Int,.RTypes) => . ... </k>
  <comtypes> ...
       <comtype>
   <ctyId> C </ctyId>
   <cntElem> 0 => N -Int 1 </cntElem> ...
       </comtype> ... </comtypes>

    

rule <k> tyBind(X,C) => emptyLftVars(0) ... </k>
     <typeCtx> (.Map => X |-> C) Rho:Map  </typeCtx>
     requires notBool (X in keys(Rho))

rule X :=: FT:FnTy => tyBind(X,FT) 


rule X :=: CT:ContTy => tyBind(X,CT) 
     

endmodule