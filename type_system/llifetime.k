
require "lexpression.k"
require "lstatement.k"

module LLIFETIME

imports LEXPRESSION
imports LSTATEMENT

/*@************************************************************
			For lifetime
**************************************************************/

syntax TyCKItem
       ::= removeVarbyLft(Int,Int)
         | updateBrwbyLft(Int,Int)
         | updateSubBrwbyLft(Int,Int,Int)
	 | updateImm(Int,VarId)
	 | updateMut(Int,VarId)
	 | removeSubBrw(Int,Int)
	 | removeLifetime(Int,Map,Map,Set)
	 | removeLifetime(Int,Map,K,K,Map,Set)

rule <k> newlft => . ... </k>
     <currentLft> C:Int => C +Int 1 </currentLft>
     <stackEnv> .List => ListItem(Rho) ...  </stackEnv>
     <env> Rho:Map </env>


rule <k> endlft =>  removeLifetime(L,VR,.Map,.Set) ... </k>
     <currentLft> L:Int => L -Int 1 </currentLft>
     <stackEnv> ListItem(Rho) => .List ...  </stackEnv>
     <env> _ => Rho:Map </env>
     <varInfo> VR:Map </varInfo>
     

rule <k> removeVarbyLft(L:Int, I:Int) => removeVarbyLft(L,I -Int 1) ... </k>
     <varInfo> ... (var(I) |-> varInfo(L,_,_,_,_,_)) => .Map ... </varInfo>

rule <k> removeLifetime(L:Int, (K |-> V) R1:Map, R2:Map,S)
     	 			=> removeLifetime(L,R1,K,V,R2,S) ... </k>

rule <k> removeLifetime(L:Int, R1:Map, Val, varInfo(L,_,_,_,_,_) , R2:Map,S)
     	 			=> removeLifetime(L,R1,R2,(SetItem(Val) S)) ... </k>

rule <k> removeLifetime(L:Int, R1:Map, V, varInfo(L1,A,B,L2,L3,D) , R2:Map,S)
     	 	=> removeLifetime(L,R1,(V|->varInfo(L1,A,B,CAM(L,L2), CAM(L,L3),D)) R2,S) ... </k>
     requires L =/=Int L1 

rule <k> removeLifetime(L:Int, R1:Map, V, varInfo(L2,L3,D) , R2:Map,S)
     	 	=> removeLifetime(L,R1,(V|->varInfo(CAM(L,L2), CAM(L,L3),D)) R2,S) ... </k>

rule <k> removeLifetime(_,.Map,R2:Map,S) => removeNode(S,Rho,.Map) ... </k>
     <varInfo> _ => R2 </varInfo>
     <depGraph> Rho </depGraph>

syntax Int
       ::= CAM(Int,Int) [function]
     

rule CAM(L,L1) => -1
     when L ==Int L1

rule CAM(L,L1) => L1
     when L=/=Int L1

/*
rule <k> removeLifetime(L:Int, R2) =>
     	 removeLifetime(L, (V|->varInfo(L1,A,B,CAM(L,L2), CAM(L,L3),D)) R2) ... </k>
     <varInfo> (V |-> varInfo(L1,A,B,L2,L3,D)) => .Map ... </varInfo>
     requires L =/=Int L1
*/

/*
rule <k> removeVarbyLft(L:Int, I:Int) => removeSubBrw(I,1) ~> removeVarbyLft(L,I -Int 1) ... </k>
     <varInfo> ... (var(I) |-> varInfo(L,_,_,_,_,_)) => .Map ... </varInfo>

rule <k> removeSubBrw(I:Int,J:Int) => removeSubBrw(I,J +Int 1) ...</k>
     <brwInfo> ... (var(I,J) |-> _) => .Map ... </brwInfo>

rule <k> removeSubBrw(I:Int,J:Int) => . ...</k>
     <brwInfo> Rho:Map </brwInfo>
     requires notBool (var(I,J) in keys(Rho))



rule <k> removeVarbyLft(L:Int, I:Int) => updateBrwbyLft(L,I) ... </k>
     <varInfo> ... var(I) |-> varInfo(_,lft(L1:Int),_,_) ... </varInfo>
     <varCnt> _ => I +Int 1 </varCnt>
     requires L =/=Int L1

rule removeVarbyLft(_,-1) => .

rule <k> updateBrwbyLft(L:Int,I:Int) => updateImm(L,var(I)) ~> updateMut(L,var(I))
     	 			    ~> updateSubBrwbyLft(L,I,1) ~> updateBrwbyLft(L,I -Int 1) ... </k>
     requires I >=Int 0


rule <k> updateBrwbyLft(L:Int,I:Int) => . ... </k>
     requires I <Int 0

rule <k> updateImm(L:Int,V:VarId) => . ... </k>
     <brwInfo> ... V |-> brwStatus(L => -1,_,_) ...  </brwInfo>

rule <k> updateImm(L:Int,V:VarId) => . ... </k>
     <brwInfo> ... V |-> brwStatus(L1:Int,_,_) ...  </brwInfo>
     requires L =/=Int L1


rule <k> updateMut(L:Int,V:VarId) => . ... </k>
     <brwInfo> ... V |-> brwStatus(_, L => -1,_) ...  </brwInfo>

rule <k> updateMut(L:Int,V:VarId) => . ... </k>
     <brwInfo> ... V |-> brwStatus(_,L1:Int,_) ...  </brwInfo>
     requires L =/=Int L1

rule <k> updateSubBrwbyLft(_, I:Int,J:Int) => . ...</k>
     <brwInfo> Rho:Map </brwInfo>
     requires notBool (var(I,J) in keys(Rho))

rule <k> updateSubBrwbyLft(L:Int, I:Int,J:Int) => updateImm(L,var(I,J)) ~>
     	 		updateMut(L,var(I,J)) ~> updateSubBrwbyLft(L,I,J +Int 1) ... </k>
     <brwInfo> Rho:Map </brwInfo>
     requires (var(I,J) in keys(Rho))
*/

syntax TyCKItem
       ::= setLftVars(LftVars)
         | emptyLftVars(Int)


rule <k> setLftVars(L:Lftvar,RestL:LftVars) => setLftVars(RestL) ... </k>
     <tclftvars> (.Set => SetItem(L)) ... </tclftvars>

rule setLftVars(.LftVars) => .

rule <k> emptyLftVars(I:Int) => . ... </k>
     <tclftvars> S:Set => .Set  </tclftvars>


endmodule