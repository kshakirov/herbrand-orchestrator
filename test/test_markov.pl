markov_rule(abc, xyz).
markov_rule(xxx, aaa).
markov_rule(aaa, abc).


markov_step(String, Replacement):-
    (   markov_rule(String, Replacement),
	write(Replacement),
	write(" "),
	!,
	
    markov_step(Replacement,Next));
    String == String,
    write(String).

    
