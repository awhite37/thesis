
require "cl-semantics.k"
require "verification.k"

module OPSEMANTICS

imports CL-SEMANTICS
imports VERIFICATION

rule let X:Ident = E1:Exp in E2:Exp => lazyCall((fn (X) {E2}), E1)

rule E1:Exp ; E2:Exp => let #anonymous = E1 in E2

rule if E:Exp then E1:Exp else E2:Exp => case E of {E2, E1}

endmodule