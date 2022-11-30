# Simulação utilizando o software Questa

Em um projeto criado no Questa, na aba Project, com o botão direito é possível adicionar
arquivos existentes em Add to Project -> Existing file... e assim pode-se
adicionar os códigos em Verilog do repositório para simulá-los.

Então é necessário compilar todos os arquivos e, para isso, clica-se com o
botão direito e encontra a opção Compile -> Compile All na aba Project

Para executar o arquivo compilado é necessário alterar para a aba Library e lá expandir
a aba work (provavelmente a primeira que aparece) e lá encontrar o arquivo testbench, clicar
nele com o botão direito e selecionar Simulate with full Optimization.

Chegando na aba de simulação, pode-se analizar a variações dos sinais com uma Wave.
Para vê-la clica-se com o botão direito e seleciona a opção Add Wave. Para ver as alterações de sinais
é necessário selecionar quais objetos você deseja ver na Wave. Para isso arraste os objetos da aba de objetos para a aba Wave.

Os objetos de entrada são:
conf: botão de configuração
t[0 até 11]: Os 10 primeiros são os botões dos números de 0 a 9 do teclado e o t[ 10 ] é o 
botão de início e o t[ 11 ] é o botão cancela
r[0 até 3]: São os 4 botões de receita do projeto
porta: É o sinal vindo do sensor responsável por detectar se a porta está aberta ou fechada, sendo aberta o nível lógico alto

Os objetos de saída são:
led[1 até 4]: São as saídas de 7 bits para um led com 7 segmentos, indicando um número visual
num[1 até 4]: São os números indicados na saída convertidos para fornecer uma melhor visualização
para quem simula




