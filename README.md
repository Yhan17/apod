# Aplicativo NASA APOD em Flutter


Bem-vindo ao **Aplicativo NASA APOD em Flutter**, uma aplicação móvel que exibe a Imagem Astronômica do Dia (APOD) fornecida pela NASA. Este aplicativo busca dados da API APOD da NASA, apresentando a imagem ou vídeo do dia juntamente com informações relevantes como título, descrição e data. Além disso, inclui funcionalidades adicionais como localização, modo escuro, widget para a tela inicial no Android e muito mais.

## Índice

- [Recursos](#recursos)
- [Diagramas](#diagramas)
- [Capturas de Tela](#capturas-de-tela)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Instalação](#instalação)
- [Uso](#uso)
- [Testes](#testes)
- [Pipeline de CI/CD](#pipeline-de-cicd)
- [Contribuição](#contribuição)
- [Licença](#licença)

## Recursos

### Funcionalidades Principais

- **Imagem Astronômica do Dia**: Exibe a APOD da NASA, que pode ser uma imagem ou um vídeo.
- **Informações Detalhadas**: Mostra o título, data e descrição da APOD.
- **Navegação por Datas**: Permite que os usuários selecionem uma data específica para visualizar a APOD desse dia utilizando um DatePicker.
- **Manipulação de Mídia**:
  - **Imagens**: Suporta funcionalidades de zoom e scroll.
  - **Vídeos**: Integra um player de vídeo para reprodução direta no aplicativo.
- **Favoritos**: Usuários podem salvar suas APODs favoritas localmente e visualizá-las em uma tela dedicada.

### Funcionalidades Adicionais

- **Localização**:
  - Tradução do texto da API e da interface do aplicativo para o idioma selecionado.
  - Atualmente suporta **Português (pt-BR)**, com a possibilidade de adicionar mais idiomas facilmente.
- **Suporte a Temas**:
  - Implementa **Modo Claro** e **Modo Escuro** para uma melhor experiência do usuário.
- **Design Responsivo**:
  - Otimizado para smartphones e tablets.
- **Widget para Tela Inicial (Android)**:
  - Permite que os usuários adicionem um widget à tela inicial exibindo a APOD.
- **Gerenciamento de Estado**:
  - Utiliza uma solução personalizada com `ChangeNotifier` para simplicidade e eficiência.
- **Controle de Carregamento**:
  - Implementa `InheritedNotifier` para gerenciar estados de carregamento em todos os widgets.
- **Desempenho Otimizado**:
  - Cache de imagens utilizando `cached_network_image` para reduzir o consumo de dados e melhorar os tempos de carregamento.
- **Rotas Personalizadas**:
  - Implementação de rotas próprias com o mínimo de dependências de terceiros.
- **Testes Unitários**:
  - Inclui testes unitários para funcionalidades críticas.

### Melhorias Planejadas

- **Gerenciamento de Estado Avançado**:
  - Implementar `InheritedWidget` para um melhor controle de estado localizado dentro dos widgets sem reconstruir a árvore principal.
- **Cache de Vídeos**:
  - Melhorar a reprodução de vídeos adicionando mecanismos de cache.
- **Localização Expandida**:
  - Adicionar suporte para mais idiomas além do português.

## Diagramas
 
### Diagramas de arquitetura e pastas
![Diagramas de arquitetura e pastas](/docs/diagrama_pastas.png)

### Gerencia de estado com loading
![Gerencia de estado com loading](/docs/state_manager_with_loading.png)

### Fluxo favoritar um APOD
![Fluxo favoritar um APOD](/docs/favorite_apod_flow.png)


## Capturas de Tela

### Vídeo Apresentação

https://github.com/user-attachments/assets/0e87333f-b369-43c2-add5-67fb20bd0a40


### Tela Inicial (Tablet) - Tema Claro e Escuro
![Tela Inicial (Tablet) - Imagem Tema Claro](/docs/inicial_claro.png) ![Tela Inicial (Tablet) - Imagem Tema Escuro](/docs/inicial_escuro.png)

### Tela Inicial (Phone) - Tema Claro e Escuro
![Tela Inicial (Phone) - Imagem Tema Claro](/docs/inicial_phone_claro.png) ![Tela Inicial (Phone) - Imagem Tema Escuro](/docs/inicial_phone_escuro.png)

### Tela de Listagem Favoritos (Tablet) - Tema Claro e Escuro
![Tela de Listagem Favoritos (Tablet) - Tema Claro e Escuro](/docs/favoritos_list_claro.png) ![Tela de Listagem Favoritos (Tablet) - Tema Claro e Escuro](/docs/favoritos_list_escuro.png)

### Tela de Listagem Favoritos (Phone) - Tema Claro e Escuro
![Tela de Listagem Favoritos (Phone) - Tema Claro e Escuro](/docs/favoritos_list_phone_claro.png) ![Tela de Listagem Favoritos (Phone) - Tema Claro e Escuro](/docs/favoritos_list_phone_escuro.png)


### Tela de Detalhes Favoritos (Phone) - Tema Claro e Escuro
![Tela de Detalhes Favoritos (Phone) - Tema Claro e Escuro](/docs/favoritos_detalhes_phone_claro.png) ![Tela de Detalhes Favoritos (Phone) - Tema Claro e Escuro](/docs/favoritos_detalhes_phone_escuro.png)

### Tela de Detalhes Favoritos (Tablet) - Tema Claro e Escuro
![Tela de Detalhes Favoritos (Tablet) - Tema Claro e Escuro](/docs/favoritos_detalhes_claro.png) ![Tela de Detalhes Favoritos (Tablet) - Tema Claro e Escuro](/docs/favoritos_detalhes_escuro.png)

### Seletor de Data
![Seletor de Data](/docs/seletor_data.png)

### Widget Android
![Widget Android](/docs/widget_android.png)

## Tecnologias Utilizadas

- **Framework**: [Flutter](https://flutter.dev/)
- **Linguagem**: Dart
- **Gerenciamento de Estado**: `ChangeNotifier` personalizado
- **API**: NASA APOD API
- **Armazenamento Local**: `shared_preferences` ou `hive`
- **Localização**: Framework de localização do Flutter
- **Cache de Imagens**: `cached_network_image`
- **Testes**: Testes unitários

## Estrutura do Projeto

```
app
├── core
│   ├── components
│   ├── config
│   ├── entities
│   ├── environment
│   ├── extensions
│   ├── http
│   │   └── failures
│   ├── l10n
│   ├── mixins
│   ├── routes
│   ├── templates
│   │   └── notifiers
│   ├── theme
│   ├── types
│   ├── utils
│   └── widgets
└── modules
    ├── favorites_details
    │   ├── data
    │   │   ├── datasources
    │   │   ├── repositories
    │   │   └── services
    │   ├── domain
    │   │   ├── repositories
    │   │   ├── services
    │   │   └── usecases
    │   └── presentation
    │       ├── pages
    │       ├── viewmodel
    │       └── widgets
    ├── favorites_list
    │   ├── data
    │   │   ├── datasources
    │   │   └── repositories
    │   ├── domain
    │   │   ├── repositories
    │   │   └── usecases
    │   └── presentation
    │       ├── pages
    │       ├── viewmodel
    │       └── widgets
    └── home
        ├── data
        │   ├── datasources
        │   ├── repositories
        │   └── services
        ├── domain
        │   ├── repositories
        │   ├── services
        │   └── usecases
        └── presentation
            ├── common
            ├── page
            ├── viewmodel
            └── widgets
```

## Instalação

### Pré-requisitos

- **Flutter SDK**: Certifique-se de ter a versão **3.27.2** do Flutter instalada. [Guia de Instalação](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Certifique-se de ter a versão **3.6.1** do Dart SDK instalada. [Guia de Instalação](https://dart.dev/get-dart)
- **Chave de API da NASA**: Registre-se e obtenha uma chave de API no [Portal de APIs da NASA](https://api.nasa.gov/).

### Passos

1. **Clone o Repositório**

   ```bash
   git clone https://github.com/Yhan17/apod.git
   cd nasa_apod_flutter_app
   ```

2. **Instale as Dependências**

   ```bash
   flutter pub get
   ```

3. **Configure a Chave da API**

   - Crie um arquivo `development.env` na raiz do diretório.
   - Adicione sua chave de API da NASA:

     ```
     BASE_URL=api_base_da_nasa
     API_KEY=sua_chave_api_aqui
     ```

4. **Execute o Aplicativo**

   ```bash
   flutter run --dart-define-from-file development.env
   ```

## Uso

- **Tela Inicial**: Exibe a Imagem ou Vídeo Astronômico do Dia juntamente com seu título, descrição e data.
- **Seleção de Data**: Toque no seletor de data para escolher uma data diferente e visualizar a APOD correspondente.
- **Favoritos**: Toque no ícone de favorito para salvar uma APOD nos seus favoritos. Acesse seus favoritos na tela dedicada.
- **Localização**: O aplicativo está disponível atualmente em Português (pt-BR). Para adicionar mais idiomas, estenda os arquivos de localização.
- **Alternância de Tema**: Alterne entre os modos claro e escuro nas configurações ou diretamente no aplicativo.
- **Widget Android**: Adicione o widget APOD à tela inicial do seu dispositivo Android para acesso rápido.

## Testes

O projeto inclui testes unitários para funcionalidades críticas.

### Executando os Testes

```bash
flutter test
```

## Pipeline de CI/CD

Este projeto utiliza **GitHub Actions** para integração contínua e entrega contínua (CI/CD). A pipeline foi configurada para garantir a qualidade do código e facilitar a distribuição do aplicativo.

### Ferramentas Utilizadas

- **Very Good Ventures**: Utilizado para cobertura de testes, garantindo que o aplicativo mantenha um alto padrão de qualidade.
- **GitHub Actions**: Automatiza o processo de build, testes e distribuição do APK.

### Funcionalidades da Pipeline

- **Cobertura de Testes**: Utiliza o Very Good Ventures para medir e reportar a cobertura dos testes, assegurando que as funcionalidades críticas estejam bem testadas.
- **Build Automatizado**: Sempre que há um push ou pull request no repositório, o GitHub Actions realiza o build do aplicativo automaticamente.
- **Distribuição de APK**: O APK gerado pelo build é armazenado como um artifact nas ações do GitHub, permitindo que seja facilmente baixado e testado.

### Como Acessar o APK

Após a execução bem-sucedida da pipeline, o APK estará disponível para download nos artifacts das **GitHub Actions**. Siga os passos abaixo:

1. Acesse a aba **Actions** no repositório do GitHub.
2. Selecione o workflow mais recente.
3. Navegue até a seção de artifacts e baixe o APK gerado.

### Ênfase nas Escolhas Técnicas

- **Minimalismo nas Bibliotecas**: O projeto foi desenvolvido utilizando o mínimo possível de bibliotecas de terceiros, reduzindo a complexidade e facilitando a manutenção.
- **Gerenciamento de Estado e Rotas Proprietárias**: Implementações próprias para gerenciamento de estado e rotas foram desenvolvidas para atender às necessidades específicas do projeto, garantindo maior controle e flexibilidade.

## Contribuição

Contribuições são bem-vindas! Siga os passos abaixo:

1. **Fork o Repositório**
2. **Crie uma Branch de Funcionalidade**

   ```bash
   git checkout -b feature/SuaFuncionalidade
   ```

3. **Comite suas Alterações**

   ```bash
   git commit -m "Adiciona SuaFuncionalidade"
   ```

4. **Envie para a Branch**

   ```bash
   git push origin feature/SuaFuncionalidade
   ```

5. **Abra um Pull Request**

## Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).

---

Para quaisquer dúvidas ou feedback, sinta-se à vontade para entrar em contato comigo através do [yhannunesleal@gmail.com](mailto:yhannunesleal@gmail.com).
