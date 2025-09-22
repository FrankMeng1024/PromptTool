#!/bin/bash
# Security Check Script - Detect potential secrets and sensitive information
# 安全检查脚本 - 检测潜在的秘密和敏感信息

set -e

echo "🔒 Starting security check for secrets... 开始秘密信息安全检查..."

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Patterns to search for potential secrets
# 搜索潜在秘密信息的模式
SECRET_PATTERNS=(
    # API Keys / API密钥
    "(?i)(api[_-]?key|apikey)\s*[=:]\s*['\"][a-z0-9]{20,}['\"]"
    "(?i)(secret[_-]?key|secretkey)\s*[=:]\s*['\"][a-z0-9]{20,}['\"]"
    "(?i)(access[_-]?token|accesstoken)\s*[=:]\s*['\"][a-z0-9]{20,}['\"]"

    # Database credentials / 数据库凭据
    "(?i)(password|passwd|pwd)\s*[=:]\s*['\"][^'\"]{3,}['\"]"
    "(?i)(username|user)\s*[=:]\s*['\"][a-z0-9_-]{3,}['\"]"
    "(?i)(database[_-]?url|db[_-]?url)\s*[=:]\s*['\"].*['\"]"

    # AWS credentials / AWS凭据
    "AKIA[0-9A-Z]{16}"
    "(?i)(aws[_-]?secret[_-]?access[_-]?key|aws[_-]?session[_-]?token)"

    # JWT tokens / JWT令牌
    "eyJ[a-zA-Z0-9_-]*\\.eyJ[a-zA-Z0-9_-]*\\.[a-zA-Z0-9_-]*"

    # Private keys / 私钥
    "-----BEGIN [A-Z ]*PRIVATE KEY-----"
    "-----BEGIN RSA PRIVATE KEY-----"
    "-----BEGIN OPENSSH PRIVATE KEY-----"

    # OAuth tokens / OAuth令牌
    "(?i)(oauth[_-]?token|bearer[_-]?token)\s*[=:]\s*['\"][a-z0-9]{20,}['\"]"

    # Generic high-entropy strings / 通用高熵字符串
    "['\"][a-zA-Z0-9+/]{50,}={0,2}['\"]"
)

# Files to exclude from search
# 要从搜索中排除的文件
EXCLUDE_PATTERNS=(
    "node_modules"
    ".git"
    "dist"
    "build"
    "*.log"
    "*.lock"
    "*.min.js"
    "*.min.css"
    ".env.example"
    ".env.template"
    "scripts/check-secrets.sh"
)

# Build exclude arguments for grep
EXCLUDE_ARGS=""
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude-dir=$pattern --exclude=$pattern"
done

# Function to check for patterns
check_pattern() {
    local pattern="$1"
    local description="$2"

    log_info "Checking for: $description"
    log_info "检查: $description"

    # Use grep to search for pattern
    if grep -r -E $EXCLUDE_ARGS "$pattern" "$PROJECT_ROOT" 2>/dev/null; then
        log_error "Potential secret found matching: $description"
        log_error "发现潜在秘密信息，匹配: $description"
        return 1
    else
        log_success "No matches found for: $description"
        log_success "未发现匹配项: $description"
        return 0
    fi
}

# 1. Check for common secret patterns
log_info "Scanning for common secret patterns... 扫描常见的秘密模式..."

ISSUES_FOUND=0

# API Keys
if grep -r -E $EXCLUDE_ARGS "(?i)(api[_-]?key|secret[_-]?key|access[_-]?token)\s*[=:]\s*['\"][a-zA-Z0-9]{20,}['\"]" "$PROJECT_ROOT" 2>/dev/null; then
    log_error "Potential API keys or tokens found 发现潜在的API密钥或令牌"
    ((ISSUES_FOUND++))
fi

# Database URLs with credentials
if grep -r -E $EXCLUDE_ARGS "(postgresql|mysql|mongodb)://[^:]+:[^@]+@" "$PROJECT_ROOT" 2>/dev/null; then
    log_error "Database URLs with credentials found 发现包含凭据的数据库URL"
    ((ISSUES_FOUND++))
fi

# AWS Access Keys
if grep -r -E $EXCLUDE_ARGS "AKIA[0-9A-Z]{16}" "$PROJECT_ROOT" 2>/dev/null; then
    log_error "AWS Access Keys found 发现AWS访问密钥"
    ((ISSUES_FOUND++))
fi

# Private keys
if grep -r -E $EXCLUDE_ARGS "-----BEGIN [A-Z ]*PRIVATE KEY-----" "$PROJECT_ROOT" 2>/dev/null; then
    log_error "Private keys found 发现私钥"
    ((ISSUES_FOUND++))
fi

