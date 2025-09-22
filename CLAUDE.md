# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview / 项目概述

**PromptTool** is a sophisticated **Claude Code Documentation-Driven Project Generator** - a professional single-file web application that generates optimized project structures specifically designed for Claude Code workflows.

**PromptTool** 是一个精密的 **Claude Code 文档驱动项目生成器** - 一个专业的单文件Web应用程序，专门为Claude Code工作流生成优化的项目结构。

### Key Features / 主要功能
- **Multi-language Support / 多语言支持**: English & Simplified Chinese interfaces and documentation
- **Documentation-Driven Development / 文档驱动开发**: Complete versioned documentation system
- **Automated Workflows / 自动化工作流**: Claude Code hooks, CI/CD, and quality checks
- **Project Structure Generation / 项目结构生成**: Optimized for Claude Code integration
- **Version Management / 版本管理**: Incremental development through document differences

## Project Structure / 项目结构

```
PromptTool/
├── index.html                 # Main application (single-file web app)
│                              # 主应用程序（单文件Web应用）
├── CLAUDE.md                  # This configuration file
│                              # 本配置文件
├── .claude/                   # Claude Code hooks configuration
│   └── hooks.toml             # Claude Code钩子配置
├── .github/                   # GitHub Actions workflows
│   └── workflows/
│       └── ci.yml             # CI/CD pipeline / CI/CD流水线
├── scripts/                   # Automation scripts / 自动化脚本
│   ├── claude-dev-cycle.sh    # Main development cycle automation
│   ├── validate-docs.sh       # Documentation validation
│   ├── check-secrets.sh       # Security scanning
│   └── update-doc-versions.sh # Version management
├── docs/                      # Documentation system / 文档系统
│   ├── versions/              # Versioned documentation / 版本化文档
│   │   └── v1.0.0/           # Version 1.0.0 documents
│   │       ├── PRD.md         # Product Requirements Document
│   │       ├── ARCHITECTURE.md # Architecture Design Document
│   │       ├── API.md         # Interface Specification
│   │       └── CHANGELOG.md   # Version Change Log
│   ├── validation-report.md   # Documentation validation report
│   └── version-summary.md     # Version summary
└── templates/                 # Document templates / 文档模板
```

## Development Philosophy / 开发理念

### Documentation-Driven Development / 文档驱动开发
- **Documentation as Truth / 文档即真理**: All features and changes are clearly documented
- **Version Management / 版本管理**: Generate new version documents for each requirement change
- **Incremental Development / 增量开发**: Claude Code only needs to understand document differences
- **Automated Workflow / 自动化工作流**: Complete automation from documentation → code → testing → commit

## Usage Guide / 使用指南

### Running the Application / 运行应用程序

1. **Open the Application / 打开应用程序**:
   ```bash
   # Open index.html in a web browser
   # 在Web浏览器中打开index.html
   open index.html  # macOS
   start index.html # Windows
   xdg-open index.html # Linux
   ```

2. **Configure Project / 配置项目**:
   - Select project mode (New Project / Version Iteration)
   - 选择项目模式（新建项目/版本迭代）
   - Choose documentation language (English/Chinese/Bilingual)
   - 选择文档语言（英文/中文/双语）
   - Configure required documents and automation features
   - 配置必需文档和自动化功能

3. **Generate Prompt / 生成提示**:
   - Click "Generate Prompt" to create optimized Claude Code instructions
   - 点击"生成提示"创建优化的Claude Code指令
   - Copy the generated prompt and use it with Claude Code
   - 复制生成的提示并在Claude Code中使用

### Automation Scripts / 自动化脚本

#### Complete Development Cycle / 完整开发周期
```bash
# Run full automated development cycle
# 运行完整自动化开发周期
bash scripts/claude-dev-cycle.sh
```

#### Documentation Management / 文档管理
```bash
# Validate all documentation
# 验证所有文档
bash scripts/validate-docs.sh

# Create new version (patch/minor/major)
# 创建新版本（补丁/次要/主要）
bash scripts/update-doc-versions.sh --new-version minor

# Update current version documents
# 更新当前版本文档
bash scripts/update-doc-versions.sh
```

#### Security Scanning / 安全扫描
```bash
# Scan for secrets and security issues
# 扫描秘密信息和安全问题
bash scripts/check-secrets.sh
```

## Claude Code Integration / Claude Code集成

### Hooks Configuration / 钩子配置
The project includes pre-configured Claude Code hooks in `.claude/hooks.toml` that:
项目在`.claude/hooks.toml`中包含预配置的Claude Code钩子，用于：

- **Pre-commit Quality Checks / 提交前质量检查**: Run tests, linting, and security scans
- **Documentation Validation / 文档验证**: Ensure documentation consistency
- **Post-commit Automation / 提交后自动化**: Trigger CI/CD and notifications

