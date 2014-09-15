-module(db).
-export([new/0, destroy/1, write/3]).
-export([delete/3, read/2, match/2]).

%% make a new DB
%% for now this is a very simple list.
new() ->
    [].

%% add a new record to the database.
%% a key is just the first element in a tuple
%% an element is the data that will be found at that key.
write(Key, Element, Db) ->
    new_record = {db_record, Key, Element},
    [new_record] ++ Db,
    Db.
