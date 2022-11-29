`timescale 1ms/100ns

module main(t, conf, r, porta,
            led1, led2, led3, led4, luz, motor, aquec, som);


    /*** Entradas e saídas ***/
    input wire [11:0] t; /* t[10] é o botão inicia e t[11] o botão cancela */
    input wire conf;
    input wire [3:0] r;
    input wire porta;

    output wire[6:0] led1;
    output wire[6:0] led2;
    output wire[6:0] led3;
    output wire[6:0] led4;
    output reg luz;
    output reg motor;
    output reg aquec;
    output reg som;





    /*** Declaração dos elementos ***/

    /** Estados
       0000 - Relógio padrão
       0001 - Seleção de contagem 1
       0010 - Seleção de contagem 2
       0011 - Seleção de contagem 3
       0100 - Seleção de conragem cheia
       0101 - Relógio regressivo
       0110 - Comida pronta
       0111 - Configuração de horário 1
       1000 - Configuração de horário 2
       1001 - Configuração de horário 3
       1010 - Configuração de horário 4
       1011 - Configuração da receita 1
       1100 - Configuração de receita 2
       1101 - Configuração da receita 3
       1110 - Configuração de receita 4
    **/
    reg [3:0] estado;

    /* Auxiliares */
    reg est1;
    reg est2;
    reg [4:0] est3;



    /** Componentes internos **/
    /* Auxiliares */
    reg luz1;
    reg luz2;
    reg luz3;
    reg s1;
    reg s2;
    reg ma1;



    /** Teclado **/
    reg [4:0] num;



    /** Visor **/
    reg [3:0] h4;
    reg [3:0] h3;
    reg [3:0] h2;
    reg [3:0] h1;
    reg [3:0] en;

    /* Auxiliares */
    reg [4:0] h4a1;
    reg [4:0] h3a1;
    reg [4:0] h2a1;
    reg [4:0] h1a1;

    reg [4:0] h4a2;
    reg [4:0] h3a2;
    reg [4:0] h2a2;
    reg [4:0] h1a2;

    reg [4:0] h4a3;
    reg [4:0] h3a3;
    reg [4:0] h2a3;
    reg [4:0] h1a3;

    reg [4:0] h4a4;
    reg [4:0] h3a4;
    reg [4:0] h2a4;
    reg [4:0] h1a4;

    reg en1;



    /** Relógio Padrão **/
    reg [3:0] p4;
    reg [3:0] p3;
    reg [3:0] p2;
    reg [3:0] p1;

    /* Auxiliares */
    reg [4:0] p4a1;
    reg [4:0] p3a1;
    reg [4:0] p2a1;
    reg [4:0] p1a1;



    /** Receitas **/
    reg [3:0] r11;
    reg [3:0] r12;
    reg [3:0] r13;
    reg [3:0] r14;
    reg [3:0] r21;
    reg [3:0] r22;
    reg [3:0] r23;
    reg [3:0] r24;
    reg [3:0] r31;
    reg [3:0] r32;
    reg [3:0] r33;
    reg [3:0] r34;
    reg [3:0] r41;
    reg [3:0] r42;
    reg [3:0] r43;
    reg [3:0] r44;
    reg [3:0] rm1;
    reg [3:0] rm2;
    reg [3:0] rm3;
    reg [1:0] rec;



    /** Relógio regressivo **/
    reg [3:0] re4;
    reg [3:0] re3;
    reg [3:0] re2;
    reg [3:0] re1;
    /* Auxiliares */
    reg [3:0] g4;
    reg [3:0] g3;
    reg [3:0] g2;
    reg [3:0] g1;


    /** Clock temporizador **/
    reg clk;





    /*** Conversão das dos números em 4 bits para o LED 7 segmentos ***/
    Conversor4bits0a9 
    m1(.ain(h1[3]), .bin(h1[2]), .cin(h1[1]), .din(h1[0]), .en(en[0]),
       .aout(led1[0]), .bout(led1[1]), .cout(led1[2]), .dout(led1[3]),
       .eout(led1[4]), .fout(led1[5]), .gout(led1[6]));

    Conversor4bits0a9 
    m2(.ain(h2[3]), .bin(h2[2]), .cin(h2[1]), .din(h2[0]), .en(en[1]),
       .aout(led2[0]), .bout(led2[1]), .cout(led2[2]), .dout(led2[3]),
       .eout(led2[4]), .fout(led2[5]), .gout(led2[6]));

    Conversor4bits0a9 
    m3(.ain(h3[3]), .bin(h3[2]), .cin(h3[1]), .din(h3[0]), .en(en[2]),
       .aout(led3[0]), .bout(led3[1]), .cout(led3[2]), .dout(led3[3]),
       .eout(led3[4]), .fout(led3[5]), .gout(led3[6]));

    Conversor4bits0a9 
    m4(.ain(h4[0]), .bin(h4[1]), .cin(h4[2]), .din(h4[3]), .en(en[3]),
       .aout(led4[0]), .bout(led4[1]), .cout(led4[2]), .dout(led4[3]),
       .eout(led4[4]), .fout(led4[5]), .gout(led4[6]));





    /*** Configuração das máquinas ***/

    /** Luz interna **/

    /* Estado inicial */
    initial
    begin

        motor <= 1'b0;
        aquec <= 1'b0;
        som <= 1'b0;
        s1 <= 1'b0;
        ma1 <= 1'b0;

        luz <= porta;
        luz1 <= 1'b0;
        luz2 <= 1'b0;
        luz3 <= 1'b0

    end

    /* Detecta se a porta abre */
    always @ (posedge porta) begin luz1 = 1'b1; #1 luz1 = 1'b0; end

    always @ (negedge porta) begin luz2 = 1'b1; #1 luz2 = 1'b0; end

    /* Atualiza o valor da luz */
    always @ (posedge luz1 or posedge luz2 or posedge luz3)
    begin
    
        if(luz1) luz = 1'b1;
        else if(luz2 | luz3) luz = 1'b0;

    end

    /* Atualiza o valor do som */
    always @ (posedge s1 or posedge s2)
        begin
                
            som = 1'b1;

            #100

            som = 1'b0;

        end

    /* Atualiza o valor do motor e do aquecimento */
    always @ (posedge ma1)
        begin
            
            if(ma1)
                begin

                    motor = 1'b0;
                    aquec = 1'b0;
                    
                end

        end



    /** Clock temporizador  **/

    /* Valor inicial */
    initial
        clk <= 1'b0;

    /* Funcionamento do clock */
    always #250 clk = ~clk; /* Configurado para alternar a cada 0,25s */



    /** Estados **/

    /* Valor inicial */
    initial
        begin

            estado <= 4'b0000;
            est1 <= 1'b0;
            est2 <= 1'b0;
            est3[4] <= 1'b0;

        end


    
    /* Atualiza o valor do estado */
    always @ (posedge est1 or posedge est2 or posedge est3[4])
        begin

            if(est1)
                estado = 4'b0110;
    
            else if(est2)
                estado = 4'b0000;

            else if(est3[4])
                estado = est3 [3:0];
 
        end


    /** Visor **/
    
    /* Valor inicial */
    initial
        begin
        
            h4 <= 4'b0000;
            h3 <= 4'b0000;
            h2 <= 4'b0000;
            h1 <= 4'b0000;

            en <= 4'b1111;

            h4a1[4] <= 1'b0;
            h3a1[4] <= 1'b0;
            h2a1[4] <= 1'b0;
            h1a1[4] <= 1'b0;

            h4a2[4] <= 1'b0;
            h3a2[4] <= 1'b0;
            h2a2[4] <= 1'b0;
            h1a2[4] <= 1'b0;

            h4a3[4] <= 1'b0;
            h3a3[4] <= 1'b0;
            h2a3[4] <= 1'b0;
            h1a3[4] <= 1'b0;

            en1 <= 1'b0;

        end

    /* Atualiza o valor do visor */
    always @ (posedge h4a1[4] or posedge h3a1[4] or posedge h2a1[4] or posedge h1a1[4] or
              posedge h4a2[4] or posedge h3a2[4] or posedge h2a2[4] or posedge h1a2[4] or
              posedge h4a3[4] or posedge h3a3[4] or posedge h2a3[4] or posedge h1a3[4] or
              posedge h4a4[4] or posedge h3a4[4] or posedge h2a4[4] or posedge h1a4[4]) 
        begin
        
            if(h4a1[4])
                h4 = h4a1 [3:0];

            if(h3a1[4])
                h3 = h3a1 [3:0];

            if(h2a1[4])
                h2 = h2a1 [3:0];

            if(h1a2[4])
                h1 = h1a2 [3:0];

            if(h4a2[4])
                h4 = h4a2 [3:0];

            if(h3a2[4])
                h3 = h3a2 [3:0];

            if(h2a2[4])
                h2 = h2a2 [3:0];

            if(h1a2[4])
                h1 = h1a2 [3:0];

            if(h4a3[4])
                h4 = h4a3 [3:0];

            if(h3a3[4])
                h3 = h3a3 [3:0];

            if(h2a3[4])
                h2 = h2a3 [3:0];

            if(h1a3[4])
                h1 = h1a3 [3:0];

            if(h4a4[4])
                h4 = h4a4 [3:0];

            if(h3a4[4])
                h3 = h3a4 [3:0];

            if(h2a4[4])
                h2 = h2a4 [3:0];

            if(h1a4[4])
                h1 = h1a4 [3:0];

        end

    /* Atualiza o valor do enable do visor */
    always @ (posedge en1)
        begin
            
            if(en1)
                begin
                    
                    en = 4'b0000;

                    #100

                    en = 4'b1111;

                end

        end


    /** Relógio padrão **/

    initial
        begin

            p4 <= 4'b0000;
            p3 <= 4'b0000;
            p2 <= 4'b0000;
            p1 <= 4'b0000;

            p4a1[4] <= 1'b0;
            p3a1[4] <= 1'b0;
            p2a1[4] <= 1'b0;
            p1a1[4] <= 1'b0;

        end


    /* Atualiza o valor do relógio */
    always @ (posedge p4a1[4] or posedge p3a1[4] or posedge p2a1[4] or posedge p1a1[4])
        begin
        
            if(p4a1[4])
                p4 = p4a1 [3:0];

            if(p3a1[4])
                p3 = p3a1 [3:0];

            if(p2a1[4])
                p2 = p2a1 [3:0];

            if(p1a1[4])
                p1 = p1a1 [3:0];


        end



    /* Contador síncrono relógio padrão */
    always

        begin #59999

            p1a1 [3:0] = p1;
            p2a1 [3:0] = p2;
            p3a1 [3:0] = p3;
            p4a1 [3:0] = p4;

            
            
            /* Limita o primeiro dígito a 9 */
            if(p1 == 4'b1001)
                begin
    
                    /* Limita o segundo dígito a 6 */
                    if(p2 == 4'b0101)
                        begin
                            
                            /* Limita o terceiro dígito a 9 mas se o quarto dígito
                                for 2 o terceiro dígito é limitado a 3 */
                            if(p3 == 4'b1001 | (p4 == 4'b0010 & p3 == 4'b0011))
                                begin
                                    
                                    /* Limita o quarto dígito a 2 */
                                    if(p4 == 4'b0010)
                                        p4a1 [3:0] = 4'b0000;
                                    else
                                        p4a1 [3:0] = p4 + 4'b0001;


                                p3a1 [3:0] = 4'b0000;

                                end
                            else
                                p3a1 [3:0] = p3 + 4'b0001;


                            p2a1 [3:0] = 4'b0000;             

                        end
                    else
                        p2a1 [3:0] = p2 + 4'b0001;

                    p1a1 [3:0] = 4'b0000;

                end
            else
                p1a1 [3:0] = p1 + 4'b0001;

            /* Altera o relógio e o visor */
            p1a1[4] = 1'b1;
            p2a1[4] = 1'b1;
            p3a1[4] = 1'b1;
            p4a1[4] = 1'b1;
        
            if(estado == 4'b0000)
                begin

                    h1a1 = p1a1;
                    h2a1 = p2a1;
                    h3a1 = p3a1;
                    h4a1 = p4a1;

                end

            #1
            
            p1a1[4] = 1'b0;
            p2a1[4] = 1'b0;
            p3a1[4] = 1'b0;
            p4a1[4] = 1'b0;

            if(estado == 4'b0000)
                begin

                    h1a1[4] = 1'b0;
                    h2a1[4] = 1'b0;
                    h3a1[4] = 1'b0;
                    h4a1[4] = 1'b0;

                end

        end



    /** Relógio regressivo **/
    always

        begin #999

            
            if(estado == 4'b0101)
            begin

                g1 = re1;
                g2 = re2;
                g3 = re3;
                g4 = re4;

                /* Contador regressivo síncrono */
                if((g1 != 4'b0000) | (g2 != 4'b0000) | (g3 != 4'b0000) | (g4 != 4'b0000))
                begin
                    

                    /* Limite é 0 e após o limite todos vão à 9 */
                    if(g1 != 4'b0000)
                        g1 = g1 - 4'b0001;

                    else
                        begin
                            
                            if(g2 != 4'b0000)
                                g2 = g2 - 4'b0001;

                            else
                                begin
                                    
                                    if(g3 != 4'b0000)
                                        g3 = g3 - 4'b0001;


                                    else
                                        begin
                            
                                            if(g4 != 4'b0000)
                                                g4 = g4 - 4'b0001;

                                            else
                                                g4 = 4'b1001;

                                            g3 = 4'b1001;

                                        end

                                    g2 = 4'b1001;

                                end

                            g1 = 4'b1001;

                        end

                    /* Atualizando o visor */
                    h1a2 [3:0] = g1;
                    h1a2 [3:0] = g2;
                    h1a2 [3:0] = g3;
                    h1a2 [3:0] = g4;

                    h1a2 [4] = g1;
                    h1a2 [4] = g2;
                    h1a2 [4] = g3;
                    h1a2 [4] = g4;

                    #1

                    h1a2 [4] = 1'b0;
                    h1a2 [4] = 1'b0;
                    h1a2 [4] = 1'b0;
                    h1a2 [4] = 1'b0;

                end

                /* Comida finalizada */
                else
                    begin

                        est1 = 1'b1;

                        #1

                        est1 = 1'b0; 

                    end


            end


        end

    /** Comida pronta **/

    /* Faz o alarme e o visor pisca */
    always @ (negedge clk) 
        begin

            if(estado == 4'b0110)
            begin

                en1 = 1'b1;
                s1 = 1'b1;

                #1

                en1 = 1'b0;
                s1 = 1'b0;

            end

        end

    /* Desliga o motor e retorna ao relógio padrão */
    always @ (*)
        begin

            if(estado == 4'b0110)
                begin

                    ma1 = 1'b1;
                    #1
                    ma1 = 1'b0;
                    
                    #5000

                    luz3 = 1'b1;

                    est2 = 1'b1;


                    h1a3 [3:0] = p1;
                    h2a3 [3:0] = p2;
                    h3a3 [3:0] = p3;
                    h4a3 [3:0] = p4;

                    h1a3[4] = 1'b1;
                    h2a3[4] = 1'b1;
                    h3a3[4] = 1'b1;
                    h4a3[4] = 1'b1;

                    #1

                    h1a3[4] = 1'b0;
                    h2a3[4] = 1'b0;
                    h3a3[4] = 1'b0;
                    h4a3[4] = 1'b0;

                    luz3 = 1'b0;

                    est2 = 1'b0;


                end

        end

    /** Teclado **/


    /* O usuário clica em um botão de número */
    always @ (posedge t[0] or posedge t[1] or posedge t[2] or
              posedge t[3] or posedge t[4] or posedge t[5] or
              posedge t[6] or posedge t[7] or posedge t[8] or posedge t[9])
        begin

            if(t[0]) num <= 4'd0;

            else if(t[1]) num <= 4'd1;

            else if(t[2]) num <= 4'd2;

            else if(t[3]) num <= 4'd3;

            else if(t[4]) num <= 4'd4;

            else if(t[5]) num <= 4'd5;

            else if(t[6]) num <= 4'd6;

            else if(t[7]) num <= 4'd7;

            else if(t[8]) num <= 4'd8;

            else if(t[9]) num <= 4'd9;


            /* Realiza as ações de acordo com o estado */
            case(estado)

        /* Seleção de contagem (o dígito a ser alterado
        vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    re1 = num;

                    re2 = 4'b0000;
                    re3 = 4'b0000;
                    re4 = 4'b0000;

                    h1 = g1;
                    h2 = g2;
                    h3 = g3;
                    h4 = g4;

                    estado = 4'b0001;

                    /* Som do botão */    
                    som = 1'b1;
                    #500
                    som = 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 = 4'd0;

                    h2 = g2;

                    estado = 4'b0010;

                    en[1] = 1'b1;

                    /* Som do botão */    
                    som = 1'b1;
                    #500
                    som = 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd0;

                    #1

                    h3 <= g3;

                    estado <= 4'b0011;

                    en[2] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0011:
                begin
                    
                    g4 <= 4'd0;

                    #1

                    h4 <= g4;

                    estado <= 4'b0100;

                    en[3] <= 1'b1;

                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

        /* Configuração de horário */
        4'b0111:
            begin
            
                rm1 <= 4'd0;

                #1

                h1 <= rm1;

                estado <= 4'b1000;

                en[0] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end
        
        4'b1000:
            begin
                rm2 <= 4'd0;

                #1

                h2 <= rm2;

                estado <= 4'b1001;

                en[1] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        4'b1001:
            begin
                rm3 <= 4'd0;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end
        
        4'b1010:
            begin

                p1 <= rm1;
                p2 <= rm2;
                p3 <= rm3;
                p4 <= 4'd0;

                #1

                h1 <= p1;
                h2 <= p2;
                h3 <= p3;
                h4 <= p4;

                estado <= 4'b0000;

                en[3] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd0;

                #1

                h1 <= rm1;

                estado <= 4'b1100;

                en[0] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        4'b1100:
            begin
                
                rm2 <= 4'd0;

                #1

                h2 <= rm2;

                estado <= 4'b1101;

                en[1] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        4'b1101:
            begin
                
                rm3 <= 4'd0;

                #1

                h3 <= rm3;

                estado <= 4'b1110;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end
        
        4'b1110:
            begin
                
                case(rec)

                    2'b00:
                        begin
                            
                            r11 <= rm1;
                            r12 <= rm2;
                            r13 <= rm3;
                            r14 <= 4'd0;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd0;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd0;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd0;

                        end

                endcase

                estado <= 4'b0000;

                en[3] <= 1'b1;

                h1 <= p1;
                h2 <= p2;
                h3 <= p3;
                h4 <= p4;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        default:
            begin
                    
                som <= 1'b1;
                #500
                som <= 1'b0;

            end        

    endcase



        end

    /* O usuário clica no botão de início */
    always @(posedge t[10]) 
    begin

        if((estado >= 4'b0001) & (estado <= 4'b0100))
        begin
           estado = 4'b0101;
           motor = 1'b1;
           aquec = 1'b1;
        //    luz = 1'b1;
        end

    end

    /* O usuário clica no botão de cancela */
    always @(posedge t[11]) 
    begin

        if(estado == 4'b0101)
        begin
            
            if(g4 == 4'b0000)
            begin
                if(g3 == 4'b0000)
                begin
                    if(g2 == 4'b0000)
                    begin
                        estado <= 4'b0001;
                        //luz = 1'b0;
                        motor = 1'b0;
                        aquec = 1'b0;
                    end
                    else
                    begin
                        estado = 4'b0010;
                        //luz = 1'b0;
                        motor = 1'b0;
                        aquec = 1'b0;
                    end
                end
                else
                begin
                    estado = 4'b0011;
                    //luz = 1'b0;
                    motor = 1'b0;
                    aquec = 1'b0;
                end
            end
            else
            begin
                estado = 4'b0100;
                //luz = 1'b0;
                motor = 1'b0;
                aquec = 1'b0;

            end
                

        end

        else if((estado != 4'b0000) & (estado != 4'b0110))
        begin
            
            estado = 4'b0000;
            h1 = p1;
            h2 = p2;
            h3 = p3;
            h4 = p4;
            
        end

            
        som = 1'b1;
        #500
        som = 1'b0;
        
    end



    /* LEDs piscando para indicar qual é o dígito sendo alterado */
    always @ (*) if(estado == 4'b0001) en[1] <= clk;
    always @ (*) if(estado == 4'b0010) en[2] <= clk;
    always @ (*) if(estado == 4'b0011) en[3] <= clk;

    always @ (*) if(estado == 4'b0111) en[0] <= clk;
    always @ (*) if(estado == 4'b1000) en[1] <= clk;
    always @ (*) if(estado == 4'b1001) en[2] <= clk;
    always @ (*) if(estado == 4'b1010) en[3] <= clk;

    always @ (*) if(estado == 4'b1011) en[0] <= clk;
    always @ (*) if(estado == 4'b1100) en[1] <= clk;
    always @ (*) if(estado == 4'b1101) en[2] <= clk;
    always @ (*) if(estado == 4'b1110) en[3] <= clk;


    /** Receita **/
    initial
    begin

        /* Receita 1 tem valor padrão de 1 minuto */
        r11 <= 4'b0000;
        r12 <= 4'b0000;
        r13 <= 4'b0001;
        r14 <= 4'b0000;

        /* Receita 2 tem valor padrão de 2 minutos */
        r21 <= 4'b0000;
        r22 <= 4'b0000;
        r23 <= 4'b0010;
        r24 <= 4'b0000;

        /* Receita 3 tem valor padrão de 3 minutos */
        r31 <= 4'b0000;
        r32 <= 4'b0000;
        r33 <= 4'b0011;
        r34 <= 4'b0000;

        /* Receita 4 tem valor padrão de 4 minutos */
        r41 <= 4'b0000;
        r42 <= 4'b0000;
        r43 <= 4'b0100;
        r44 <= 4'b0000; 

    end

    /* O usuário clica em um botão de receita */
    always @ (posedge r[0])
    begin

        if((estado >= 4'b0111) & (estado <= 4'b1010))
            begin

                rec <= 2'b00;

                estado <= 4'b1011;

                h1 <= r11;
                h2 <= r12;
                h3 <= r13;
                h4 <= r14;

            end
        else if(estado == 4'b0000)
        begin
            
            g1 <= r11;
            g2 <= r12;
            g3 <= r13;
            g4 <= r14;

            h1 <= r11;
            h2 <= r12;
            h3 <= r13;
            h4 <= r14;

            estado <= 4'b0100;

        end


        som <= 1'b1;
        #500
        som <= 1'b0;

    end

    always @ (posedge r[1])
    begin

        if((estado >= 4'b0111) & (estado <= 4'b1010))
            begin

                rec <= 2'b01;

                estado <= 4'b1011;

                h1 <= r21;
                h2 <= r22;
                h3 <= r23;
                h4 <= r24;

            end
        else if(estado == 4'b0000)
        begin
            
            g1 <= r21;
            g2 <= r22;
            g3 <= r23;
            g4 <= r24;

            #1

            h1 <= g1;
            h2 <= g2;
            h3 <= g3;
            h4 <= g4;

            estado <= 4'b0100;

        end


        som <= 1'b1;
        #500
        som <= 1'b0;

    end

    always @ (posedge r[2])
    begin

        if((estado >= 4'b0111) & (estado <= 4'b1010))
            begin

                rec <= 2'b10;

                estado <= 4'b1011;

                h1 <= r31;
                h2 <= r32;
                h3 <= r33;
                h4 <= r34;

            end
        else if(estado == 4'b0000)
        begin
            
            g1 <= r31;
            g2 <= r32;
            g3 <= r33;
            g4 <= r34;

            #1

            h1 <= g1;
            h2 <= g2;
            h3 <= g3;
            h4 <= g4;

            estado <= 4'b0100;

        end


        som <= 1'b1;
        #500
        som <= 1'b0;

    end

    always @ (posedge r[3])
    begin

        if((estado >= 4'b0111) & (estado <= 4'b1010))
            begin

                rec <= 2'b11;

                estado <= 4'b1011;

                h1 <= r41;
                h2 <= r42;
                h3 <= r43;
                h4 <= r44;

            end
        else if(estado == 4'b0000)
        begin
            
            g1 <= r41;
            g2 <= r42;
            g3 <= r43;
            g4 <= r44;

            #1

            h1 <= g1;
            h2 <= g2;
            h3 <= g3;
            h4 <= g4;

            estado <= 4'b0100;

        end


        som <= 1'b1;
        #500
        som <= 1'b0;

    end


    /** Configuração **/

    /* O usuário clica no botão de configuração */
    always @ (posedge conf) 
    begin

        if(estado == 4'b0000)            
            estado <= 4'b0111;

        som <= 1'b1;
        #500
        som <= 1'b0;

    end

endmodule