#!/bin/bash
# Documentation Validation Script
# 文档验证脚本

set -e

echo "📚 Starting documentation validation... 开始文档验证..."

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$PROJECT_ROOT/docs"
VERSIONS_DIR="$DOCS_DIR/versions"

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

# Check if documentation directory exists
if [ ! -d "$DOCS_DIR" ]; then
    log_warning "Documentation directory not found: $DOCS_DIR"
    log_warning "文档目录未找到: $DOCS_DIR"
    exit 0
fi

# 1. Check for required core documents
log_info "Checking for required core documents... 检查必需的核心文档..."

REQUIRED_DOCS=(
    "CLAUDE.md"
)

RECOMMENDED_DOCS=(
    "README.md"
    "docs/versions/v1.0/PRD.md"
    "docs/versions/v1.0/ARCHITECTURE.md"
    "docs/versions/v1.0/API.md"
)

# Check required documents
for doc in "${REQUIRED_DOCS[@]}"; do
    if [ -f "$PROJECT_ROOT/$doc" ]; then
        log_success "Found required document: $doc"
    else
        log_error "Missing required document: $doc"
        echo "  Please create this document or run the project generator"
        echo "  请创建此文档或运行项目生成器"
    fi
done

# Check recommended documents
for doc in "${RECOMMENDED_DOCS[@]}"; do
    if [ -f "$PROJECT_ROOT/$doc" ]; then
        log_success "Found recommended document: $doc"
    else
        log_warning "Missing recommended document: $doc"
    fi
done

# 2. Validate document structure and content
log_info "Validating document structure... 验证文档结构..."

