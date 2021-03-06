-module(db).
-export([new/0, write/3, new_record/2, read/2, delete/2, match/2]).

-include_lib("eunit/include/eunit.hrl").

%% make a new DB
%% for now this is a very simple list.
new() -> [].

new_record(Key, Data) ->
    {db_record, Key, Data}.


get_element(Record) ->
    element(3, Record).


get_key(Record) ->
    element(2, Record).


read(_, Db) when Db =:= [] ->
    {error,instance};
read(Key, [Head| _]) when Key =:= element(2, Head) ->
    {ok, get_element(Head)};
read(Key, [_| Tail])  -> read(Key, Tail).


%% exists
exists(Key, [Head| _]) when Key =:= element(2, Head) ->
    true;
exists(_Key, Db) when Db =:= [] ->
    false;
exists(Key, [_| Tail])  -> exists(Key, Tail).


%% delete
%% if the key is found, return the database without
delete(Key, Db) ->
    delete_help(Key, Db, []).

delete_help(Key, [Head| Tail], Checked) when Key =:= element(2, Head) ->
    Checked ++ Tail;
%% case of element not in db, just return all
delete_help(_Key, Db, Checked) when Db =:= [] ->
    Checked;
delete_help(Key, [_| Tail], Checked)  -> delete_help(Key, Tail, Checked).


%% add a new record to the database.
%% a key is just the first element in a tuple
%% an element is the data that will be found at that key.
%% if the element exists, overwrite the current element
write(Key, Element, Db) ->
    %% check if the key already exists, if it does, delete it from the db
    Exists = exists(Key, Db),
    %% then insert a new element
    write_help(Key, Element, Db, Exists).


write_help(Key, Element, Db, false) ->
    [{db_record, Key, Element}] ++ Db;
write_help(Key, Element, Db, true) ->
    DbN = delete(Key, Db),
    [{db_record, Key, Element}] ++ DbN.

%% match - return a list of keys containing the given element
match(Element, Db) ->
    match_help(Element, Db, []).

match_help(Element, [Head | Tail], Found) when Element =:= element(3, Head) ->
    match_help(Element, Tail, Found ++ [element(2, Head)]);
match_help(Element, [Head | Tail], Found) when Element =/= element(3, Head) ->
    match_help(Element, Tail, Found);
match_help(_, [], Found) ->
    Found.



%% tests
match_test() ->
    El = "blah",
    Db = [{db_record, "thing", "blah"}, {db_record, "foop", "blah"}],
    Res = match(El, Db),
    Exp = ["thing", "foop"],
    io:format("Res: ~s, exp: ~s", [Res, Exp]),
    ?assert(Res =:= Exp).

write_test() ->
    ?assert(write("s1", "winter", new()) =:= [{db_record, "s1", "winter"}]).

write_exists_test() ->
    Db = new(),
    Db2 = write("s1", "winter", Db),
    ?assert(write("s1", "winter", Db2) =:= [{db_record, "s1", "winter"}]).

new_test() ->
    ?assert(length(new()) =:= 0).

read_test() ->
    Record = new_record("a", "stuff"),
    Key = get_key(Record),
    Element = get_element(Record),
    ?assert(read('a', []) =:= {error,instance}),
    ?assert(read(Key, [Record]) =:= {ok,Element}).

get_element_test() ->
    ?assert(get_element({db_record, "s1", "winter"}) =:= "winter").

get_key_test() ->
    ?assert(get_key({db_record, "s1", "winter"}) =:= "s1").

exists_test() ->
    Record = new_record("a", "stuff"),
    Key = get_key(Record),
    ?assert(exists(Key, [Record]) =:= true).
