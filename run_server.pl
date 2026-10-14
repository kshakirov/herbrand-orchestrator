:- use_module(library(socket)).
:-include('lib/parser/commands.pl').
run_server(Port) :-
    setup_call_cleanup(
        open_server(Port, ListenSocket),
        accept_loop(ListenSocket),
        tcp_close_socket(ListenSocket)
    ).

open_server(Port, ListenSocket) :-
    tcp_socket(ListenSocket),
    tcp_setopt(ListenSocket, reuseaddr),
    tcp_bind(ListenSocket, Port),
    tcp_listen(ListenSocket, 16).

accept_loop(ListenSocket) :-
    tcp_accept(ListenSocket, ClientSocket, Peer),
    handle_connection(ClientSocket, Peer),
    accept_loop(ListenSocket).

handle_connection(ClientSocket, Peer) :-
    setup_call_cleanup(
        tcp_open_socket(ClientSocket, StreamPair),
        (   stream_pair(StreamPair, In, Out),
            once(serve_client(In, Out, Peer))
        ),
        close(StreamPair)
    ).

serve_client(In, Out, Peer) :-
    read_bytes(In, Out, start, Peer).
    % format("Connected: ~q~n", [Peer]),
    % get_byte(In, Byte),
    % format("Received byte: ~d~n", [Byte]),
    % parser_state(start, Byte,State1,Event),
    % format("state is ~s ~n", Event),
    % put_byte(Out, Byte),
    % flush_output(Out).

read_bytes(In, Out, State0, Peer):-
    format("Connected: ~q~n", [Peer]),
    get_byte(In, Byte),
    format("Received byte: ~d~n", [Byte]),
    (   Byte \= -1
    ->  parser_state(State0, Byte, State1, Event),
	format("state is ~s~n", [Event]),
	(   Event == start
	->  put_byte(Out, 1),
	    flush_output(Out),
	    read_bytes(In, Out, start, Peer)
	;   read_bytes(In, Out, State1, Peer)
	)
    ;   true
    ).
    
