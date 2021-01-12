
require "memory-syntax.k"
require "configuration.k"

module MEMORY

imports MEMORY-SYNTAX
imports CONFIGURATION

syntax Val
       ::= Int
         | undefine(Int)

syntax KResult
       ::= Address
         | Val


rule O1:Operation Os:Operations => O1 ~> Os

/****************************************************************
  	           The semantics for allocation
****************************************************************/

/*
 * the semantics of allocate memory
 */

/*
 * processAllocate is an intermediate sort for dealing with allocations
 */
syntax MemoryItem
       ::= initAllocate(Address, Datas)
       	 | initEmpty(Address, Int)


rule <k> allocateInit(D:Datas) => initAllocate(address(N),D) ... </k>
     <memaddress> N:Int => N +Int 1 </memaddress>
     <memorystatus> .Map => (N |-> memstatus(0,1)) ...  </memorystatus>
     (.Bag => <block>			
			<baddress> address(N) </baddress>
			<bnum> 0:Int </bnum>
		        <bstore> .Map </bstore>
     	      </block>)

/*
 * store one data of datas in one index
 */
rule initAllocate(A:Address,(D1:(Ds:Datas))) =>
		append(A,D1) ~> initAllocate(A,Ds)
     
/*
 * finish the allocation of memory
 */
rule <k> initAllocate(address(N:Int), .Datas) => address(N:Int) ... </k>
     <memorystatus> ... (N |-> memstatus(0,(1 => 0))) ... </memorystatus>

rule <k> allocate(I:Int) => initEmpty(address(N),0) ... </k>
     <memaddress> N:Int => N +Int 1  </memaddress>
     <memorystatus> .Map => (N |-> memstatus(0,1)) ...  </memorystatus>
     (.Bag => <block>			
			<baddress> address(N) </baddress>
			<bnum> I:Int </bnum>
		        <bstore> .Map </bstore>
     	      </block>)

rule <k> initEmpty(A:Address,I:Int) => initEmpty(A, I +Int 1) ...  </k>
     <baddress> A </baddress>
     <bnum> N:Int </bnum>
     <bstore> .Map => I |-> uninit(0) ...  </bstore> requires I <Int N

rule <k> initEmpty(address(N:Int), I:Int) => location(N,0) ... </k>
     <baddress> address(N) </baddress>
     <bnum> I </bnum>
     <memorystatus> ... (N |-> memstatus(0,(1 => 0))) ... </memorystatus>

/****************************************************************/



/****************************************************************
		The Semantics of Read
*****************************************************************/

/*
 * read the value of an address for basic data type
 * here it is only for int
 */
 
rule <k> readsc(A:Address, I:Int) => D ... </k>
     <baddress> A </baddress>
     <bstore> ... (I |-> D:Value) ... </bstore>


rule <k> readna(address(N:Int), I:Int) => readnac(address(N),I:Int) ... </k>
     <memorystatus> ... (N |-> memstatus(_,(K:Int => K+Int1))) ...  </memorystatus>

rule <k> readnac(address(N:Int), I:Int) => V ... </k>
     <memorystatus> ... (N |-> memstatus(_,(K:Int => K-Int1))) ...  </memorystatus>
     <baddress> address(N:Int) </baddress>
     <bstore> ... (I |-> V:Value) ...  </bstore>
     

/*********************************************************/



/*********************************************************
		 the semantics for Write
 **********************************************************/

rule <k> writesc(address(N:Int), I:Int, D:Value) => unit ... </k>
     <memorystatus> ... (N |-> memstatus(0,0)) ...  </memorystatus>
     <baddress> address(N) </baddress>
     <bstore> ... (I |-> (_ => D)) ... </bstore>
   
rule <k> writena(address(N:Int), I:Int, D:Value) => 
     	 			 writenac(address(N), I, D) ... </k>
     <memorystatus> ... (N |-> memstatus(0,(0 => 1))) ... </memorystatus>

rule <k> writenac(A:Address, I:Int, D:Value) => unit ... </k>
     <memorystatus> ... (N |-> memstatus(0,(1 => 0))) ... </memorystatus>
     <baddress> address(N) </baddress>
     <bstore> ... (I |-> (_ => D)) ... </bstore>


/*******************************************************/


/*******************************************************
		The semantics for append
********************************************************/

rule <k> append(A:Address, D:Value) => . ... </k>
     <baddress> A </baddress>
     <bnum> N:Int => N +Int 1 </bnum>
     <bstore> .Map => (N |-> D) ... </bstore>

/********************************************************/



/*******************************************************
		The semantics for Free
********************************************************/

rule <k> free(address(N:Int)) => . ... </k>
     <baddress> address((N => -1:Int)) </baddress> 

/***********************************************************/


/*********************************************************
		The Semantics for CAS
*************************************************************/

rule <k> cas(A:Address,I:Int, D1:Value, D2:Value) => . ... </k>
     <baddress> A </baddress>
     <bstore> ... (I |-> (D1 => D2)) ...  </bstore>
     


endmodule








