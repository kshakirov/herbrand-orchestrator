
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
    
    
parser_state(payload_length,Length, payload(Length,0,[]), needs_more_data).
parser_state(magic, 84,payload_length,   needs_more_data).
parser_state(start, 83, magic, needs_more_data).


    
run_bytes([], State, State).
run_bytes([Byte|Bytes], State0, State) :-
    parser_state(State0, Byte, State1, Event),
    % handle_test_event(Event),
    format( ' ~s ', Event) ,
     run_bytes(Bytes, State1, State).
