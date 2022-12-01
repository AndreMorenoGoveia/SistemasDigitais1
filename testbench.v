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
    reg [3:0] num1;
    wire [6:0] led2;
    reg [3:0] num2;
    wire [6:0] led3;
    reg [3:0] num3;
    wire [6:0] led4;
    reg [3:0] num4;
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

/* Valores iniciais das entradas */
initial
    begin
    
    auxt <= 12'b000000000000;
    auxc <= 1'b0;
    auxr <= 4'b0000;
    auxp <= 1'b0;

    end


/* Transformando a saída de 7 segmentos em números */
always @ (*)
    begin

        /* led1 */
        if(led1 == 7'b0111111)
            num1 = 4'd0;
        else if(led1 == 7'b0000110)
            num1 = 4'd1;
        else if(led1 == 7'b1011011)
            num1 = 4'd2;
        else if(led1 == 7'b1001111)
            num1 = 4'd3;
        else if(led1 == 7'b1100110)
            num1 = 4'd4;
        else if(led1 == 7'b1101101)
            num1 = 4'd5;
        else if(led1 == 7'b1111101)
            num1 = 4'd6;
        else if(led1 == 7'b0000111)
            num1 = 4'd7;
        else if(led1 == 7'b1111111)
            num1 = 4'd8;
        else if(led1 == 7'b1101111)
            num1 = 4'd9;
        else num1 = 4'd15;

        /* led2 */
        if(led2 == 7'b0111111)
            num2 = 4'd0;
        else if(led2 == 7'b0000110)
            num2 = 4'd1;
        else if(led2 == 7'b1011011)
            num2 = 4'd2;
        else if(led2 == 7'b1001111)
            num2 = 4'd3;
        else if(led2 == 7'b1100110)
            num2 = 4'd4;
        else if(led2 == 7'b1101101)
            num2 = 4'd5;
        else if(led2 == 7'b1111101)
            num2 = 4'd6;
        else if(led2== 7'b0000111)
            num2 = 4'd7;
        else if(led2 == 7'b1111111)
            num2 = 4'd8;
        else if(led2 == 7'b1101111)
            num2 = 4'd9;
        else num2 = 4'd15;


        /* led3 */
        if(led3 == 7'b0111111)
            num3 = 4'd0;
        else if(led3 == 7'b0000110)
            num3 = 4'd1;
        else if(led3 == 7'b1011011)
            num3 = 4'd2;
        else if(led3 == 7'b1001111)
            num3 = 4'd3;
        else if(led3 == 7'b1100110)
            num3 = 4'd4;
        else if(led3 == 7'b1101101)
            num3 = 4'd5;
        else if(led3 == 7'b1111101)
            num3 = 4'd6;
        else if(led3 == 7'b0000111)
            num3 = 4'd7;
        else if(led3 == 7'b1111111)
            num3 = 4'd8;
        else if(led3 == 7'b1101111)
            num3 = 4'd9;
        else num3 = 4'd15;
        

        /* led4 */
        if(led4 == 7'b0111111)
            num4 = 4'd0;
        else if(led4 == 7'b0000110)
            num4 = 4'd1;
        else if(led4 == 7'b1011011)
            num4 = 4'd2;
        else if(led4 == 7'b1001111)
            num4 = 4'd3;
        else if(led4 == 7'b1100110)
            num4 = 4'd4;
        else if(led4 == 7'b1101101)
            num4 = 4'd5;
        else if(led4 == 7'b1111101)
            num4 = 4'd6;
        else if(led4 == 7'b0000111)
            num4 = 4'd7;
        else if(led4 == 7'b1111111)
            num4 = 4'd8;
        else if(led4 == 7'b1101111)
            num4 = 4'd9;
        else num4 = 4'd15;

    end


    /* Simulação de eventos */
    initial
        begin
            
            #100

            /* Aquecimento da comida por 1:25 minutos */
            /* Apertando o botão 5 */
            auxt[5] = 1'b1;
            #100
            auxt[5] = 1'b0;
            #100

            /* Apertando o botão 2 */
            auxt[2] = 1'b1;
            #100
            auxt[2] = 1'b0;
            #100

            /* Apertando o botão 1 */
            auxt[1] = 1'b1;
            #100
            auxt[1] = 1'b0;
            #100

            /* Apertando o botão início */
            auxt[10] = 1'b1;
            #100
            auxt[10] = 1'b0;
            #100

            /* Esperando o tempo para a comida ficar pronta */
            #145000

            /* Aquecimento da comida por 14:76 minutos mas cancelando */
            /* Apertando o botão 6 */
            auxt[6] = 1'b1;
            #100
            auxt[6] = 1'b0;
            #100

            /* Apertando o botão 7 */
            auxt[7] = 1'b1;
            #100
            auxt[7] = 1'b0;
            #100

            /* Apertando o botão 4 */
            auxt[4] = 1'b1;
            #100
            auxt[4] = 1'b0;
            #100

            /* Apertando o botão 1 */
            auxt[1] = 1'b1;
            #100
            auxt[1] = 1'b0;
            #100

            /* Apertando o botão início */
            auxt[10] = 1'b1;
            #100
            auxt[10] = 1'b0;
            #100

            /* Esperando 30s para cancelar */
            #30000

            /* Apertando o botão cancela */
            auxt[11] = 1'b1;
            #100
            auxt[11] = 1'b0;
            #100

            #1000

            /* Retornando ao aquecimento */
            /* Apertando o botão início */
            auxt[10] = 1'b1;
            #100
            auxt[10] = 1'b0;
            #100

            #30000

            /* Cancelando novamente */
            auxt[11] = 1'b1;
            #100
            auxt[11] = 1'b0;
            #100

            /* Cancelando por definitivo */
            auxt[11] = 1'b1;
            #100
            auxt[11] = 1'b0;
            #100

            #1000


            /* Alterando o horário marcado atual para 08:16 */
            /* Apertando o botão de configuração */
            auxc = 1'b1;
            #100
            auxc = 1'b0;
            #100

            /* Apertando o botão 6 */
            auxt[6] = 1'b1;
            #100
            auxt[6] = 1'b0;
            #100

            /* Apertando o botão 1 */
            auxt[1] = 1'b1;
            #100
            auxt[1] = 1'b0;
            #100

            /* Apertando o botão 8 */
            auxt[8] = 1'b1;
            #100
            auxt[8] = 1'b0;
            #100

            /* Apertando o botão 0 */
            auxt[0] = 1'b1;
            #100
            auxt[0] = 1'b0;
            #100


            #30000

            /* Configurando uma receita para 3:49 */
            /* Apertando o botão de configuração */
            auxc = 1'b1;
            #100
            auxc = 1'b0;
            #100

            /* Apertando um botão de receita */
            auxr[2] = 1'b1;
            #100
            auxr[2] = 1'b0;
            #100

            /* Apertando o botão 9 */
            auxt[9] = 1'b1;
            #100
            auxt[9] = 1'b0;
            #100

            /* Apertando o botão 4 */
            auxt[4] = 1'b1;
            #100
            auxt[4] = 1'b0;
            #100

            /* Apertando o botão 3 */
            auxt[3] = 1'b1;
            #100
            auxt[3] = 1'b0;
            #100

            /* Apertando o botão 0 */
            auxt[0] = 1'b1;
            #100
            auxt[0] = 1'b0;
            #100


            #30000


            /* Utilizando a receita armazenada */
            /* Apertando o botão de receita */
            auxr[2] = 1'b1;
            #100
            auxr[2] = 1'b0;
            #100

            /* Apertando o botão de início */
            auxt[10] = 1'b1;
            #100
            auxt[10] = 1'b0;
            #100
            
            /* Esperando ficar pronto */
            #300000

            /* Deixando o relógio padrão rodar por 25 horas */
            #90000000

            /* Encerra a simulação */
            $stop;

        end

endmodule