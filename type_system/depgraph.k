
require "configuration.k"

module DEPGRAPH

imports CONFIGURATION



syntax DepGraphOp
       ::= directTo(K,KItem) [strict(2)]
         | merge(K,K,K) 
         
	 | copyDG(K,K)
	 | SmoveDG(KItem,KItem,K) [strict(1,2)]
	 | moveDG(K,K,K)
	 | SmoveEDG(K,K,K)
	 | moveEDG(K,K,K)
	 | delTo(K,K)
	 | removeNode(Set,Map,Map)
	 | removeNode(Set,Map,K,K,Map)




rule <k> directTo(V:VarId,S:Set) => . ... </k>
     <depGraph> ... (V |-> (_ => S)) ...  </depGraph>

rule <k> directTo(V:VarId,S:Set) => . ... </k>
     <depGraph> (.Map => (V |-> S)) Rho:Map  </depGraph>
     requires (notBool (V in keys(Rho))) andBool (S =/=K .Set)

rule directTo(V:VarId,.Set) => .


rule directTo(SetItem(V) S1:Set,S:Set) => directTo(V,S) ~> directTo(S1,S) 

rule directTo(.Set,_) => .

rule <k> directTo(V,S:Set) => . ... </k>
     <depGraph> (.Map => (V |-> S)) Rho:Map  </depGraph>
     requires notBool (V in keys(Rho))

rule merge(V:VarId,R1:Map,R2:Map) => merge(V,R1[V],R2[V])

rule merge(V:VarId,S1,S2) => directTo(V,setUnion(S1, S2))

rule copyDG(S1:Set,S2:Set) => directTo(S1,S2)


rule SmoveDG(SetItem(V) S1:Set,S,T) => SmoveDG(V,S,T) ~> SmoveDG(S1,S,T)


rule SmoveDG(.Set,_,_) => .

rule SmoveDG(V:VarId,S,T) => directTo(V,.Set) ~> SmoveEDG(V,S,T) ~> moveDG(V,S,T)

rule moveDG(V:VarId,SetItem(V1) S:Set,T) => moveDG(V,V1,T) ~>  moveDG(V,S,T)

rule moveDG(_,.Set,_) => .

syntax ASet
     ::= setUnion(KItem,KItem)	[strict]
    | getbyKey(VarId,Map) 
    
syntax KResult ::= VarId | Set

rule setUnion(S1:Set,S2:Set) => (S1 S2)

rule setUnion(S1:Set,S2:SetItem .Set) => (S1 S2)


rule <k> moveDG(V1:VarId,V2:VarId,T) =>
     	 directTo(V1, setUnion(getbyKey(V1,Rho), getbyKey(V2,Rho))) ... </k>
     <depGraph> Rho:Map </depGraph>

rule <k> moveDG(V1:VarId,deref S,T) =>
     	 directTo(V1, setUnion(getbyKey(V1,Rho), S)) ... </k>
     <depGraph> Rho:Map </depGraph>


rule getbyKey(V,R:Map) => .Set
     when notBool (V in keys(R))
rule getbyKey(V,R:Map) => R[V]
     when V in keys(R)

rule SmoveEDG(_,_,i32) => .
rule SmoveEDG(_,_,bool) => .
rule SmoveEDG(_,_,ref(_,_,_)) => .

rule SmoveEDG(V,V1,own(T)) => .


rule <k> SmoveEDG(V,S,own(ty(T))) => SmoveEDG(V,S,N) ... </k>
     <typeCtx> ... ty(T) |-> C ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 0 </ctyKind>
     <cntElem> N:Int </cntElem>

rule <k> SmoveEDG(V,S,own(ty(T))) => . ... </k>
     <typeCtx> ... ty(T) |-> C ... </typeCtx>
     <ctyId> C </ctyId>
     <ctyKind> 1 </ctyKind>
     <cntElem> N:Int </cntElem>


rule SmoveEDG(V,S,0) => .

rule SmoveEDG(V:VarId, S:Set, N:Int) => directTo(var(V,N),.Set) ~> moveEDG(V,S,N) ~> SmoveEDG(V,S,N-Int 1)
     requires N >Int 0

rule moveEDG(V,SetItem(V1) S:Set,N:Int) => moveEDG(V,V1,N) ~> moveEDG(V,S,N)

rule moveEDG(V,.Set,N) => . 

rule <k> moveEDG(V,V1,N) => directTo(var(V,N),setUnion(getbyKey(var(V,N),Rho),getbyKey(var(V1,N),Rho))) ... </k>
     <depGraph> Rho:Map </depGraph>

syntax ASet
       ::= next(KItem,K)	[strict(1)]
         | calCSet(K,K)	
         | Set
         

rule next(SetItem(V) S:Set,Rho:Map) => setUnion(getbyKey(V,Rho),next(S,Rho))

rule next(.Set,_) => .Set

rule next(deref S, _) => S

syntax RSet
       ::= Set
         | "deref" ASet


rule calCSet(SetItem(V) S:Set,Rho:Map) => setUnion(calCSet(V,Rho),calCSet(S,Rho))

rule calCSet(V:VarId, Rho:Map) => SetItem(V)
rule calCSet(* V:RValue, Rho:Map) => next(calCSet(V,Rho),Rho)
rule calCSet(& M V:RValue, Rho:Map) => SetItem(deref calCSet(V,Rho))
rule calCSet(V:RValue.I:Int, Rho:Map) => calCSet(calCSet(V,Rho),I)
rule calCSet(SetItem(V:VarId) S:Set,I) => setUnion(SetItem(var(V,I)),calCSet(S,I))
rule calCSet(.Set,_) => .Set

/****************************/

rule calCSet(call X(Es),_) => .Set

/*****************************/


rule removeNode(S:Set, ((V |-> D) Rho:Map), M) => removeNode(S,Rho,V,D,M)

rule removeNode(S:Set, Rho:Map, V, D, M) => removeNode(S, Rho, M)
     requires V in S

rule removeNode(S:Set, Rho:Map, V, D,  M) => removeNode(S,Rho,((V |-> (D -Set S)) M))
     requires notBool (V in S)

rule <k> removeNode(_,.Map,M) => . ... </k>
     <depGraph> _ => M </depGraph>

endmodule