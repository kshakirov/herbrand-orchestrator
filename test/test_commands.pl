:- ensure_loaded('../lib/parser/commands.pl').

test_magic :-
    assertion(run_bytes([0x53, 0x54], start, payload_length)).

main :-
    test_magic,
    writeln('test_commands: ok').

:- initialization(main, program).
