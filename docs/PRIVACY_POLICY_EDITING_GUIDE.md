# 隐私政策修改指南

## 📝 如何修改隐私政策内容

### 1. 基本信息修改

在 `privacy-policy.html` 文件中，找到并修改以下内容：

#### 应用名称
- **第3行**: `<title>Privacy Policy - Routine Track</title>`
- **第61行**: `Welcome to Routine Track.`

#### 更新时间
- **第58行**: `<strong>Last Updated:</strong> December 2024`

#### 联系信息
- **第159行**: `<li><strong>Email:</strong> privacy@routinetrack.app</li>`
- **第160行**: `<li><strong>GitHub:</strong> <a href="https://github.com/yourusername/routine_track"...`

### 2. 内容部分修改

#### 数据收集部分（第1节）
根据你的应用实际功能修改：
- 个人信息收集
- 应用数据收集
- 设备信息收集

#### 数据使用部分（第2节）
根据你的应用实际用途修改数据使用目的。

#### 数据存储部分（第3节）
根据你的应用实际存储方式修改：
- 本地存储
- 云端存储
- 第三方服务

### 3. 常见修改场景

#### 场景1：添加第三方服务
如果你使用了第三方服务（如Firebase、Google Analytics等），需要在相应部分添加说明。

#### 场景2：修改数据收集范围
根据你的应用实际功能，添加或删除数据收集项目。

#### 场景3：修改存储方式
如果数据存储在云端，需要修改存储说明。

### 4. 修改步骤

1. **备份原文件**
   ```bash
   cp docs/privacy-policy.html docs/privacy-policy-backup.html
   ```

2. **编辑文件**
   使用任何文本编辑器打开 `docs/privacy-policy.html`

3. **查找替换**
   使用编辑器的查找功能快速定位需要修改的内容

4. **保存并测试**
   保存文件后在浏览器中打开检查效果

5. **提交更改**
   ```bash
   git add docs/privacy-policy.html
   git commit -m "Update privacy policy content"
   git push origin main
   ```

### 5. 重要提醒

- 修改后记得更新"Last Updated"日期
- 确保所有联系信息都是正确的
- 根据实际应用功能调整内容
- 考虑咨询法律专业人士确保合规性

### 6. 模板变量

你可以使用以下变量替换：
- `{APP_NAME}` - 你的应用名称
- `{YOUR_EMAIL}` - 你的邮箱地址
- `{YOUR_GITHUB_USERNAME}` - 你的GitHub用户名
- `{CURRENT_DATE}` - 当前日期 