# JWT tokens
if grep -r -E $EXCLUDE_ARGS "eyJ[a-zA-Z0-9_-]*\\.eyJ[a-zA-Z0-9_-]*\\.[a-zA-Z0-9_-]*" "$PROJECT_ROOT" 2>/dev/null; then
    log_error "JWT tokens found 发现JWT令牌"
    ((ISSUES_FOUND++))
fi

# 2. Check for .env files in git
log_info "Checking for .env files in git history... 检查git历史中的.env文件..."

if [ -d "$PROJECT_ROOT/.git" ]; then
    if git -C "$PROJECT_ROOT" ls-files | grep -E "\.env$|\.env\.|secrets|credentials" 2>/dev/null; then
        log_warning "Environment or credential files found in git 在git中发现环境或凭据文件"
        log_warning "Consider adding these to .gitignore: 考虑将这些添加到.gitignore:"
        echo "  .env"
        echo "  .env.*"
        echo "  !.env.example"
        echo "  !.env.template"
        ((ISSUES_FOUND++))
    fi
fi

# 3. Check for hardcoded localhost URLs with credentials
log_info "Checking for hardcoded localhost URLs... 检查硬编码的localhost URL..."

if grep -r -E $EXCLUDE_ARGS "localhost:[0-9]+.*[?&](password|token|key)=" "$PROJECT_ROOT" 2>/dev/null; then
    log_warning "Localhost URLs with credentials found localhost URL包含凭据"
    ((ISSUES_FOUND++))
fi

# 4. Check for common password patterns
log_info "Checking for common weak passwords... 检查常见弱密码..."

WEAK_PASSWORDS=("password" "123456" "admin" "root" "test" "demo")

for pwd in "${WEAK_PASSWORDS[@]}"; do
    if grep -r -i $EXCLUDE_ARGS "password.*[=:].*$pwd" "$PROJECT_ROOT" 2>/dev/null; then
        log_warning "Weak password pattern found: $pwd 发现弱密码模式: $pwd"
        ((ISSUES_FOUND++))
    fi
done

# 5. Check for TODO/FIXME comments with security implications
log_info "Checking for security-related TODO/FIXME comments... 检查与安全相关的TODO/FIXME注释..."

if grep -r -E $EXCLUDE_ARGS "(?i)(TODO|FIXME|HACK).*\b(password|secret|key|token|auth|security)\b" "$PROJECT_ROOT" 2>/dev/null; then
    log_warning "Security-related TODO/FIXME comments found 发现与安全相关的TODO/FIXME注释"
    echo "  Review these comments for security implications"
    echo "  请检查这些注释的安全影响"
fi

# 6. Generate security report
log_info "Generating security report... 生成安全报告..."

REPORT_FILE="$PROJECT_ROOT/docs/security-scan-report.md"
mkdir -p "$(dirname "$REPORT_FILE")"

cat > "$REPORT_FILE" << EOF
# Security Scan Report
# 安全扫描报告

Generated on: $(date)
生成时间: $(date)

## Summary / 总结

Security scan completed with $ISSUES_FOUND potential issues found.
安全扫描完成，发现$ISSUES_FOUND个潜在问题。

## Scan Results / 扫描结果

### Patterns Checked / 检查的模式

- API Keys and Tokens / API密钥和令牌
- Database Credentials / 数据库凭据
- AWS Access Keys / AWS访问密钥
- Private Keys / 私钥
- JWT Tokens / JWT令牌
- Environment Files in Git / Git中的环境文件
- Weak Passwords / 弱密码
- Security TODOs / 安全相关TODO

### Recommendations / 建议

1. Use environment variables for sensitive configuration / 使用环境变量存储敏感配置
2. Add .env files to .gitignore / 将.env文件添加到.gitignore
3. Use proper secret management tools / 使用适当的秘密管理工具
4. Rotate any exposed credentials immediately / 立即轮换任何暴露的凭据
5. Review and resolve security-related TODO comments / 检查并解决与安全相关的TODO注释

### Next Steps / 下一步

1. Review flagged files manually / 手动检查标记的文件
2. Remove or obfuscate any real secrets / 删除或混淆任何真实的秘密
3. Implement proper secret management / 实施适当的秘密管理
4. Add this check to your CI/CD pipeline / 将此检查添加到您的CI/CD流水线

---
Generated by Claude Code Security Scanner
由Claude Code安全扫描器生成
EOF

# Final summary
if [ $ISSUES_FOUND -eq 0 ]; then
    log_success "🎉 No security issues found! 未发现安全问题！"
    log_success "Security scan completed successfully 安全扫描成功完成"
else
    log_warning "⚠️  $ISSUES_FOUND potential security issues found"
    log_warning "⚠️  发现$ISSUES_FOUND个潜在安全问题"
    log_warning "Please review the findings and take appropriate action"
    log_warning "请检查发现的问题并采取适当措施"
fi

log_info "Security report generated: $REPORT_FILE"
log_info "安全报告已生成: $REPORT_FILE"

exit 0