%%

%standalone    // Habilitar a execução independente (sem JCup).
%class Scanner // Nome da classe gerada.
%line          // Habilita rastreamento da linha atual.
%column        // Habilita rastreamento da coluna atual.
%type void     // Especifica o tipo de retorno do yylex().

%{
    // Variável para armazenar o comentário (StringBuilder melhora o desempenho):
    private StringBuilder comentario = new StringBuilder();

    // Método auxiliar para imprimir o comentário:
    private void imprimirComentario(String texto, int linha, int coluna) {
        System.out.println("Comentário (linha: " + linha + ", coluna: " + coluna + "): " + texto.trim());
    }
%}

// Nome personalizado do estado:
%states LINHA_COMENTARIO 

%%

<YYINITIAL> {
    "//" {
        yybegin(LINHA_COMENTARIO);  // Entra no estado de comentário.
        comentario.setLength(0);    // Limpa o buffer.
    }

    [^] { /* Ignorar qualquer caracter fora de comentários. */ }
}

<LINHA_COMENTARIO> {
    \n {
        yybegin(YYINITIAL);  // Retorna ao estado inicial.
        imprimirComentario(comentario.toString(), yyline, yycolumn);
        comentario.setLength(0);    // Limpa o buffer.
    }

    [^\n]+ { comentario.append(yytext()); }  // Acumula conteúdo do comentário (captura tudo até a quebra de linha).
}


<<EOF>> { // Garantir que, se o último comentário não terminar com \n, ele ainda será impresso antes de sair.
    // Se o arquivo terminar enquanto estamos no comentário:
    if (comentario.length() > 0) {
        imprimirComentario(comentario.toString(), yyline, yycolumn);
        comentario.setLength(0);    // Limpa o buffer.
    }
    System.out.println("Fim do arquivo!");

    return; //Termina a execução.
}

/*
