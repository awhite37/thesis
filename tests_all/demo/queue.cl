fn main () {
(fn  (q) { q.0:=na 5 ; q.1:=na 0 ; q.2:=na 0 ; q.3:=na allocate(5); for (q,6);
let re = get (q) in (case (*na(re.0)) - 1 of {0, ((*na(re.1)) == 6)})})
(allocate(4)) } ;

fn for (q, i) { case (i > 0) of { clskip, (put (i, q) ; for (q, i - 1))}} ;

fn put (e, q) { (fn  (return) { case (((* na (q.2)) - (*na (q.1))) == (* na (q.0))) of
{((* na (q.3)).((* na (q.2)) mod (* na (q.0))) :=na e ; q.2 :=na (* na (q.2)) + 1 ; return:= 1), (return := 0)}  ; return }) (0) } ;

fn get (q)
{ (fn  (return) {
  case (* na (q.2)) - (*na(q.1)) == 0 of
  {(return.0 :=na 2;
  return.1 := na * na (((* na (q.3)).((* na (q.1)) mod (*na (q.0)) )))),
  (return.0 :=na 1; return.1 := na 1)}  ;
  q.1 := na ((* na (q.1)) + 1) ; return }) ( allocate(2) ) } ;
main()

