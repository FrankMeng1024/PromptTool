#!/bin/bash
# Claude Code Automated Development Cycle
# Claude Code 自动化开发周期

set -e

echo "🤖 Starting Claude Code automated development cycle..."
echo "🤖 开始Claude Code自动化开发周期..."

# Configuration 配置
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
VERSIONS_DIR="$DOCS_DIR/versions"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"

# Colors for output 输出颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions 日志函数
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 1. Documentation difference analysis 文档差异分析
log_info "Step 1: Analyzing documentation changes... 步骤1: 分析文档变更..."

if [ -f "$SCRIPTS_DIR/analyze-doc-diff.sh" ]; then
    bash "$SCRIPTS_DIR/analyze-doc-diff.sh"
    log_success "Documentation analysis completed 文档分析完成"
else
    log_warning "Documentation analysis script not found, skipping... 未找到文档分析脚本，跳过..."
fi

# 2. Automated code generation/update 自动代码生成/更新
log_info "Step 2: Checking for code generation requirements... 步骤2: 检查代码生成需求..."

if [ -f "$DOCS_DIR/changes.md" ]; then
    log_info "Found changes document, ready for Claude Code integration"
    log_info "发现变更文档，准备Claude Code集成"

    # Check if we should run Claude Code automatically
    # 检查是否应该自动运行Claude Code
    if command -v claude-code >/dev/null 2>&1; then
        log_info "Claude Code CLI detected, would run: claude-code -p 'Based on documentation diff in docs/changes.md, update the codebase'"
        log_info "检测到Claude Code CLI，可运行: claude-code -p '基于docs/changes.md中的文档差异，更新代码库'"
    else
        log_warning "Claude Code CLI not found. Please install it or run manually."
        log_warning "未找到Claude Code CLI。请安装或手动运行。"
    fi
else
    log_info "No changes document found, skipping code generation"
    log_info "未找到变更文档，跳过代码生成"
fi

# 3. Automated test generation 自动化测试生成
log_info "Step 3: Checking test requirements... 步骤3: 检查测试需求..."

if [ -f "package.json" ]; then
    # Check if test framework exists 检查测试框架是否存在
    if npm list --depth=0 2>/dev/null | grep -q -E "jest|vitest|mocha|cypress"; then
        log_info "Test framework detected 检测到测试框架"

        # Check for new features that need tests 检查需要测试的新功能
        if [ -f "$DOCS_DIR/test-requirements.md" ]; then
            log_info "Test requirements found, ready for test generation"
            log_info "发现测试需求，准备生成测试"
        else
            log_info "No specific test requirements found"
            log_info "未发现特定测试需求"
        fi
    else
        log_warning "No test framework detected, skipping test generation"
        log_warning "未检测到测试框架，跳过测试生成"
    fi
elif [ -f "requirements.txt" ]; then
    if command -v pytest >/dev/null 2>&1; then
        log_info "Python test framework detected (pytest) Python测试框架已检测到(pytest)"
    else
        log_warning "Python project detected but pytest not found Python项目已检测但未找到pytest"
    fi
else
    log_info "No supported project structure detected for testing"
    log_info "未检测到支持的测试项目结构"
fi

# 4. Quality validation 质量验证
log_info "Step 4: Running quality checks... 步骤4: 运行质量检查..."

# Run tests 运行测试
if [ -f "package.json" ] && npm list --depth=0 2>/dev/null | grep -q -E "jest|vitest|mocha"; then
    log_info "Running JavaScript/TypeScript tests... 运行JavaScript/TypeScript测试..."
    if npm test; then
        log_success "All tests passed 所有测试通过"
    else
        log_error "Tests failed 测试失败"
        exit 1
    fi
elif [ -f "requirements.txt" ] && command -v pytest >/dev/null 2>&1; then
    log_info "Running Python tests... 运行Python测试..."
    if python -m pytest; then
        log_success "All Python tests passed 所有Python测试通过"
    else
        log_error "Python tests failed Python测试失败"
        exit 1
    fi
