-module(create_list).
-export([normal/1, reversed/1]).

create(N) ->
    lists:seq(1, N)
