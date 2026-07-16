# Tasker — Task Scheduling App

A lightweight **Flutter** task manager with offline persistence.

## Features

- ✅ Create, complete, and delete tasks
- 🔎 Live search across your task list
- 💾 Offline storage with **Hive** (code-generated type adapters)
- 🎨 Custom theming + splash screen

## Stack

**Provider** for state management, **get_it** for service location, a dedicated `HiveService` and navigation service.

```
lib/
├── model/       # task model (+ generated Hive adapter)
├── provider/    # task state
├── screens/     # splash, task list
├── services/    # hive, navigation
└── widget/      # todo item, search field
```

## Run it

```bash
flutter pub get
flutter run
```

## 📦 Packages

| Package | Version |
|---|---|
| `provider` | ^6.1.2 |
| `get_it` | ^8.0.2 |
| `hive_flutter` | ^1.1.0 |
| `path_provider` | ^2.1.5 |
| `logger` | ^1.0.0 |
| `cupertino_icons` | ^1.0.8 |

