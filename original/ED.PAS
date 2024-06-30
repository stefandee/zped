program ed;
uses crt,graph,dos;
const cp='c:\tp\plot';
type scrbuf=array[1..32767] of byte;
     sb=^scrbuf;
     str8=string[8];
var b1,b2,pa,w,m1,m2,m3,m4,px,py,x,y:integer;
    cod,abc,n,gd,gm,color,c2,c1,ox,oy,limx,limy,i,j,k,size,saved:integer;
    save,put,keep:sb;
    fil:file;
    ch:char;
    s,sp:string;
    one:byte;
    pass,sem,mo:boolean;
    r,tt:searchrec;
{$I error1.dat}
{$I preset.dat}
{$I window.dat}
{$I border.dat}
{$I gmouse.dat}
{$I office.dat}
{$I aboutp.dat}
{$I typpe.dat}
{$I help.dat}
{$I tab.dat}
procedure beep(x:integer);
begin
sound(600);delay(x);nosound;
end;
procedure trc(x:integer);
begin
setcolor(0);for i:=0 to 9 do line(340,getmaxy-20+i,379,getmaxy-20+i);
setcolor(x);str(trunc(ox/n),s);outtextxy(340,getmaxy-20,copy(s,1,3));
setcolor(0);for i:=0 to 9 do line(410,getmaxy-20+i,449,getmaxy-20+i);
setcolor(x);str(trunc(oy/n),s);outtextxy(410,getmaxy-20,copy(s,1,3));
end;
procedure scale(x,y:integer);
begin
setcolor(x);
for i:=0 to limx do if int(i div y)=i div y then line(i*y+10,10,i*y+10,limy*y+y+10);
for i:=0 to limy do if int(i div y)=i div y then line(10,i*y+10,limx*y+y+10,i*y+10);
end;
procedure veryf;
begin
setcolor(0);
for i:=0 to 10 do
line(310,435+i,499,435+i);
if ((limx*n+10>getmaxx-10) or (limx<1)) then limx:=trunc((getmaxx-20)/n)-1;
if ((limy<1) or (limy*n+10>379)) then limy:=trunc(380/n)-1;
if limy>69 then limy:=69;
if limx>289 then limx:=289;
setcolor(14);
str(limx,s);outtextxy(320,435,copy(s,1,3));
str(limy,s);outtextxy(380,435,copy(s,1,3));
str(n,s);outtextxy(440,435,copy(s,1,2));
end;
procedure askx;
begin
setcolor(0);
for i:=0 to 10 do line(310,435+i,340,435+i);
s:='             ';setcolor(14);
typpe(310,435);val(copy(s,1,3),limx,i);if i<>0 then limx:=100;
end;
procedure asky;
begin
setcolor(0);
for i:=0 to 10 do line(380,435+i,400,435+i);
s:='             ';setcolor(14);
typpe(370,435);val(copy(s,1,3),limy,i);if i<>0 then limy:=69;
end;
procedure askz;
begin
setcolor(0);
for i:=0 to 10 do line(440,435+i,480,435+i);
s:='             ';setcolor(14);
typpe(440,435);val(copy(s,1,2),n,i);if i<>0 then n:=5;
end;
procedure findout(var s:string);
var i:integer;
label f1;
begin
setcolor(0);
for i:=0 to 10 do line(500,435+i,640,435+i);
setcolor(2);
outtextxy(500,420,'nume fisier:');
s:='             ';
k:=1;typpe(490,435);
if k=1 then begin s[9]:='.';s[10]:='z';s[11]:='p';s[12]:='x';goto f1;end;
setcolor(0);
for i:=1 to 12 do
outtextxy(490+i*10,435,s[i]);
f1:setcolor(0);
outtextxy(500,420,'nume fisier:');
setcolor(color);
end;
function cr(x:integer):integer;
begin
cr:=x+6;
end;
procedure et;
begin
setcolor(getpixel((ox+10+trunc(n div 2)),(oy+10+trunc(n div 2))));
circle(ox+10+trunc(n div 2),oy+10+trunc(n div 2),trunc(n div 2)-1);
setcolor(color);
end;
procedure t;
begin
setcolor(cr(getpixel(ox+10+trunc(n/2),oy+10+trunc(n/2))));
circle(ox+10+trunc(n/2),oy+10+trunc(n/2),trunc(n/2)-1);
end;
procedure verif;
begin
if ox div n<0 then ox:=0;
if ox div n>limx then ox:=limx*n;
if oy div n<0 then oy:=0;
if oy div n>limy then oy:=limy*n;
end;
procedure left;
begin
et;
ox:=ox-n;
verif;
t;
end;
procedure right;
begin
et;
ox:=ox+n;
verif;
t;
end;
procedure down;
begin
et;
oy:=oy+n;
verif;
t;
end;
procedure up;
begin
et;
oy:=oy-n;
verif;
t;
end;
procedure fire(ox,oy:integer);
begin
setfillstyle(1,color);
bar(ox+11,oy+11,ox+n+9,oy+n+9);
putpixel(10+(ox div n),400+(oy div n),color);
end;
procedure afill(ox,oy:integer);
var i,j:integer;
begin
fire(ox,oy);
if getpixel(10+(ox div n),400+(oy div n)-1)<>color then afill(ox,oy-n);
if getpixel(10+(ox div n)-1,400+(oy div n))<>color then afill(ox-n,oy);
if getpixel(10+(ox div n)+1,400+(oy div n))<>color then afill(ox+n,oy);
if getpixel(10+(ox div n),400+(oy div n)+1)<>color then afill(ox,oy+n);
end;
procedure careu;
var i,j:integer;
begin
ox:=0;
oy:=0;
for i:=0 to 19 do begin
color:=15;fire(ox,oy);t;right;color:=11;fire(ox,oy);t;right;
end;left;
for i:=0 to 19 do begin
color:=11;fire(ox,oy);t;down;color:=15;fire(ox,oy);t;down;
end;up;
for i:=0 to 19 do begin
color:=15;fire(ox,oy);t;left;color:=11;fire(ox,oy);t;left;
end;
for i:=0 to 19 do begin
color:=11;fire(ox,oy);t;up;color:=15;fire(ox,oy);t;up;
end;right;down;
for i:=0 to 18 do begin
color:=3;fire(ox,oy);t;right;color:=11;fire(ox,oy);t;right;
end;left;
for i:=0 to 18 do begin
color:=11;fire(ox,oy);t;down;color:=3;fire(ox,oy);t;down;
end;up;
for i:=0 to 18 do begin
color:=3;fire(ox,oy);t;left;color:=11;fire(ox,oy);t;left;
end;right;
for i:=0 to 18 do begin
color:=11;fire(ox,oy);t;up;color:=3;fire(ox,oy);t;up;
end;right;down;down;
for i:=0 to 17 do begin
color:=3;fire(ox,oy);t;right;color:=9;fire(ox,oy);t;right;
end;left;
for i:=0 to 17 do begin
color:=9;fire(ox,oy);t;down;color:=3;fire(ox,oy);t;down;
end;up;
for i:=0 to 17 do begin
color:=3;fire(ox,oy);t;left;color:=9;fire(ox,oy);t;left;
end;right;
for i:=0 to 17 do begin
color:=9;fire(ox,oy);t;up;color:=3;fire(ox,oy);t;up;
end;right;down;down;
for i:=0 to 16 do begin
color:=1;fire(ox,oy);t;right;color:=9;fire(ox,oy);t;right;
end;left;
for i:=0 to 16 do begin
color:=9;fire(ox,oy);t;down;color:=1;fire(ox,oy);t;down;
end;up;
for i:=0 to 16 do begin
color:=1;fire(ox,oy);t;left;color:=9;fire(ox,oy);t;left;
end;right;
for i:=0 to 16 do begin
color:=9;fire(ox,oy);t;up;color:=1;fire(ox,oy);t;up;
end;
end;
procedure load;
begin
if not(pass) then exit;
{$I-}
assign(fil,sp);
reset(fil);
if ioresult<>0 then begin beep(400);eror1;{$I+}exit;end;
new(save);
findfirst(sp,anyfile,tt);
blockread(fil,save^,trunc(tt.size/128)+1,saved);
putimage(10,400,save^,0);setcolor(0);
for i:=0 to 9 do line (490,435+i,580,435+i);
setcolor(11);outtextxy(500,435,fp(tt.name));
dispose(save);
close(fil);
{$I+}
for i:=0 to limx do for j:=0 to limy do
begin
color:=getpixel(i+10,400+j);fire(i*n,j*n);
end;color:=getpixel(getmaxx-15,getmaxy-15);
end;
label 1,2,nev,out,aut;
begin
clrscr;
gotoxy(5,15);textcolor(9);
write('Zoom pixel editor - version ');
textcolor(14);write('7.3');
textcolor(9);write(' - from Alex and Phane of BlueFlower @1994');
gotoxy(30,24);textcolor(10);write('Acces code : 00008562');
gotoxy(5,17);textcolor(12);write('ENTER ACCES CODE:');
pass:=pas;
mo:=false;
gd:=detect;
initgraph(gd,gm,'');
setcbreak(false);
limx:=100;limy:=44;n:=6;
cleardevice;
nev:cleardevice;
setcolor(14);
ox:=0;
oy:=0;
bord;
scale(7,n);
if mo then mousefer(10,10,10+limx*n,10+limy*n)
      else t;
