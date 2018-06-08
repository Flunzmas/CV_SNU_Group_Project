function run()
%RUN Summary of this function goes here
%   Detailed explanation goes here
    try
    s1 = output_generation.DCVoltage('V1',25,125,'down',10000);
    r1 = output_generation.Resistor('R1',125,50,'right',1.23*10^(-9));
    c1 = output_generation.Capacitor('C1',375,50,'right',7.89*10^(-3));
    l1 = output_generation.Inductor('L1',225,50,'right',45.6*10^(-6));

    ref1 = output_generation.Ground('Ref1',25,200,'down');
    ref2 = output_generation.Ground('Ref2',425,200,'down');

    w1 = output_generation.Connection(s1,'-',ref1,'+');
    w2 = output_generation.Connection(c1,'-',ref2,'+');
    w3 = output_generation.Connection(s1,'+',r1,'+');
    w4 = output_generation.Connection(r1,'-',l1,'+');
    w5 = output_generation.Connection(l1,'-',c1,'+');
    w6 = output_generation.Connection(c1,'-',ref2,'+');


    output_generation.create_system('new_sys',[r1;c1;l1;s1;ref1;ref2],[w1;w2;w3;w4;w5;w6]);
    catch
    disp('connection warnings');
    end
end

