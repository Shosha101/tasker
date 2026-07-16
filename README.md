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
