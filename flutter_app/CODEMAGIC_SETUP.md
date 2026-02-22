# Codemagic 自动构建配置指南

## 📋 目录

1. [简介](#简介)
2. [注册账号](#注册账号)
3. [连接 GitHub 仓库](#连接-github-仓库)
4. [配置构建](#配置构建)
5. [设置环境变量](#设置环境变量)
6. [启动首次构建](#启动首次构建)
7. [下载应用](#下载应用)
8. [自动构建](#自动构建)
9. [常见问题](#常见问题)

---

## 简介

Codemagic 是一个强大的 CI/CD 平台,可以自动构建 iOS 和 Android 应用。

**优势:**
- ✅ 完全免费 (个人项目)
- ✅ 自动化构建流程
- ✅ 支持 GitHub/GitLab/Bitbucket
- ✅ 一键发布到应用商店
- ✅ 构建速度快

---

## 注册账号

### 步骤 1: 访问 Codemagic

打开浏览器访问: https://codemagic.io/

### 步骤 2: 注册账号

1. 点击右上角 **"Log in"** 或 **"Sign up"**
2. 选择使用 **GitHub** 账号登录 (推荐)
3. 授权 Codemagic 访问你的 GitHub 仓库

---

## 连接 GitHub 仓库

### 步骤 1: 添加新应用

登录后,点击 **"Add new application"** 按钮

### 步骤 2: 选择仓库

1. 点击 **"Connect to GitHub"**
2. 在弹出窗口中找到 `sangzhexianxian/app_focus` 仓库
3. 点击 **"Select"** 选择该仓库

### 步骤 3: 确认选择

Codemagic 会自动检测到 `codemagic.yaml` 配置文件,点击 **"Next"**

---

## 配置构建

### 选择构建工作流

Codemagic 会读取 `codemagic.yaml` 文件,显示以下工作流:

1. **Android Build** - 构建 Android APK 和 App Bundle
2. **iOS Build** - 构建 iOS 应用 (需要 Mac 环境)
3. **Web Build** - 构建 Web 应用

### 配置 Android 构建

#### 1. 基本信息

```
Application name: FOCUS
Bundle identifier: com.focus.app
```

#### 2. 构建配置

- **Flutter version**: `stable` (自动选择)
- **Gradle version**: `latest` (自动选择)
- **Build type**: `Release`

#### 3. 签名配置 (可选)

如果要发布到 Google Play Store,需要配置签名:

**生成 keystore 文件:**

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**在 Codemagic 中上传 keystore:**

1. 在 "Build configuration" 中找到 "Keystore"
2. 上传 `upload-keystore.jks` 文件
3. 填写以下信息:
   - Keystore password: `你的密码`
   - Key alias: `upload`
   - Key password: `你的密码`

### 配置 iOS 构建 (可选,需要 Mac)

1. **iOS 项目配置**
   - Bundle Identifier: `com.focus.app`
   - Team ID: (需要 Apple 开发者账号)

2. **代码签名**
   - 选择 "Automatic code signing"
   - 填写 Team ID

---

## 设置环境变量

### 必需的环境变量

在 Codemagic 的 **"Environment variables"** 中添加以下变量:

#### 1. 应用信息

```bash
APP_NAME=FOCUS
BUILD_NUMBER=1
```

#### 2. GitHub Token (用于 Web 部署)

如果需要部署 Web 到 GitHub Pages:

1. 访问 GitHub Settings -> Developer settings -> Personal access tokens
2. 生成新的 token,勾选 `repo` 权限
3. 在 Codemagic 中添加环境变量:
   ```bash
   GITHUB_TOKEN=你的_github_token
   ```

#### 3. 邮件通知

```bash
CM_EMAIL=sangzhexianxian@github.com
```

---

## 启动首次构建

### 步骤 1: 开始构建

1. 确认配置无误后,点击 **"Start new build"**
2. 选择工作流 (建议先选择 **Android Build**)
3. 点击 **"Start build"**

### 步骤 2: 监控构建进度

构建过程大约需要 5-15 分钟,包括:

1. ✅ 克隆代码仓库
2. ✅ 安装 Flutter SDK
3. ✅ 安装依赖 (`flutter pub get`)
4. ✅ 代码分析 (`flutter analyze`)
5. ✅ 运行测试 (`flutter test`)
6. ✅ 构建 Android APK
7. ✅ 构建 Android App Bundle
8. ✅ 打包和上传

### 步骤 3: 查看构建日志

- 点击构建任务可以查看详细日志
- 如果构建失败,日志会显示错误信息

---

## 下载应用

### 下载 Android APK

构建成功后:

1. 在构建页面找到 **"Artifacts"** 部分
2. 点击 **"download"** 下载 `app-release.apk`
3. 将 APK 传输到 Android 手机
4. 在手机上安装并测试

### 下载 Android App Bundle

如果要发布到 Google Play:

1. 下载 `app-release.aab` 文件
2. 登录 Google Play Console
3. 上传到 "App bundles" 部分

---

## 自动构建

### 触发条件

配置完成后,以下操作会自动触发构建:

1. **推送到 main 分支**
   ```bash
   git push origin main
   ```

2. **创建 Pull Request**
   ```bash
   git checkout -b feature/new-feature
   git push origin feature/new-feature
   ```

3. **手动触发**
   - 在 Codemagic 页面点击 **"Rebuild"**

### 构建状态通知

- **邮件通知**: 构建完成后会发送邮件到 `sangzhexianxian@github.com`
- **GitHub 状态**: 在 GitHub PR 页面可以看到构建状态
- **Slack 集成**: 可选配置 Slack 通知

---

## 常见问题

### Q1: 构建失败怎么办?

**解决方案:**

1. 查看构建日志,找到错误信息
2. 常见错误:
   - 依赖冲突: 检查 `pubspec.yaml`
   - 代码错误: 运行 `flutter analyze` 检查
   - 签名错误: 检查 keystore 配置

### Q2: 如何修改构建配置?

**解决方案:**

1. 修改 `codemagic.yaml` 文件
2. 提交到 GitHub:
   ```bash
   git add codemagic.yaml
   git commit -m "Update build config"
   git push origin main
   ```
3. Codemagic 会自动使用新配置

### Q3: 如何加快构建速度?

**优化建议:**

1. 启用缓存 (Codemagic 默认启用)
2. 减少不必要的依赖
3. 跳过测试 (开发阶段):
   ```yaml
   # 在 codemagic.yaml 中注释掉测试步骤
   # - name: Run Flutter tests
   #   script: |
   #     flutter test
   ```

### Q4: iOS 构建需要什么?

**要求:**

- Apple 开发者账号 ($99/年)
- Mac 电脑 (用于配置证书)
- 有效的 Bundle Identifier

### Q5: 如何发布到应用商店?

#### Google Play:

1. 注册开发者账号 ($25)
2. 使用 Codemagic 构建 App Bundle
3. 上传到 Google Play Console
4. 填写应用信息和截图
5. 提交审核

#### App Store:

1. 注册开发者账号 ($99/年)
2. 配置证书和 Provisioning Profile
3. 使用 Codemagic 构建 IPA
4. 通过 Xcode 或 Transporter 上传
5. 在 App Store Connect 填写信息
6. 提交审核

---

## 📞 技术支持

- Codemagic 文档: https://docs.codemagic.io/
- GitHub Issues: https://github.com/codemagic-ci-cd/cli/issues
- 邮箱: support@codemagic.io

---

## 🎉 完成!

现在你的 FOCUS App 已经配置好自动构建了!

**下一步:**
1. 测试下载的 APK 文件
2. 优化应用功能
3. 准备应用商店上架材料
4. 发布到应用商店

祝你成功! 🚀
