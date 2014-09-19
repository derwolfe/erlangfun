-module(db).
-export([new/0, write/3]).
%%destroy/1, write/3]).
%%-export([delete/3, read/2, match/2]).

-include_lib("eunit/include/eunit.hrl").

%% make a new DB
%% for now this is a very simple list.
new() ->
    [].

new_test() ->
    ?assert(length(new()) =:= 0).

new_record(Key, Data) ->
    {db_record, Key, Data}.

get_element(Record) ->
    element(3, Record).

get_element_test() ->
    ?assert(get_element({db_record, "s1", "winter"}) =:= "winter").

get_key(Record) ->
    element(2, Record).

get_key_test() ->
    ?assert(get_key({db_record, "s1", "winter"}) =:= "s1").

find(_, Db) when Db =:= [] ->
    {error,instance};
find(Key, [Head| _]) when Key =:= element(2, Head) ->
    {ok, get_element(Head)};
find(Key, [_| Tail])  -> find(Key, Tail).

find_test() ->
    Record = new_record("a", "stuff"),
    Key = get_key(Record),
    Element = get_element(Record),
    ?assert(find(Key, [Record]) =:= {ok,Element}).

exists(_, Db) when Db =:= [] ->
    {error,instance};
exists(Key, [Head| _]) when Key =:= element(2, Head) ->
    {ok,true};
exists(Key, [_| Tail])  -> exists(Key, Tail).

exists_test() ->
    Record = new_record("a", "stuff"),
    Key = get_key(Record),
    ?assert(exists(Key, [Record]) =:= {ok,true}).

%% add a new record to the database.
%% a key is just the first element in a tuple
%% an element is the data that will be found at that key.
write(Key, Element, Db) ->
    DbT = [{db_record, Key, Element}] ++ Db,
    DbT.

write_test() ->
    ?assert(write("s1", "winter", new()) =:= [{db_record, "s1", "winter"}]).
