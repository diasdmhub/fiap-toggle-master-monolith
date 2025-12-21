| [↩️ Back](/) |
| --- |

# TECH CHALLENGE Fase 1 - Implementação

## Resumo

Para implementar a aplicação ToggleMaster em um ambiente "MVP", o "monolito" proposto no [repositório original](/) é adequado e rápido. A aplicação é executada em um ambiente Docker com um arranjo que permite que os componentes funcionem de forma integrada, com comunicação facilitada e coordenação interna simplificada.

À medida que a aplicação cresce, descentralizar os componentes se torna vantajoso. Nesse contexto, a [aplicação principal](/analise/) pode ser executada em um ambiente AWS, utilizando instâncias EC2. Portanto, foi elaborado um script para facilitar a inicialização da aplicação nesse ambiente. Ele valida os requisitos básicos da instância e prepara o ambiente Python para a execução da aplicação. Também é criado um serviço no SystemD para facilitar o gerenciamento da aplicação. Com o ambiente preparado, a aplicação é inicializada e fica pronta para uso.

<BR>

### Requerimentos

- Instância EC2 com empacotamento **RPM** (_Amazon Linux, RHEL, etc_)
- A instância EC2 deve alcançar a instância de banco-de-dados (_RDS, security groups_)
- Pacotes necessários:
    - `git`
    - `python3`
    - `phton3-pip`

<BR>

### Preparação prévia

1. Crie e acesse o diretório de trabalho da aplicação (_default: `/opt/togglemaster`_)
    > - `mkdir /opt/togglemaster`
    > - `cd /opt/togglemaster`

2. Clone o repositório da aplicação dentro do diretório de trabalho
    > - `git clone https://github.com/diasdmhub/fiap-toggle-master-monolith.git`

3. Copie e execute o script como root

<BR>

### [↗️ Script Download](./env_setup.sh)

<BR>

| [⬆️ Top](#tech-challenge-fase-1---implementação) |
| --- |