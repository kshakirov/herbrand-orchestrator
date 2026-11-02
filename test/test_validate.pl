:- ensure_loaded('../lib/coordinator/validate_topology.pl').

test_unique_source_sink :-
    source(1,NodeId),
    assertion(NodeId == 1),
    unique_source(1,Source),
    assertion(Source == 1),
    unique_sink(1,Sink),
    assertion(Sink == 3).
   

    

main :-
    assertz(node(1,1)),
    assertz(node(2,1)),
    assertz(node(3,1)),
    assertz(edge(1,2,1)),
    assertz(edge(4,2,1)),
    assertz(edge(2,3,1)),
    test_unique_source_sink,
    writeln('test_one_source_sink: ok').

:- initialization(main, program).
