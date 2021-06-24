/* simplest version of calculator */
%{

#include<string.h>
#include<cstdio>
#include<iostream>
#include<stdio.h>
#include<vector>
#include<cstring>
#include<algorithm>
#include "fb1.tab.h"


bool filemode = false;
int errorbit = 0;
extern FILE *yyin;

int yylex(void);
void yyerror(const char *s) {
    if(errorbit == 0) {
        errorbit = 1;
        printf("--->");
        fprintf(stderr, "-1\n");
    }
    yyparse();
}

using namespace std;

#define ADD      '+'
#define SUBTRACT '-'
#define MULTIPLY '*'
#define DIVIDE   '/'
#define LEFT     'a'
#define RIGHT    'd'
#define UP       'w'
#define DOWN     's'



struct Element{
    int val;
    vector<string> names;
    Element() : val(0), names(){};
};

vector<vector<Element>> board(4, vector<Element>(4, Element()));


void insert_random() {
    int x = rand()%4, y = rand()%4;
    if(board[x][y].val == 0) {
        board[x][y].val = 2;
        return;
    }    
    insert_random();
}

void print_board() {
    printf("\n");
    for(int i=0; i<4; i++){
        for(int j=0; j<4; j++){
            cout << board[i][j].val << " ";
        }
        printf("\n");
    }
}

void rotate_board_c() {
    vector<vector<Element>> temp_board(4, vector<Element>(4));
    int R=3, C=3;
    for(int i=0; i<4; i++){
        for(int j=0; j<4; j++){
            temp_board[j][C-i] = board[i][j];
        }
    }
    board = temp_board;
}

void rotate_board_a(){
    vector<vector<Element>> temp_board(4, vector<Element>(4));
    int R=3, C=3;
    for(int i=0; i<4; i++){
        for(int j=0; j<4; j++){
            temp_board[i][j] = board[j][C-i];
        }
    }
    board = temp_board;
}

void mergeRow(vector<Element>& row, char op, char d) {
    for(int i = 0; i < row.size()-1; i++) {
        if(row[i].val == row[i+1].val) {
            
            if(op == '+') {
                row[i].val += row[i+1].val;
            }
            else if(op == '-') {
                row[i].val -= row[i+1].val;
            }
            else if(op == '/') {
                row[i].val /= row[i+1].val;
            }
            else {
                row[i].val *= row[i+1].val;
            }

            row[i].names.insert(row[i].names.end(),
                row[i+1].names.begin(), row[i+1].names.end());

            for(int j = i+1; j < row.size()-1; j++) {//hops
                row[j] = row[j+1];
            }

            row.pop_back();
            /*if(row[i].val == row[i+1].val)
                 i--;*/
        }
    }
    if(d == 'd')
        reverse(row.begin(), row.end());
}

void makeMove(char op, char d) {
    for(int i = 0; i < 4; i++) {
        vector<Element> temp_row;
        vector<int> not_picked;
        for(int j = 0; j < 4; j++) {
            if(board[i][j].val != 0) {
                temp_row.push_back(board[i][j]);
            }
            else {
                not_picked.push_back(j);
            }
        }
        if(temp_row.size() == 0)
            continue;
        if(d == 'd')
            reverse(temp_row.begin(), temp_row.end());
        
        mergeRow(temp_row, op, d);

        while(temp_row.size() < 4) {
            if(d == 'a')
                temp_row.push_back(Element());
            if(d == 'd')
                temp_row.insert(temp_row.begin(), Element());
        }

        for(int k = 0; k < not_picked.size(); k++) {
            int index = not_picked[k];
            temp_row[index].names.insert(temp_row[index].names.begin(),
            board[i][index].names.begin(), board[i][index].names.end());
        }

        board[i] = temp_row;
    }

    insert_random();
}

void left(char op) {
    makeMove(op, 'a');
}
void up(char op) {
    rotate_board_a();
    makeMove(op, 'a');
    rotate_board_c();
}
void right(char op) {
    makeMove(op, 'd');
}
void down(char op) {
    rotate_board_c();
    makeMove(op, 'a');
    rotate_board_a();
}

void assign(int x, int y, int v) {
    board[x][y].val = v;
}

int query(int x, int y) {
    return board[x][y].val;
}

void name(int x, int y, string name) {
    board[x][y].names.push_back(name);
}

void output() {
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            //fprintf(stderr, "%d ", board[i][j].val);
            cerr << board[i][j].val << " ";
        }
    }
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            if(board[i][j].names.size() == 0)
                continue;
            cerr << i << "," << j;
            for(int k = 0; k < board[i][j].names.size(); k++) {
                string name = board[i][j].names[k];
                //fprintf(stderr, "%d,%d%c", i, j, name);
                cerr << name;
                if(k < board[i][j].names.size()-1) {
                    //fprintf(stderr, ",");
                    cerr << ",";
                }
                else {
                    //fprintf(stderr, " ");
                    cerr << " ";
                }
            }
        }
    }
    //fprintf(stderr, "\n");
    cerr << "\n";
}

