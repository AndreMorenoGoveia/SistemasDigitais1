`timescale 1ns/1ps

module testbench;

    wire [3:0] h1;
    wire [3:0] h2;
    wire [3:0] h3;
    wire [3:0] h4;

    main inst0 (.h1(h1), .h2(h2), .h3(h3), .h4(h4));


endmodule