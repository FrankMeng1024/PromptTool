# 🤖 PromptTool - Claude Code Documentation-Driven Project Generator

A sophisticated **single-file web application** that generates optimized project structures specifically designed for **Claude Code** workflows, featuring complete **multi-language support** and **documentation-driven development**.

一个精密的**单文件Web应用程序**，专门为**Claude Code**工作流生成优化的项目结构，具有完整的**多语言支持**和**文档驱动开发**功能。

## ✨ Key Features / 主要功能

🌐 **Multi-language Support** - English & Simplified Chinese interfaces and documentation
🌐 **多语言支持** - 英文和简体中文界面及文档

📚 **Documentation-Driven Development** - Complete versioned documentation system
📚 **文档驱动开发** - 完整的版本化文档系统

⚙️ **Automated Workflows** - Claude Code hooks, CI/CD, and quality checks
⚙️ **自动化工作流** - Claude Code钩子、CI/CD和质量检查

🏗️ **Project Structure Generation** - Optimized for Claude Code integration
🏗️ **项目结构生成** - 针对Claude Code集成优化

📈 **Version Management** - Incremental development through document differences
📈 **版本管理** - 通过文档差异进行增量开发

## 🚀 Quick Start / 快速开始

### 1. Open the Application / 打开应用程序

Simply open `index.html` in your web browser:
只需在Web浏览器中打开`index.html`：

```bash
# macOS
open index.html

# Windows
start index.html

# Linux
xdg-open index.html
```

### 2. Configure Your Project / 配置您的项目

1. **Select Project Mode / 选择项目模式**:
   - 🆕 New Project (Generate complete documentation system)
   - 🔄 Version Iteration (Generate new version based on existing docs)

2. **Choose Languages / 选择语言**:
   - English only
   - 简体中文 only
   - Bilingual (双语)

3. **Configure Documents / 配置文档**:
   - ✅ Core documents (CLAUDE.md, PRD.md, ARCHITECTURE.md, API.md)
   - 📋 Professional documents (UX.md, SECURITY.md, PERFORMANCE.md)
   - 🔄 Workflow documents (TESTING.md, DEVELOPMENT.md, REVIEW.md)

4. **Setup Automation / 设置自动化**:
   - 🔧 Claude Code Hooks
   - 🚀 CI/CD Pipeline
   - 🧪 Automated Testing
   - 🔍 Quality Checks

### 3. Generate & Use / 生成和使用

1. Click **"Generate Prompt"** to create optimized Claude Code instructions
   点击**"生成提示"**创建优化的Claude Code指令

2. Copy the generated prompt and use it with Claude Code
   复制生成的提示并在Claude Code中使用

3. Claude Code will generate a complete project structure based on your configuration
   Claude Code将根据您的配置生成完整的项目结构

## 📁 Project Structure / 项目结构

```
PromptTool/
├── 🌐 index.html                 # Main application (single-file web app)
├── 📋 CLAUDE.md                  # Claude Code configuration
├── 📖 README.md                  # This file
├── .claude/                      # Claude Code hooks
│   └── hooks.toml
├── .github/workflows/            # GitHub Actions
│   └── ci.yml
├── 📜 scripts/                   # Automation scripts
│   ├── claude-dev-cycle.sh       # Main development cycle
│   ├── validate-docs.sh          # Documentation validation
│   ├── check-secrets.sh          # Security scanning
│   └── update-doc-versions.sh    # Version management
└── 📚 docs/                      # Documentation system
    ├── versions/v1.0.0/          # Versioned documentation
    ├── validation-report.md      # Validation reports
    └── version-summary.md        # Version summaries
```

## 🛠️ Automation Scripts / 自动化脚本

### Complete Development Cycle / 完整开发周期
Run the full automated development workflow:
运行完整的自动化开发工作流：

```bash
bash scripts/claude-dev-cycle.sh
```

### Documentation Management / 文档管理
```bash
# Validate all documentation / 验证所有文档
bash scripts/validate-docs.sh

# Create new version / 创建新版本
bash scripts/update-doc-versions.sh --new-version minor

# Update current version documents / 更新当前版本文档
bash scripts/update-doc-versions.sh
```

### Security Scanning / 安全扫描
```bash
bash scripts/check-secrets.sh
```

## 🎯 Use Cases / 使用场景

### 🆕 New Project Generation / 新项目生成
Perfect for starting new projects with:
非常适合启动具有以下特性的新项目：
- Complete documentation structure / 完整的文档结构
- Claude Code integration / Claude Code集成
- Multi-language support / 多语言支持
- Automated workflows / 自动化工作流

