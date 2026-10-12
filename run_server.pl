:- use_module(library(socket)).

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
        tcp_open_socket(ClientSocket, In, Out),
        serve_client(In, Out, Peer),
        close_streams(In, Out)
    ).

serve_client(In, Out, Peer) :-
    format("Connected: ~q~n", [Peer]),
    get_byte(In, Byte),
    format("Received byte: ~d~n", [Byte]),
    put_byte(Out, Byte),
    flush_output(Out).

close_streams(In, Out) :-
    close(In, [force(true)]),
    close(Out, [force(true)]).
