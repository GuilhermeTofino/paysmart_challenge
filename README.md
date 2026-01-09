# 🎬 CinePaySmart - Desafio Flutter

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?style=flat&logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green)
![Testing](https://img.shields.io/badge/Tests-Unit%20%26%20Widget-orange)

Uma aplicação Flutter robusta para listagem de filmes, desenvolvida como parte do desafio técnico. O projeto consome a API do **The Movie Database (TMDb)** para exibir lançamentos, detalhes e permitir buscas, seguindo rigorosos padrões de arquitetura e qualidade de código.

---

## 📱 Funcionalidades

* **Listagem de Lançamentos:** Exibe os filmes "Upcoming" diretamente da API.
* **Scroll Infinito (Paginação):** Carregamento automático de mais filmes ao rolar a lista.
* **Busca em Tempo Real:** Pesquisa de filmes por título integrada na AppBar.
* **Indicador Visual de Nota:** Componente personalizado (`RatingCircle`) que muda de cor (Verde/Amarelo/Vermelho) conforme a avaliação do filme.
* **Detalhes do Filme:** Tela rica com imagem de capa (backdrop), sinopse, data de lançamento e nota.
* **Tratamento de Erros:** Feedback visual amigável para falhas de internet ou erros de servidor.
* **Cache de Imagens:** Otimização de dados e performance visual.

---

## 🛠 Tecnologias e Dependências

* **Linguagem:** Dart
* **Framework:** Flutter
* **Gerência de Estado:** Nativa (`ChangeNotifier` + `ListenableBuilder`).
    * *Decisão:* Optei por não usar libs externas (como Bloc ou GetX) para demonstrar domínio dos fundamentos do Flutter e manter o projeto leve.
* **API Client:** `http`
* **Imagens:** `cached_network_image`
* **Formatação:** `intl` (Datas em pt-BR)
* **Testes:** `flutter_test`, `mockito`

---

## 🏗 Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)** com princípios de **Clean Architecture**, garantindo separação de responsabilidades e testabilidade.

### Estrutura de Pastas
```bash
lib/
├── core/            # Configurações globais (Constantes, Exceções)
├── models/          # Modelos de dados (JSON Parsing)
├── services/        # Camada de Dados (Repository, ApiClient)
├── viewmodels/      # Gerência de Estado e Regras de Negócio
└── views/           # Camada de UI (Telas e Widgets)
    ├── screens/
    └── widgets/