color:=0;c1:=0;c2:=0;
new(keep);
1:trc(14);
if mo then begin
                     poz;ox:=m3-10;oy:=m4-10;verif;trc(14);
                     mouseda(1);
                     m1:=3;
                     mousedata;
                     if m2=1 then begin
                                   mouseda(2); color:=c1;
                                   fire(trunc(ox/n)*n,trunc(oy/n)*n);
                                   mouseda(1);
                                   end;
                     if m2=2 then begin
                                   mouseda(2);color:=c2;
                                   fire(trunc(ox/n)*n,trunc(oy/n)*n);
                                   mouseda(1);
                                   end;
                     end;
                     if keypressed then begin
                             ch:=readkey;
                     if ((ch=#9) and not(mo)) then begin color:=c1;fire(ox,oy);t;end;
                     if ch=#27 then goto 2;
                     if ((ch='O') and not(mo)) then begin trc(0);left;fire(ox,oy);t;end;
                     if ((ch='P') and not(mo)) then begin trc(0);right;fire(ox,oy);t;end;
                     if ((ch='Q') and not(mo)) then begin trc(0);up;fire(ox,oy);t;end;
                     if ((ch='Z') and not(mo)) then begin trc(0);down;fire(ox,oy);t;end;
                     if ((ch='K') and not(mo)) then begin trc(0);left;left;fire(ox,oy);t;end;
                     if ((ch='L') and not(mo)) then begin trc(0);right;right;fire(ox,oy);t;end;
                     if ((ch='W') and not(mo)) then begin trc(0);up;up;fire(ox,oy);t;end;
                     if ((ch='X') and not(mo)) then begin trc(0);down;down;fire(ox,oy);t;end;
                     if ch=#0 then begin
                     ch:=readkey;
                     if ((ch=#75) and not(mo)) then begin trc(0);left;end;
                     if ((ch=#77) and not(mo)) then begin;trc(0);right;end;
                     if ((ch=#72) and not(mo)) then begin;trc(0);up;end;
                     if ((ch=#80) and not(mo)) then begin;trc(0);down;end;
                     if ch=#59 then begin if mo then mouseda(2);
                                          help(100,100);
                                          if mo then mouseda(1);
                                    end;
                     if ch=#67 then if mo then begin ox:=trunc(ox/n)*n;
                                                     oy:=trunc(oy/n)*n;
                                                     mouseda(2);
                                                     mo:=not(mo);
                                                     t;
                                                     end
                                          else begin et;
                                                     mo:=not(mo);m3:=ox;m4:=oy;
                                                     mouseda(1);
                                                     mousefer(10,10,limx*n+10,limy*n+10);
                                                     end;
                     if ch=#66 then begin
                                    if mo then begin
                                               mouseda(2);
                                               ox:=(ox div n)*n;
                                               oy:=(oy div n)*n;
                                               end
                                          else et;
                                    dispose(keep);new(keep);
                                    getimage(10,400,limx+10,limy+400,keep^);
                                    color:=c1;
                                    afill(ox,oy);
                                    if mo then mouseda(1)
                                          else t;
                                    end;
                     if ch=#111 then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     careu;et;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#64 then begin
                                    if mo then mouseda(2)
                                          else et;
                                    scale(c1,n);
                                    if mo then mouseda(1)
                                          else t;
                                    end;
                     if ch=#62 then begin
                                    if mo then mouseda(2)
                                          else et;
                                    tabb(100,100);
                                    if mo then mouseda(1)
                                          else t;
                                    end;
                     if ch=#63 then begin
                     if mo then mouseda(2);
                     limx:=100;limy:=69;n:=5;veryf;
                     sp:='*.zpx';
                     findfirst(sp,anyfile,r);k:=0;
                     while doserror=0 do begin
                     inc(k);findnext(r);end;
                     findfirst(sp,anyfile,r);sp:=''+r.name;
                     if k>0 then begin
                     setcolor(0);
                     for i:=10 to getmaxx-10 do line(i,10,i,389);
                     for i:=400 to getmaxy-10 do line(10,i,299,i);
                     scale(7,n);
                     for abc:=1 to k do begin
                     load;
                     repeat if keypressed then begin
                     ch:=readkey;
                     if ch=#27 then begin ch:=#0;goto aut;end;
                     if (ch=#13) or (ch='+') then goto out;
                     end;until false;
out:                 setcolor(0);
                     for i:=10 to getmaxx-10 do line(i,10,i,389);
                     for i:=400 to getmaxy-10 do line(10,i,299,i);
                     scale(7,n);
                     sp:='*.zpx';
                     findnext(r);
                     sp:=''+r.name;
                     end;
                     end;
aut:                 if mo then mouseda(1);
                     end;
                     if ch=#65  then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     k:=getpixel(10+trunc(ox/n),400+trunc(oy/n));
                                     for i:=0 to limx do for j:=0 to limy do
                                       begin
                                       color:=c1;
                                       if getpixel(i+10,400+j)=k then begin
                                       putpixel(i+10,400+j,c1);fire(i*n,j*n);
                                       end;
                                       end;if mo then mouseda(1)
                                                 else t;
                                     end;
                     if ch=#104 then begin
                                     if mo then mouseda(2)
                                           else et;
                                     dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     new(save);new(put);
                                     getimage(10,400,10,400+limy,save^);
                                     getimage(11,400,10+limx,400+limy,put^);
                                     putimage(10,400,put^,0);
                                     putimage(10+limx,400,save^,0);
                                     for i:=0 to limx do for j:=0 to limy do
                                     begin
                                     color:=getpixel(i+10,400+j);fire(i*n,j*n);
                                     end;color:=getpixel(getmaxx-15,getmaxy-15);
                                     dispose(save);dispose(put);
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#105 then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     new(save);new(put);
                                     getimage(10+limx,400,10+limx,400+limy,save^);
                                     getimage(10,400,9+limx,400+limy,put^);
                                     putimage(10,400,save^,0);
                                     putimage(11,400,put^,0);
                                     for i:=0 to	 limx do for j:=0 to limy do
                                     begin
                                     color:=getpixel(i+10,400+j);fire(i*n,j*n);
                                     end;color:=getpixel(getmaxx-15,getmaxy-15);
                                     dispose(save);dispose(put);
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#106 then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     new(save);new(put);
                                     getimage(10,400,10+limx,400,save^);
                                     getimage(10,401,10+limx,400+limy,put^);
                                     putimage(10,400+limy,save^,0);
                                     putimage(10,400,put^,0);
                                     for i:=0 to limx do for j:=0 to limy do
                                     begin
                                     color:=getpixel(i+10,400+j);fire(i*n,j*n);
                                     end;color:=getpixel(getmaxx-15,getmaxy-15);
                                     dispose(save);dispose(put);
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#107 then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     new(save);new(put);
                                     getimage(10,400+limy,10+limx,400+limy,save^);
                                     getimage(10,400,10+limx,399+limy,put^);
                                     putimage(10,400,save^,0);
                                     putimage(10,401,put^,0);
                                     for i:=0 to limx do for j:=0 to limy do
                                     begin
                                     color:=getpixel(i+10,400+j);fire(i*n,j*n);
                                     end;color:=getpixel(getmaxx-15,getmaxy-15);
                                     dispose(save);dispose(put);
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#108 then begin
                                     if mo then mouseda(2)
                                           else et;
                                     about(150,110);
                                     if mo then mouseda(1)
                                           else t;
                                           end;
                     if ch=#94 then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     for i:=0 to trunc((limx+1)/2) do
                                     for j:=0 to limy do begin
                                     color:=getpixel(10+i,400+j);
                                     putpixel(10+limx-i,400+j,color);
                                     fire(n*(limx-i),n*j);
                                     end;color:=c1;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#95 then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     for i:=0 to trunc((limx+1)/2) do
                                     for j:=0 to limy do begin
                                     color:=getpixel(10+limx-i,400+j);
                                     putpixel(10+i,400+j,color);
                                     fire(n*i,n*j);
                                     end;color:=c1;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#96 then begin
                                     if mo then mouseda(2)
                                           else et;
                                    dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     for i:=0 to trunc((limy+1)/2) do
                                     for j:=0 to limx do begin
                                     color:=getpixel(10+j,400+i);
                                     putpixel(10+j,400+limy-i,color);
                                     fire(n*j,n*(limy-i));
                                     end;color:=c1;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#97 then begin
                                     if mo then mouseda(2)
                                           else et;
                                     dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     for i:=0 to trunc((limy+1)/2) do
                                     for j:=0 to limx do begin
                                     color:=getpixel(10+j,400+limy-i);
                                     putpixel(10+j,400+i,color);
                                     fire(n*j,n*i);
                                     end;color:=c1;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#98  then begin
                                     if mo then mouseda(2)
                                           else et;
                                     dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     new(put);
                                     getimage(400,400,400+limx,400+limy,put^);
                                     putimage(400,400,keep^,0);
                                     for i:=0 to limy do
                                     for j:=0 to limx do
                                     begin
                                     color:=getpixel(400+j,400+i);
                                     fire(n*(limx-j),n*i);
                                     end;
                                     putimage(400,400,put^,0);dispose(put);
                                     color:=c1;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#99  then begin
                                     if mo then mouseda(2)
                                           else et;
                                     dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     new(put);
                                     getimage(400,400,400+limx,400+limy,put^);
                                     putimage(400,400,keep^,0);
                                     for i:=0 to limx do
                                     for j:=0 to limy do
                                     begin
                                     color:=getpixel(400+i,400+j);
                                     fire(n*i,n*(limy-j));
                                     end;
                                     putimage(400,400,put^,0);dispose(put);
                                     color:=c1;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#100 then begin
                                     if mo then mouseda(2)
                                           else et;
                                     if (limx=limy) and (limx<70) then
                                     begin
                                     dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     putimage(100,400,keep^,0);
                                     for i:=0 to limy do
                                     for j:=0 to limx do
                                     begin
                                     color:=getpixel(j+100,i+400);
                                     fire(i*n,(limy-j)*n);
                                     end;
                                     color:=c1;
                                     setcolor(0);
                                     for i:=0 to limy do
                                     line(100,400+i,100+limx,400+i);
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                                     end;
                     if ch=#103 then begin
                                     if mo then mouseda(2)
                                           else et;
                                     putimage(10,400,keep^,0);
                                     for i:=0 to limx do
                                     for j:=0 to limy do begin
                                     color:=getpixel(10+i,400+j);
                                     fire(n*i,n*j);
                                     end;color:=c1;
                                     if mo then mouseda(1)
                                           else t;
                                     end;
                     if ch=#60  then begin
                                     setcolor(2);outtextxy(500,400,'save');
                                     findout(s);if k=1 then begin
                                     setcolor(0);
                                     outtextxy(500,400,'save');
                                     if not(pass) then goto 1;
                                     setcolor(red);
                                     outtextxy(500,400,'saving..');
                                     sp:=''+copy(s,1,12);
                                     assign(fil,sp);
                                     rewrite(fil);
		     getimage(10,400,limx+10,limy+400,keep^);
		     size:=imagesize(10,400,limx+10,limy+400);
                                     blockwrite(fil,keep^,(size div 128)+1,saved);
                                     close(fil);
                                     setcolor(0);
                                     outtextxy(500,400,'saving..');
                                     setcolor(color);
                                     end
                                     else begin setcolor(0);
                                     outtextxy(500,400,'save');
                                     end;
                                     end;
                      if ch=#61 then begin
                                     setcolor(2);outtextxy(500,400,'load');
                                     findout(s);if k=1 then begin
                                     if mo then mouseda(2)
                                           else et;
                                     setcolor(0);
                                     for i:=10 to getmaxx-10 do line(i,10,i,389);
                                     for i:=400 to getmaxy-10 do line(10,i,294,i);
                                     setcolor(color);
                                     sp:=''+copy(s,1,12);
                                     askx;if i<>0 then limx:=100;
                                     asky;if i<>0 then limy:=44;
                                     askz;if i<>0 then n:=6;veryf;
                                     scale(7,n);
                                     setcolor(red);
                                     outtextxy(500,400,'loading..');
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     load;
                                     if mo then mousefer(10,10,limx*n+10,limy*n+10);
                                     setcolor(0);
                                     outtextxy(500,400,'loading..');
                                     if mo then mouseda(1);
                                     end
                                     else  setcolor(0);
                                     outtextxy(500,400,'load');
                                     end;
                     if ch=#73 then begin
                                    inc(c2);
                                    if c2>getmaxcolor then c2:=0;
                                    setfillstyle(1,c2);
                                    bar(getmaxx-20,getmaxy-20,getmaxx-10,getmaxy-10);
                                    end;
                     if ch=#81 then begin
                                    dec(c2);
                                    if c2<0 then c2:=getmaxcolor;
                                    setfillstyle(1,c2);
                                    bar(getmaxx-20,getmaxy-20,getmaxx-10,getmaxy-10);
                                    end;
                     if ch=#71 then begin
                                    inc(c1);
                                    if c1>getmaxcolor then c1:=0;
                                    setfillstyle(1,c1);
                                    bar(getmaxx-40,getmaxy-20,getmaxx-30,getmaxy-10);
                                    end;
                     if ch=#79 then begin
                                    dec(c1);
                                    if c1<0 then c1:=getmaxcolor;
                                    setfillstyle(1,c1);
                                    bar(getmaxx-40,getmaxy-20,getmaxx-30,getmaxy-10);
                                    end;
                     if ch=#83  then begin
                                     dispose(keep);new(keep);
                                     getimage(10,400,limx+10,limy+400,keep^);
                                     askx;asky;askz;veryf;
                                     if mo then mouseda(2)
                                           else et;
                                     goto nev;
                                     end;
                     end;
                     end;
goto 1;
2:closegraph;
end.