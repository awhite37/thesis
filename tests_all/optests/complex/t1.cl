fn main () { (fn  (v) {v.0 := na 1; v.1:=na2 ; v.2:=na3 ; v.3:=na4 ; v.4:=na5 ; for (v, 0) }) ( allocate(5)) } ;
fn for (v, i) { case i <= 4 of {0, (fn (k) {(* na k) + for ( v, i + 1) }) (v.i)}  } ; main()

