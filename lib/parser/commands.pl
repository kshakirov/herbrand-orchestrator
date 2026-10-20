
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

fraiming(payload(0, 0, Acc), createTopoloy).
fraiming(payload(Length, Idx, Acc), other).
    
run_bytes([], State, State).
run_bytes([Byte|Bytes], State0, State) :-
    parser_state(State0, Byte, State1, Event),
    % handle_test_event(Event),
    format( ' ~s ', Event) ,
    run_bytes(Bytes, State1, State).

decode_opcode(Bytes, State0, Opcode):-
    run_bytes(Bytes,State0,State1),
    fraiming(State1, Opcode).




			       
