
require "tydef.k"
require "lang.k"

module CONFIGURATION

imports TYDEF
imports LANG

syntax KResult
       ::= ExpTy
	 | VoidTy

/*@
    The information of a variable\\
    Ident: the name of the variable\\
    Lifetime: the lifetime of the variable\\
    Mutability: whether this variable is mutable\\
    RType: The Type of the variable
*/

syntax VarInfo
       ::= varInfo(Int,Mutability,RType,Int,Int,Bool)
         | varInfo(Int,Int,Bool)
	 | dep(Set)


configuration

	<k> $PGM:Rust </k>
	   <varCtx>
	     <varCnt> 0:Int </varCnt>
	     <varInfo> .Map  </varInfo>
	   </varCtx>

	   <typeCtx> .Map </typeCtx>
	   <env> .Map </env>
	   <stackEnv> .List </stackEnv>

	   <depGraph> .Map </depGraph>
	   
	   <lifetime>
		<tclftvars> .Set </tclftvars>
	  	<currentLft> 0:Int </currentLft>
	   </lifetime>
	   
	<comtypes>
	   <comtype multiplicity="*"  type="Set">
	       <ctyId> -1:Int </ctyId>
	       <ctyKind> 0:Int </ctyKind> 
	       <ctyElem> .Map  </ctyElem>
	       <cntElem> 0:Int </cntElem>
	   </comtype>
	</comtypes>
   <ctyCnt> 0:Int </ctyCnt>



endmodule

















