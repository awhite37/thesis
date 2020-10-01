
require "cl-syntax.k"

module CONFIGURATION

imports CL-SYNTAX

/*
 * memstatus: denote the status of a memory
 *     The first Int indicates the number of operations that read the memory
 *     The second Int indicates the number of operations that write the memory
 */
syntax MemStatus
       ::= memstatus(Int,Int)

    
configuration
<T>
 /*@
  Threads include a set of threads.\\
  Each thread has:\\
  1. <k/>  : is the computation needs to be done
  2. <env/>: it is like the stack to store the map from variables to its memory locations
 */
    <threads>
	<thread multiplicity="*">	
		<k> $PGM:Exp </k>
		<env> .Map </env>
		<clstack> .List </clstack>		
	</thread>
    </threads>

/*@
   Closure is the value of a function it consists of \\
   1. crId  : The identifier of a closure
   2. crcontext: The map which maps a name to a closure, 
                   Type: Id -> Int, where Id the name of a funcition and 
		   Int is its corresponding closure.
   3. crparams : the params of closure, it is same as fnParams
   4. crBody: The computation body of a closure
   
   closureCnt  : Stores the number of closures
   funclosure  : map a name to a closure

   ps: cr denotes closure
*/
    <closures>
	<closureCnt> 0:Int </closureCnt>
	<funclosure> .Map </funclosure>
	<closure multiplicity = "*">
	     <crId> 0:Int </crId>
	     <crContext> .Map </crContext>
	     <crParams> .FnParams </crParams>
	     <crBody> .K </crBody>  
   	 </closure>
    </closures>
    <memory>
	<memaddress> 0:Int </memaddress>
	<blocks>
		/*
	         * baddress : the id of the tuple
		 * bnum     : the number of datas stored 
	         * bstore   : is a map from an index (e.g. an offset) of a data
	   	*/
		<block multiplicity="*">
	   	      <baddress> .K </baddress>
		      <bnum> 0:Int </bnum>
	   	      <bstore> .Map </bstore>
      	  	</block>
     	</blocks>
	/*
	 * memorystatus indicuates that for each location 
	 * whether the memory of this location is reading, writing or free
	 */ 
	<memorystatus> .Map </memorystatus>
    </memory>
</T>

endmodule


