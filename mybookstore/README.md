# MyBookstore

Aplicativo de gerenciamento de livrarias que permite o controle de estoque de livros e funcionários.

## Funcionalidades

- **Autenticação**: Login e registro de usuários
- **Criação de Loja**: Cadastro e configuração de novas livrarias
- **Gerenciamento de Funcionários**: Cadastro, edição, visualização e remoção de funcionários
- **Gerenciamento de Livros**: Cadastro, edição, visualização e remoção de livros no estoque
- **Dashboard**: Visualização rápida do estoque e métricas importantes

## Configuração de Ambiente

### Pré-requisitos

- Flutter (versão 3.0.0 ou superior)
- Dart (versão 2.17.0 ou superior)
- Firebase CLI (para configuração de ambientes)

### Variáveis de Ambiente

O projeto utiliza diferentes ambientes de desenvolvimento. Para configurar:

1. Crie um arquivo `.env.dev.json` para ambiente de desenvolvimento
2. Crie um arquivo `.env.staging.json` para ambiente de homologação
3. Crie um arquivo `.env.prod.json` para ambiente de produção

Exemplo de arquivo `.env.json`:

```
API_URL=https://api.mybookstore.com
```

## Estrutura do Projeto

```
lib/
  ├── core/                    # Código essencial da aplicação
  │    ├── entities/           # Entidades de domínio
  │    └── errors/             # Tratamento de erros centralizado
  ├── features/                # Módulos de funcionalidades
  │    ├── books/              # Gestão de livros
  │    ├── employees/          # Gestão de funcionários
  │    ├── home/               # Dashboard principal
  │    └── login/              # Autenticação e registro
  ├── shared/                  # Código compartilhado entre módulos
  │    ├── controllers/        # Controllers compartilhados
  │    ├── di/                 # Injeção de dependências
  │    ├── drivers/            # Drivers de acesso a recursos externos
  │    ├── navigation/         # Navegação do app
  │    └── utils/              # Utilidades gerais
  ├── app.dart                 # Componente principal do app
  └── main.dart                # Ponto de entrada da aplicação
```

## Gerando Builds

### Android

#### Build de Homologação
```bash
flutter build apk ---dart-define-from-file=envs/homolog.json
```

#### Build de Produção
```bash
flutter build apk ---dart-define-from-file=envs/prod.json
```

### iOS


#### Build de Homologação
```bash
flutter build ipa ---dart-define-from-file=envs/homolog.json
```

#### Build de Produção
```bash
flutter build ipa ---dart-define-from-file=envs/prod.json
```

## Publicação

### Android
1. Gere a build de produção
2. Acesse o Google Play Console
3. Envie o APK/AAB para a track desejada (internal, alpha, beta, production)

### iOS
1. Gere a build de produção
2. Abra o Xcode e configure o certificado de distribuição
3. Archive e envie para o App Store Connect
4. Configure o TestFlight ou publique diretamente na App Store

## Arquitetura

O projeto segue uma arquitetura modular baseada em features, utilizando:

- **BLoC** para gerenciamento de estado
- **Repository Pattern** para acesso a dados
- **Clean Architecture** para separação de responsabilidades
- **Injeção de Dependências** para desacoplamento de componentes

## Contribuição

1. Clone o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Faça commit das alterações (`git commit -m 'Adiciona nova funcionalidade'`)
4. Envie para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request
