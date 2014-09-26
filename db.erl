-module(db).
-export([new/0, write/3, new_record/2, find/2, delete/2]).
%%destroy/1, write/3]).
%%-export([delete/3, read/2, match/2]).

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


find(_, Db) when Db =:= [] ->
    {error,instance};
find(Key, [Head| _]) when Key =:= element(2, Head) ->
    {ok, get_element(Head)};
find(Key, [_| Tail])  -> find(Key, Tail).


%% exists
exists(Key, [Head| _]) when Key =:= element(2, Head) ->
    {ok,true};
exists(Key, [_| Tail])  -> exists(Key, Tail);
exists(_Key, Db) when Db =:= [] ->
    {ok, false}.



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
    DbT = [{db_record, Key, Element}] ++ Db,
    DbT.

%% tests
write_test() ->
    ?assert(write("s1", "winter", new()) =:= [{db_record, "s1", "winter"}]).

write_exists_test() ->
    Db = new(),
    Db2 = write(write("s1", "winter", Db)
    ?assert(write("s1", "winter", Db2) =:= [{db_record, "s1", "winter"}]).

new_test() ->
    ?assert(length(new()) =:= 0).

find_test() ->
    Record = new_record("a", "stuff"),
    Key = get_key(Record),
    Element = get_element(Record),
    ?assert(find(Key, [Record]) =:= {ok,Element}).

get_element_test() ->
    ?assert(get_element({db_record, "s1", "winter"}) =:= "winter").

get_key_test() ->
    ?assert(get_key({db_record, "s1", "winter"}) =:= "s1").

exists_test() ->
    Record = new_record("a", "stuff"),
    Key = get_key(Record),
    ?assert(exists(Key, [Record]) =:= {ok,true}).
