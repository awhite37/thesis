fn main (){
   (fn  (v1) { v1.0:=na1 ; v1.1:=na2 ; v1.2:=na3 ;
   	(fn  (v2) { v2.0:=na4 ; v2.1:=na5 ; v2.2:=na6 ;
	     (fn  (answer) { answer :=na foo ( v1, 2, v2, 2) }) ( allocate(1) ) })
	 ( allocate(3)) }) ( allocate(3)) } ;

fn foo (v1, i1, v2, i2) { (fn  (s1) { (fn  (s2) { s1 + s2 }) (sumvec ( v2, i2)) }) (sumvec ( v1, i1)) } ;

fn sumvec (v, i) { (fn  (r) { case i == 0 of {r:= * na (v.i) + sumvec ( v, i - 1),r := * na (v.i)}  ; r }) ( 0 ) } ;

main()

