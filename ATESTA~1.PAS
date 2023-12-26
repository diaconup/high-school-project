program Atestat;
uses crt,graph,venbuton,mouse2,dos;
type mat=array[1..5,1..5] of button;

var a:mat;
    trei,patru,verif,iesi,mutari:button;
    x,y,i,j,k,gd,gm,c,l,c1,l1,dim,q,rand,cont,mut:integer;
    s,s1:string;
    ok:boolean;

{creeaza partea din dreapta a ecranului}
procedure creearedreapta;
begin
     setbkcolor(darkgray);

     outtextxy(556,15,'Mutari');
     line(520,30,650,30);
     definire_buton(mutari,519,70,650,40,darkgray,white,'0');
     pune_buton(mutari);

     rectangle(getmaxx-120,1,getmaxx-1,getmaxy-1);

     definire_buton(iesi,getmaxx-115,getmaxy-100,getmaxx-5,getmaxy-5,red,white,'IESIRE');
     pune_buton(iesi);

     definire_buton(verif,getmaxx-115,getmaxy-210,getmaxx-5,getmaxy-105,red,white,'VERIFICARE');
     pune_buton(verif);

     mouseon;
end;

{procedura de verificare a corectidudinii matricii }
procedure verificare;
begin
     q:=0;
     ok:=true;
     for i:=1 to dim-1 do
         for j:=1 to dim do
         begin
              inc(q);
              str(q,s1);
              if a[i,j].t<>s1 then ok:=false;
         end;
     for j:=1 to dim-1 do
         begin
              inc(q);
              str(q,s1);
              if a[dim,j].t<>s1 then ok:=false;
         end;

     if ok then
     begin
          initgraph(gd,gm,' ');
          outtextxy(170,40,'Bravo, ai terminat puzzle-ul.');
          str(mut,s);
          outtextxy(175,100,'L-ai terminat din ');
          outtextxy(320,100,s);
          outtextxy(340,100,'mutari.');
          delay(3300);
          halt;
     end
     else
     begin
          outtextxy(250,40,'Gresit!');
          delay(2000);
          setcolor(black);
          outtextxy(250,40,'Gresit!');

     end;
end;

{Optiunile de la inceputul programului}
procedure optiuni(var dim:integer);
var sem:boolean;
begin
    gd:=detect;
    initgraph(gd,gm,' ');
    mouseon;
    outtextxy(180,40,'  Alege dimensiunea jocului: ');

    definire_buton(trei,170,150,430,210,4,15,'3x3');
    pune_buton(trei);

    definire_buton(patru,170,250,430,310,4,15,'4x4');
    pune_buton(patru);

    sem:=false;
    repeat
          if buton_apasat(trei) then
             begin
                  sem:=true; dim:=3;
             end
             else
             if buton_apasat(patru) then
             begin
                  dim:=4; sem:=true;
             end;
    until sem;

end;

{Creearea matricii de la 1 pana la dimensiunea aleasa}
procedure famatriceinit;
begin
 y:=60;
 k:=0;
 for i:=1 to dim do
  begin
   if dim=3 then x:=140
   else x:=70;
   for j:=1 to dim do
     begin
         inc(k);
         str(k,s);
         definire_buton(a[i,j],x,y,90+x,90+y,15,0,s);
         pune_buton(a[i,j]);
         x:=x+92;
         delay(50);
         If ((a[i,j].t='9') and (dim=3)) or ((a[i,j].t='16') and (dim=4)) then
         begin
             a[i,j].bcolor:=yellow;
             a[i,j].t:='';
             pune_buton(a[i,j]);
         end;
     end;
   y:=y+92;
  end;
end;

{Testeaza daca butonul este apasat pentru a fi mutat in locul liber}
procedure apasat;
begin
  for i:=1 to dim do
    for j:=1 to dim do
    begin
     if buton_apasat(a[i,j]) then
       begin
            c:=j;
            l:=i;
       end;
     if a[i,j].t='' then
        begin
             c1:=j;
             l1:=i;
        end;
    end;
end;

{Interschimbarea a unui patrat liber cu unul "umplut"}
procedure schimbunu;
begin
    a[l1,c1].t:=a[l,c].t;
    a[l1,c1].bcolor:=white;
    a[l,c].bcolor:=yellow;
    a[l,c].t:='';
    pune_buton(a[l1,c1]);
    pune_buton(a[l,c]);

    {Incrementare numar mutari}
    mut:=mut+1;
    str(mut,s);
    mutari.t:=s;
    mutari.bcolor:=darkgray;
    pune_buton(mutari);
end;

{Daca se apasa un patrat si este o mutare legala se schimba}
procedure schimba;
begin
     apasat;
     if (l=l1) and ((c+1=c1) or (c-1=c1)) then schimbunu
     else
     if (c=c1) and ((l+1=l1) or (l-1=l1)) then schimbunu;
end;

{Randomizam matricea: 0 sus 1 dreapta 2 jos 3 stanga}
procedure randomizeaza;
begin
     i:=dim;
     j:=dim;
     for cont:=1 to 50 do
     begin
         rand:=random(4);
         {sus}
         if (rand=0) and (i>1) then
         begin
              a[i,j].t:=a[i-1,j].t;
              a[i,j].bcolor:=white;
              a[i-1,j].bcolor:=yellow;
              a[i-1,j].t:='';
              pune_buton(a[i,j]);
              pune_buton(a[i-1,j]);
              i:=i-1;
         end;
         {dreapta}
         if (rand=1) and (j<dim) then
         begin
              a[i,j].t:=a[i,j+1].t;
              a[i,j].bcolor:=white;
              a[i,j+1].bcolor:=yellow;
              a[i,j+1].t:='';
              pune_buton(a[i,j]);
              pune_buton(a[i,j+1]);
              inc(j);
         end;
         {stanga}
         if (rand=2) and (j>1) then
         begin
              a[i,j].t:=a[i,j-1].t;
              a[i,j].bcolor:=white;
              a[i,j-1].bcolor:=yellow;
              a[i,j-1].t:='';
              pune_buton(a[i,j]);
              pune_buton(a[i,j-1]);
              j:=j-1;
         end;
         {jos}
         if (rand=3) and (i<dim) then
         begin
              a[i,j].t:=a[i+1,j].t;
              a[i,j].bcolor:=white;
              a[i+1,j].bcolor:=yellow;
              a[i+1,j].t:='';
              pune_buton(a[i,j]);
              pune_buton(a[i+1,j]);
              inc(i);
         end;
     end;
end;

{creeaza matricea amestecata}
procedure creearejoc;
begin
    optiuni(dim);
    x:=getmaxx;
    y:=getmaxy;
    cleardevice;
    creearedreapta;
    famatriceinit;
    randomizeaza;
end;

procedure rularejoc;
begin
     repeat
           apasat;
           schimba;
           if buton_apasat(verif) then verificare;
     until buton_apasat(iesi);
end;


{Program principal}
begin
     clrscr;
     randomize;
     creearejoc;
     rularejoc;
end.
