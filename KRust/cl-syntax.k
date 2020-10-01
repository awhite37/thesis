


/*!

\title{The Syntax of Core Languages for Rust}

*/

/*@
\section{Part 2. The Syntax of Items}
*/

require "memory-syntax.k"

module CL-SYNTAX

imports MEMORY-SYNTAX

syntax Exp
       ::= "if" Exp "then" Exp "else" Exp	[klabel(ifexp)]
	 | "let" Ident "=" Exp "in" Exp		[klabel(letexp)]
	 | Exp ";" Exp				[right,klabel(seqexp)]


/*@
  The syntax of expressions\\
  1. Ident: identifiers for variables
  2. Exp BinOp Exp: Binary operations over two operands
  3. * Order Exp: Dereference
  4. Exp := Order Exp : Assignment
  5. case Exp of ExpList: branch control
  6. fork{Exp}: invoke a thread
  7. Exp(ExpList): function call
*/

syntax Exp
       ::= Ident        
         | Value
	 | MemoryOperations
	 | "*" Order Exp			[strict(2),klabel(dereference)]
	 | Exp "[" Exp "]"				[seqstrict,klabel(field)]
	 | Exp "(" ExpList ")"			[strict(1,2), klabel(funapply)]
	 | ArithExp	   		
	 | Exp ":=" Order Exp  	       		[strict(1,3),klabel(memwrite),prefer]
	 | Ident ":=" Exp			[strict(2), klabel(assignExp)]
	 | Fn
	 | ( Exp )				[bracket]
	 | "clskip"


syntax Exp
       ::= "fork" "{" Exp "}"
	 | "case" Exp "of" "{" ExpList "}"	[strict(1)]
	 

syntax Ident
       ::= Id

syntax Ident
       ::= "#anonymous"


/*@
 additional priorities
*/

syntax priorities
         dereference
       > field
       > funapply
       > arith
       > memwrite
       > assignExp 
       > letexp ifexp
       > seqexp
       
       


/*@
  The syntax of expressions for memory operations
*/

syntax MemoryOperations
       ::= Allocate
	 | Read
	 | Write
	 | Append
	 | Free
	 | CAS 


syntax ArithExp
       ::= left:
	   Exp "+" Exp				[left, strict(1,2),arith]
	 | Exp "-" Exp				[left, strict(1,2),arith]
	 > left:
	   Exp "==" Exp				[left, strict(1,2),arith]
	 | Exp "<=" Exp				[left, strict(1,2),arith]
	 | Exp "<" Exp				[left, strict(1,2),arith]
	 | Exp ">" Exp				[left, strict(1,2),arith]
	 | Exp "mod" Exp			[left, strict(1,2),arith]

/*@
  Order indicate whether a read or write operation is atomic or non-atomic
*/
syntax Order
       ::= "sc"
         | "na"


/*@
 Function Definitions
*/
syntax Fn
       ::= "fn" Id "(" FnParams ")" "{" Exp "}"
         | "fn" "(" FnParams ")" "{" Exp "}"

syntax FnParams
       ::= List{Ident, ","} [klabel(fnparams)]

syntax ArgList
       ::= ExpList      
         | ValList

syntax ExpList
       ::= List{Exp, ","}			[strict]
       |ValList


syntax ValList
       ::= List{Value, ","} 


endmodule
