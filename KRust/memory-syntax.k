


/*@

\section{1. Introduction}

The syntax of the core language for Rust includes two pars:
\begin{itemize}
\item The syntax of operations for memory
\item The syntax of items, such as expressions, function definitions, etc
\end{itemize}

*/


/*@
\section{Part 1. The Syntax of Operations for Memory}
*/


module MEMORY-SYNTAX
imports DOMAINS
imports DOMAINS-SYNTAX

/*@
  operation sequences, it is only for test
 */
syntax Operations
       ::= Operation Operations
       	 | Operation

/*@
 (1) Address denote the address of a memory\\
 (2) use Int to denote addresses
 */ 
syntax Address
       ::= address(Int)


/*@
   Basic data types, such as Int, pointers\\
   The element uninit(Int) denote this allocated memory is uninitialized
 */
syntax Value
       ::= Int 
         | point(Address)
	 | "unit"
	 | cr(Int)
	 | Location
	 | uninit(Int)

/*@
    The location of a memory\\
    1. The first Int is address\\
    2. The second Int is offset\\
    
*/
syntax Location
       ::= "location" "(" Int "," Int ")"



/*@
   the list of datas
 */
syntax Datas
       ::= List{Value, ":"}



/*@
  Basic memory operations\\
    Allocate: allocate a block of memory\\
    Read    : read a value from an address\\
    write   : write a value to an address\\
    Append  : append data to the end of a block\\
    Free    : Free a block of memory\\
    CAS     : operations for compare-and-swap
 */
syntax Operation
       ::= Allocate
         | Read
       	 | Write
	 | Append
	 | Free
	 | CAS

/*@
 Read a value from a memory address with an index\\
   readsc: sequential consistency read
   readna, readnac: non-atomic read
 */
syntax Read
       ::= readsc(Address, Int)
         | readna(Address, Int)
	 | readnac(Address, Int)

/*@
Write a value to a memory address with an index\\
   writesc: sequential consistency read
   writena, writenac: non-atomic read
 
*/
syntax Write
       ::= writesc(Address, Int, Value)
         | writena(Address, Int, Value)
	 | writenac(Address, Int, Value)

/*@
  The operation "allocate" that allocate memories for size of Int
 */
syntax Allocate
       ::= allocate(Int)
         | allocateInit(Datas)

/*@
  The operation "append", which appends a basic data to the end of a block
*/
syntax Append
       ::= append(Address, Value)
	 

/*@
  The operation "free", which free a block
*/
syntax Free
       ::= free(Address)

/*@
  The operation "compare and swap"
*/
syntax CAS
       ::= cas(Address, Int, Value, Value)

endmodule

