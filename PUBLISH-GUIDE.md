# 🚀 SSH Tool v1.0.0 - 发布指南

## 当前状态

⚠️ **Flutter 未安装** - 需要先安装 Flutter SDK 才能构建 APK

---

## 方案一：安装 Flutter 后发布（推荐）

### 1. 安装 Flutter

#### macOS
```bash
# 下载 Flutter
git clone https://github.com/flutter/flutter.git -b stable ~/flutter

# 添加到 PATH
export PATH="$PATH:$HOME/flutter/bin"

# 验证安装
flutter doctor
```

#### Linux
```bash
# 下载 Flutter
git clone https://github.com/flutter/flutter.git -b stable ~/flutter

# 添加到 PATH
export PATH="$PATH:$HOME/flutter/bin"

# 安装依赖
sudo apt-get install curl git unzip xz-utils zip libglu1-mesa

# 验证安装
flutter doctor
```

#### Windows
1. 下载: https://flutter.dev/docs/get-started/install/windows
2. 解压到 `C:\flutter`
3. 添加到环境变量 PATH
4. 运行 `flutter doctor`

### 2. 运行发布脚本

```bash
# 自动化发布脚本
./release.sh
```

这个脚本会：
- ✅ 检查 Flutter 环境
- ✅ 安装依赖
- ✅ 运行测试
- ✅ 构建 Release APK
- ✅ 构建 App Bundle
- ✅ 创建发布包
- ✅ 生成校验和

### 3. 发布到 GitHub

```bash
# 创建 Git 标签
git add .
git commit -m "Release v1.0.0"
git tag -a v1.0.0 -m "v1.0.0 - Initial Release"
git push origin master --tags
```

然后在 GitHub 上：
1. 进入 Releases → Draft new release
2. 选择标签 `v1.0.0`
3. 复制 `RELEASE-v1.0.0.md` 内容
4. 上传 APK 和 AAB 文件
5. 发布！

---

## 方案二：使用 Docker 构建（无需安装 Flutter）

### 1. 构建 Docker 镜像

```bash
docker build -t ssh-tool .
```

### 2. 提取构建产物

```bash
# 运行容器并复制文件
docker run --name ssh-builder ssh-tool
docker cp ssh-builder:/app/build/app/outputs/flutter-apk/app-release.apk ./ssh-tool-v1.0.0.apk
docker cp ssh-builder:/app/build/app/outputs/bundle/release/app-release.aab ./ssh-tool-v1.0.0.aab
docker rm ssh-builder
```

---

## 方案三：使用 GitHub Actions 自动发布

### 1. 推送代码到 GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/sshtool.git
git push -u origin master
```

### 2. 创建标签触发自动构建

```bash
git tag -a v1.0.0 -m "v1.0.0 - Initial Release"
git push origin v1.0.0
```

GitHub Actions 会自动：
- ✅ 构建 APK
- ✅ 构建 App Bundle
- ✅ 创建 GitHub Release
- ✅ 上传构建产物

### 3. 查看构建结果

访问: `https://github.com/yourusername/sshtool/actions`

---

## 方案四：使用在线 Flutter 环境

### FlutterPad (在线 IDE)
1. 访问: https://www.flutterpad.dev/
2. 上传项目文件
3. 构建 APK
4. 下载

### Codemagic (CI/CD 平台)
1. 访问: https://codemagic.io/
2. 连接 GitHub 仓库
3. 配置构建流程
4. 自动构建和分发

---

## 📦 发布包内容

构建完成后，`release-v1.0.0/` 目录包含：

```
release-v1.0.0/
├── ssh-tool-v1.0.0.apk     # Android APK (安装包)
├── ssh-tool-v1.0.0.aab     # App Bundle (Play Store)
├── README.md               # 项目说明
├── CHANGELOG.md            # 更新日志
├── RELEASE-v1.0.0.md       # 发布说明
├── QUICKSTART.md           # 快速开始
├── LICENSE                 # 许可证
└── checksums.txt           # SHA256 校验和
```

---

## ✅ 发布检查清单

### 构建前
- [ ] Flutter 已安装并配置
- [ ] 代码已提交到 Git
- [ ] 版本号已更新 (pubspec.yaml)
- [ ] 文档已更新

### 构建
- [ ] 依赖安装成功
- [ ] 测试通过
- [ ] APK 构建成功
- [ ] App Bundle 构建成功
- [ ] APK 大小合理 (< 15MB)

### 测试
- [ ] 在 Android 设备上安装测试
- [ ] 基本功能正常
- [ ] 无崩溃和严重 bug

### 发布
- [ ] Git 标签已创建
- [ ] GitHub Release 已创建
- [ ] APK 已上传
- [ ] 发布说明已填写

### 分发
- [ ] 分享下载链接
- [ ] 社交媒体宣传
- [ ] 收集用户反馈

---

## 🔗 快速链接

### 下载 Flutter
- 官网: https://flutter.dev/docs/get-started/install
- 中国镜像: https://flutter.cn/docs/get-started/install

### 文档
- Flutter 文档: https://docs.flutter.dev/
- 打包发布: https://docs.flutter.dev/deployment/android

### 工具
- GitHub Actions: https://github.com/features/actions
- Codemagic: https://codemagic.io/
- Fastlane: https://fastlane.tools/

---

## 💡 提示

1. **首次发布建议使用方案一**（本地构建），便于调试
2. **后续版本使用方案三**（GitHub Actions），自动化更高效
3. **没有 Flutter 环境使用方案二**（Docker）
4. **团队协作推荐方案三**，CI/CD 自动化

---

## 🆘 常见问题

### Q: Flutter doctor 报错？
A: 根据提示安装缺失的依赖，通常是 Android SDK 或 Xcode

### Q: APK 太大？
A: 使用 `--shrink` 参数，已包含在构建脚本中

### Q: 构建失败？
A: 运行 `flutter clean && flutter pub get` 后重试

### Q: 无法安装到设备？
A: 开启开发者选项和 USB 调试

---

## 📞 需要帮助？

- GitHub Issues: https://github.com/yourusername/sshtool/issues
- Flutter 社区: https://flutter.dev/community
- Stack Overflow: `[flutter]` 标签

---

**选择一个方案开始发布吧！** 🚀

推荐顺序：
1. 安装 Flutter → 运行 `./release.sh`
2. 或使用 GitHub Actions 自动发布
3. 或使用 Docker 构建
