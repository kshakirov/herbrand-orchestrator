% ========================================================================
% HERBRAND-ORCHESTRATOR: КОМПОНЕНТ М1 (ДЕТЕРМИНИРОВАННЫЙ ПАРСЕР)
% ========================================================================

% Гарантируем, что двойные кавычки "..." всегда интерпретируются как списки кодов
:- set_prolog_flag(double_quotes, codes).
:-set_prolog_flag(answer_write_options, [quoted(true), portray(true), max_depth(100)]).
:- set_prolog_flag(debugger_write_options, [quoted(true), portray(true), max_depth(100)]).

% 1. Синтаксический базис (Вынос терминаторов)
is_terminator(44).  % Код 0', (запятая)
is_terminator(10).  % Код 0'\n (перенос строки)

% 2. Сборщик всей строки (csv_line//1)
% Рекурсивный шаг имеет наивысший приоритет. 
% Если в потоке есть буквы, сначала собираем их в ячейку.
csv_file([Line| Rest])-->
    csv_line(Line),
     !,
     ("\n"
     -> csv_file(Rest)
     ; { Rest = [] }
     ).



csv_line([Cell|Rest]) -->
    cell(Cell),
    !, 
    (   ","                 
    ->  csv_line(Rest)      
    ;   { Rest = [] }       
    ).

% Базис 1: Конец строки (\n)
csv_line([]) --> 
    "\n", 
    !, 
    "\n".

% Базис 2: Конец файла (пустой поток)
csv_line([]) --> 
    [], 
    !.

% 3. Материализация атома (cell//1)
cell(Atom) --> 
    parseCSV(Codes), 
    { atom_codes(Atom, Codes) }.

% 4. Сборщик кодов ячейки (parseCSV//1)
% Шаг рекурсии: если символ НЕ терминатор, забираем его и идем глубь
parseCSV([Char|Codes]) --> 
    [Char], 
    { \+ is_terminator(Char) }, 
    !, 
    parseCSV(Codes).

% Базис: во всех остальных случаях (впереди терминатор или конец потока) 
% останавливаемся и ничего не трогаем из потока.
parseCSV([]) --> 
    [].


csv_file([]) --> 
    [], 
    !.
