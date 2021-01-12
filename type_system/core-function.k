
require "configuration.k"
require "lang.k"
require "tydef.k"

module CORE-FUNCTION

imports CONFIGURATION
imports LANG
imports TYDEF


rule <k> lessInt(I1, expTy(R:Int,_,_,_,_,_)) => . ...</k>
     requires I1 <=Int R



rule getVarId(V:VarId) => getVarIndex(V)
rule getVarId(* V:RValue) => getVarId(V)
rule getVarId(& M:Mutability V:RValue) => getVarId(V)
rule getVarId(V:RValue.J:Int) => getVarId(V)


rule getVarIndex(var(I:Int)) => I
rule getVarIndex(var(V:VarId,J:Int)) => getVarIndex(V) 
rule getVarIndex(* V:RValue) => getVarIndex(V)
rule getVarIndex(& M:Mutability V:RValue) => getVarIndex(V)
rule getVarIndex(V:RValue.J:Int) => getVarIndex(V)


/*******************************************************@
	Move Checking and Borrow Checking
********************************************************/
/*
syntax KItem
       ::= canMove(RValue)

rule <k> canMove(expTy( R:RValue,ref(_,_,_),_,_)) => . ... </k>

rule canMove(expTy( R:RValue, i32, _, _)) => .
rule canMove(expTy( R:RValue, bool, _ ,_)) => .

rule canMove(expTy(R:RValue,T:RType,_,_)) => .

rule canMove(expTy(var(_), T:RType, _ , _)) => .
rule canMove(expTy(var(_,_), T:RType, _,_ )) => .

*/

rule getRootId(var(I)) => I

rule getRootId(var(V:VarId,I)) => getRootId(V)

rule minSet(.Set) => -1

rule minSet(SetItem(V:VarId)) => getRootId(V)

rule minSet(SetItem(V:VarId) S:Set) => minSet2(getRootId(V),minSet(S))

rule minSet2(I,-1) => I

rule minSet2(I,J) => minInt(I,J)

endmodule