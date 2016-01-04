-module(tablemaker).

-author(tyler_neely).

-export([fmt/1, fmt_with_separators/1]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.


column_lengths([])->
  [];
column_lengths(L = [H|_])->
  column_lengths(L, [0 || _V <- H]).

column_lengths([], AccIn) ->
  AccIn;
column_lengths([L|Rest], [])->
  InitialMaxes = lengths(L),
  column_lengths(Rest, InitialMaxes);
column_lengths([L|Rest], AccIn) ->
  MaxSoFar = max_2_lists(L, AccIn, []),
  column_lengths(Rest, MaxSoFar).

max_2_lists([A|RestA], [B|RestB], AccIn) ->
  Max = max(length(A), B),
  max_2_lists(RestA, RestB, [Max | AccIn]);
max_2_lists(_, _, AccIn) ->
  lists:reverse(AccIn).

lengths(L) ->
  lists:map(fun length/1, L).

fmt_with_separators(InputRows) ->
  Maxes = column_lengths(InputRows),
  Rows = fmt(Maxes, InputRows, []),
  SeparatorRowLen = lists:sum(Maxes) + (2 * length(Maxes)),
  SeparatorRow = [$- || _S <- lists:seq(0, SeparatorRowLen)] ++ "~n",
  string:join(Rows, "~n" ++ SeparatorRow).

fmt(InputRows) ->
  Maxes = column_lengths(InputRows),
  Rows = fmt(Maxes, InputRows, []),
  string:join(Rows, "~n").

fmt(_Maxes, [], FmtRows) ->
  lists:reverse(FmtRows);
fmt(Maxes, [H|Rest], FmtRows) ->
  FormattedRow = fmt_row(Maxes, H),
  fmt(Maxes, Rest, [FormattedRow|FmtRows]).

fmt_row(Maxes, Row) ->
  PaddedParts = lists:zipwith(fun pad/2, Maxes, Row),
  string:join(PaddedParts, "| ").

pad(Len, Item) ->
  Item ++ [$\s || _S <- lists:seq(length(Item), Len)].

-ifdef(TEST).

pad_test() ->
  ?assertEqual("yo      ", pad(7, "yo")),
  ?assertEqual("yo  ", pad(3, "yo")),
  ?assertEqual("yo ", pad(2, "yo")).

fmt_row_test() ->
  ?assertEqual("1    | 3 ", fmt_row([4, 1], ["1", "3"])).

max_n_test() ->
  Inputs = [["abcd",   "abcdefg", "a"],
            ["32.232", "29",      "9"],
            ["534",    "34131",   "32"],
            ["54.23",  "544",     "655"]],

  ?assertEqual([6, 7, 3], column_lengths(Inputs)),
  ?assertEqual([], column_lengths([])).

fmt_test() ->
  Inputs = [["abcd",   "abcdefg", "a"],
            ["32.232", "29",      "9"],
            ["534",    "34131",   "32"],
            ["54.23",  "544",     "655"]],

  ?assertEqual("abcd   | abcdefg | a   ~n" ++
               "32.232 | 29      | 9   ~n" ++
               "534    | 34131   | 32  ~n" ++
               "54.23  | 544     | 655 ",
               fmt(Inputs)).

fmt_with_separators_test() ->
  Inputs = [["abcd",   "abcdefg", "a"],
            ["32.232", "29",      "9"],
            ["534",    "34131",   "32"],
            ["54.23",  "544",     "655"]],

  ?assertEqual("abcd   | abcdefg | a   ~n" ++
               "-----------------------~n" ++
               "32.232 | 29      | 9   ~n" ++
               "-----------------------~n" ++
               "534    | 34131   | 32  ~n" ++
               "-----------------------~n" ++
               "54.23  | 544     | 655 ",
               fmt_with_separators(Inputs)).

-endif.
