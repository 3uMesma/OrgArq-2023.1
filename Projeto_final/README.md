# DEPENDÊNCIA DE DADOS EM PIPELINE: UM RECURSO EDUCACIONAL ABERTO COM IMPLEMENTAÇÃO EM JAVASCRIPT

Um Recurso Educacional Aberto (REA) está baseado nos princípios de acesso livre ao conhecimento, colaboração e compartilhamento. Nesse contexto, criamos um REA, no formato de um site, sobre dependência de dados em pipeline, contendo informações, explicações teóricas e código em JavaScript para reconhecer dependências de dados nesse contexto. O site terá como propósito fornecer um material educativo acessível, contribuindo para o aprendizado e a compreensão desse assunto específico, tanto para estudantes como para profissionais da área de Organização e Arquitetura de Computadores.

Notamos durante a nossa pesquisa que ao pesquisar no Google por “dependência de dados em pipeline”, poucos sites eram recomendados e os que eram eram materiais de universidade ou artigos científicos, enquanto que ao procurar por “Data Hazards Pipeline” muito mais sites e outras fontes de informação apareciam. Isso demonstra a falta de materiais abertos sobre o tema em português, fortalecendo a importância da nossa escolha de tema para o site.

** IMPORTANTE: ** Esse foi um trabalho em grupo que pode ser visto aqui: https://github.com/arthur-qm/SSC0902---Organiza-o-e-Arquitetura-de-Computadores-REA-. Ele foi clonado para meu github pessoal também por questão de organização. 

## Desenvolvimento
Escolhemos JavaScript para desenvolver nosso código devido a facilidade de integração com o site, dado que é uma linguagem já bastante usada no desenvolvimento web.

Nosso código vai receber como entrada um input, em formato de texto, que representaria as linhas de código de um programa em Assembly e a partir disso vai verificar se há dependências de dados. Esse código recebe como entrada linhas de código em Assembly RISC-V e sua saída retorna a(s) linha(s) em que ocorrem as dependências. Nosso código reconhece tanto dependências de dados verdadeiras (RAW) como a WAR e a WAW.

Para reconhecer quando há dependência de dados ou não, o código lê e armazena os registradores que estão sendo usados para escrita e leitura e verificase eles cumprem uma distância mínima. No caso da RAW, essa distância é de duas linhas e para a WAR e WAW é de nenhuma linha, ou seja, não há linhas entre elas. Nosso código reconhece os comandos mais utilizados em Assembly RISC-V, no caso de leitura e escrita, como: lw, sw, add, addi, mul e mv.

## Conclusão
O nosso REA fornece um recurso educacional aberto e acessível sobre dependência de dados em pipeline, contribuindo para a disseminação do conhecimento, o aprendizado e a compreensão desse tema. Esperamos que esse material possa ser útil tanto para estudantes quanto para profissionais da área de Organização e Arquitetura de Computadores, auxiliando-os no entendimento dos problemas e soluções relacionados às dependências de dados em pipeline.