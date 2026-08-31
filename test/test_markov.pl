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

    
