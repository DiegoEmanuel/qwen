# 🍽️ Controle de Jejum - Aplicativo Flutter

Um aplicativo fantástico e cross-platform para controle de jejum intermitente, desenvolvido em Flutter.

## ✨ Funcionalidades

- **Timer de Jejum em Tempo Real**: Acompanhe o tempo decorrido e restante do seu jejum
- **Múltiplas Durações**: Escolha entre 12h, 14h, 16h, 18h, 20h ou 24h de jejum
- **Histórico Completo**: Visualize todas as suas sessões completadas
- **Estatísticas**: Acompanhe seu progresso com cards informativos
- **Configurações Personalizáveis**:
  - Duração padrão do jejum
  - Notificações
  - Tema (Claro/Escuro/Sistema)
- **Persistência de Dados**: Seus dados são salvos localmente no dispositivo
- **Interface Moderna**: Design Material 3 com suporte a tema escuro

## 📱 Plataformas Suportadas

- Android
- iOS
- Web
- Desktop (Windows, macOS, Linux)

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK 3.0 ou superior
- Dart SDK 3.0 ou superior

### Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd fasting_app
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## 🧪 Testes

Execute os testes unitários:

```bash
flutter test
```

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada do aplicativo
├── models/
│   ├── fasting_session.dart  # Modelo de sessão de jejum
│   └── user_settings.dart    # Modelo de configurações do usuário
├── providers/
│   └── fasting_provider.dart # Gerenciamento de estado com Provider
├── screens/
│   ├── home_screen.dart      # Tela principal
│   └── settings_screen.dart  # Tela de configurações
├── services/
│   └── storage_service.dart  # Serviço de persistência de dados
└── widgets/
    ├── fasting_timer.dart    # Widget do timer
    ├── stats_card.dart       # Card de estatísticas
    └── fasting_history.dart  # Lista de histórico

test/
├── fasting_session_test.dart # Testes do modelo FastingSession
└── user_settings_test.dart   # Testes do modelo UserSettings
```

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework UI cross-platform
- **Provider** - Gerenciamento de estado
- **SharedPreferences** - Armazenamento local
- **intl** - Internacionalização e formatação de datas

## 📸 Screenshots

O aplicativo possui:
- Tela inicial com timer circular animado
- Cards de estatísticas (horas totais, sessões completas)
- Histórico de sessões recentes
- Tela de configurações completa

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer um fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commitar suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abrir um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

## 👨‍💻 Desenvolvedor

Desenvolvido com ❤️ usando Flutter

---

**Nota**: Este aplicativo é apenas para fins informativos. Consulte sempre um profissional de saúde antes de iniciar qualquer tipo de jejum.