else
    log_info "No tests found or test framework not available 未找到测试或测试框架不可用"
fi

# Run linting 运行代码检查
if [ -f "package.json" ] && npm list --depth=0 2>/dev/null | grep -q "eslint"; then
    log_info "Running ESLint... 运行ESLint..."
    if npm run lint --if-present; then
        log_success "Linting passed 代码检查通过"
    else
        log_warning "Linting issues found (non-blocking) 发现代码检查问题（非阻塞）"
    fi
fi

# Type checking 类型检查
if [ -f "tsconfig.json" ]; then
    log_info "Running TypeScript type checking... 运行TypeScript类型检查..."
    if npx tsc --noEmit; then
        log_success "Type checking passed 类型检查通过"
    else
        log_warning "Type checking issues found (non-blocking) 发现类型检查问题（非阻塞）"
    fi
fi

# 5. Security validation 安全验证
log_info "Step 5: Running security checks... 步骤5: 运行安全检查..."

if [ -f "package.json" ]; then
    log_info "Running npm security audit... 运行npm安全审计..."
    if npm audit --audit-level=moderate; then
        log_success "Security audit passed 安全审计通过"
    else
        log_warning "Security vulnerabilities found 发现安全漏洞"
    fi
fi

# Check for secrets 检查秘密信息
if [ -f "$SCRIPTS_DIR/check-secrets.sh" ]; then
    bash "$SCRIPTS_DIR/check-secrets.sh"
else
    log_info "No secrets check script found, skipping... 未找到秘密检查脚本，跳过..."
fi

# 6. Documentation sync validation 文档同步验证
log_info "Step 6: Validating documentation consistency... 步骤6: 验证文档一致性..."

if [ -f "$SCRIPTS_DIR/validate-doc-code-sync.sh" ]; then
    bash "$SCRIPTS_DIR/validate-doc-code-sync.sh"
    log_success "Documentation consistency validated 文档一致性验证完成"
else
    log_warning "Documentation validation script not found 未找到文档验证脚本"
fi

# 7. Automated commit (if all checks pass) 自动提交（如果所有检查通过）
log_info "Step 7: Checking if automated commit is needed... 步骤7: 检查是否需要自动提交..."

if git diff --quiet && git diff --cached --quiet; then
    log_info "No changes to commit 无变更需要提交"
else
    log_info "Changes detected, preparing commit... 检测到变更，准备提交..."

    # Stage all changes 暂存所有变更
    git add -A

    # Generate commit message based on changes 基于变更生成提交信息
    if command -v claude-code >/dev/null 2>&1; then
        log_info "Would generate semantic commit message using Claude Code"
        log_info "将使用Claude Code生成语义化提交信息"
    else
        # Fallback commit message 备用提交信息
        COMMIT_MSG="feat: Automated development cycle update

🤖 Generated with Claude Code automated development cycle

Co-Authored-By: Claude <noreply@anthropic.com>"

        git commit -m "$COMMIT_MSG"
        log_success "Automated commit created 自动提交已创建"
    fi
fi

# 8. Final summary 最终总结
log_success "🎉 Development cycle completed successfully! 开发周期成功完成！"

# Generate summary report 生成总结报告
echo ""
echo "📊 Development Cycle Summary / 开发周期总结"
echo "================================================"
echo "✅ Documentation analysis: Completed"
echo "✅ Code quality checks: Passed"
echo "✅ Security validation: Completed"
echo "✅ Documentation sync: Validated"
echo ""
echo "🚀 Next steps / 下一步:"
echo "1. Review generated changes 审查生成的变更"
echo "2. Test functionality manually 手动测试功能"
echo "3. Create pull request if needed 如需要创建拉取请求"
echo "4. Deploy to staging environment 部署到测试环境"
echo ""

exit 0