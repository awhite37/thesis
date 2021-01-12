

require "lang.k"
require	"tydef.k"
require "configuration.k"
require "core-function.k"
require "depgraph.k"

module LEXPRESSION

imports LANG
imports TYDEF
imports CONFIGURATION
imports CORE-FUNCTION
imports DEPGRAPH


/***** auxiliary syntax sorts *****/

syntax TyCKItem
       ::= setBrwStatus(K,K,K)
         | createSubBS(K,K,K)
	 | borrowCK(K,K,K,K)
	 | move(K)
	 | createVar(Ident,Mutability)
	 | cpbCK(K,K)
	 | updateL(K,K)
	 | trySetBorrow(K,K,K)
	 | setBorrow(K,K,K)


/***** auxiliary functions *****/
syntax KItem
       ::= getMainVar(RValue)		[function]

rule getMainVar(var(I:Int)) => var(I)
rule getMainVar(V:VarId) => V


/***** rewrite rules for arithmatics *****/

rule R:Int => expTy(R,i32,0,-1,-1, imm)
rule R:Bool => expTy(R,bool,0,-1,-1, imm)
rule expTy(R1,i32,_,_,_, imm) * expTy(R2,i32,_, _, _, imm) => expTy(R1 * R2,i32,0, -1, -1, imm)
rule expTy(R1,i32,_,_,_,imm) / expTy(R2,i32,_,_,_,imm) => expTy(R1 / R2,i32,0,-1,-1,imm)

rule expTy(R1,i32,_,_,_, imm) + expTy(R2,i32,_, _, _, imm) => expTy(R1 + R2,i32,0, -1, -1, imm)
rule expTy(R1,i32,_,_,_,imm) - expTy(R2,i32,_,_,_,imm) => expTy(R1 - R2,i32,0,-1,-1,imm)
rule expTy(R1,i32,_,_,_,imm) <= expTy(R2,i32,_,_,_,imm) => expTy(R1 <= R2,bool,0,-1,-1,imm)
rule expTy(R1,i32,_,_,_,_) = expTy(R2,i32,_,_,_,_) => expTy(R1 = R2,bool,0,-1,-1,imm)
rule expTy(R1,i32,_,_,_,imm) < expTy(R2,i32,_,_,_,imm) => expTy(R1 < R2,bool,0,-1,-1,imm)
rule expTy(R1,i32,_,_,_,imm) > expTy(R2,i32,_,_,_,imm) => expTy(R1 > R2,bool,0,-1,-1,imm)
rule expTy(R1,i32,_,_,_,imm) >= expTy(R2,i32,_,_,_,imm) => expTy(R1 >= R2,bool,0,-1,-1,imm)
rule expTy(R1,i32,_,_,_,imm) mod expTy(R2,i32,_,_,_,imm) => expTy(R1 mod R2,bool,0,-1,-1,imm)





rule new(T,I) => new(array(T))

rule <k> new(T:RType) => expTy(addr(0), own(T),L,-1,-1, mut) ... </k>
     <currentLft> L:Int </currentLft>

rule <k> X:Ident => expTy(var(C),T,L,B1,B2,M) ...  </k>
     <env> ... X |-> C:Int ... </env>
     <varInfo> ... var(C) |-> varInfo(L,M,T:RType,B1,B2,true) ... </varInfo>


/***** rewrite rules for own and ref types *****/

rule <k> & mut expTy(V:RValue,own(T),L ,-1 ,-1 ,mut) => 
               expTy(& mut V,ref(L,mut,own(T)),CL,-1,1,mut) ...  </k>	      
     <currentLft> CL:Int </currentLft>
     
rule <k> & imm expTy(V:RValue,own(T),L , _ ,-1 ,M) =>  
               expTy(& imm V,ref(L,imm,own(T)),CL,1,-1,M)  ...  </k>
     <currentLft> CL:Int </currentLft>

rule * expTy(V:RValue,own(T:RType),_,_,_,_) => expTy( *V,T,0,-1,-1,imm)

rule <k> & mut expTy(V:RValue,ref(L1,M1,T),L,-1,-1, M) => lessInt(L1, CL) ~>
               expTy(& mut V,ref(L,mut,ref(L1,M1,T)), CL, -1, 1,mut)  ...  </k>
     <currentLft> CL:Int </currentLft>

rule <k> & imm expTy(V:RValue,ref(L1,M1,T),L,_,-1, M) => lessInt(L1, CL) ~>
               expTy(& imm V,ref(L,imm,ref(L1,M1,T)), CL, 1, -1 ,mut) ...  </k>
     <currentLft> CL:Int </currentLft>


rule * expTy(V:RValue,ref(L,mut,T:RType),_,_,_,_) =>  expTy(*V,T,L,-1,1,imm)
rule * expTy(V:RValue,ref(L,imm,T:RType),_,_,_,_) =>  expTy(*V,T,L,1,-1,imm)



