-module(lister).
-export([create/1, reverse_create/1, print/1]).

-include_lib("eunit/include/eunit.hrl").

%% create a list that is in order
create(N) -> create_acc(N, []).

create_acc(0, ACC) -> ACC;
create_acc(N, ACC) -> create_acc(N - 1, [N] ++ ACC).

%% create a reversed list
reverse_create(N) -> reverse_acc(N, []).

reverse_acc(0, ACC) -> ACC;
reverse_acc(N, ACC) -> reverse_acc(N - 1, ACC ++ [N]).

%% test reverse create
reverse_test() -> ?assert(length(reverse_create(5)) =:= 5).

%% given a number print it out
list_printer(N) -> io:format("Number:~p~n",[N]).

%% when passed a list, print all of the items of the list
print_all([]) -> io:format("No more elements");
print_all(XS) ->
    list_printer(hd(XS)),
    print_all(tl(XS)).

%% print out a list of integers
print(N) ->
    print_all(create(N)).
