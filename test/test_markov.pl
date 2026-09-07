markov_rule(abc, xyz).
markov_rule(xxx, aaa).
markov_rule(aaa, abc).


markov_step(String, Next):-
    (   markov_rule(String, Replacement),
	write(Replacement),
	write(" inside "),
	!,
	
    markov_step(Replacement,Next));
    Next =String,
    write("NExt "),
    write(Next).

test_cut_prefix(L, Len1,0,R):- test_cut_prefix(L,Len1,0,R, []);   write("\nfail"), R = [].
test_cut_prefix([], Len1,Len2,R):- R = [].  
test_cut_prefix([], Len,Len,R,R).
test_cut_prefix([], Len1,Len2,R,X):-
    Len1 \== Len2,
    write("fdfdfd"),
    fail.
   

test_cut_prefix(L, Len, Len,R,R).
test_cut_prefix([H|T], Len1,Len2, Acc, Tail):-
    Len2 < Len1,
    Len3 is Len2 + 1,
    Acc = [H | DiffTail],
    test_cut_prefix(T, Len1 , Len3, DiffTail,Tail).
    

    
    
    