if [ -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    # Check CLAUDE.md structure
    if grep -q "# CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md"; then
        log_success "CLAUDE.md has proper header CLAUDE.md有正确的标题"
    else
        log_warning "CLAUDE.md missing proper header CLAUDE.md缺少正确的标题"
    fi

    if grep -q "Project Overview" "$PROJECT_ROOT/CLAUDE.md"; then
        log_success "CLAUDE.md contains project overview CLAUDE.md包含项目概述"
    else
        log_warning "CLAUDE.md missing project overview section CLAUDE.md缺少项目概述部分"
    fi

    if grep -q "Development" "$PROJECT_ROOT/CLAUDE.md"; then
        log_success "CLAUDE.md contains development information CLAUDE.md包含开发信息"
    else
        log_warning "CLAUDE.md missing development section CLAUDE.md缺少开发部分"
    fi
fi

# 3. Check for version consistency
log_info "Checking version consistency... 检查版本一致性..."

if [ -d "$VERSIONS_DIR" ]; then
    VERSIONS=($(ls "$VERSIONS_DIR" | grep -E "^v[0-9]" | sort -V))

    if [ ${#VERSIONS[@]} -gt 0 ]; then
        log_success "Found ${#VERSIONS[@]} version(s): ${VERSIONS[*]}"
        log_success "找到${#VERSIONS[@]}个版本: ${VERSIONS[*]}"

        # Check if latest version has all required documents
        LATEST_VERSION="${VERSIONS[-1]}"
        LATEST_DIR="$VERSIONS_DIR/$LATEST_VERSION"

        if [ -d "$LATEST_DIR" ]; then
            log_info "Validating latest version: $LATEST_VERSION"
            log_info "验证最新版本: $LATEST_VERSION"

            VERSION_DOCS=("PRD.md" "ARCHITECTURE.md" "API.md" "CHANGELOG.md")
            for doc in "${VERSION_DOCS[@]}"; do
                if [ -f "$LATEST_DIR/$doc" ]; then
                    log_success "Found $doc in $LATEST_VERSION"
                else
                    log_warning "Missing $doc in $LATEST_VERSION"
                fi
            done
        fi
    else
        log_warning "No version directories found in $VERSIONS_DIR"
        log_warning "在$VERSIONS_DIR中未找到版本目录"
    fi
else
    log_warning "Versions directory not found: $VERSIONS_DIR"
    log_warning "版本目录未找到: $VERSIONS_DIR"
fi

# 4. Check for broken links (simplified)
log_info "Checking for potential broken internal links... 检查潜在的内部链接问题..."

find "$PROJECT_ROOT" -name "*.md" -type f | while read -r file; do
    # Check for relative links to missing files
    if grep -H "\]\(" "$file" | grep -v "http" | while IFS: read -r filepath linkline; do
        # Extract relative path from markdown link
        relative_path=$(echo "$linkline" | sed -n 's/.*](\([^)]*\)).*/\1/p' | head -1)

        if [ -n "$relative_path" ] && [ ! "$relative_path" = "#"* ]; then
            # Convert relative path to absolute
            link_dir=$(dirname "$filepath")
            target_file="$link_dir/$relative_path"

            if [ ! -f "$target_file" ] && [ ! -d "$target_file" ]; then
                log_warning "Potential broken link in $(basename "$filepath"): $relative_path"
                log_warning "$(basename "$filepath")中可能存在断开的链接: $relative_path"
            fi
        fi
    done; then
        continue
    fi
done

# 5. Check documentation language consistency
log_info "Checking language consistency... 检查语言一致性..."

# Count English and Chinese content
find "$PROJECT_ROOT" -name "*.md" -type f | while read -r file; do
    if grep -q "[\u4e00-\u9fff]" "$file" 2>/dev/null; then
        if grep -q "[a-zA-Z]" "$file"; then
            log_info "Bilingual document detected: $(basename "$file")"
            log_info "检测到双语文档: $(basename "$file")"
        else
            log_info "Chinese document: $(basename "$file")"
            log_info "中文文档: $(basename "$file")"
        fi
    else
        log_info "English document: $(basename "$file")"
        log_info "英文文档: $(basename "$file")"
    fi
done

# 6. Generate documentation report
log_info "Generating documentation validation report... 生成文档验证报告..."

REPORT_FILE="$PROJECT_ROOT/docs/validation-report.md"
mkdir -p "$(dirname "$REPORT_FILE")"

cat > "$REPORT_FILE" << EOF
# Documentation Validation Report
# 文档验证报告

Generated on: $(date)
生成时间: $(date)

## Summary / 总结

This report was generated by the automated documentation validation script.
此报告由自动化文档验证脚本生成。

## Documents Found / 找到的文档

### Required Documents / 必需文档
EOF

for doc in "${REQUIRED_DOCS[@]}"; do
    if [ -f "$PROJECT_ROOT/$doc" ]; then
        echo "- ✅ $doc" >> "$REPORT_FILE"
    else
        echo "- ❌ $doc (missing / 缺失)" >> "$REPORT_FILE"
    fi
done

cat >> "$REPORT_FILE" << EOF

### Recommended Documents / 推荐文档
EOF

for doc in "${RECOMMENDED_DOCS[@]}"; do
    if [ -f "$PROJECT_ROOT/$doc" ]; then
        echo "- ✅ $doc" >> "$REPORT_FILE"
    else
        echo "- ⚠️ $doc (missing / 缺失)" >> "$REPORT_FILE"
    fi
done

if [ -d "$VERSIONS_DIR" ]; then
    cat >> "$REPORT_FILE" << EOF

### Version Documents / 版本文档

Found versions: ${VERSIONS[*]}
找到的版本: ${VERSIONS[*]}
EOF
fi

cat >> "$REPORT_FILE" << EOF

## Recommendations / 建议

1. Ensure all required documents are present / 确保所有必需文档都存在
2. Keep version documentation up to date / 保持版本文档更新
3. Maintain consistent terminology across languages / 在各语言之间保持术语一致
4. Review and fix any broken internal links / 检查并修复任何内部链接问题

---
Generated by Claude Code Documentation Validator
由Claude Code文档验证器生成
EOF

log_success "Documentation validation completed! 文档验证完成！"
log_info "Report generated: $REPORT_FILE"
log_info "报告已生成: $REPORT_FILE"

exit 0