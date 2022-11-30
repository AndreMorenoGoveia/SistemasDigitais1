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
    reg est4;
    reg [4:0] est5;
    reg [1:0] est6;
    reg est7;



    /** Componentes internos **/
    /* Auxiliares */
    reg luz1;
    reg luz2;
    reg luz3;
    reg luz4;
    reg luz5;
    reg s1;
    reg s2;
    reg s3;
    reg s4;
    reg s5;
    reg s6;
    reg ma1;
    reg ma2;
    reg ma3;



    /** Teclado **/
    reg [3:0] num;



    /** Visor **/
    reg [3:0] h4;
    reg [3:0] h3;
    reg [3:0] h2;
    reg [3:0] h1;
    reg [3:0] en;

    /* Auxiliares */
    reg ha1;
    reg ha2;
    reg ha3;
    reg ha4;
    reg ha5;
    reg [3:0] h1a;
    reg [3:0] h2a;
    reg [3:0] h3a;
    reg [3:0] h4a;
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
    reg [3:0] p4a2;
    reg [3:0] p3a2;
    reg [3:0] p2a2;
    reg [3:0] p1a2;
    reg pa;



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
    reg [3:0] g4;
    reg [3:0] g3;
    reg [3:0] g2;
    reg [3:0] g1;

    /* Auxiliares */
    reg [3:0] g4a1;
    reg [3:0] g3a1;
    reg [3:0] g2a1;
    reg [3:0] g1a1;
    reg ga1;
    reg [3:0] g4a2;
    reg [3:0] g3a2;
    reg [3:0] g2a2;
    reg [3:0] g1a2;
    reg ga2;
    reg ga3;


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
        s2 <= 1'b0;
        s3 <= 1'b0;
        s4 <= 1'b0;
        s5 <= 1'b0;
        s6 <= 1'b0;
        ma1 <= 1'b0;
        ma2 <= 1'b0;
        ma3 <= 1'b0;

        luz <= porta;
        luz1 <= 1'b0;
        luz2 <= 1'b0;
        luz3 <= 1'b0;
        luz4 <= 1'b0;
        luz4 <= 1'b0;

    end

    /* Detecta se a porta abre */
    always @ (posedge porta) begin luz1 = 1'b1; #1 luz1 = 1'b0; end

    always @ (negedge porta) begin luz2 = 1'b1; #1 luz2 = 1'b0; end

    /* Atualiza o valor da luz */
    always @ (posedge luz1 or posedge luz2 or posedge luz3 or posedge luz4 or posedge luz5)
    begin
    
        if(luz1 | luz4) luz = 1'b1;
        else if(luz2 | luz3 | luz5) luz = 1'b0;

    end

    /* Atualiza o valor do som */
    always @ (posedge s1 or posedge s2 or posedge s3 or
              posedge s4 or posedge s5 or posedge s6)
        begin
                
            som = 1'b1;

            #100

            som = 1'b0;

        end

    /* Atualiza o valor do motor e do aquecimento */
    always @ (posedge ma1 or posedge ma2 or posedge ma3)
        begin
            
            if(ma1 | ma3)
                begin

                    motor = 1'b0;
                    aquec = 1'b0;
                    
                end

            else if(ma2)
                begin

                    motor = 1'b1;
                    aquec = 1'b1;
                    
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
            est4 <= 1'b0;
            est5[4] <= 1'b0;
            est6[0] <= 1'b0;
            est7 = 1'b0;

        end


    
    /* Atualiza o valor do estado */
    always @ (posedge est1 or posedge est2 or posedge est3[4] or
              posedge est4 or posedge est5[4] or posedge est6[0] or posedge est7)
        begin

            if(est1)
                estado = 4'b0110;
    
            else if(est2)
                estado = 4'b0000;

            else if(est3[4])
                estado = est3 [3:0];

            else if(est4)
                estado = 4'b0101;

            else if(est5[4])
                estado = 4'b0000;

            else if(est6[0])
                begin
                    if(est6[1])
                        estado = 4'b1011;
                    else 
                        estado = 4'b0100;
                end
            
            else if(est7)
                estado = 4'b0111;
 
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

            ha1 <= 1'b0;
            ha2 <= 1'b0;
            ha3 <= 1'b0;
            ha4 <= 1'b0;
            ha5 <= 1'b0;
    
            en1 <= 1'b0;

        end

    /* Atualiza o valor do visor */
    always @ (posedge ha1 or posedge ha2 or posedge ha3 or
              posedge ga2 or posedge ha4 or posedge ha5) 
        begin
        
            if(ha1 | ha3 | ha4)
                begin
                    
                    h1 = p1;
                    h2 = p2;
                    h3 = p3;
                    h4 = p4;

                end

            else if(ha2)
                begin
                    
                    h1 = g1;
                    h2 = g2;
                    h3 = g3;
                    h4 = g4;

                end

            if(ga2)
                begin
                    
                    h1 = g1a2;
                    h2 = g2a2;
                    h3 = g3a2;
                    h4 = g4a2;

                end

            else if(ha5)
                begin

                    h1 = h1a;
                    h2 = h2a;
                    h3 = h3a;
                    h4 = h4a;

                end

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

            pa = 1'b0;

        end


    /* Atualiza o valor do relógio */
    always @ (posedge p4a1[4] or posedge p3a1[4] or
              posedge p2a1[4] or posedge p1a1[4] or posedge pa)
        begin
        
            if(p4a1[4])
                p4 = p4a1 [3:0];

            if(p3a1[4])
                p3 = p3a1 [3:0];

            if(p2a1[4])
                p2 = p2a1 [3:0];

            if(p1a1[4])
                p1 = p1a1 [3:0];

            if(pa)
                begin
                    
                    p1 = p1a2;
                    p2 = p2a2;
                    p3 = p3a2;
                    p4 = p4a2;

                end


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
                ha1 = 1'b1;


            #1

            p1a1[4] = 1'b0;
            p2a1[4] = 1'b0;
            p3a1[4] = 1'b0;
            p4a1[4] = 1'b0;

            if(estado == 4'b0000)
                ha1 = 1'b0;

        end



    /** Relógio regressivo **/

    /* Valor inicial */
    initial 
        begin
        
            ga1 = 1'b0;
            ga2 = 1'b0;

        end

    /* Alterando o valor do cronômetro */
    always @ (posedge ga1 or posedge ga2 or posedge ha5)
        begin
            
            if(ga1)
                begin

                    g1 = g1a1;
                    g2 = g2a1;
                    g3 = g3a1;
                    g4 = g4a1;

                end

            if(ga2)
                begin
                    
                    g1 = g1a2;
                    g2 = g2a2;
                    g3 = g3a2;
                    g4 = g4a2;

                end

            else if(ha5)
                begin
                    
                    g1 = h1a;
                    g2 = h2a;
                    g3 = h3a;
                    g4 = h4a;

                end

        end

    /* Contador regressivo síncrono */
    always

        begin #999

            g1a1 = g1;
            g2a1 = g2;
            g3a1 = g3;
            g4a1 = g4;
            
            if(estado == 4'b0101)
            begin

                if((g1 != 4'b0000) | (g2 != 4'b0000) | (g3 != 4'b0000) | (g4 != 4'b0000))
                begin
                    

                    /* Limite é 0 e após o limite todos vão à 9 */
                    if(g1a1 != 4'b0000)
                        g1a1 = g1 - 4'b0001;

                    else
                        begin
                            
                            if(g2a1 != 4'b0000)
                                g2a1 = g2 - 4'b0001;

                            else
                                begin
                                    
                                    if(g3 != 4'b0000)
                                        g3a1 = g3 - 4'b0001;


                                    else
                                        begin
                            
                                            if(g4 != 4'b0000)
                                                g4a1 = g4 - 4'b0001;

                                            else
                                                g4a1 = 4'b1001;

                                            g3a1 = 4'b1001;

                                        end

                                    g2a1 = 4'b1001;

                                end

                            g1a1 = 4'b1001;

                        end

                    /* Atualizando o visor e o cronômetro */
                    ga1 = 1'b1;
                    ha2 = 1'b1;

                    #1

                    ha2 = 1'b0;
                    ga1 = 1'b0;

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


                    ha3 = 1'b1;

                    #1

                    ha3 = 1'b0;

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

            #1


            /* Realiza as ações de acordo com o estado */
            case(estado)

        /* Seleção de contagem (o dígito a ser alterado
        vai andanddo de acordo com o apertar de botões) */

            /* Caso esteja no relógio padrão é configurado para que
               o primeiro numero seja o digitado e os outros sejam 0 */
            4'b0000:
                begin
                    
                    g1a2 = num;
                    g2a2 = 4'b0000;
                    g3a2 = 4'b0000;
                    g4a2 = 4'b0000;

                    ga2 = 1'b1;


                    est3 [3:0] = 4'b0001;

                    est3[4] = 1'b1;
  
                    s2 = 1'b1;

                    #1

                    s2 = 1'b0;

                    est3[4] = 1'b0;

                    ga2 = 1'b0;

                end
        
            /* O segundo dígito é alterado e o terceiro passa a ser o próximo */
            4'b0001:
                begin
                    
                    g2a2 = num;
                    ga2 = 1'b1;

                    est3 [3:0] = 4'b0010;
                    est3 [4] = 1'b1;

                    s2 = 1'b1;

                    #1

                    ga2 = 1'b0;

                    est3 [4] = 1'b0;

                    s2 = 1'b0;

                end

            /* O terceiro dígito é alterado e o quarto passa a ser o próximo */
            4'b0010:
                begin
                    
                    g3a2 = num;
                    ga2 = 1'b1;

                    est3 [3:0] = 4'b0011;
                    est3 [4] = 1'b1;

                    s2 = 1'b1;

                    #1

                    ga2 = 1'b0;

                    est3 [4] = 1'b0;

                    s2 = 1'b0;

                end


            /* Caso o quarto dígito for diferente de zero, o visor entra em estado de cheio */
            4'b0011:
                begin

                    if(num != 4'b0000)
                        begin
                    
                            g4a2 = num;
                            ga2 = 1'b1;

                            est3 [3:0] = 4'b0100;
                            est3 [4] = 1'b1;

                            s2 = 1'b1;

                            #1

                            ga2 = 1'b0;

                            est3 [4] = 1'b0;

                            s2 = 1'b0;

                        end

                end

        /* Configuração de horário */
        /* É alterado o primeiro dígito */
        4'b0111:
            begin
            
                g1a2 = num;
                g2a2 = p2;
                g3a2 = p3;
                g4a2 = p4;
                ga2 = 1'b1;

                est3 [3:0] = 4'b1000;
                est3 [4] = 1'b1;

                s2 = 1'b1;

                #1

                s2 = 1'b0;

                est3 [4] = 1'b0;

                ga2 = 1'b0; 

            end
        
        /* É alterado o segundo dígito caso este seja menor que 6 */
        4'b1000:
            begin

                if(num < 4'd6)
                    begin

                    
                        g2a2 = num;
                        ga2 = 1'b1;

                        est3 [3:0] = 4'b1001;
                        est3 [4] = 1'b1;

                        s2 = 1'b1;

                        #1

                        ga2 = 1'b0;

                        est3 [4] = 1'b0;

                        s2 = 1'b0;

                    end

                else
                    begin

                        s2 = 1'b1;
                        #1
                        s2 = 1'b0;

                    end

            end

        /* É alterado o terceiro dígito */
        4'b1001:
            begin

                g3a2 = num;
                ga2 = 1'b1;

                est3 [3:0] = 4'b1010;
                est3 [4] = 1'b1;

                s2 = 1'b1;

                #1

                ga2 = 1'b0;

                est3 [4] = 1'b0;

                s2 = 1'b0;

            end

        /* É alterado o quarto dígito e, caso seja menor que 3 e, dependendo da escolha anterior,
           menor que 2, o reógio padrão é atualizado */
        4'b1010:
            begin

                if((num < 4'd3 & g3a2 < 4'd4) | num <  4'd2)
                    begin

                        p1a2 = g1a2;
                        p2a2 = g2a2;
                        p3a2 = g3a2;
                        p4a2 = g4a2;
                        pa = 1'b1;

                        #1

                        ga2 = 1'b1;

                        est3 [3:0] = 4'b0000;
                        est3 [4] = 1'b1;

                        s2 = 1'b1;

                        #1

                        pa = 1'b0;

                        ga2 = 1'b0;

                        est3 [4] = 1'b0;

                        s2 = 1'b0;

                    end

                else
                    begin

                        s2 = 1'b1;
                        #1
                        s2 = 1'b0;
    
                    end

            end

        /* Configuração de receita */
        /* É alterado o primeiro dígito da receita */
        4'b1011:
            begin
                
                g1a2 = num;
                g2a2 = 4'b0000;
                g3a2 = 4'b0000;
                g4a2 = 4'b0000; 
                ga2 = 1'b1;

                est3 [3:0] = 4'b1100;
                est3 [4] = 1'b1;

                s2 = 1'b1;

                #1

                ga2 = 1'b0;

                est3 = 1'b0;

                s2 = 1'b0;

            end

        /* É alterado o segundo dígito da receita */
        4'b1100:
            begin
                
                g2a2 = num;
                ga2 = 1'b1;

                est3 [3:0] = 4'b1101;
                est3 [4] = 1'b1;

                s2 = 1'b1;

                #1

                ga2 = 1'b0;

                est3 = 1'b0;

                s2 = 1'b0;

            end

        /* É alterado o terceiro dígito da receita */
        4'b1101:
            begin
                
                g3a2 = num;
                ga2 = 1'b1;

                est3 [3:0] = 4'b1110;
                est3 [4] = 1'b1;

                s2 = 1'b1;

                #1

                ga2 = 1'b0;

                est3 = 1'b0;

                s2 = 1'b0;

            end
        
        /* É alterado o quarto dígito da receita, a receita na memória é atualizada
           e retorna ao relógio padrão */
        4'b1110:
            begin
                
                case(rec)

                    2'b00:
                        begin
                            
                            r11 = g1a2;
                            r12 = g2a2;
                            r13 = g3a2;
                            r14 = num;

                        end

                    2'b01:
                        begin
                            
                            r21 = g1a2;
                            r22 = g2a2;
                            r23 = g3a2;
                            r24 = num;

                        end

                    2'b10:
                        begin
                            
                            r31 = g1a2;
                            r32 = g2a2;
                            r33 = g3a2;
                            r34 = num;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 = g1a2;
                            r42 = g2a2;
                            r43 = g3a2;
                            r44 = num;

                        end

                endcase

                est3 [3:0] = 4'b0000;
                est3 [4] = 1'b1;

                g1a2 = p1;
                g2a2 = p2;
                g3a2 = p3;
                g4a2 = p4;

                ga2 = 1'b1;

                s2 = 1'b1;

                #1

                est3 [4] = 1'b0;

                ga2 = 1'b0;

                s2 = 1'b0;

            end

        /* Caso algum botão seja pressionado sairá um som */
        default:
            begin
                    
                s2 = 1'b1;
                #1
                s2 = 1'b0;

            end        

    endcase

        end

    /* O usuário clica no botão de início */
    always @(posedge t[10]) 
    begin

        if((estado >= 4'b0001) & (estado <= 4'b0100) & (porta != 1'b1))
            begin

                est4 = 1'b1;
                ma2 = 1'b1;
                luz4 = 1'b1;

                #1

                est4 = 1'b0;
                ma2 = 1'b0;
                luz4 = 1'b0;

            end

        s3 = 1'b1;
        #1
        s3 = 1'b0;

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
                        est5 [3:0] = 4'b0001;

                    else
                        est5 [3:0] = 4'b0010;

                end
                else
                    est5 [3:0] = 4'b0011;

            end
            else
                est5 [3:0] = 4'b0100;

            est5[4] = 1'b1;

            luz5 = 1'b1;

            ma3 = 1'b1;

            #1 

            est5[4] = 1'b0;

            luz5 = 1'b0;

            ma3 = 1'b0;
                

        end

        else if((estado != 4'b0000) & (estado != 4'b0110))
        begin
            
            est5 [3:0] = 4'b0000;
            est5 [4] = 1'b1;

            ha4 = 1'b1;

            #1

            est5[4] = 1'b0;

            ha4 = 1'b0;
            
        end

            
        s4 = 1'b1;
        #1
        s4 = 1'b0;
        
    end



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
    always @ (posedge r[0] or posedge r[1] or posedge r[2] or posedge r[3])
    begin

        if(r[0])
            rec = 2'b00;
        else if(r[1])
            rec = 2'b01;
        else if(r[2])
            rec = 2'b10;
        else
            rec = 2'b11;


        if((estado >= 4'b0111) & (estado <= 4'b1010))
            begin

                est6[1] <= 1'b1;
                est6[0] <= 1'b1;

                #1

                est6[0] = 1'b0;

            end
        else if(estado == 4'b0000)
        begin


            case(rec)

                1'b00:
                    begin
                        
                        h1a = r11;
                        h2a = r12;
                        h3a = r13;
                        h4a = r14;

                    end

                1'b01:
                    begin
                        
                        h1a = r21;
                        h2a = r22;
                        h3a = r23;
                        h4a = r24;

                    end

                1'b10:
                    begin
                        
                        h1a = r31;
                        h2a = r32;
                        h3a = r33;
                        h4a = r34;

                    end

                1'b11:
                    begin
                        
                        h1a = r41;
                        h2a = r42;
                        h3a = r43;
                        h4a = r44;

                    end


            endcase

            ha5 = 1'b1;

            est6[1] = 1'b0;
            est6[0] = 1'b1;

            #1

            est6[0] = 1'b0;

            ha5 = 1'b0;


        end

        s5 <= 1'b1;
        #1
        s5 <= 1'b0;

    end


    /** Configuração **/

    /* O usuário clica no botão de configuração */
    always @ (posedge conf) 
    begin

        if(estado == 4'b0000)            
            est7 = 1'b1;

        s6 <= 1'b1;
        #1
        s6 <= 1'b0;

        est7 = 1'b0;

    end

endmodule