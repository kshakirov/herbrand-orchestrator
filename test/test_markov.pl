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

test_cut_prefix(L, Len1,0,R):- test_cut_prefix(L,Len1,0,[], R).
test_cut_prefix([], Len,Len,R,R).
test_cut_prefix([], _,_,R,[]).
test_cut_prefix(L, Len, Len,R,R).
test_cut_prefix([H|T], Len1,Len2, Prefix, R):-
    Len3 is Len2 + 1,
    test_cut_prefix(T, Len1 , Len3, [H | Prefix], R).

    
    
    