### 🔄 Version Iteration / 版本迭代
Ideal for existing projects needing:
非常适合需要以下功能的现有项目：
- Incremental feature development / 增量功能开发
- Documentation-driven changes / 文档驱动的变更
- Version-controlled updates / 版本控制的更新
- Automated testing and deployment / 自动化测试和部署

### 🏢 Enterprise Development / 企业开发
Designed for teams requiring:
专为需要以下功能的团队设计：
- Standardized documentation / 标准化文档
- Multi-language collaboration / 多语言协作
- Quality assurance automation / 质量保证自动化
- Compliance and audit trails / 合规性和审计跟踪

## 🌟 Generated Project Features / 生成项目功能

Projects generated by PromptTool include:
PromptTool生成的项目包括：

### 📚 Documentation System / 文档系统
- **CLAUDE.md**: Complete Claude Code configuration
- **PRD.md**: Product requirements with user stories
- **ARCHITECTURE.md**: System design and technical specifications
- **API.md**: Interface documentation and data models
- **Version management**: Incremental documentation updates

### ⚙️ Automation & CI/CD / 自动化和CI/CD
- **Claude Code Hooks**: Pre/post-commit quality checks
- **GitHub Actions**: Automated testing and deployment
- **Security Scanning**: Secrets detection and vulnerability analysis
- **Quality Assurance**: Multi-layer validation system

### 🌐 Multi-language Support / 多语言支持
- **Interface**: English and Chinese UI with auto-detection
- **Documentation**: Synchronized bilingual documentation
- **Code Comments**: Configurable comment languages
- **Cultural Adaptation**: Localized content and terminology

## 🎨 Screenshots / 截图

### Main Interface / 主界面
![Main Interface](https://via.placeholder.com/800x600/1e293b/ffffff?text=PromptTool+Main+Interface)

### Configuration Panel / 配置面板
![Configuration](https://via.placeholder.com/400x600/3b82f6/ffffff?text=Project+Configuration)

### Generated Prompt / 生成的提示
![Generated Prompt](https://via.placeholder.com/800x400/10b981/ffffff?text=Generated+Claude+Code+Prompt)

## 🔧 Technical Details / 技术细节

### Architecture / 架构
- **Single-file application**: No dependencies, runs in any modern browser
- **Vanilla JavaScript**: No frameworks, lightweight and fast
- **Tailwind CSS**: Modern, responsive design
- **Progressive Enhancement**: Works without JavaScript for basic functionality

### Browser Support / 浏览器支持
- ✅ Chrome 70+
- ✅ Firefox 65+
- ✅ Safari 12+
- ✅ Edge 79+

### Features / 功能特性
- 🎨 **Responsive Design**: Works on desktop, tablet, and mobile
- 🌙 **Auto Language Detection**: Detects user's preferred language
- 💾 **Local Storage**: Saves configuration automatically
- 📋 **Copy to Clipboard**: Easy prompt copying with feedback
- 📥 **Configuration Export**: Download settings as JSON

## 🤝 Contributing / 贡献

Contributions are welcome! / 欢迎贡献！

### Development Setup / 开发设置
1. Clone the repository / 克隆仓库
2. Open `index.html` in your browser / 在浏览器中打开`index.html`
3. Make changes and test / 进行更改并测试
4. Run validation scripts / 运行验证脚本
5. Submit a pull request / 提交拉取请求

### Code Quality / 代码质量
- Use the provided automation scripts / 使用提供的自动化脚本
- Follow the documentation standards / 遵循文档标准
- Test in multiple browsers / 在多个浏览器中测试
- Maintain bilingual support / 维护双语支持

## 📄 License / 许可证

This project is open source and available under the [MIT License](LICENSE).
此项目是开源的，采用[MIT许可证](LICENSE)。

## 🙏 Acknowledgments / 致谢

- **Claude AI**: For the inspiration and integration capabilities
- **Tailwind CSS**: For the beautiful and responsive design system
- **Open Source Community**: For the tools and libraries that make this possible

## 📞 Support / 支持

For questions or issues:
如有问题或疑问：

1. 📖 Check the [CLAUDE.md](CLAUDE.md) for detailed documentation
   查看[CLAUDE.md](CLAUDE.md)获取详细文档
2. 🐛 Open an issue on GitHub for bugs or feature requests
   在GitHub上开启问题报告错误或功能请求
3. 📧 Contact the development team for enterprise support
   联系开发团队获取企业支持

---

<div align="center">

**🤖 Generated with Claude Code Documentation-Driven Project Generator**
**由Claude Code文档驱动项目生成器生成**

**Co-Authored-By: Claude <noreply@anthropic.com>**

[⭐ Star this project](../../stargazers) | [🐛 Report Bug](../../issues) | [💡 Request Feature](../../issues) | [📖 Documentation](CLAUDE.md)

</div>