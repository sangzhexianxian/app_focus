# FOCUS App - 极简目标管理应用

一个帮助用户通过减法思维找到最重要事情的 Flutter 跨平台应用。

## 📱 功能特性

### 核心功能
- ✅ **5步目标筛选流程**: 输入→选5个→选3个→分配权重→生成专注卡
- ✅ **多种挑战模式**: 一天1件/3件、一周3件、一月3件、年度3件、一生1件
- ✅ **专注卡生成**: 自动生成精美的手机壁纸,方便随时查看
- ✅ **积分系统**: 签到、完成任务、分享获得积分
- ✅ **成就系统**: 解锁各种成就,激励持续专注
- ✅ **等级系统**: 从专注新手到专注传奇,不断成长

### 数据存储
- 🔄 **本地存储**: 使用 Hive 和 SharedPreferences
- ☁️ **云端同步**: 集成 Supabase,支持多设备同步
- 👤 **用户系统**: 支持邮箱登录注册,也支持游客模式

### 跨平台支持
- 📱 iOS
- 🤖 Android
- 🌐 Web
- 💻 Desktop (通过 Flutter Desktop)

## 🚀 快速开始

### 前置要求
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / Xcode (用于构建原生应用)

### 安装依赖

```bash
cd flutter_app
flutter pub get
```

### 运行应用

```bash
# 运行在 Android 模拟器或设备
flutter run

# 运行在 iOS 模拟器 (需要 Mac)
flutter run -d ios

# 运行在浏览器
flutter run -d chrome

# 运行在桌面
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## 📦 构建发布版本

### Android APK

```bash
flutter build apk --release
```

生成的 APK 文件在 `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (用于 Google Play)

```bash
flutter build appbundle --release
```

生成的文件在 `build/app/outputs/bundle/release/app-release.aab`

### iOS IPA (需要 Mac)

```bash
flutter build ios --release
```

然后使用 Xcode 打包并上传到 App Store

### Web

```bash
flutter build web --release
```

生成的文件在 `build/web/` 目录

## ☁️ 在线构建 (Codemagic)

本项目已配置 Codemagic 自动构建,无需本地环境:

### 设置步骤

1. **注册 Codemagic 账号**
   - 访问 https://codemagic.io/
   - 使用 GitHub/GitLab/Bitbucket 账号登录

2. **连接代码仓库**
   - 点击 "Add application"
   - 选择你的代码仓库 (GitHub)
   - 选择 `flutter_app` 目录

3. **配置构建**
   - Codemagic 会自动检测到 `codemagic.yaml` 配置文件
   - 配置构建类型 (iOS/Android/Web)

4. **开始构建**
   - 点击 "Start new build"
   - 等待构建完成,下载生成的 APK/IPA 文件

5. **自动构建**
   - 以后每次 push 代码到 `main` 分支
   - Codemagic 会自动触发构建
   - 构建完成后通过邮件或 Slack 通知

### 环境变量

在 Codemagic 中设置以下环境变量:

```bash
APP_NAME=FOCUS
BUILD_NUMBER=1
GITHUB_TOKEN=your_github_token
```

## 📁 项目结构

```
flutter_app/
├── lib/
│   ├── main.dart                 # 应用入口
│   ├── models/                   # 数据模型
│   │   └── goal.dart            # Goal、User、Points 模型
│   ├── providers/                # 状态管理
│   │   ├── goal_provider.dart   # 目标管理
│   │   ├── user_provider.dart   # 用户管理
│   │   └── points_provider.dart # 积分管理
│   ├── screens/                  # 页面
│   │   ├── splash_screen.dart   # 启动页
│   │   ├── home_screen.dart     # 首页
│   │   └── steps/               # 步骤页面
│   │       ├── step1_screen.dart
│   │       ├── step2_screen.dart
│   │       ├── step3_screen.dart
│   │       ├── step4_screen.dart
│   │       └── step5_screen.dart
│   └── widgets/                 # 通用组件
├── assets/                       # 资源文件
│   ├── images/
│   └── icons/
├── pubspec.yaml                  # 依赖配置
├── codemagic.yaml               # Codemagic 构建配置
└── README.md                    # 项目说明
```

## 🔧 配置说明

### Supabase 配置

在 `lib/main.dart` 中修改 Supabase 配置:

```dart
await Supabase.initialize(
  url: 'your-supabase-url',
  anonKey: 'your-supabase-anon-key',
);
```

### 应用图标

替换 `assets/icons/` 中的应用图标

### 启动画面

修改 `lib/screens/splash_screen.dart` 中的启动画面

## 📱 上架应用商店

### Google Play

1. 注册 Google Play 开发者账号 ($25)
2. 创建应用并填写应用信息
3. 上传 App Bundle (`.aab` 文件)
4. 填写商店列表信息
5. 提交审核

### App Store

1. 注册 Apple 开发者账号 ($99/年)
2. 在 App Store Connect 创建应用
3. 使用 Xcode 上传 IPA 文件
4. 填写应用信息和截图
5. 提交审核

### 国内应用商店

- 腾讯应用宝
- 华为应用市场
- 小米应用商店
- OPPO 应用商店
- vivo 应用商店

## 🎨 UI 设计

- 主色调: `#667eea` (紫色)
- 辅助色: `#764ba2` (深紫色)
- 强调色: `#f39c12` (橙色)
- 成功色: `#28a745` (绿色)
- 错误色: `#dc3545` (红色)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request!

## 📄 许可证

MIT License

## 📞 联系方式

- 邮箱: your-email@example.com
- GitHub: https://github.com/yourusername/focus-app

---

**FOCUS - 只做最重要的事** 🎯
