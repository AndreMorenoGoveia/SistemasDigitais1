`timescale 1ms/100ns

module maindebbug(t, conf, r, porta,
                    led1, led2, led3, led4, luz, motor, aquec, som);


    /** Entradas e saídas **/
    input wire [11:0] t; /* t[10] é o botão inicia e t[11] o botão cancela */
    input wire conf;
    input wire [3:0] r;
    input wire porta;

    output wire[3:0] led1;
    output wire[3:0] led2;
    output wire[3:0] led3;
    output wire[3:0] led4;
    output reg luz;
    output reg motor;
    output reg aquec;
    output reg som;



    /** Declaração dos elementos **/

    /* Estados
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
    */
    reg [4:0] estado;

    /* Visor */
    reg [3:0] h4;
    reg [3:0] h3;
    reg [3:0] h2;
    reg [3:0] h1;
    reg [3:0] en;

    /* Relógio Padrão */
    reg [3:0] p4;
    reg [3:0] p3;
    reg [3:0] p2;
    reg [3:0] p1;
    reg clk1;

    /* Receitas */
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

    /* Relógio regressivo */
    reg [3:0] g4;
    reg [3:0] g3;
    reg [3:0] g2;
    reg [3:0] g1;
    reg clk2;

    /* Clocks temporizadores */
    reg clk3;
    always #30000 clk1 <= ~clk1; /* Configurado para alternar a cada 30s */
    always #500 clk2 <= ~clk2; /* Configurado para alternar a cada 0,5s */
    always #250 clk3 <= ~clk3; /* Configurado para alternar a cada 0,25s */

    /** Relações entre os módulos **/
    Conversor4bits0a9 
    m1(.ain(h1[0]), .bin(h1[1]), .cin(h1[2]), .din(h1[3]), .en(en[0]),
       .aout(led1[0]), .bout(led1[1]), .cout(led1[2]), .dout(led1[3]),
       .eout(led1[4]), .fout(led1[5]), .gout(led1[6]));

    Conversor4bits0a9 
    m2(.ain(h2[0]), .bin(h2[1]), .cin(h2[2]), .din(h2[3]), .en(en[1]),
       .aout(led2[0]), .bout(led2[1]), .cout(led2[2]), .dout(led2[3]),
       .eout(led2[4]), .fout(led2[5]), .gout(led2[6]));

    Conversor4bits0a9 
    m3(.ain(h3[0]), .bin(h3[1]), .cin(h3[2]), .din(h3[3]), .en(en[2]),
       .aout(led3[0]), .bout(led3[1]), .cout(led3[2]), .dout(led3[3]),
       .eout(led3[4]), .fout(led3[5]), .gout(led3[6]));

    Conversor4bits0a9 
    m4(.ain(h4[0]), .bin(h4[1]), .cin(h4[2]), .din(h4[3]), .en(en[3]),
       .aout(led4[0]), .bout(led4[1]), .cout(led4[2]), .dout(led4[3]),
       .eout(led4[4]), .fout(led4[5]), .gout(led4[6]));


    /** Luz interna **/
    initial luz <= porta;
    always @ (posedge porta) luz <= 1'b1;
    always @ (negedge porta) luz <= 1'b0;


    /** Componentes internos **/
    initial 
    begin

        motor <= 1'b0;
        aquec <= 1'b0;
        som <= 1'b0;

    end

    /** Relógio padrão **/

    initial
        begin

            p4 <= 4'b0010;
            p3 <= 4'b0011;
            p2 <= 4'b0101;
            p1 <= 4'b1001;

            estado <= 4'b0000;

            clk1 <= 1'b0;
            clk2 <= 1'b0;
            clk3 <= 1'b0;

            #1

            h4 <= p4;
            h3 <= p3;
            h2 <= p2;
            h1 <= p1;

            en <= 4'b1111;


        end



    /* Contador síncrono relógio padrão */
    always @ (negedge clk1)

        begin
            
            if(p1 == 4'b1001)
                begin
    
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

                    p1 <= 4'b0000;

                end
            else
                p1 <= p1 + 4'b0001;


            if(estado == 4'b0000)
                begin

                    #1
                    
                    h1 <= p1;
                    h2 <= p2;
                    h3 <= p3;
                    h4 <= p4;

                end

        end


    /** Relógio regressivo **/
    always @ (negedge clk2)
    begin
        

        if(estado == 4'b0101)
        begin
            /* Contador regressivo síncrono */
            if((g1 != 4'b0000) | (g2 != 4'b0000) | (g3 != 4'b0000) | (g4 != 4'b0000))
            begin
                
                if(g1 != 4'b0000)
                begin
                    g1 <= g1 - 4'b0001;
                    #1
                    h1 <= g1;
                end

                else
                begin
                    
                    if(g2 != 4'b0000)
                    begin
                        g2 <= g2 - 4'b0001;
                        #1
                        h2 <= g2;
                    end

                    else
                        begin
                            
                            if(g3 != 4'b0000)
                            begin
                                g3 <= g3 - 4'b0001;
                                #1
                                h3 <= g3;   
                            end

                            else
                            begin
                                if(g4 != 4'b0000)
                                begin
                                    g4 <= g4 - 4'b0001;
                                    #1
                                    h4 <= g4;
                                end
                                else
                                begin
                                    g4 <= 4'b1001;
                                    #1
                                    h4 <= g4;
                                end


                                g3 <= 4'b1001;
                                #1
                                h3 <= g3;
                            end

                            g2 <= 4'b1001;
                            #1
                            h2 <= g2;

                        end


                    g1 <= 4'b1001;
                    #1
                    h1 <= g1;

                end

            end

            /* Comida finalizada */
            else
                estado <= 4'b0110;


        end


    end

    /** Comida pronta **/
    always @ (negedge clk3) 
        begin

            if(estado == 4'b0110)
            begin
                en <= ~en;
                som <= ~som;
            end

        end
    always @ (estado == 4'b0110)
    begin

        motor <= 1'b0;
        aquec <= 1'b0;
        


        #5000

        en <= 4'b1111;
        som <= 1'b0;
        luz <= 1'b0;

        estado <= 4'b0000;

        h1 <= p1;
        h2 <= p2;
        h3 <= p3;
        h4 <= p4;


    end

    /** Teclado **/

    /* O usuário clica no botão de início */
    always @(posedge t[10]) 
    begin

        if((estado >= 4'b0001) & (estado <= 4'b0100))
           estado <= 4'b0101;

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
                        luz <= 1'b0;
                        motor <= 1'b0;
                        aquec <= 1'b0;
                    end
                    else
                    begin
                        estado <= 4'b0010;
                        luz <= 1'b0;
                        motor <= 1'b0;
                        aquec <= 1'b0;
                    end
                end
                else
                begin
                    estado <= 4'b0011;
                    luz <= 1'b0;
                    motor <= 1'b0;
                    aquec <= 1'b0;
                end
            end
            else
            begin
                estado <= 4'b0100;
                luz <= 1'b0;
                motor <= 1'b0;
                aquec <= 1'b0;

            end
                

        end

        else if((estado != 4'b0000) & (estado != 4'b0110))
        begin
            
            estado <= 4'b0000;
            h1 <= p1;
            h2 <= p2;
            h3 <= p3;
            h4 <= p4;
            
        end

            
        som <= 1'b1;
        #500
        som <= 1'b0;
        
    end



    /* O usuário clica em algum botão de número */
    always @ (posedge t[0])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd0;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd0;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

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

    always @ (posedge t[1])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd1;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd1;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd1;

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
                    
                    g4 <= 4'd1;

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
            
                rm1 <= 4'd1;

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
                rm2 <= 4'd1;

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
                rm3 <= 4'd1;

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
                p4 <= 4'd1;

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
                
                rm1 <= 4'd1;

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
                
                rm2 <= 4'd1;

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
                
                rm3 <= 4'd1;

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
                            r14 <= 4'd1;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd1;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd1;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd1;

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

    always @ (posedge t[2])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd2;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd2;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd2;

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
                    
                    g4 <= 4'd2;

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
            
                rm1 <= 4'd2;

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
                rm2 <= 4'd2;

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
                rm3 <= 4'd2;

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

                if(rm3 < 4'b0100)
                begin
                    
                    p1 <= rm1;
                    p2 <= rm2;
                    p3 <= rm3;
                    p4 <= 4'd2;

                    #1

                    h1 <= p1;
                    h2 <= p2;
                    h3 <= p3;
                    h4 <= p4;

                    estado <= 4'b0000;

                    en[3] <= 1'b1;

                end

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd2;

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
                
                rm2 <= 4'd2;

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
                
                rm3 <= 4'd2;

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
                            r14 <= 4'd2;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd2;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd2;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd2;

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
    always @ (posedge t[3])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd3;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd3;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd3;

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
                    
                    g4 <= 4'd3;

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
            
                rm1 <= 4'd3;

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
                rm2 <= 4'd3;

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
                rm3 <= 4'd3;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd3;

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
                
                rm2 <= 4'd3;

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
                
                rm3 <= 4'd3;

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
                            r14 <= 4'd3;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd3;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd3;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd3;

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
    always @ (posedge t[4])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd4;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd4;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd4;

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
                    
                    g4 <= 4'd4;

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
            
                rm1 <= 4'd4;

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
                rm2 <= 4'd4;

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

                rm3 <= 4'd4;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd4;

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
                
                rm2 <= 4'd4;

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
                
                rm3 <= 4'd4;

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
                            r14 <= 4'd4;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd4;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd4;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd4;

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
    always @ (posedge t[5])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd5;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd5;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd5;

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
                    
                    g4 <= 4'd5;

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
            
                rm1 <= 4'd5;

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
                rm2 <= 4'd5;

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
                rm3 <= 4'd5;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd5;

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
                
                rm2 <= 4'd5;

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
                
                rm3 <= 4'd5;

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
                            r14 <= 4'd5;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd5;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd5;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd5;

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
    always @ (posedge t[6])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd6;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd6;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd6;

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
                    
                    g4 <= 4'd6;

                    #1

                    h4 <= g4;

                    estado <= 4'b0100;

                    en[1] <= 1'b1;

                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

        /* Configuração de horário */
        4'b0111:
            begin
            
                rm1 <= 4'd6;

                #1

                h1 <= rm1;

                estado <= 4'b1000;

                en[0] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end
        


        4'b1001:
            begin
                rm3 <= 4'd6;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd6;

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
                
                rm2 <= 4'd6;

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
                
                rm3 <= 4'd6;

                #1

                h3 <= rm3;

                estado <= 4'b1110;

                en[1] <= 1'b1;

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
                            r14 <= 4'd6;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd6;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd6;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd6;

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
    always @ (posedge t[7])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd7;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd7;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd7;

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
                    
                    g4 <= 4'd7;

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
            
                rm1 <= 4'd7;

                #1

                h1 <= rm1;

                estado <= 4'b1000;

                en[0] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        4'b1001:
            begin
                rm3 <= 4'd7;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd7;

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
                
                rm2 <= 4'd7;

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
                
                rm3 <= 4'd7;

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
                            r14 <= 4'd7;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd7;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd7;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd7;

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
    always @ (posedge t[8])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd8;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd8;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd8;

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
                    
                    g4 <= 4'd8;

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
            
                rm1 <= 4'd8;

                #1

                h1 <= rm1;

                estado <= 4'b1000;

                en[0] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        4'b1001:
            begin
                rm3 <= 4'd8;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd8;

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
                
                rm2 <= 4'd8;

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
                
                rm3 <= 4'd8;

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
                            r14 <= 4'd8;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd8;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd8;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd8;

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
    always @ (posedge t[9])
    begin

        case(estado)

        /* Seleção de contagem (vai andanddo de acordo com o apertar de botões) */
            4'b0000:
                begin
                    
                    g1 <= 4'd9;

                    g2 <= 4'b0000;
                    g3 <= 4'b0000;
                    g4 <= 4'b0000;

                    #1

                    h1 <= g1;
                    h2 <= g2;
                    h3 <= g3;
                    h4 <= g4;

                    estado <= 4'b0001;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end
        
            4'b0001:
                begin
                    
                    g2 <= 4'd9;

                    #1

                    h2 <= g2;

                    estado <= 4'b0010;

                    en[1] <= 1'b1;

                    /* Som do botão */    
                    som <= 1'b1;
                    #500
                    som <= 1'b0;

                end

            4'b0010:
                begin
                    
                    g3 <= 4'd9;

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
                    
                    g4 <= 4'd9;

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
            
                rm1 <= 4'd9;

                #1

                h1 <= rm1;

                estado <= 4'b1000;

                en[0] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;

            end

        4'b1001:
            begin
                rm3 <= 4'd9;

                #1

                h3 <= rm3;

                estado <= 4'b1010;

                en[2] <= 1'b1;

                som <= 1'b1;
                #500
                som <= 1'b0;
            end

        /* Configuração de receita */
        4'b1011:
            begin
                
                rm1 <= 4'd9;

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
                
                rm2 <= 4'd9;

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
                
                rm3 <= 4'd9;

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
                            r14 <= 4'd9;

                        end

                    2'b01:
                        begin
                            
                            r21 <= rm1;
                            r22 <= rm2;
                            r23 <= rm3;
                            r24 <= 4'd9;

                        end

                    2'b10:
                        begin
                            
                            r31 <= rm1;
                            r32 <= rm2;
                            r33 <= rm3;
                            r34 <= 4'd9;

                        end
                    
                    2'b11:
                        begin
                            
                            r41 <= rm1;
                            r42 <= rm2;
                            r43 <= rm3;
                            r44 <= 4'd9;

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


    /* LEDs piscando para indicar qual é o dígito sendo alterado */
    always @ (estado == 4'b0001) en[1] <= clk3;
    always @ (estado == 4'b0010) en[2] <= clk3;
    always @ (estado == 4'b0011) en[3] <= clk3;

    always @ (estado == 4'b0111) en[0] <= clk3;
    always @ (estado == 4'b1000) en[1] <= clk3;
    always @ (estado == 4'b1001) en[2] <= clk3;
    always @ (estado == 4'b1010) en[3] <= clk3;

    always @ (estado == 4'b1011) en[0] <= clk3;
    always @ (estado == 4'b1100) en[1] <= clk3;
    always @ (estado == 4'b1101) en[2] <= clk3;
    always @ (estado == 4'b1110) en[3] <= clk3;


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
            estado <= 0111;

        som <= 1'b1;
        #500
        som <= 1'b0;

    end


endmodule