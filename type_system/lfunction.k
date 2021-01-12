
require "lexpression.k"
require "lstatement.k"
require "llifetime.k"
require "wellform.k"
require "configuration.k"

module LFUNCTION

imports LEXPRESSION
imports LSTATEMENT
imports LLIFETIME
imports WELLFORM
imports CONFIGURATION

/****************************************************************@
	The Decomposition of Function Definition
*****************************************************************/

syntax TyCKItem
       ::= rtTyCK(Exp,K)	[strict(1)]
	 | argTyCK(CExps,RTypes)
	 | bindParamTy(K,K)
	 | "bindParamTys" "(" K ";" K ";" K ")"
	 | contTyCK(K,K)
      | evalE(Exp, CExps, RTypes) [strict(1)]
 
syntax KResult ::= ExpTy



rule [decompose-fn]:
     <k> fun F:Ident (P:CIdents) newlft E:Exp endlft
     	 	=> 
     	     newlft ~> bindParamTys(P;Ts;Ls) 
     	     	    ~> rtTyCK(E,T) ~> endlft ...
     </k>
     <typeCtx> ... (F |-> (fnTy(Ls:LftVars; Ts:RTypes; T:RType))) ...  </typeCtx>

rule <k> call F:Ident (Rs:CExps) => argTyCK(Rs,Ts) ~> expTy(call F(Rs),T,L,-1,-1,imm) ... </k>
     <typeCtx> ... (F |-> fnTy(_;Ts:RTypes;T:RType)) ... </typeCtx>
     <currentLft> L:Int </currentLft>


rule rtTyCK(expTy(_,T:RType,_,_,_,_),T) => .
rule rtTyCK(T,T) => .

rule argTyCK(E:Exp, Rs:CExps, Ts:RTypes) =>  evalE(E, Rs,Ts)

rule evalE(E, Rs, Ts) => argTyCK(E, Rs,Ts)

//rule <k> argTyCK(V:Ident, Rs:CExps, Ts:RTypes) => argTyCK(expTy(var(C),T,L,B1,B2,M), Rs,Ts) ... </k>
  //   <env> ... V |-> C:Int ... </env>
    // <varInfo> ... var(C) |-> varInfo(L,M,T:RType,B1,B2,true) ... </varInfo>

rule argTyCK(expTy(L,T1:RType,A1,A2,A3,A4),Rs:CExps,T2:RType, Ts:RTypes)
				=> cpbCK(T1,T2) ~> move(expTy(L,T1,A1,A2,A3,A4)) ~> argTyCK(Rs,Ts)

rule cpbCK(T1:RType,T2:RType) => .

//the first type is assigned to second type

rule cpbCK(ref(_:Int,M,T),ref(_:Lftvar,M,T)) => .

rule cpbCK(ref(L1:Int,M,T),ref(L2:Int,M,T)) => .
     requires L1 >=Int L2

rule argTyCK(.CExps,.RTypes) => .

rule <k> contTyCK(C:Ident,T:RType) => . ... </k>
     <typeCtx> ... (C |-> contTy(T)) ... </typeCtx>


/*************************************************@
	Binding Arguments of Parameters
**************************************************/

rule bindParamTys((P:Ident,Ps:CIdents); (T:RType, Ts:RTypes); Ls) => 
     	     createVar(P,imm) ~> bindParamTy(P,T) ~> bindParamTys(Ps;Ts;Ls)

rule bindParamTys(.CIdents; .RTypes; _) => .

rule <k> bindParamTy(P,T) => . ... </k>
     <env> ... P |-> I:Int ... </env>
     <varInfo> ... var(I) |-> varInfo(_,_,(_ => T),_,_,(_ => true)) ... </varInfo>


endmodule