# Tank War 🎮

基于 Flutter + Flame 引擎开发的经典坦克大战游戏。

## 功能特性

- 经典坦克大战玩法
- 基于 Flame 2D 游戏引擎
- 支持多平台：iOS、Android、Web、Windows、macOS、Linux

## 技术栈

- **框架**: Flutter
- **游戏引擎**: Flame ^1.23.0
- **音频**: flame_audio ^2.10.0
- **本地存储**: shared_preferences ^2.2.0

## 快速开始

```bash
# 安装依赖
flutter pub get

# 运行游戏
flutter run
```

## 构建

```bash
# Web
flutter build web

# Android
flutter build apk

# iOS
flutter build ios
```

## 项目结构

```
lib/
├── main.dart          # 应用入口
├── game/              # 游戏逻辑
├── components/        # 游戏组件
└── screens/           # 界面
```
