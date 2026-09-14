:- use_module(library(portray_text)).
:-set_portray_text(enabled, true).


:- set_prolog_flag(double_quotes, codes).

markov_rule("abc", "xyz").
markov_rule("xxx", "aaa").
markov_rule("aaa","abc").

markov_step(String, Next):-
    (   markov_rule(String, Replacement),
	write(Replacement),
	write(" inside "),
	!,
	
    markov_step(Replacement,Next));
    Next =String,
    write("NExt "),
    write(Next).

test_cut_prefix(L, Len1,0,R, Rest):- test_cut_prefix(L,Len1,0,R, [],Rest);  format("Fail test_cut_prefix ~n"), R = [].
test_cut_prefix([], Len,Len,R,R,[]).
test_cut_prefix([], Len1,Len2,R,X,Rest):-
    Len1 \== Len2,

    fail.
   

test_cut_prefix(L, Len, Len,R,R, L).
test_cut_prefix([H|T], Len1,Len2, Acc, Tail, Rest):-
    Len2 < Len1,
    Len3 is Len2 + 1,
    Acc = [H | DiffTail],
    test_cut_prefix(T, Len1 , Len3, DiffTail,Tail, Rest).
    


markov_step_mod(String, Next):-
    (   markov_rule(Template, R),
	length(Template,N),
	test_cut_prefix(String,N,0,Fragment, Rest),
	format( "Fragment before rule ~s~n", [Fragment]),
	markov_rule(Fragment, Replacement),
	append(Replacement, Rest, WholeReplacement),
	format("Now the append "),
	format("Fragment after rule ~s~n", [WholeReplacement]),
	format("Finishing"),
	!,
	
    markov_step_mod(WholeReplacement,Next));
    Next =String,
   format("Next~n "),
   format("~s~n", [Next]).

    
    
