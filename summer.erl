-module(summer).
-export([sum/1, sum_to_n/1, add_to/2, halver/1]).

sum(List) -> sum_acc(List,0).
sum_acc([],Sum) -> Sum;
sum_acc([Head|Tail], Sum) -> sum_acc(Tail, Head+Sum).

%% make a list of numbers inside of a range, then sum them %%
sum_to_n(N) -> sum(lists:seq(1, N)).

halver(A) -> float(A)/2.

%% write a recursive function that builds a list of numbers %%
add_to(Elm, List) when is_list(Elm) ->
    Elm ++ List.
