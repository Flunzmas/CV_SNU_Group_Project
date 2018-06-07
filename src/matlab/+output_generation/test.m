clc;
r1 = Resistor('R1',200,50,'right',500);
r2 = Resistor('R2',400,50,'right',5000);
c1 = Capacitor('C1',300,150,'down',0.3);
l1 = Inductor('L1',500,150,'down',10.1);
s1 = ACCurrent('S1',100,150,'down',20,50);

ref1 = Ground('Ref1',100,300,'down');
ref2 = Ground('Ref2',300,300,'down');
ref3 = Ground('Ref3',500,300,'down');

w1 = Connection(r1,'-',r2,'+');
w2 = Connection(r1,'-',c1,'+');
w3 = Connection(r2,'-',l1,'+');
w4 = Connection(s1,'+',r1,'+');

w5 = Connection(s1,'-',ref1,'+');
w6 = Connection(c1,'-',ref2,'+');
w7 = Connection(l1,'-',ref3,'+');


create_system('new_sys',[r1;r2;c1;l1;s1;ref1;ref2;ref3],[w1;w2;w3;w4;w5;w6;w7]);