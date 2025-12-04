| [↩️ Back](/) |
| --- |

# TECH CHALLENGE - 12-Factor App

**Em relação à [metodologia de 12 fatores][12factor] para microserviços, a aplicação ToogleMaster possui as características abaixo.**

<BR>

## ✅ Repositório de código (_Codebase_)

A aplicação está hospedada em um [**sistema de repositório de código centralizado**][codebase] (*codebase*) com controle de versões, o GitHub.

## ✅ Dependências (_Dependencies_)

O repositório possui um manifesto explícito de dependências da aplicação: o [**arquivo `requirements.txt`**][requirements]. Por se tratar de uma aplicação Python, é possível utilizar ferramentas como o *Pip* e o *Virtualenv* para gerenciar as dependências e isolá-las respectivamente.

## ⚠️ Configuração (_Config_)

A [**aplicação principal (`app.py`)**][app-principal] utiliza configurações externas ao código-fonte, separadas como variáveis de ambiente por meio do Docker Compose. Entretanto, essas variáveis são definidas como valores constantes em texto claro, o que as torna suscetíveis a riscos de segurança, e estão no mesmo conjunto de códigos do repositório da aplicação. Seria recomendável criar um arquivo dedicado às variáveis de ambiente que não fosse rastreado no repositório da aplicação para evitar o comprometimento de dados sensíveis.

## ⚠️ Serviços de apoio (_Backing services_)

A aplicação possui uma base de dados PostgreSQL unificada em seu conjunto de código de implementação principal do Docker, o [**`docker-compose.yaml`**][docker-compose]. Esse conjunto torna o acoplamento do recurso menos flexível, pois a base de dados precisa ser implementada em conjunto com o script Python principal. Assim, pode haver dificuldade de modificação ou a substituição de recursos individuais. Uma implementação mais flexível e aderente à metodologia dos 12 fatores utiliza recursos ou serviços de apoio gerenciados de forma independente, de modo que a aplicação principal não faça distinção entre recursos locais ou externos.

## ⚠️ Compilação, entrega, execução (_Build, release, run_)

A compilação do código da aplicação é feita pelo Docker e pode ser iniciada a cada atualização do código pelos desenvolvedores. Em contraste, a entrega da aplicação é automatizada pelo Docker Compose, que a torna pronta para execução e também a inicia em um ambiente isolado. Esses estágios são relativamente distintos ao se utilizar o Docker. Além disso, ele também permite gerenciar a separação de entregas compiladas (_releases_) e possibilita a restauração a releases anteriores, se necessário. No entanto, são necessários ajustes para que as releases da aplicação sejam versionadas corretamente. O próprio GitHub oferece ferramentas para esse fim.

## ✅ Processos (_Processes_)

A aplicação principal (`app.py`) é executada como um processo único dentro do ambiente de execução do Docker. Esse processo não possui estado permanente para os dados, que são armazenados diretamente no serviço de banco de dados agregado, o _PostgreSQL_.

## ✅ Associação de porta (_Port binding_)

O _Web framework_ Flask é implementado na aplicação principal ao importar a sua própria biblioteca no código-fonte (_`from flask`_) e por meio da declaração de dependências  (_`requirements.txt`_) do projeto. Esse _framework_ permite a associação de portas HTTP à aplicação, sem a necessidade de inserir um servidor Web ao ambiente de execução. Neste contexto, o Docker Compose é utilizado para declarar as portas associadas, e o Docker atua como uma camada de roteamento entre o ambiente de execução da aplicação e o ambiente externo. Esse contexto de associação de portas também permite que a aplicação se torne um serviço de apoio para outras aplicações.

## ⚠️ Concorrência (_Concurrency_)

Como se trata de um conjunto fechado, a aplicação é executada em um contêiner gerenciado pelo Docker, que interage com o sistema operacional, e o isola como um todo. Esse gerenciador organiza fluxos de saída, atua na recuperação de processos e interage com o usuário. Desse modo, a concorrência é gerenciada pelo Docker, sem a necessidade de arquivos `.pid` ou _daemons_. No entanto, a aplicação também utiliza um banco de dados PostgreSQL integrado ao contêiner da aplicação principal, o que dificulta a distribuição de carga e a consistência dos dados.

Apesar de o Docker oferecer opções que permitem a escalada de cargas de trabalho (_como o Swarm_), a aplicação não está preparada para tal finalidade. Para particionar a aplicação em processos concorrentes, é possível separá-la de seu banco de dados e manter a aplicação principal em um contêiner que utilize ferramentas de orquestração por carga de trabalho, como o Kubernetes.

## ✅ Descarte (_Disposability_)

É possível implementar e encerrar a aplicação de forma relativamente rápida por meio do Docker, pois ele agiliza o início e o término do processo de maneira adequada. Isso auxilia no dimensionamento rápido e elástico da aplicação conforme a demanda. Além disso, implicitamente esse processo torna as operações da aplicação principal idempotentes.

## ✅ Paridade de desenv/prod (_Dev/prod parity_)

O repositório do ToggleMaster permite a atualização do código de maneira integrada entre os desenvolvedores, prevenindo conflitos. Nesse modelo, a aplicação pode seguir o fluxo de teste, implementação e compilação do código em um período relativamente curto, realizado pelos próprios desenvolvedores. Além disso, o mesmo repositório pode conter ramificações dedicadas a ambientes similares de desenvolvimento e produção.

Com o uso do Docker, a aplicação está preparada para a segmentação dos ambientes de desenvolvimento e produção, pois pode haver paridade entre eles. O ambiente local é leve para o desenvolvimento e se assemelha ao ambiente de produção. Adicionalmente, o provisionamento declarativo do Docker auxilia na implementação do mesmo tipo e versão dos serviços de apoio.

> Como MVP, a aplicação está preparada para a paridade de ambientes. No entanto, ressalto que não há fluxo de implementação ativo no repositório.

## ⚠️ Logs

A aplicação exporta mensagens diretamente para o fluxo de saída padrão (`stdout`) do ambiente de execução. Ela não armazena nem gerencia arquivos de log, pois delega essa atividade ao gerenciador do ambiente, o Docker. Este se encarrega de oferecer a visibilidade dos registros e do comportamento da aplicação.

Embora existam registros da inicialização, não há registros dos eventos da aplicação principal, o que inviabiliza a heurística dela.

## ✅ Processos administrativos (_Admin processes_)

O ambiente do Docker permite interagir com a aplicação para atividades administrativas. Adicionalmente, como a aplicação principal utiliza o Python, é possível acessar uma _shell_ interativa dentro do contêiner. Isso possibilita que os desenvolvedores adminstrem os processos por meio da execução de scripts ou partes do código. Contudo, é importante destacar que não há mecanismos administrativos definidos para este MVP.

<BR>

#### Legenda:

✅ Aderente à metodologia 12-Factor

⚠️ Requer melhorias ou ajustes para atender à metodologia 12-Factor

| [⬆️ Top](#tech-challenge---análise) |
| --- |

[12factor]: https://12factor.net/
[codebase]: /
[requirements]: /requirements.txt
[app-principal]: /app.py
[docker-compose]: /docker-compose.yaml