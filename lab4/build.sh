rm -f y.* a.out lex.yy.c lol
#yacc: if debug not needed, invoke with -d only 
#yacc -d *.y  
yacc -vtd *.y
#lex: option -s to supress default action ECHO
lex -s *.l
cc *.c -o lol

echo "--------------------------------------------------------"
echo 

./lol <test.in>test.out

cat test.out


echo 