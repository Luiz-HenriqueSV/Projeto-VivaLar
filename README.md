# VivaLar - Projeto Final de Desenvolvimento Mobile

VivaLar é um aplicativo mobile desenvolvido em Flutter como parte de uma atividade acadêmica de Desenvolvimento Mobile. O projeto simula uma loja virtual especializada na venda de móveis e itens para o lar, permitindo que os usuários naveguem por produtos, visualizem detalhes, adicionem itens ao carrinho e finalizem compras.

## 📋 Sobre o Projeto

Este é um projeto educacional que demonstra a aplicação de conceitos fundamentais do desenvolvimento mobile utilizando Flutter e Dart. O aplicativo fornece uma experiência completa de compra online, desde a navegação por produtos até a simulação de finalização de pedidos.

## 🎯 Objetivo

O objetivo do projeto é aplicar conceitos fundamentais do desenvolvimento mobile incluindo:

* Navegação entre telas
* Gerenciamento de estado
* Manipulação de listas e arrays
* Cálculos de valores (subtotal, impostos, frete)
* Construção de interfaces gráficas responsivas
* Validação de dados e estoque
* Armazenamento de dados em arquivos JSON

## ✨ Funcionalidades Principais

* **Listagem de Produtos**: Visualização de móveis e itens de decoração com cards informativos
* **Detalhes do Produto**: Visualização completa com especificações, preço e estoque
* **Carrinho de Compras**: Adição, remoção e alteração de quantidades de itens
* **Controle de Estoque**: Validação de disponibilidade de produtos
* **Cálculos Automáticos**: Subtotal, impostos e frete são calculados automaticamente
* **Gerenciamento de Pedidos**: Simulação de finalização de compra com confirmação
* **Sistema de Autenticação**: Login e conta de usuário

## 🛋️ Produtos Disponíveis

A loja oferece diversos móveis e itens de decoração:

* Sofás
* Mesas de jantar
* Cadeiras
* Guarda-roupas
* Estantes
* Racks para televisão
* Camas
* Escrivaninhas
* Poltronas
* Mesas de centro

## 📁 Estrutura do Projeto

```
Projeto Final - Mobile/
│
├── README.md                           # Este arquivo
│
└── VivaLar/                            # Diretório principal do aplicativo Flutter
    ├── pubspec.yaml                    # Configurações do projeto e dependências
    ├── analysis_options.yaml           # Análise de código e lint rules
    ├── README.md                       # Documentação específica do app
    │
    ├── lib/                            # Código fonte Dart/Flutter
    │   ├── main.dart                   # Arquivo principal do aplicativo
    │   ├── models/                     # Modelos de dados
    │   │   ├── app_state.dart         # Estado global da aplicação
    │   │   ├── app_theme.dart         # Temas e estilos
    │   │   └── product.dart           # Modelo de produto
    │   ├── pages/                      # Telas da aplicação
    │   │   ├── home_page.dart         # Página inicial
    │   │   ├── login_page.dart        # Página de login
    │   │   ├── account_page.dart      # Página de conta do usuário
    │   │   ├── product_detail_page.dart # Página de detalhes do produto
    │   │   ├── cart_page.dart         # Página do carrinho
    │   │   ├── checkout_page.dart     # Página de finalização
    │   │   ├── orders_page.dart       # Página de pedidos
    │   │   └── settings_page.dart     # Página de configurações
    │   └── widgets/                    # Componentes reutilizáveis
    │       └── product_card.dart      # Card de produto
    │
    ├── assets/                         # Recursos estáticos
    │   ├── products.json              # Base de dados de produtos em JSON
    │   └── images/                    # Imagens da aplicação
    │
    ├── android/                        # Código nativo Android
    ├── ios/                            # Código nativo iOS
    ├── web/                            # Código para versão web
    ├── linux/                          # Código para versão Linux
    ├── macos/                          # Código para versão macOS
    ├── windows/                        # Código para versão Windows
    ├── build/                          # Diretório de compilação (gerado)
    └── test/                           # Testes automatizados

```

### Descrição dos Diretórios Principais

**`lib/`** - Código-fonte do aplicativo
* `models/` - Define as estruturas de dados (produto, estado, tema)
* `pages/` - Todas as telas e interfaces do aplicativo
* `widgets/` - Componentes reutilizáveis para construir as interfaces

**`assets/`** - Dados e recursos
* `products.json` - Catálogo completo de produtos com preços e estoque
* `images/` - Imagens utilizadas na interface

**Plataformas** - Configurações específicas para cada sistema operacional
* `android/` - Configurações e código específico para Android
* `ios/` - Configurações e código específico para iOS
* `web/`, `linux/`, `macos/`, `windows/` - Suporte a outras plataformas

## 🔧 Tecnologias Utilizadas

* **Flutter** - Framework UI multiplataforma
* **Dart** - Linguagem de programação
* **Android Studio** - IDE de desenvolvimento
* **JSON** - Formato de armazenamento de dados

## 🚀 Como Executar

### Pré-requisitos
* Flutter SDK instalado e configurado
* Android Studio com emulador ou dispositivo conectado
* Conexão com a internet para baixar dependências

### Passos de Execução

1. **Navegue até a pasta do projeto**
   ```bash
   cd VivaLar
   ```

2. **Obtenha as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

4. **Em caso de problemas**, recrie os arquivos de plataforma:
   ```bash
   flutter create .
   flutter pub get
   flutter run
   ```

## 📌 Dados do Projeto

**Base de Dados**: O aplicativo utiliza um arquivo `assets/products.json` que contém toda a lista de produtos com:
* ID do produto
* Nome
* Preço
* Descrição
* Quantidade em estoque
* Imagem

Todos os dados são carregados em memória no início da aplicação e gerenciados através do estado global.

## 👤 Autor

* **Luiz Henrique Souza Ventura** - 3 DSA
* **Instituição**: Escola Técnica Estadual Juscelino Kubitschek de Oliveira
* **Localização**: Diadema / SP

Projeto desenvolvido para fins acadêmicos na disciplina de Desenvolvimento Mobile.