/**********************************************************@
	 The Computation for Composite Type
************************************************************/

syntax RType
       ::= tylft(K,K,K)		[function]
         | tylft1(K,K)		[function]

rule tylft(V:RValue,T:RType,_) => T

rule tylft(V:RValue,ref(L,M,T),Rho:Map) => tylft1(next(calCSet(V,Rho),Rho),ref(L,M,T))

rule tylft1(S:Set,ref(L,M,T)) => ref((minSet(S)),M,T)

rule expTy(V:RValue, own(array(T)), L, B1,B2,M).J:RValue => expTy(V.J,T,L,B1,B2,M)

rule <k> expTy(V:VarId, own(T),L,_,_,MT).J:Int => expTy(var(V,J),tylft(var(V,J),T1,Rho), L,B1,B2,MT) ... </k>
     <typeCtx> ... T |-> C:Int ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 0  </ctyKind>
     <ctyElem> ... (J |-> T1) ... </ctyElem>
     <varInfo> ... var(V,J) |-> varInfo(B1,B2,M) ... </varInfo>
     <depGraph> Rho:Map </depGraph>

rule <k> expTy(V:VarId, own(T:RType),L,_,_,_).J:Int => expTy(var(V,J),tylft(var(V,J),T1,Rho1), L,-1,-1,mut) ... </k>
     <typeCtx> ... T |-> C:Int ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 0  </ctyKind>	   
     <ctyElem> ... J |-> T1:RType ...  </ctyElem>
     <varInfo> (.Map => var(V,J) |-> varInfo(-1,-1,true)) Rho:Map </varInfo>
     <depGraph> Rho1:Map </depGraph>


rule <k> expTy(V,own(T),L,B1,B2,M).J:Int => expTy(V.J,tylft(V.J,T1,Rho),L,B1,B2,M) ... </k>
     <typeCtx> ... T |-> C:Int ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 0  </ctyKind>	   
     <ctyElem> ... J |-> T1:RType ...  </ctyElem>
     <depGraph> Rho:Map </depGraph>

rule <k> expTy(V,own(T),L,B1,B2,M).J:Int => expTy(V.J,T1,0,-1,-1,mut) ... </k>
     <typeCtx> ... T |-> C:Int ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 1  </ctyKind>	   
     <varInfo> ... V.J |-> varInfo(0,_,T1,_,_,_) ...  </varInfo>


syntax RValue
       ::= lhs(RValue)

rule lhs(* R:RValue) => * lhs(R)
rule lhs(& M:Mutability R:RValue) => & M lhs(R)
rule lhs(R:RValue.I:RValue) => lhs(R).I

rule <k> lhs(X:Ident) => lhsTy(var(C),T) ...  </k>
     <env> ... X |-> C:Int ... </env>
     <varInfo> ... var(C) |-> varInfo(L,_,T:RType,_,_,_) ... </varInfo>


rule <k> lhsTy(V:VarId,own(T)).I => lhsTy(var(V,I),T1) ... </k>
     <typeCtx> ... T |-> C:Int ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 0  </ctyKind>	   
     <ctyElem> ... I |-> T1:RType ...  </ctyElem>

rule <k> lhsTy(V:RValue,own(T)).I => lhsTy(V.I,T1) ... </k>
     <typeCtx> ... T |-> C:Int ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 0  </ctyKind>	   
     <ctyElem> ... I |-> T1:RType ...  </ctyElem>


rule lhsTy(V,own(array(T))).I => lhsTy(V.I,T)

rule  * lhsTy(R,own(T)) => lhsTy(*R,T)
rule  * lhsTy(R,ref(L,_,T)) => lhsTy(* R,T) 
     


rule move(expTy(addr(0),own(T:RType),_,_,_,_)) => .
rule move(expTy(_,i32,_,_,_,_)) => .
rule move(expTy(_,bool,_,_,_,_)) => .
rule move(expTy(_,ref(_,_,_),_,_,_,_)) => .


rule <k> move(expTy(V, own(T:RType),_ ,_ ,_ ,_)) => . ... </k>
     <varInfo> ... V |-> varInfo(_,_,_,-1,-1,(true => false))  ... </varInfo>

rule <k> move(expTy(V, own(T:RType),_ ,_ ,_ ,_)) => . ... </k>
     <varInfo> ... V |-> varInfo(-1,-1,(true => false))  ... </varInfo>

rule move(expTy(call X:Id (Es:CExps),_,_,_,_,_)) => .
     
     

