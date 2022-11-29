/*****************************************************************************************/
/**																						**/
/** 	Conversor4bits0a9.v																**/
/** 	Descrição: Operações combinatórias que convertem bits em numeros visuais		**/
/**		em um display LED de 7 segmentos.												**/
/**																						**/
/*****************************************************************************************/

module Conversor4bits0a9(ain, bin, cin, din, en,
                         aout, bout, cout, dout, eout, fout, gout);

    
    /* Entradas e saídas */
    input wire ain, bin, cin, din, en;
    output wire aout, bout, cout, dout, eout, fout, gout;

    /* Lógica combinatória */
    assign  aout = (ain | cin | (bin ~^ din)) & en,
            bout = ((~bin) | (cin ~^ din)) & en,
            cout = ((~cin) | din | bin) & en,
            dout = (ain | ((~bin) & (~din)) | ((~bin) & cin) |
             (bin & (~cin) & din) | (cin & (~din)) ) & en, 
            eout = (((~bin) & (~din)) | (cin & (~din))) & en,
            fout = (((~cin) & (~din)) | (bin & (~din)) | (bin & (~cin)) | ain) & en,
            gout = (ain | (bin ^ cin) | (cin & (~din))) & en;   

    
endmodule