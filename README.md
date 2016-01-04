# Tablemaker

Simple column formatter for erlang.

Feed it a list of lists of strings.

`tablemaker:fmt` returns a string with column separators

`tablemaker:fmt_with_separators` returns a string with column and row separators

```
1> io:format(tablemaker:fmt([["C1R1", "C2R1"], ["C1R2", "C2R2"]])).     
C1R1 | C2R1 
C1R2 | C2R2 

2> io:format(tablemaker:fmt([["C1R1randomstuff", "C2R1"], ["C1R2", "C2R2random"]])).
C1R1randomstuff | C2R1       
C1R2            | C2R2random 

3> io:format(tablemaker:fmt_with_separators([["C1R1randomstuff", "C2R1"], ["C1R2", "C2R2random"]])).
C1R1randomstuff | C2R1       
------------------------------
C1R2            | C2R2random
```
