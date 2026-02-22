# FOCUS App 本地开发指南

## 📋 目录

1. [环境准备](#环境准备)
2. [安装 Flutter SDK](#安装-flutter-sdk)
3. [配置开发工具](#配置开发工具)
4. [安装依赖](#安装依赖)
5. [运行应用](#运行应用)
6. [调试技巧](#调试技巧)
7. [常见问题](#常见问题)

---

## 环境准备

### 必要工具

| 工具 | 版本要求 | 用途 |
|------|---------|------|
| Flutter SDK | >= 3.0.0 | 跨平台应用开发 |
| Dart SDK | >= 3.0.0 | Flutter 编程语言 |
| VS Code 或 Android Studio | 最新版 | 代码编辑器 |
| Git | 最新版 | 版本控制 |

### 操作系统支持

- ✅ **Windows** 10 或更高版本
- ✅ **macOS** 10.14 或更高版本
- ✅ **Linux** (Ubuntu, Debian 等)

---

## 安装 Flutter SDK

### Windows 安装步骤

#### 1. 下载 Flutter SDK

访问 Flutter 官网下载页面:

https://docs.flutter.dev/get-started/install/windows

下载最新的 Flutter SDK 稳定版。

#### 2. 解压安装包

1. 将下载的 zip 文件解压到你想要安装的位置
2. 推荐路径: `C:\flutter`
3. **注意**: 不要安装在需要管理员权限的目录

#### 3. 添加环境变量

1. 右键点击 "此电脑" -> 属性
2. 点击 "高级系统设置"
3. 点击 "环境变量"
4. 在 "系统变量" 中找到 `Path`,点击编辑
5. 添加 Flutter 的 bin 目录:
   ```
   C:\flutter\bin
   ```
6. 点击确定保存

#### 4. 验证安装

打开新的 PowerShell 或 CMD 窗口,运行:

```powershell
flutter --version
```

应该看到类似输出:

```
Flutter 3.16.0 • channel stable
Dart 3.2.0
```

### macOS 安装步骤

#### 1. 下载 Flutter SDK

访问: https://docs.flutter.dev/get-started/install/macos

下载最新的 Flutter SDK 稳定版。

#### 2. 解压到指定目录

```bash
cd ~/development
unzip ~/Downloads/flutter_macos_3.16.0-stable.zip
```

#### 3. 添加到 PATH

编辑 `~/.zshrc` 或 `~/.bash_profile`:

```bash
export PATH="$PATH:$HOME/development/flutter/bin"
```

保存后运行:

```bash
source ~/.zshrc
```

#### 4. 验证安装

```bash
flutter --version
```

---

## 配置开发工具

### 选项 1: VS Code (推荐,轻量级)

#### 1. 安装 VS Code

下载并安装: https://code.visualstudio.com/

#### 2. 安装 Flutter 扩展

1. 打开 VS Code
2. 点击左侧扩展图标 (或按 `Ctrl+Shift+X`)
3. 搜索并安装:
   - **Flutter** (官方扩展)
   - **Dart** (代码高亮和智能提示)

#### 3. 配置设置

在 VS Code 设置中添加:

```json
{
  "dart.flutterSdkPath": "C:\\flutter",
  "flutter.enableEmbeddedDevTools": true
}
```

### 选项 2: Android Studio (推荐,功能全)

#### 1. 下载并安装 Android Studio

下载: https://developer.android.com/studio

#### 2. 安装 Flutter 插件

1. 打开 Android Studio
2. File -> Settings -> Plugins
3. 搜索并安装:
   - **Flutter**
   - **Dart**

#### 3. 重启 Android Studio

---

## 安装依赖

### 1. 克隆项目

```bash
git clone https://github.com/sangzhexianxian/app_focus.git
cd app_focus/flutter_app
```

或者如果你已经在项目目录:

```bash
cd d:\ai_projects\xcx_focus\flutter_app
```

### 2. 安装项目依赖

```bash
flutter pub get
```

如果遇到网络问题,可以使用国内镜像:

```bash
# Windows
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
flutter pub get

# macOS/Linux
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter pub get
```

### 3. 检查依赖

```bash
flutter doctor
```

应该看到类似输出:

```
[✓] Flutter (Channel stable, 3.16.0)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[!] Android Studio (version 2023.1)
    ✗ Android Studio not found
[✓] VS Code (version 1.85)
[✓] Connected device
```

---

## 运行应用

### 方法 1: 使用 VS Code (推荐)

#### 1. 打开项目

```bash
code d:\ai_projects\xcx_focus\flutter_app
```

#### 2. 选择运行设备

- 点击 VS Code 右下角的状态栏
- 选择设备:
  - **Chrome** (Web 调试)
  - **Android Emulator** (Android 模拟器)
  - **Physical Device** (连接的 Android 手机)

#### 3. 运行应用

- 按 `F5` 或
- 点击 **Run and Debug** 按钮
- 或在终端运行: `flutter run`

#### 4. 热重载

修改代码后,按:
- `Ctrl+S` (Windows) 或 `Cmd+S` (Mac) - 热重载
- `Shift+R` - 热重启
- `R` - 完全重启

### 方法 2: 使用 Android Studio

#### 1. 打开项目

1. 打开 Android Studio
2. File -> Open
3. 选择 `flutter_app` 目录

#### 2. 选择设备

点击顶部工具栏的设备下拉菜单,选择设备。

#### 3. 运行应用

- 点击绿色三角形 **Run** 按钮
- 或按 `Shift+F10`

### 方法 3: 使用命令行

#### 运行在 Chrome (Web)

```bash
flutter run -d chrome
```

#### 运行在 Android 模拟器

```bash
flutter run -d android
```

#### 运行在 iOS 模拟器 (仅 Mac)

```bash
flutter run -d ios
```

#### 运行在桌面

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

#### 查看可用设备

```bash
flutter devices
```

---

## 调试技巧

### 1. 使用 DevTools

Flutter 提供强大的 DevTools 调试工具:

#### 启动 DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

#### DevTools 功能

- **Widget Inspector** - 查看和修改 Widget 树
- **Performance** - 性能分析
- **Memory** - 内存使用情况
- **Network** - 网络请求监控
- **Logging** - 查看日志

### 2. 断点调试

#### 在 VS Code 中:

1. 在代码行号左侧点击,设置断点
2. 按 `F9` 或点击 **Start Debugging**
3. 应用运行到断点时会暂停
4. 可以查看变量值、单步执行等

#### 调试快捷键

| 快捷键 | 功能 |
|--------|------|
| `F5` | 开始调试 |
| `F9` | 切换断点 |
| `F10` | 单步跳过 |
| `F11` | 单步进入 |
| `Shift+F11` | 单步跳出 |
| `Shift+F5` | 停止调试 |

### 3. 打印日志

#### 使用 `print()` 函数

```dart
print('目标数量: ${goalProvider.allGoals.length}');
print('当前步骤: ${goalProvider.currentStep}');
```

#### 使用 `debugPrint()` 函数 (更安全)

```dart
debugPrint('调试信息: ${data}');
```

### 4. 查看控制台日志

#### VS Code

- 打开 **Output** 面板
- 选择 **Flutter** 或 **Dart** 频道

#### Android Studio

- 打开 **Run** 窗口
- 查看日志输出

### 5. 性能分析

```bash
flutter run --profile
```

然后打开 DevTools 查看性能数据。

---

## 常见问题

### Q1: `flutter doctor` 报错 "Android SDK not found"

**解决方案:**

1. 安装 Android Studio
2. 在 Android Studio 中安装 Android SDK
3. 设置环境变量 `ANDROID_HOME`:

```bash
# Windows
setx ANDROID_HOME "C:\Users\你的用户名\AppData\Local\Android\Sdk"

# macOS/Linux
export ANDROID_HOME=$HOME/Library/Android/sdk
```

### Q2: 模拟器启动失败

**解决方案:**

1. 打开 Android Studio
2. Tools -> AVD Manager
3. 创建新的虚拟设备
4. 确保至少有一个 AVD 可以使用

### Q3: 热重载不工作

**解决方案:**

1. 尝试热重启 (按 `Shift+R`)
2. 如果还不行,完全重启应用 (按 `R`)
3. 最后,完全停止并重新运行应用

### Q4: 依赖下载失败

**解决方案:**

使用国内镜像:

```bash
# Windows
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

# macOS/Linux
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

### Q5: 应用在真机上无法运行

**解决方案:**

1. Android:
   - 开启开发者选项
   - 允许 USB 调试
   - 安装驱动程序

2. iOS:
   - 确保设备信任开发者证书
   - Xcode 签名配置正确

### Q6: 代码修改后界面没有变化

**解决方案:**

1. 检查是否触发热重载
2. 尝试热重启
3. 检查代码语法错误
4. 查看控制台是否有错误信息

---

## 🚀 快速开始命令

### 完整的本地启动流程

```bash
# 1. 进入项目目录
cd d:\ai_projects\xcx_focus\flutter_app

# 2. 安装依赖
flutter pub get

# 3. 检查环境
flutter doctor

# 4. 查看可用设备
flutter devices

# 5. 运行应用 (选择一个)
flutter run -d chrome      # 浏览器
flutter run -d android     # Android 模拟器
flutter run -d windows     # Windows 桌面
```

### 常用开发命令

```bash
# 清理构建缓存
flutter clean

# 重新安装依赖
flutter pub get

# 运行测试
flutter test

# 代码分析
flutter analyze

# 格式化代码
flutter format .

# 构建发布版本
flutter build apk --release
flutter build ios --release
flutter build web --release
```

---

## 📱 在真机上调试

### Android 真机调试

#### 1. 开启开发者选项

1. 进入手机设置
2. 关于手机 -> 连续点击 "版本号" 7 次
3. 返回设置,找到"开发者选项"

#### 2. 允许 USB 调试

1. 开发者选项 -> USB 调试
2. 开启"允许 USB 调试"

#### 3. 连接电脑

1. 使用 USB 线连接手机和电脑
2. 手机上选择"文件传输"模式
3. 允许电脑访问手机

#### 4. 运行应用

```bash
flutter run
```

### iOS 真机调试 (需要 Mac)

#### 1. 连接设备

使用 USB 线连接 iOS 设备。

#### 2. 信任开发者证书

1. 在 iOS 设备上打开"设置"
2. 通用 -> VPN与设备管理
3. 信任开发者证书

#### 3. 运行应用

```bash
flutter run
```

---

## 🔧 推荐的开发工作流

1. **启动应用**
   ```bash
   flutter run -d chrome
   ```

2. **修改代码**
   - 在 VS Code 中编辑代码
   - 按 `Ctrl+S` 保存,自动热重载

3. **测试功能**
   - 在应用中测试修改的功能
   - 检查控制台日志

4. **修复问题**
   - 使用断点调试
   - 查看 DevTools

5. **提交代码**
   ```bash
   git add .
   git commit -m "Add new feature"
   git push origin main
   ```

---

## 📞 需要帮助?

- Flutter 官方文档: https://docs.flutter.dev/
- Flutter 中文网: https://flutter.cn/
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- GitHub Issues: https://github.com/sangzhexianxian/app_focus/issues

---

## 🎉 开始开发吧!

现在你已经准备好在本地开发和调试 FOCUS App 了!

**快速开始:**

```bash
cd d:\ai_projects\xcx_focus\flutter_app
flutter pub get
flutter run -d chrome
```

祝你开发愉快! 🚀
