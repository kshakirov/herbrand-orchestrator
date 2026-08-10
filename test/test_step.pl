:- set_prolog_flag(double_quotes, codes).

% 1. Терминаторы
is_terminator(44).  % ','
is_terminator(10).  % '\n'

% 2. Уровень строки (с преобразованием в атомы)
csv_file([Line|Rest]) -->
    csv_line(Line),
    ("\n" -> csv_file(Rest)
    ; { Rest = []}
    ).

csv_line([Atom | Rest]) -->
    cell(RawBytes),
    
    { atom_codes(Atom, RawBytes) },
    (   "," -> csv_line(Rest)
    ;   { Rest = [] }
    ).

% 3. Побайтовое накопление ячейки
cell([Byte | Rest]) -->
    [Byte],
    { \+ is_terminator(Byte) },
    !,
    cell(Rest).
cell([]) --> [].
