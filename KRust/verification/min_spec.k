
require "../surfacerust.k"
require "../cl-syntax.k"
require "../cl-semantics.k"
require "int_list.k"
require "int_set.k"

module MIN-SPEC

imports SURFACERUST
imports CL-SYNTAX
imports CL-SEMANTICS
imports INT-LIST
imports INT-SET



rule
     <threads>
     <thread>
     <k>
	case 2 < 5 of {X:Int,Y:Int} => X
     </k>
     </thread>
     </threads>
     
//     requires X >=Int 1 andBool X <=Int 100 andBool Y >=Int 1 andBool Y <=Int 100


endmodule