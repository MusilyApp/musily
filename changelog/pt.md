## 5.0.0

**Novos Recursos**

- Interface refinada e mais consistente, com melhorias gerais na organização visual e navegação.
- UI/UX melhorada no desktop: melhor comportamento com janelas, mouse e uso geral do PC.
- Adicionado Timer de Sono.
- Biblioteca Local: você pode agora adicionar pastas do seu dispositivo à sua biblioteca.
Nota: A biblioteca local e a biblioteca Musily são gerenciadas separadamente para garantir a integridade dos dados.
- Fila persistente: sua fila de reprodução é preservada mesmo após reiniciar o aplicativo.
- Modo offline: o aplicativo agora detecta automaticamente quando não há conexão com a internet e muda para o modo offline.
- Gerenciador de Atualizações: você pode agora atualizar o aplicativo ou baixar outras versões diretamente de dentro do aplicativo.

**Melhorias**
**Backup**

- Backup e restauração agora funcionam completamente em segundo plano sem congelar o aplicativo — mesmo com um grande número de downloads ativos.
- Backups multiplataforma agora são mais estáveis e confiáveis.
**Downloads**

- Sistema de download otimizado com múltiplas conexões simultâneas, controle dinâmico de velocidade e reconexões mais confiáveis.
- Velocidades de download significativamente mais rápidas — até 50× mais rápidas dependendo da conexão.
- Múltiplos downloads simultâneos sem congelar o aplicativo.

**Interface**

- A cor de destaque do aplicativo agora muda automaticamente com base na faixa atualmente em reprodução
(Este comportamento pode ser alterado nas configurações.)
- Mensagens de feedback revisadas para maior clareza.
**Recomendações**

- Algoritmo de recomendação aprimorado, fornecendo sugestões mais relevantes.
- Sugestões de música mostradas na tela inicial com base no seu perfil de audição.
**Playlists e Biblioteca**

- Playlists agora mostram o tempo total de reprodução.
- Faixas mais antigas sem duração armazenada agora têm sua duração atualizada automaticamente quando reproduzidas.

**Player – Correções de Estabilidade**

- Vários problemas críticos foram resolvidos:
- Corrigidos problemas de concorrência que causavam o congelamento do aplicativo ao alternar rapidamente entre faixas.
- Modo repetir-um agora funciona corretamente.
- Corrigido um problema que impedia a reprodução de retomar após longos períodos de inatividade.
- O player agora move corretamente para a próxima faixa no final da reprodução em dispositivos onde anteriormente parava inesperadamente.
- Corrigido um bug que impedia os usuários de reordenar a fila.
- Ao reproduzir uma faixa de um álbum ou playlist já em reprodução, no modo aleatório, uma faixa aleatória incorreta era às vezes selecionada — agora corrigido.
- Modo aleatório poderia desestabilizar o aplicativo — isso foi totalmente resolvido.

**Letras**

- Faixas sem letras sincronizadas agora exibem tempo alinhado com o temporizador de reprodução.
- Para algumas faixas sem timestamps, a sincronização automática de letras é gerada.

**Correções Gerais**

- Windows: o botão de download agora muda corretamente para "Concluído" quando o download termina.
- Várias melhorias de estabilidade e desempenho em todo o aplicativo.

**Interface e Localização**

- Adicionado suporte para 13 novos idiomas: Francês, Alemão, Italiano, Japonês, Chinês, Coreano, Hindi, Indonésio, Turco, Árabe, Polonês e Tailandês.

## 4.0.4

**Correções**

- Corrigido um problema onde os usuários não conseguiam carregar streams de música.
- Resolvido um problema que impedia o Musily de abrir no Linux.

## 4.0.3

**Correções**

- Corrigido um problema onde os usuários não conseguiam carregar streams de música.

## 4.0.2

**Correções**

- Corrigido um problema onde o título da janela não atualizava quando a música mudava.
- Resolvidos problemas regionais adicionando `CurlService`

**Recursos**

- Novo: Rola automaticamente para o início da fila quando a música muda.

## 4.0.1

**Correções**

- Resolvido um problema onde a Fila Inteligente não podia ser desabilitada quando vazia.
- Corrigido a Fila Inteligente não funcionando quando apenas um item está presente na fila.

**Melhorias**

- Reescreveu completamente o sistema de reprodução de áudio para melhor desempenho e estabilidade.

**Desktop**

- Melhorada a resolução do ícone do Windows.
- Adicionado um tamanho mínimo de janela para melhorar o gerenciamento de janelas.

## 4.0.0

**Recursos**

- Introduzido suporte a letras sincronizadas, permitindo que as letras sincronizem com a reprodução.
- Implementada detecção de cor de destaque: cor de destaque do sistema no desktop e cor de destaque da papel de parede no Android.
- Adicionado suporte a desktop, permitindo downloads e uso no Linux e Windows.
- Implementada API nativa de tela de inicialização do Android 12+ para uma experiência de inicialização mais rápida e suave.
- Melhorado o gerenciamento de fila com ordenação intuitiva de músicas: próximas músicas aparecem primeiro seguidas por faixas anteriores.
- Adicionadas animações suaves de transição de faixas na seção de reprodução atual.
- Adicionado *atualizador no aplicativo*, permitindo que os usuários atualizem o aplicativo diretamente sem sair dele (apenas Android e Desktop).