### Typical Claude Code Workflow / 典型Claude Code工作流

1. **Initial Project Generation / 初始项目生成**:
   ```bash
   claude-code "Generate complete project structure based on docs/versions/v1.0.0/PRD.md"
   ```

2. **Version Iteration Development / 版本迭代开发**:
   ```bash
   claude-code "Compare differences between docs/versions/v1.0.0 and v1.1.0, update corresponding code implementation"
   ```

3. **Quality Assurance / 质量保证**:
   ```bash
   claude-code "Run complete test suite and generate test report"
   ```

## Documentation Standards / 文档标准

### Core Documents (Required) / 核心文档（必需）
- **CLAUDE.md**: Project configuration and development guide
- **PRD.md**: Product requirements document with user stories
- **ARCHITECTURE.md**: System architecture and technical design
- **API.md**: Interface specifications and data models

### Version Management / 版本管理
- All changes create new version documents in `docs/versions/vX.X.X/`
- 所有变更在`docs/versions/vX.X.X/`中创建新版本文档
- CHANGES.md documents differences between versions
- CHANGES.md记录版本间的差异
- CHANGELOG.md maintains complete change history
- CHANGELOG.md维护完整的变更历史

## Multi-language Support / 多语言支持

### Interface Languages / 界面语言
- **English**: Full interface and documentation
- **简体中文**: Complete Chinese interface and documentation
- **Bilingual / 双语**: Automatic language detection and switching

### Documentation Languages / 文档语言
- **English Only**: Generate English documentation
- **Chinese Only**: Generate Chinese documentation
- **Bilingual**: Generate synchronized English and Chinese documentation

## Automation Features / 自动化功能

### GitHub Actions Integration / GitHub Actions集成
- **Quality Checks / 质量检查**: Automated testing and code analysis
- **Documentation Sync / 文档同步**: Auto-update documentation versions
- **Security Scanning / 安全扫描**: Vulnerability detection and secrets scanning
- **Deployment Pipeline / 部署流水线**: Automated staging and production deployment

### Quality Assurance / 质量保证
Multi-layer protection system:
多层保护系统：

1. **Pre-commit Hooks / 提交前钩子**: Real-time code and documentation checks
2. **Claude Code Review / Claude代码审查**: AI-powered code quality analysis
3. **CI/CD Validation / CI/CD验证**: Comprehensive testing and security scanning
4. **Production Deployment / 生产部署**: Final integration and acceptance testing

## Development Commands / 开发命令

### Project Initialization / 项目初始化
```bash
# Initialize new project from generated prompt
# 从生成的提示初始化新项目
claude-code [generated-prompt]

# Set up development environment
# 设置开发环境
bash scripts/claude-dev-cycle.sh
```

### Version Management / 版本管理
```bash
# Create new minor version
# 创建新的次要版本
bash scripts/update-doc-versions.sh --new-version minor

# Validate all documentation
# 验证所有文档
bash scripts/validate-docs.sh
```

### Quality Assurance / 质量保证
```bash
# Run security scan
# 运行安全扫描
bash scripts/check-secrets.sh

# Complete development cycle
# 完整开发周期
bash scripts/claude-dev-cycle.sh
```

## Success Criteria / 成功标准

### Project Delivery Standards / 项目交付标准
- ✅ Code runs directly, passes all tests / 代码可直接运行，通过所有测试
- ✅ Complete documentation system with version management / 完整的文档系统和版本管理
- ✅ Git workflow configured with automation / Git工作流配置自动化
- ✅ Claude Code integration ready for incremental development / Claude Code集成支持增量开发
- ✅ CI/CD pipeline ready for continuous integration / CI/CD流水线支持持续集成
- ✅ Multi-language support implemented / 多语言支持已实现

### Maintainability Assurance / 维护性保证
- ✅ **Documentation-Driven**: Feature changes have clear documentation guidance / 功能变更有清晰的文档指导
- ✅ **Versioned**: Supports precise incremental development / 支持精确的增量开发
- ✅ **Automated**: Reduces manual operations, improves efficiency / 减少人工操作，提高效率
- ✅ **Traceable**: Complete change history and decision records / 完整的变更历史和决策记录
- ✅ **Multi-language**: Supports international team collaboration / 支持国际化团队协作

## Support / 支持

For questions or issues related to this project generator:
有关此项目生成器的问题或疑问：

1. Check the generated documentation in `docs/` directory
   检查`docs/`目录中的生成文档
2. Review the validation reports for guidance
   查看验证报告以获得指导
3. Use the automation scripts for common tasks
   使用自动化脚本处理常见任务
4. Refer to the version summary for project history
   参考版本总结了解项目历史

---

🤖 **Generated with Claude Code Documentation-Driven Project Generator**
**由Claude Code文档驱动项目生成器生成**

**Co-Authored-By: Claude <noreply@anthropic.com>**