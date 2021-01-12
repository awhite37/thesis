
tyck-kompiled: tyck.k lang.k tydef.k configuration.k llifetime.k core-function.k lexpression.k lstatement.k lfunction.k depgraph.k wellform.k rlib.k
	kompile --debug tyck.k --backend haskell


clean:
	rm -f -r *~ \#* tests/*~ tests/*/*~

cleanall:
	rm -f -r *~ tests/*~ tests/*/*~ *-kompiled


tests: townership

townership: to1 wto1

to1: tests/ownership/t1.r
	krun tests/ownership/t1.r

wto1: tests/ownership/t1.r
	krun tests/ownership/t1.r
