%%

%standalone    
%class Scanner 
%line         
%column        
%type void     
%unicode

%{
    private String numero, titulo, dataPublicacao, resumo, reivindicacoes;
    private StringBuilder buffer = new StringBuilder();


    private void exibirResultado() {
        System.out.println("Número"  + numero);
        System.out.println("Título"  + titulo);
        System.out.println("Data de Pubicação"  + dataPublicacao);
        System.out.println("Resumo"  + resumo);
        System.out.println("Reivindicações"  + reivindicacoes);
    }

    private String limpar(String texto) {
        return texto.replaceAll("<[^>]+>", "").trim();
    }
%}

%%
    <!-- Ignorar qualquer coisa fora das tags relevantes -->
[^<]+               { /* ignora texto irrelevante */}
<[^>]+>             { /* ignora tags não reconhecidas */}

"<span class=\"numero\">"                { buffer.setLength(0); }
"</span>"                                { numero = limpar(buffer.toString()); }

"<h1 class=\titulo\">"                   { buffer.setLength(0); }
"</h1>"                                  { titulo = limpar(buffer.toString()); }

"<time class=\data-publicacao\">"        { buffer.setLength(0); }
"</time>"                                { dataPublicacao = limpar(buffer.toString()); }

"<section class=\resumo\">"              { buffer.setLength(0); }
"</section>"                             { 
                                            if ( resumo == null)
                                                resumo = limpar(buffer.toString());
                                            else
                                                reivindicacoes = limpar (buffer.toString());
                                            }


[^<]+ {buffer.append(yytext()); }


<<EOF>> { 
    exibirResultado();
    return;
}
    

/*
