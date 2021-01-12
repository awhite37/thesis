
require "lfunction.k"
require "composety.k"
require "depgraph.k"
require "rlib.k"


module TYCK

imports LFUNCTION
imports COMPOSETY
imports DEPGRAPH
imports RLIB

rule D:Decl Ds:Decls => D ~> Ds 

rule .Decls => .

endmodule