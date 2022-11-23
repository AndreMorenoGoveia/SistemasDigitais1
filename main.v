`timescale 1ns/1ps

module main(t, conf, r,
            led1, led2, led3, led4);


    /* Entradas e saídas */
    input wire [11:0] t; /* t[10] é o botão inicia e t[11] o botão cancela */
    input wire conf;
    input wire r[63:0];

    output reg[6:0] led1;
    output reg[6:0] led2;
    output reg[6:0] led3;
    output reg[6:0] led4;



    /** Declaração dos elementos **/
    /* Visor */
    reg [3:0] h4;
    reg [3:0] h3;
    reg [3:0] h2;
    reg [3:0] h1;
    reg en[3:0];

    /* Relógio Padrão */
    reg [3:0] p4;
    reg [3:0] p3;
    reg [3:0] p2;
    reg [3:0] p1;
    reg clk1;
    reg p;

    /* Teclado */
    reg tm1;
    reg tm2;
    reg tm3;
    reg tm4;
    reg tm;

    /* Configuração */
    reg confm;

    /* Receitas */
    reg [15:0] r1;
    reg [15:0] r2;
    reg [15:0] r3;
    reg [15:0] r4;



    /* Relações entre os modulos */
    Conversor4bits0a9 
    m1(.ain(h1[0]), .bin(h1[1]), .cin(h1[2]), .din(h1[3]), .en(en[0]),
       .aout(led1[0]), .bout(led1[1], .cout(led1[2]), .dout(led1[3]),
       .eout(led1[4]), .fout(led1[5]), .gout(led1[6])));

    Conversor4bits0a9 
    m2(.ain(h2[0]), .bin(h2[1]), .cin(h2[2]), .din(h2[3]), .en(en[1])
       .aout(led2[0]), .bout(led2[1], .cout(led2[2]), .dout(led2[3]),
       .eout(led2[4]), .fout(led2[5]), .gout(led2[6])));

    Conversor4bits0a9 
    m3(.ain(h3[0]), .bin(h3[1]), .cin(h3[2]), .din(h3[3]), .en(en[2]),
       .aout(led3[0]), .bout(led3[1], .cout(led3[2]), .dout(led3[3]),
       .eout(led3[4]), .fout(led3[5]), .gout(led3[6])));

    Conversor4bits0a9 
    m4(.ain(h4[0]), .bin(h4[1]), .cin(h4[2]), .din(h4[3]), .en(en[3]),
       .aout(led4[0]), .bout(led4[1], .cout(led4[2]), .dout(led4[3]),
       .eout(led4[4]), .fout(led4[5]), .gout(led4[6])));



    /** Visor **/
    initial
        begin

            h4 = 4'b0010;
            h3 = 4'b1001;
            h2 = 4'b0101;
            h1 = 4'b1001;
            en = 4'b1111;

        end



    /** Relógio padrão **/

    initial
        begin

            p4 = 4'b0010;
            p3 = 4'b1001;
            p2 = 4'b0101;
            p1 = 4'b1001;
            clk1 = 1'b0;
            p = 1'b1;

        end

    always #30000 clk1 = ~clk1; /* Configurado para alternar a cada 30s */


    /* Contador síncrono relógio padrão */
    always @ (negedge clk1)

        begin
            
            if(p1 == 4'b1001)
                begin
    
                    p2 <= p2 + 4'b0001;
                    if(p2 == 4'b0101)
                        begin
                            
                            
                            if(p3 == 4'b1001 | (p4 == 4'b0010 & p3 == 4'b0011))
                                begin
                                    
                                    if(p4 == 4'b0010)
                                        p4 <= 4'b0000;
                                    else
                                        p4 <= p4 + 4'b0001;


                                p3 <= 4'b0000;

                                end
                            else
                                p3 <= p3 + 4'b0001;


                            p2 <= 4'b0000;             

                        end
                    else
                        p2 <= p2 + 4'b0001;

                    p1 = 4'b0000;

                end
            else
                p1 <= p1 + 4'b0001;


            if(p)
                begin
                    
                    h1 <= p1;
                    h2 <= p2;
                    h3 <= p3;
                    h4 <= p4

                end

        end


    /** Teclado **/



    /* O usuário clica em algum botão de número */
    always @ (posedge t[0] or posedge t[1] or posedge t[2] or
            posedge t[3] or posedge t[4] or posedge t[5] or
            posedge t[6] or posedge t[7] or posedge t[8] or
            posedge t[9]) 
    begin

        /* O usuário clica no botão de início */
        always @ (posedge t[10]) 
        begin
            


        end

        /* O usuário clica no botão de cancela */
        always @ (posedge t[11]) 
        begin
            
        end


    end


    /* O usuário clica em um botão de receita */
    always @ (posedge r[0] or posedge r[1] or posedge r[2] or posedge r[3])
    begin

        /* O usuário clica no botão de inicio */
        always @(posedge ti) begin
            
        end

        /* O usuário clica no botão de cancela */
        always @(posedge tc) begin
            
        end

    end


    /** Configuração **/
    initial confm = 1'b0;

    /* O usuário clica no botão de configuração */
    always @ (posedge conf) 
    begin

      if(~confm)
        begin
            
            confm = 1'b1;
            
            if(p | tm)
                begin
                    
                    always #250 en[0] = ~en[0];/* Alterna o enable a cada 1/4 s */

                    h1 <= p1;
                    h2 <= p2;
                    h3 <= p3;
                    h4 <= p4;

                    p = 1'b0;

                end

        end  

    end


endmodule