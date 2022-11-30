`timescale 1ms/100ns

module testbench;

    wire [11:0] t;
    wire conf;
    wire [3:0] r;
    wire porta;
    reg [11:0] auxt;
    reg auxc;
    reg [3:0] auxr;
    reg auxp;

    wire [6:0] led1;
    wire [6:0] led2;
    wire [6:0] led3;
    wire [6:0] led4;
    wire luz;
    wire motor;
    wire aquec;
    wire som;

    main inst0 (.t(t), .conf(conf), .r(r), .porta(porta),
                .led1(led1), .led2(led2), .led3(led3), .led4(led4),
                .luz(luz), .motor(motor), .aquec(aquec), .som(som));

assign t = auxt,
conf = auxc,
r = auxr,
porta = auxp;

initial
    begin
    
    auxt <= 12'b000000000000;
    auxc <= 1'b0;
    auxr <= 4'b0000;
    auxp <= 1'b0;


    end


endmodule