**Correções**

- Corrigido um problema onde o aplicativo fechava após importar uma playlist do YouTube.
- Resolvido um problema onde o aplicativo travava após restaurar um backup da biblioteca.

## 3.1.1

**Melhorias**

- Fila Mágica: Corrigida e completamente redesenhada para uma experiência mais suave e inteligente.

## 3.1.0

**Recursos**

- Adicionada a capacidade de importar playlists do YouTube para sua biblioteca.

**Melhorias**

- Melhorado o backup da biblioteca.
- Outras melhorias na interface.

**Correções**

- Corrigidas inconsistências na biblioteca.
- Resolvido um problema onde os álbuns não eram adicionados a playlists ou à fila pelo menu.

## 3.0.0

**Recursos**

- Backup da Biblioteca: Introduzida funcionalidade para operações de backup perfeitas.
- Salvar Música em Downloads: Adicionada a capacidade de salvar música diretamente na pasta de downloads.

**Melhorias**

- Interface Aprimorada: Melhorada a interface do usuário para uma experiência mais intuitiva e visualmente atraente.
- Downloads Mais Rápidos: Otimizadas as velocidades de download para transferências de arquivos mais rápidas e eficientes.

**Correções**

- Problemas da Barra de Navegação: Resolvidos bugs que afetavam telefones com barras de navegação em vez de navegação baseada em gestos.

## 2.1.2

**Correções Rápidas**

- Corrigido um problema onde a música carregava infinitamente (novamente).

## 2.1.1

**Correções Rápidas**

- Corrigido um problema onde a música carregava infinitamente.
- Corrigido um bug onde o miniplayer sobrepunha o último item da biblioteca.

**Melhorias Menores**

- A mensagem de biblioteca vazia agora é exibida corretamente.

## 2.1.0

**Correções**

- Resolvido um problema onde certos termos de pesquisa resultavam em resultados de pesquisa vazios.
- Resolvido um problema onde alguns artistas não podiam ser encontrados.
- Corrigido um problema onde alguns álbuns não estavam sendo encontrados.
- Resolvido um bug onde playlists baixadas eram excluídas quando o botão de download era pressionado.

**Localização**

- Adicionado suporte ao idioma ucraniano.

**Melhorias**

- Melhorada a funcionalidade Fila Mágica para descobrir melhor faixas relacionadas.

**Recursos**

- Introduzida uma nova tela de configurações para gerenciar preferências de idioma e alternar entre temas escuro e claro.

**Melhorias Menores**

- Várias melhorias e refinamentos menores.

## 2.0.0

**Recursos**

- Gerenciador de Downloads: Introduzido um novo gerenciador de downloads para melhor controle e rastreamento de arquivos.
- Filtros da Biblioteca: Aplique filtros à sua biblioteca para organização mais fácil.
- Pesquisa em Playlists e Álbuns: Adicionada a capacidade de pesquisar dentro de playlists e álbuns para navegação mais precisa.

**Localização**

- Suporte a Idiomas Melhorado: Adicionadas novas entradas de tradução para localização melhorada.
- Adicionado Suporte ao Espanhol: Suporte completo ao idioma espanhol foi adicionado.

**Melhorias**

- Otimização do Modo Offline: Melhorado o desempenho no modo offline, proporcionando uma experiência mais suave e eficiente.
- Carregamento Mais Rápido da Biblioteca: A biblioteca agora carrega mais rápido, reduzindo os tempos de espera ao navegar pela sua música e conteúdo.
- Estabilidade Aumentada do Player: Melhorada a estabilidade do player.

**Mudança Incompatível**

- Incompatibilidade do Gerenciador de Downloads: O novo gerenciador de downloads não é compatível com a versão anterior. Como resultado, toda a música baixada precisará ser baixada novamente.

## 1.2.0

- **Recurso**: Opção para desabilitar sincronização de letras
- **Recurso**: Fila Mágica - Descubra nova música com recomendações automáticas adicionadas à sua playlist atual.
- **Localização:** Adicionado suporte ao idioma russo
- **Desempenho:** Otimizações na seção Biblioteca

## 1.1.0

### Novos Recursos

- **Novo Recurso:** Letras
- **Suporte Multi-idioma:** Inglês e Português

### Correções

- **Corrigido:** Carregamento infinito ao adicionar a primeira música favorita

### Melhorias

- **Melhorias de Desempenho:** Otimizações em Listas
- **Novas Animações de Carregamento**
- **Melhorias em Favoritos**
- **Melhorias no Player**

## 1.0.1

- Corrigido: Tela inicial cinza
- Corrigido: Obter diretório do arquivo de áudio
- Corrigido: Cores da barra de navegação no modo claro
- Corrigido: Travamentos quando o usuário tenta reproduzir uma música

## 1.0.0

- Versão inicial.

