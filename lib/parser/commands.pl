
% start — ждём 0x53;
% magic — уже получили 0x53, ждём 0x54;
% length_high — ждём старший байт длины;
% length_low(HighByte) — старший сохранён, ждём младший;
% payload(...) — читаем заявленное число байтов.



parser_state(payload(Length,CurrentIdx,Acc),Byte,State1,Event):-
    Length  - 1> CurrentIdx,
(    NewAcc =[Byte | Acc],
    NewIdx is  CurrentIdx + 1,
    Event =needs_more_data,
    State1 = payload(Length,NewIdx, NewAcc));
    NewAcc =[Byte | Acc],
    State1 = (payload(Length, CurrentIdx, NewAcc)),
    Event = start.
    
parser_state(payload_length_low(High),Low, payload(Length,0,[]),needs_more_data):- Length is (High << 8) + Low.
parser_state(payload_length_high,High, payload_length_low(High), needs_more_data).
parser_state(magic, 84,payload_length_high,   needs_more_data).
parser_state(start, 83, magic, needs_more_data).


handle_create_topology(counting_edges, [], hande_state(_TopologyId,0,0)).
handle_create_topology(counting_edges, [O|[N|[A|[R|Rest]]]], hande_state(TopologyId,0, EdgeCount)):-
    EdgeCount > 0,
    (NewEdgeCount is EdgeCount -1,
     OneNodeId is (O << 8) + N ,
     AnotherNodeId is (A << 8) + R ,
     assertz(edge(OneNodeId, AnotherNodeId,  TopologyId)),
     handle_create_topology(counting_edges, Rest, hande_state(TopologyId, 0, NewEdgeCount))).



handle_create_topology(edge_count, [N | [C|Rest]], hande_state(TopologyId, 0,0)):-
    EdgeCount is (N << 8) + C ,
    handle_create_topology(counting_edges, Rest, hande_state(TopologyId,0, EdgeCount)).
handle_create_topology(counting_nodes, [I|[D|Rest]], hande_state(TopologyId, NodeCount, 0)):-
    NodeCount > 0,
    (NewNodeCount is NodeCount -1,
    NodeId is (I << 8) + D ,
    assertz(node(NodeId, TopologyId)),
    handle_create_topology(counting_nodes, Rest, hande_state(TopologyId, NewNodeCount, 0)));
    NodeCount =:= 0,
    handle_create_topology(edge_count, [I|[D|Rest]], hande_state(TopologyId, 0, 0)).
handle_create_topology(node_count, [N | [C|Rest]], hande_state(TopologyId, 0,0)):-
    NodeCount is (N << 8) + C ,
    handle_create_topology(counting_nodes, Rest, hande_state(TopologyId,NodeCount, 0)).
handle_create_topology(start, [I | [D| Rest]], hande_state(0, 0, 0) ):-
  TopologyId is (I << 8) + D ,
  handle_create_topology(node_count, Rest, hande_state(TopologyId, 0, 0)).


dispatch_command(payload(_Length, _Idx, [3 |Body])) :- handle_create_topology(start, Body, hande_state(0,0,0)).


reverse_body(payload(Length, Idx, Acc), (payload(Length,Idx,Body))):-reverse(Acc, Body).

consume_bytes([], State, State).
consume_bytes([Byte|Bytes], State0, State) :-
    parser_state(State0, Byte, State1, Event),
    % handle_test_event(Event),
    format( ' ~s ', Event) ,
    consume_bytes(Bytes, State1, State).

process_frame(Bytes, State0, _Opcode):-
    consume_bytes(Bytes,State0,State1),
    reverse_body(State1, State2),
    dispatch_command(State2).




			       
