:- ensure_loaded('../lib/parser/commands.pl').

test_agg_payload :-
    pack_edges(1, Payload),
    assertion(Payload == [0,1,0,2,0,2,0,3]),
    topology_map(1, Map),
    assertion(Map == [0x53,0x54,0,11,6,0, 1,0,1,0,2,0,2,0,3]).

main :-
    assertz(node(1,1)),
    assertz(node(2,1)),
    assertz(node(3,1)),
    assertz(edge(1,2,1)),
    assertz(edge(2,3,1)),
    test_agg_payload,
    writeln('test_commands: ok').

:- initialization(main, program).
