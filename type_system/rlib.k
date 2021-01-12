
require "lfunction.k"
require "composety.k"
require "depgraph.k"

module RLIB

imports LFUNCTION
imports COMPOSETY
imports DEPGRAPH


/*
Consider the channel
*/

syntax RType
       ::= channel(RType)

syntax RValue
       ::= RValue "." "send" "(" RValue ")"	[seqstrict]
         | RValue "." "recv" "(" ")"    		[strict]

rule expTy(var(I:Int),channel(own(T)),_,_,_,_).send( expTy(R,own(T),A,B,C,D) )
				=> move(expTy(R,own(T),A,B,C,D))

rule expTy(var(I:Int),channel(own(T)),_,_,_,_).recv() => expTy(var(I).recv(), own(T), 0,-1,-1,mut)

endmodule