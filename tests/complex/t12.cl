fn main () { (fn  (a) { a:=na 5 ; borrow (a) ; ((fn  (b) { clskip }) (a)) ; eatBox ( a) }) ( allocate(1) ) } ;fn borrow (a) { clskip } ;fn eatBox (a) { clskip } ;main()