rule <k> createVar(X:Ident,M:Mutability) => setVar(X,C)  ... </k>
     <varCnt> C:Int => C +Int 1 </varCnt>
     <varInfo> .Map => (var(C) |-> varInfo(L,M,#TyUndef,-1,-1,false)) ... </varInfo>
     <currentLft> L:Int </currentLft>

syntax CreateItem
       ::= setVar(Ident,Int)

rule <k> setVar(X:Ident,C:Int) => . ... </k>
     <env> (.Map => X |-> C) Rho:Map </env>
     requires notBool (X in keys(Rho))

rule <k> setVar(X:Ident,C:Int) => . ... </k>
     <env> ... (X |-> (_ => C)) ... </env>

syntax CompatibleCKItem
       ::= assignCptCK(RType,RType)

syntax TyCKItem
       ::= tyCKAssign(RType,RType)
        
/*******************************************************@
	Compatible Checking for Assignment
********************************************************/

rule cpbCK(lhsTy(_,#TyUndef),expTy(_,T:RType,L2,_,_,_)) => .

rule cpbCK(lhsTy(L:RValue,T1:RType), expTy(R:RValue,T1,L2,_,_,_)) => .

rule <k> cpbCK(lhsTy(L:RValue,ref(_,M,T)),
     	 		expTy(R:RValue,ref(L2,M,T),_,_,_,_)) => lessInt(L2, getVarId(L)) ~> . ... </k>

rule <k> cpbCK(lhsTy(L:RValue,#TyUndef),
     	 		expTy(R:RValue,ref(L2,M,T),_,_,_,_)) => lessInt(L2, getVarId(L)) ~> . ... </k>


/***********************************************@
         Binding a RValue to a variable
***********************************************/

syntax TyCkItem
       ::= setBorrowUp(K,K,K)
         | updateDG(K,K,K)
         
rule <k> updateL(lhsTy(var(I:Int),_),expTy(R,T:RType,_,_,_,_)) => 
			updateDG(var(I),R,T) ~> trySetBorrow(R,T,L) ... </k>
     <varInfo>
	... var(I) |-> varInfo(L,_,(_ => T),_,_,(_ => true)) ...
     </varInfo>

rule <k> updateL(lhsTy(V,_),expTy(R,T:RType,_,_,_,_)) =>
			updateDG(V,R,T) ~> trySetBorrow(R,T,L) ... </k>
     <varInfo>
	(.Map => V |-> varInfo(-1,-1,true)) Rho:Map
     </varInfo>
     <currentLft> L:Int  </currentLft>
     requires (notBool (V in keys(Rho)))

rule <k> updateL(lhsTy(V,T),expTy(R,T:RType,_,_,_,_)) =>
			updateDG(V,R,T) ~> trySetBorrow(R,T,L) ... </k>
     <currentLft> L:Int  </currentLft>
     <depGraph> Rho:Map </depGraph>


rule <k> updateDG(R1:RValue,R2:RValue, T:PointTy) =>
     	 SmoveDG(calCSet(R1,Rho),calCSet(R2,Rho),T) ... </k>
     <depGraph> Rho:Map </depGraph>

rule updateDG(_,_,i32) => .
rule updateDG(_,_,bool) => .

rule trySetBorrow(_,T:RType,_) => .     	      

rule trySetBorrow(R,ref(_,M,_),L) => trySetBorrow(R,M,L)

rule trySetBorrow(& M R,M,L) => setBorrow(R,M,L)

rule trySetBorrow(* R, M , L) => trySetBorrow(R,M,L)

rule trySetBorrow( R.I, M , L) => trySetBorrow(R,M,L)

rule trySetBorrow(V:VarId,M,L) => .


rule setBorrow(* R, M ,L) => setBorrow(R,M,L)


rule <k> setBorrow(V:VarId,mut,L) => setBorrowUp(V,mut,L) ... </k>
     <varInfo> ... V |-> varInfo(_,_,_,_,(_ => L),_) ... </varInfo>

rule <k> setBorrow(V:VarId,imm,L) => setBorrowUp(V,imm,L) ... </k>
     <varInfo> ... V |-> varInfo(_,_,_,(_ => L),_,_) ... </varInfo>

rule <k> setBorrow(V:VarId, imm, L) => setBorrowUp(V,imm,L) ... </k>
     <varInfo> ... V |-> varInfo(_,_,_,(N:Int => minInt(L,N)),-1,_) ... </varInfo>

rule <k> setBorrow(V:VarId, mut, L) => setBorrowUp(V,mut,L) ... </k>
     <varInfo> ... V |-> varInfo(_,(_ => L),_) ... </varInfo>

rule <k> setBorrow(V:VarId,imm, L) => setBorrowUp(V,imm,L) ... </k>
     <varInfo> ... V |-> varInfo((_ => L),-1,_) ... </varInfo>

rule <k> setBorrow(V:VarId,imm, L) => setBorrowUp(V,imm,L) ... </k>
     <varInfo> ... V |-> varInfo((N:Int => minInt(L,N)),-1,_) ... </varInfo>


rule setBorrowUp(var(I:Int),_,_) => .
rule setBorrowUp(var(V:VarId,I:Int),M,L) => setBorrow(V,M,L)

endmodule


