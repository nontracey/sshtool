# 🚀 GitHub 发布步骤

## 第一步：在 GitHub 创建仓库

1. 访问 https://github.com/new
2. 填写信息：
   - Repository name: `sshtool`
   - Description: `SSH Android Manager - A powerful SSH client for Android`
   - 可见性: Public（公开）或 Private（私有）
   - **不要**勾选 "Add a README file"（我们已经有了）
   - **不要**勾选 "Add .gitignore"（我们已经有了）
   - License: 选择 MIT（我们已经有了）

3. 点击 "Create repository"

---

## 第二步：推送代码到 GitHub

创建仓库后，GitHub 会显示推送命令。使用以下命令：

### 如果你使用 HTTPS：
```bash
git remote add origin https://github.com/你的用户名/sshtool.git
git branch -M main
git push -u origin main
git push origin v1.0.0
```

### 如果你使用 SSH：
```bash
git remote add origin git@github.com:你的用户名/sshtool.git
git branch -M main
git push -u origin main
git push origin v1.0.0
```

---

## 第三步：GitHub Actions 自动构建

推送标签后，GitHub Actions 会自动：

1. ✅ 检出代码
2. ✅ 安装 Flutter
3. ✅ 安装依赖
4. ✅ 运行测试
5. ✅ 构建 APK
6. ✅ 构建 App Bundle
7. ✅ 创建 GitHub Release
8. ✅ 上传 APK 和 AAB

### 查看构建进度：

1. 访问你的仓库
2. 点击 "Actions" 标签
3. 查看 "Release APK" 工作流
4. 等待构建完成（约 5-10 分钟）

---

## 第四步：查看发布

构建完成后：

1. 访问你的仓库主页
2. 点击右侧的 "Releases"
3. 你会看到 v1.0.0 发布
4. 下载 APK 和 AAB 文件

---

## 🔧 完整命令（复制粘贴）

```bash
# 1. 添加远程仓库（替换为你的用户名）
git remote add origin https://github.com/你的用户名/sshtool.git

# 2. 重命名分支为 main
git branch -M main

# 3. 推送代码
git push -u origin main

# 4. 推送标签（触发自动构建）
git push origin v1.0.0

# 完成！等待 GitHub Actions 构建
```

---

## 📊 预期结果

GitHub Actions 会创建一个发布，包含：

```
v1.0.0 - Initial Release
├── app-release.apk (约 10MB)
├── app-release.aab (约 12MB)
└── Release Notes (从 RELEASE-v1.0.0.md)
```

---

## 🎯 快速检查清单

推送前确认：

- [ ] GitHub 账号已登录
- [ ] 仓库已创建
- [ ] Git 远程仓库已添加
- [ ] 代码已推送到 main 分支
- [ ] 标签已推送

---

## 📝 示例命令（替换你的用户名）

假设你的 GitHub 用户名是 `johndoe`：

```bash
# 添加远程仓库
git remote add origin https://github.com/johndoe/sshtool.git

# 推送代码
git branch -M main
git push -u origin main

# 推送标签（触发自动构建）
git push origin v1.0.0

# 完成！
echo "✅ 推送完成！访问 GitHub Actions 查看构建进度"
```

---

## ⚡ 如果遇到问题

### 问题 1: Permission denied (publickey)
**解决方案**: 使用 HTTPS 而不是 SSH，或者配置 SSH 密钥

### 问题 2: Remote already exists
**解决方案**: 
```bash
git remote remove origin
git remote add origin https://github.com/你的用户名/sshtool.git
```

### 问题 3: Push rejected
**解决方案**: 
```bash
git pull origin main --rebase
git push -u origin main
```

### 问题 4: GitHub Actions 失败
**解决方案**: 
- 检查 Actions 日志
- 确认所有文件已提交
- 查看 `.github/workflows/release.yml` 配置

---

## 🎉 成功后

构建完成后，你可以：

1. **分享下载链接**:
   `https://github.com/你的用户名/sshtool/releases/tag/v1.0.0`

2. **在手机上安装**:
   - 下载 APK
   - 允许安装未知来源
   - 安装并使用

3. **发布到社交媒体**:
   ```
   🎉 SSH Tool v1.0.0 发布了！
   
   一个轻量级、美观的 Android SSH 客户端
   
   特性：
   ✅ SSH 主机管理
   ✅ 完整终端支持
   ✅ 主题定制
   ✅ 仅 10MB！
   
   下载: https://github.com/你的用户名/sshtool/releases/tag/v1.0.0
   
   #SSH #Android #Flutter
   ```

---

## 📞 需要帮助？

- GitHub 文档: https://docs.github.com/en/get-started
- Actions 文档: https://docs.github.com/en/actions
- 问题排查: 查看 Actions 日志

---

**准备好了吗？执行上面的命令开始发布！** 🚀