void movement(char op, char d) {
    if(d == 'w') {
        up(op);
    }
    else if(d == 'a') {
        left(op);
    }
    else if(d == 'd') {
        right(op);
    }
    else {
        down(op);
    }
}

void giveName(char *n, int x, int y) {
    string str(n);
    if(x>=1 && x<=4 && y>=1 && y<=4) {
        name(x-1, y-1, str); 
        print_board(); 
        output();
        errorbit=0;
    }
    else {
        printf("Invalid Coordinates.\n"); 
        errorbit=1; 
        fprintf(stderr, "-1\n");
    }
}

void queryHelper(int x, int y) {
    //cout << query(x, y) << "\n";
    if(x>=1 && x<=4 && y>=1 && y<=4) {
        cout << query(x-1,y-1); 
        print_board(); 
        output(); 
        errorbit=0;
    }else {
        printf("Invalid Coordinates.\n"); 
        errorbit=1; 
        fprintf(stderr, "-1\n");
    }
}

void assignmentHelper(int val, int x, int y) {
    if(x>=1 && x<=4 && y>=1 && y<=4) {
        assign(x-1,y-1,val);
        print_board(); 
        output(); 
        errorbit=0;
    }
    else {
        printf("Invalid Coordinates.\n"); 
        errorbit=1; 
        fprintf(stderr, "-1\n");
    }
}


%}
/* declare tokens */

// int yylex(void);
// void yyerror(const char *);

%union{
  int num;
  char *str;
  char ch;
}

%token<num> NUMBER
%token<ch> YADD YSUB YMUL YDIV YLEFT YRIGHT YUP YDOWN ASSIGN TO VAR IS VALUE IN STOP COMMA
%token EOL 
%token<str> STRING 

%%

// commandlist : /* nothing */                       
// //  | commandlist exp EOL { printf("= %d\n", $2); } 
// //  ;
commandlist: /* nothing */  
           | commandlist command EOL { errorbit = 0; }
;

command: assignment
       | movement 
       | query
       | naming
;

naming: VAR STRING IS NUMBER COMMA NUMBER STOP          {giveName($2, $4, $6); printf("--->");}
    |   VAR STRING IS NUMBER COMMA NUMBER               {printf("You need to end a command with a full stop.\n"); errorbit=1;  fprintf(stderr, "-1\n");}
;
query: VALUE IN NUMBER COMMA NUMBER STOP                {queryHelper($3,$5); printf("--->");}
    |   VALUE IN NUMBER COMMA NUMBER                    {printf("You need to end a command with a full stop.\n"); errorbit=1;  fprintf(stderr, "-1\n");}
;
assignment: ASSIGN NUMBER TO NUMBER COMMA NUMBER STOP   {assignmentHelper($2, $4, $6); printf("--->");}
    |       ASSIGN NUMBER TO NUMBER COMMA NUMBER        {printf("You need to end a command with a full stop.\n"); errorbit=1;  fprintf(stderr, "-1\n");}
;
movement: operation direction STOP                      { movement($<ch>1, $<ch>2); print_board(); output(); errorbit=0; printf("--->");}
    |     operation direction                           {printf("You need to end a command with a full stop.\n"); errorbit=1;  fprintf(stderr, "-1\n");}
;


direction: YLEFT  { $<ch>$ = 'a' ; }
         | YRIGHT { $<ch>$ = 'd' ; }
         | YUP    { $<ch>$ = 'w' ; }
         | YDOWN  { $<ch>$ = 's' ; }
;

operation: YADD   { $<ch>$ = '+' ; }
         | YSUB   { $<ch>$ = '-' ; }
         | YMUL   { $<ch>$ = '*' ; }
         | YDIV   { $<ch>$ = '/' ; }
;
%%
// int main(int argc, char **argv)
// {
//   yyparse();
// }

// void yyerror(char *s)
// {
//   fprintf(stderr, "error: %s\n", s);
// }

int main(int argc, char *argv[]) {
    srand(time(0));
    ++argv, --argc;
    //detect if an argument was passed...
    if(argc > 0) {
        yyin = fopen( argv[0], "r" );
        if(yyin == NULL) {
            printf("No such file exist.\n");
            return 0;
        }
        else {
            filemode = true;
        }
    }
    else
        yyin = stdin;
    
    
    printf("Hi, this is 2048 game engine.\n");
    insert_random();
    print_board();
    printf("\n");
    
    printf("--->");

    do{
        yyparse();
    }while(!feof(yyin));

    printf("\nFinished.\n");
    return 0;
}
