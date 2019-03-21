lex -o indiv.c indiv.l
gcc indiv.c -o indiv
./indiv <indiv.in>indiv.out
echo ------------------------------------------------------------------
echo
cat indiv.out
echo
echo