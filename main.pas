program XsiO;

uses  graph, sysutils;


type
celula = record x1, x2, y1, y2 : integer;
                value : integer;
                end;
mat = array[1..3, 1..3] of celula;

procedure get_next(var x, y : integer; a : mat);
begin
    repeat
        x:=random(3)+1;
        y:=random(3)+1;
    until a[x,y].value=0;
end;

procedure read_next(var x, y : integer; a : mat);
begin
    repeat
        write('Introduceti x(1-3) si y(1-3): ');
        readln(x, y);
        if not((x in [1..3]) and (y in [1..3])) then
            write('Pozitie incorecta')
        else
            if a[x,y].value<>0 then writeln('Pozitie ocupata!');
    until (x in [1..3]) and (y in [1..3]) and (a[x,y].value=0);
end;

procedure fill(x, y, x_o : integer; var a : mat);
begin
    case x_o of
        0 : begin
                line(a[x,y].x1+20, a[x,y].y1+20, a[x,y].x2-20, a[x,y].y2-20);
                line(a[x,y].x2-20, a[x,y].y1+20, a[x,y].x1+20, a[x,y].y2-20);
            end;
        1:
            circle((a[x,y].x1+a[x,y].x2)div 2, (a[x,y].y1+a[x,y].y2)div 2, (a[x,y].x2-a[x,y].x1)div 2-20);
    end;
    a[x,y].value:=x_o+1;
end;

function joc_terminat(a : mat):integer;
var termina : integer;
    i, j, c: integer;
begin
    termina:=0;
    c:=0;

    for i:=1 to 3 do
        for j:=1 to 3 do
            if a[i,j].value<>0 then c:=c+1;
    if c=9 then termina:=1;

    for i:=1 to 3 do begin
        c:=0;
        for j:=1 to 3 do
            if a[i,j].value=a[i,1].value then c:=c+1;
        if (a[i,1].value<>0) and (c=3) then termina:=a[i,1].value+1;
    end;

    for j:=1 to 3 do begin
        c:=0;
        for i:=1 to 3 do
            if a[i,j].value=a[1,j].value then c:=c+1;
        if (a[1,j].value<>0) and (c=3) then termina:=a[1,j].value+1;
    end;
    
    if (a[1,1].value<>0) and (a[1,1].value=a[2,2].value) and (a[2,2].value=a[3,3].value) then termina:=a[1,1].value+1;
    if (a[1,3].value<>0) and (a[1,3].value=a[2,2].value) and (a[2,2].value=a[3,1].value) then termina:=a[1,3].value+1;
    
    joc_terminat:=termina;
end;

procedure vs_pc(var a:mat);
var termina : integer;
    turn, x_o : integer;
    x, y : integer;
begin
    randomize;
    termina:=0;
    turn:=random(2);
    x_o:=0;

    while termina=0 do begin
        case turn of
            0 :
                get_next(x, y, a);
            1 :
                read_next(x, y, a);
        end;
        fill(x, y, x_o, a);
        termina:=joc_terminat(a);
        turn:=1-turn;
        x_o:=1-x_o;
    end;
    
    case termina of
        1:
            writeln('Egalitate :|');
        else:
            if (termina-2=(x_o+turn+1)mod 2)
                writeln('Ai castigat :D!')
            else
                writeln('Ai pierdut :(');
    end;
end;

procedure init(tip : integer);
var gd, gm, i, j : integer;
    box, x, y : integer;
    a : mat=(((x1:0; x2:0; y1:0; y2:0; value:0), (x1:0; x2:0; y1:0; y2:0; value:0), (x1:0; x2:0; y1:0; y2:0; value:0)),
             ((x1:0; x2:0; y1:0; y2:0; value:0), (x1:0; x2:0; y1:0; y2:0; value:0), (x1:0; x2:0; y1:0; y2:0; value:0)),
             ((x1:0; x2:0; y1:0; y2:0; value:0), (x1:0; x2:0; y1:0; y2:0; value:0), (x1:0; x2:0; y1:0; y2:0; value:0)));
begin
    gd:=9;
    gm:=2;

    initgraph(gd, gm, GetCurrentDir);
    //Vom folosi 83% din minimul dintre L si l pentru teren.
    //Un patratel va avea aceasta lungime div 3 (3 patrate pe linie/coloana)
    if getmaxy<getmaxx then box:=getmaxy*83 div 100 div 3
                       else box:=getmaxx*83 div 100 div 3;
    y:=(getmaxy-box*3-2)div 2;
    for i:=1 to 3 do begin
        x:=(getmaxx-box*3-2)div 2;
        for j:=1 to 3 do begin
            a[i,j].x1:=x;
            a[i,j].x2:=x+box+1;
            a[i,j].y1:=y;
            a[i,j].y2:=y+box+1;
            rectangle(a[i,j].x1, a[i,j].y1, a[i,j].x2, a[i,j].y2);
            x:=x+box+1;
        end;
        y:=y+box+1;
    end;
    case tip of
        1 : vs_pc(a);
    end;
    closegraph;
end;

procedure joc;
var termina : boolean;
    optiune : integer;
begin
    termina := false;
    while not(termina) do begin
        //clrscr;
        writeln('1. Joaca');
        writeln('2. Inchide');
        read(optiune);
        case optiune of
            1 : init(optiune);
            2 : termina:=true;
        end;
    end;
end;


begin
  joc;
end.

