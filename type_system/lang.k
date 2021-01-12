
require "tydef.k"

module LANG

imports TYDEF

syntax Rust
       ::= Decls

syntax Decls		//Declarations
       ::= List{Decl, ""}

syntax Decl
       ::= FnDef
         | CompTyDecl 

syntax LValue
       ::= Ident			
         | "*" RValue				[strict,    dereference]
	 | RValue "." RValue			[left,strict(1), offset]

syntax Ident
       ::= Id

syntax RValue
       ::= Int
         | Bool
         | LValue
         | ArithExp
	 | "&" Mutability RValue  [strict(2),reference]
	 | "new" "(" RType "," Int ")"
	 | "new" "(" RType ")"
	 | ExpTy
	 | "(" RValue ")"	  [bracket]
	 | "call" Ident "(" CExps ")"					[strict(2)]

syntax RValue
       ::= VarId

syntax RValues
       ::= List{RValue, ","}		[strict]



syntax Integers
       ::= List{Int, ","}


/*
	This structure is designedcomplex:
	1: RValue: the expression to be evaluated
	2: RType: the type of RValue
	3: Int  : the lifetime of RValue
	4: Int  : whether it is immutable borrowed
	5: Int  : whether it is mutable borrowed
	6: Mutability: the mutability of RValue
*/

syntax ExpTy
       ::= lhsTy(RValue,RType)
         | expTy(RValue,RType,IntwithSpecialSym,Int,Int,Mutability)

syntax ExpTys
       ::= List{ExpTy,","}

syntax ArithExp
       ::= left:
       	   Exp "*" Exp		[strict,left,arith]
	 | Exp "/" Exp		[strict,left,arith]
	 >left:
	   Exp "+" Exp		[strict,left,arith]
	  |Exp "-" Exp		[strict,left,arith]
	 >left:
	   Exp "<=" Exp		[strict,left,arith]
	 |  Exp "=" Exp		[strict,left,arith]
	 | Exp "<" Exp		[strict,left,arith]
	 | Exp ">" Exp		[strict,left,arith]
	 | Exp ">=" Exp		[strict,left,arith]
	 | Exp "mod" Exp	[strict,left,arith]


syntax Assignment
       ::= LValue ":=" RValue				[assignment]
	 | LValue ":=inj" Int RValue			[assignment]

syntax LetExp
       ::= "let" Ident "=" RValue "in" "{" Exp "}"			[prefer, letexp]
         | "let" Mutability Ident "=" Exp "in" "{" Exp "}"		[prefer, letexp]
	 | "let" Ident "in" "{" Exp "}"	     	      	  		[prefer, letexp]
	 | "let" Mutability Ident "in" "{" Exp "}"	     	      	[prefer, letexp]
	

syntax Exp
       ::= RValue
         | Assignment
	 | LetExp
	 | "jump" Ident "(" RValue ")"
	 | "if" RValue "then" "{" Exp "}" "else" "{" Exp "}"		[strict(1)]
	 | "case" RValue "of" "{" CExps "}"	     	 		[strict(1)]
	 | Block
	 | Exp ";" Exp					[left,strict(1),seqexp]
	 | "newthread" MB "{" Exp "}"

syntax MB
       ::= "move" | "borrow"

syntax Block
       ::= Newlft Exp Endlft

syntax FnDef
       ::= "fun" Ident "(" CIdents ")" Newlft Exp Endlft


syntax Newlft
       ::= "newlft"

syntax Endlft
       ::= "endlft"


syntax CIdents
       ::= List{Ident, ","}
       

syntax CExps
       ::= List{Exp,","}		[strict]

syntax SExps
       ::= List{Exp,"|"}


syntax CompTyDecl	//Compound Type Declaration
       ::= Ident ":=:" RType

syntax Exp
       ::= RType 

syntax priorities
         dereference
       > offset
       > reference
       > arith
       > assignment
       > letexp
       > seqexp

endmodule






















































