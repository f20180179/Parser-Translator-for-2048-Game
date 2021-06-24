fb: fb1.l fb1.y
	bison -d -t fb1.y
	flex fb1.l
	g++ -o run.out fb1.tab.c lex.yy.c -lfl
