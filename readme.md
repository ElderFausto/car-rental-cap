# 🚗 Car Rental CAP — Sistema de Locação de Veículos

Projeto full-stack corporativo de locação de veículos desenvolvido com **SAP Cloud Application Programming Model (CAP)**, interface com **SAP Fiori Elements**, persistência em banco de dados relacional e deploy no **SAP Business Technology Platform (BTP) Cloud Foundry**.

---

## 📋 Sumário
- [Tecnologias](#-tecnologias)
- [Arquitetura](#-arquitetura)
- [Estrutura de Pastas](#-estrutura-de-pastas)
- [Regras de Negócio](#-regras-de-negócio)
- [Internacionalização (i18n)](#-internacionalização-i18n)
- [Como Rodar Localmente](#-como-rodar-localmente)
- [Build e Deploy no SAP BTP](#-build-e-deploy-no-sap-btp)

---

## 🚀 Tecnologias

- **Backend:** Node.js, [SAP CAP (@sap/cds)](https://cap.cloud.sap)
- **Frontend:** SAP Fiori Elements (List Report & Object Page), SAPUI5
- **Banco de Dados:** SQLite (`@cap-js/sqlite`) com dados iniciais via CSV
- **Segurança & Autenticação:** SAP XSUAA (`@sap/xssec`, `xs-security.json`)
- **Roteamento:** SAP Approuter (`@sap/approuter`)
- **Empacotamento:** Cloud MTA Build Tool (`mbt`)
- **Plataforma de Nuvem:** SAP BTP Cloud Foundry

---

## 🏛 Arquitetura

A solução adota o padrão **Service-Centric** do ecossistema SAP:

```
[ Usuário / Navegador ]
         │
         ▼
[ SAP Approuter (Frontend) ] ── (Arquivos estáticos Fiori Elements)
         │  (Proxy reverso + OAuth2 via XSUAA)
         ▼
[ SAP CAP Service (Backend Node.js) ]
         │
         ▼
[ Banco de Dados SQLite ]
```

- **Approuter (`car-rental-cap`):** Ponto único de entrada, protege as rotas via autenticação XSUAA e serve a interface Fiori.
- **Backend Service (`car-rental-cap-srv`):** Expõe os serviços OData v4 (`/odata/v4/rental`), executa as validações e lógicas de negócio.
- **XSUAA (`car-rental-cap-auth`):** Gerencia sessões, tokens JWT e autenticação de usuários da SAP.

---

## 📁 Estrutura de Pastas

```
car-rental-cap/
├── _i18n/                    # Catálogo de mensagens e labels (pt e en)
│   ├── i18n.properties       # Idioma padrão (Inglês)
│   └── i18n_pt.properties    # Tradução em Português
├── app/                      # Aplicações Frontend
│   ├── cars/                 # App SAP Fiori Elements (Gestão de Frota)
│   │   ├── webapp/           # Component.js, manifest.json, index.html
│   │   └── annotations.cds   # Anotações visuais da Object Page
│   └── services.cds          # Ponto de entrada das anotações de UI
├── db/                       # Camada de Dados
│   ├── data/                 # Cargas iniciais (seed) em arquivos CSV
│   │   └── car.rental-Cars.csv
│   └── schema.cds            # Modelo de dados (Entidades Cars e Rentals)
├── srv/                      # Camada de Serviços
│   ├── rental-service.cds    # Definição do serviço OData v4 e anotações UI
│   └── rental-service.js     # Lógica de negócio, validações e hooks de evento
├── .deploy/                  # Configurações do SAP Approuter standalone
├── mta.yaml                  # Descritor MTA para build e deploy multi-módulo
├── xs-security.json          # Configuração de segurança e escopos do XSUAA
└── package.json              # Dependências e scripts do projeto
```

---

## ⚙️ Regras de Negócio

Implementadas no arquivo `srv/rental-service.js`:

1. **Validação de Veículo Obrigatório:** É obrigatório selecionar um veículo para registrar a locação (`CarRequired`).
2. **Disponibilidade da Frota:** Apenas veículos com status `AVAILABLE` podem ser locados (`CarNotAvailable`).
3. **Validação de Período:** A data final do aluguel deve ser estritamente posterior à data inicial (`InvalidDates`).
4. **Cálculo Automático do Total:** O valor total da locação (`totalPrice`) é calculado automaticamente multiplicando o número de diárias pela tarifa diária (`dailyRate`) do veículo selecionado.
5. **Atualização Automática de Status:** Ao confirmar a locação, o veículo tem seu status alterado automaticamente para `RENTED`.

---

## 🌐 Internacionalização (i18n)

Todas as labels de interface e mensagens de validação estão internacionalizadas:

| Chave | Inglês (`i18n.properties`) | Português (`i18n_pt.properties`) |
|---|---|---|
| `Brand` | Brand | Marca |
| `Model` | Model | Modelo |
| `DailyRate` | Daily Rate (USD) | Diária (R$) |
| `Status` | Status | Status |
| `CarNotAvailable` | The car {0} is not available... | O carro {0} não está disponível... |
| `InvalidDates` | The end date must be after... | A data final deve ser maior que... |

O SAP CAP detecta automaticamente o idioma através do cabeçalho HTTP `Accept-Language` ou do navegador do usuário.

---

## 💻 Como Rodar Localmente

### Pré-requisitos
- Node.js (v18 ou superior)
- SAP CDS Development Kit instalado globalmente:
  ```bash
  npm install -g @sap/cds-dk
  ```

### Passos
1. Clone o repositório:
   ```bash
   git clone https://github.com/ElderFausto/car-rental-cap.git
   cd car-rental-cap
   ```

2. Instale as dependências:
   ```bash
   npm install
   ```

3. Inicie o servidor com hot-reload:
   ```bash
   cds watch
   ```

4. Acesse no navegador:
   - **Página inicial do CAP:** [http://localhost:4004](http://localhost:4004)
   - **Aplicação Fiori:** [http://localhost:4004/cars/webapp/index.html](http://localhost:4004/cars/webapp/index.html)
   - **Metadados OData v4:** [http://localhost:4004/odata/v4/rental/$metadata](http://localhost:4004/odata/v4/rental/$metadata)

---

## ☁️ Build e Deploy no SAP BTP

### Pré-requisitos
- Cloud Foundry CLI (`cf`) autenticado na sua subaccount do SAP BTP
- Cloud MTA Build Tool (`mbt`)

### Comandos de Deploy
```bash
# 1. Compilar o projeto e gerar o pacote .mtar
mbt build

# 2. Realizar o deploy no Cloud Foundry
cf deploy mta_archives/car-rental-cap_1.0.0.mtar
```

---

## 👤 Autor

Desenvolvido por **Elder Fausto**  
- GitHub: [@ElderFausto](https://github.com/ElderFausto)
