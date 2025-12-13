| [↩️ Back](/) |
| --- |

# TECH CHALLENGE Fase 1 - Análise

## 🧩 Componentes

A aplicação é executada em um ambiente Docker, utilizando o Docker Compose para definir e inicializar os seus componentes. Esse arranjo permite que os componentes funcionem de forma integrada, com comunicação facilitada e coordenação interna simplificada pelo Docker.

Os principais componentes são:

- **Ambiente de execução:** [`Docker`][docker-file] e [`Docker Compose`][docker-compose]
    - **Aplicação geral:** [`ToogleMaster`][app-geral]
        - **Aplicação principal:** [`app.py` (_`Python 3.9`_)][app-principal]
        - **Banco de Dados:** `PostgreSQL 13`

<BR>

## 📈 Análise

> **Por que o código é considerado um "monolito"?**

O código é classificado como monolito porque a aplicação é uma unidade coesa. Todos os seus componentes estão fortemente interligados, com um único banco de dados e uma interface centralizada. Nesse modelo, as funcionalidades estão todas dentro de um único projeto, sem a separação de responsabilidades que é característica de arquiteturas mais distribuídas, como microserviços.

<BR>

### 👍 Vantagens como MVP

Com a aplicação organizada de forma monolítica, com todos os componentes integrados (*Python* + *PostgreSQL* + *Docker*), o desenvolvimento e a entrega de uma versão funcional são mais rápidos, o que permite validar a ideia no mercado rapidamente. Seguem algumas possíveis vantagens, especialmente em termos de simplicidade de desenvolvimento e operação:

- **Menor Complexidade Inicial:** Como todos os serviços estão interligados internamente via Docker, a comunicação entre os componentes é simples e não exige configuração complexa de rede. A coordenação entre os serviços é direta, sem a necessidade de orquestração entre containers ou serviços distribuídos.
- **Gerenciamento Facilitado:** O Docker facilita o gerenciamento das dependências entre os componentes, garantindo que todos os serviços necessários sejam inicializados corretamente de forma coordenada.
- **Desempenho e Comunicação Interna:** A comunicação entre os componentes da aplicação ocorre de forma rápida e sem os obstáculos de latência elevados que poderiam existir em uma arquitetura distribuída. O fato de todos os componentes estarem no mesmo ambiente facilita a troca de informações e reduz a sobrecarga de comunicação.
- **Gestão Centralizada:** Como a aplicação é um único projeto, ela pode ser gerenciada de forma centralizada, sem a necessidade de lidar com a complexidade de múltiplos sistemas interconectados.

<BR>

### 👎 Desvantagens após o MVP

Apesar das vantagens, se o MVP for bem-sucedido, a escala pode se tornar um problema. A arquitetura monolítica apresenta algumas desvantagens à medida que a aplicação cresce:

- **Escalabilidade e Manutenção Difíceis:** Com o aumento da complexidade e tamanho da aplicação, torna-se cada vez mais difícil mantê-la. A adição de novos recursos ou correção de bugs exige a reimplantação de toda a aplicação, o que pode ser demorado e arriscado, já que qualquer mudança afeta o sistema como um todo.
- **Alta Dependência entre Módulos:** A interdependência entre os módulos é alta, pois todos são inicializados conjuntamente. Isso pode dificultar a modificação ou a substituição de componentes individuais sem afetar o restante da aplicação.
- **Desenvolvimento Centralizado e Lento:** O desenvolvimento de uma aplicação monolítica é frequentemente centralizado e pode ser mais lento, já que todos os módulos devem ser desenvolvidos e testados de forma integrada. Isso impede uma abordagem mais ágil, onde diferentes partes da aplicação poderiam ser trabalhadas independentemente.

<BR>

| [⬆️ Top](#tech-challenge-fase-1---análise) |
| --- |

[app-geral]: /
[app-principal]: /app.py
[docker-file]: /Dockerfile
[docker-compose]: /docker-compose.yaml