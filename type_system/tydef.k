
module TYDEF

imports INT
imports ID
imports SET
imports MAP


syntax Id
       ::= "channel"	[reject]
         | "send"	[reject]
	 | "recv"	[reject]

syntax RType
       ::= "i32" | "bool"
         | PointTy
	 | FnTy
	 | ComposeTy
	 | ContTy
	 | uinit(RType)
	 | "#TyUndef"
	 | VoidTy
	 | ty(Ident)		[klabel('TyIdent)]
	 | array(RType)

syntax VoidTy
       ::= "void"

/*@
 Both own and ref type have a point.\\
 For own type, the point points to an address.\\
 For ref type, the point points to another variable.
*/

syntax IntwithSpecialSym
       ::= Int
         | Lftvar
         | CoreOp

syntax CoreOp
       ::= minSet(Set)  
    | minSet2(KItem,KItem)   
    | getRootId(VarId)     
    | getVarId(RValue)   
    | getVarIndex(RValue) 
    | Int

syntax CoreOp ::= lessInt(Int, KItem) [strict(2)] 




syntax VarId
       ::= var(Int)   [klabel('SimpVar)]
         | var(VarId,Int) [klabel('SimpVar)]
   | addr(Int)    

syntax PointTy
       ::= own(RType)
       	 | ref(IntwithSpecialSym, Mutability, RType)		[klabel('Reference)]

syntax Mutability
       ::= "mut"
         | "imm"


/*
   This lifetime is for a variable.
   The first element is the lifetime
   and the second is the index of a variable
*/
syntax Lifetime
       ::= "static"
       	 | lft(Int)
	 | lft(Int,Int)	
	 | Lftvar

syntax Lftvar
       ::= "'" Ident

syntax FnTy
       ::= "fnTy" "(" LftVars ";" RTypes ";" RType ")"

syntax LftVars
       ::= List{Lftvar, ","}

syntax RTypes
       ::= List{RType,","}


syntax ComposeTy
       ::= sumTy(RTypes)			
         | sumTy(LftVars, RTypes)		
	 | prodTy(RTypes) 			[klabel('ProdTy)]
         | prodTy(LftVars, RTypes)		[klabel('ProdTy)]


syntax ContTy
       ::= contTy(RType)


syntax Ident
syntax RValue


endmodule