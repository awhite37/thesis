
require "tydef.k"

module TYPROP

imports TYDEF

syntax TyPropKind
       ::= "#Copy"
         | "#Move"

syntax TyProp
       ::= TyPropCopy

syntax TyPropCopy
       ::= tyPropCopy(RType)

rule tyPropCopy(i32) => #Copy
rule tyPropCopy(own(_)) => #Move
rule tyPropCopy(ref(_,_,_)) => #Copy


endmodule






























