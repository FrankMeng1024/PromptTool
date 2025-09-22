#!/bin/bash
# Documentation Version Update Script
# 文档版本更新脚本

set -e

echo "📚 Starting documentation version update... 开始文档版本更新..."

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

# Function to get current version from package.json or default
get_current_version() {
    if [ -f "$PROJECT_ROOT/package.json" ]; then
        VERSION=$(grep '"version"' "$PROJECT_ROOT/package.json" | sed 's/.*"version": *"\([^"]*\)".*/\1/')
        echo "v$VERSION"
    else
        # Default version if no package.json
        echo "v1.0.0"
    fi
}

# Function to increment version
increment_version() {
    local version="$1"
    local type="${2:-patch}"  # patch, minor, major

    # Remove 'v' prefix
    version="${version#v}"

    # Split version into parts
    IFS='.' read -ra VERSION_PARTS <<< "$version"
    local major="${VERSION_PARTS[0]}"
    local minor="${VERSION_PARTS[1]:-0}"
    local patch="${VERSION_PARTS[2]:-0}"

    case "$type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            log_error "Invalid version type: $type"
            exit 1
            ;;
    esac

    echo "v$major.$minor.$patch"
}

# Create versions directory if it doesn't exist
mkdir -p "$VERSIONS_DIR"

# Get current version
CURRENT_VERSION=$(get_current_version)
log_info "Current version: $CURRENT_VERSION"
log_info "当前版本: $CURRENT_VERSION"

# Check if current version directory exists
CURRENT_VERSION_DIR="$VERSIONS_DIR/$CURRENT_VERSION"
if [ ! -d "$CURRENT_VERSION_DIR" ]; then
    log_info "Creating directory for current version: $CURRENT_VERSION"
    log_info "为当前版本创建目录: $CURRENT_VERSION"
    mkdir -p "$CURRENT_VERSION_DIR"
fi

# Function to create or update document template
create_document_template() {
    local doc_name="$1"
    local version="$2"
    local doc_path="$VERSIONS_DIR/$version/$doc_name"

    case "$doc_name" in
        "PRD.md")
            cat > "$doc_path" << EOF
# Product Requirements Document (PRD) $version
# 产品需求文档 $version

## Document Information / 文档信息
- **Version / 版本**: $version
- **Created / 创建**: $(date)
- **Last Updated / 最后更新**: $(date)

## Product Overview / 产品概述

### Vision / 愿景
Describe the product vision and goals here.
在此描述产品愿景和目标。

### Target Users / 目标用户
Define who will use this product.
定义谁将使用此产品。

## Features / 功能

### Core Features / 核心功能

#### Feature 1: [Feature Name]
**Description / 描述**:
Brief description of the feature.
功能的简要描述。

**User Stories / 用户故事**:
- As a user, I want to... so that...
- 作为用户，我希望...以便...

**Acceptance Criteria / 验收标准**:
- [ ] Criteria 1 / 标准1
- [ ] Criteria 2 / 标准2

### Secondary Features / 次要功能

## Technical Requirements / 技术要求

### Performance / 性能
- Response time requirements / 响应时间要求
- Scalability targets / 可扩展性目标

### Security / 安全
- Authentication requirements / 认证要求
- Data protection needs / 数据保护需求

## Constraints / 约束条件

### Technical Constraints / 技术约束
- Technology stack limitations / 技术栈限制
- Integration requirements / 集成要求

### Business Constraints / 业务约束
- Timeline / 时间表
- Budget / 预算
- Resources / 资源

## Success Metrics / 成功指标

### Key Performance Indicators (KPIs) / 关键性能指标
- Metric 1: Target value / 指标1: 目标值
- Metric 2: Target value / 指标2: 目标值

## Roadmap / 路线图

### Phase 1 / 第一阶段
- Timeline: [Start Date] - [End Date]
- 时间表: [开始日期] - [结束日期]
- Deliverables / 交付物:
  - Feature A / 功能A
  - Feature B / 功能B

### Phase 2 / 第二阶段
- Timeline: [Start Date] - [End Date]
- 时间表: [开始日期] - [结束日期]
- Deliverables / 交付物:
  - Feature C / 功能C
  - Feature D / 功能D

## Appendix / 附录

### References / 参考资料
- [Reference 1] / [参考资料1]
- [Reference 2] / [参考资料2]

### Glossary / 术语表
- **Term 1 / 术语1**: Definition / 定义
- **Term 2 / 术语2**: Definition / 定义
EOF
            ;;

        "ARCHITECTURE.md")
            cat > "$doc_path" << EOF
# System Architecture Document $version
# 系统架构文档 $version

## Document Information / 文档信息
- **Version / 版本**: $version
- **Created / 创建**: $(date)
- **Last Updated / 最后更新**: $(date)

## Architecture Overview / 架构概述

### System Purpose / 系统目的
Brief description of what the system does and its main objectives.
系统功能的简要描述及其主要目标。

### Key Design Principles / 关键设计原则
- Scalability / 可扩展性
- Maintainability / 可维护性
- Security / 安全性
- Performance / 性能

## System Components / 系统组件

### High-Level Architecture / 高级架构
\`\`\`
[Add architecture diagram here]
[在此添加架构图]
\`\`\`

### Component Descriptions / 组件描述

#### Frontend Layer / 前端层
- **Technology / 技术**: [e.g., React, Vue.js]
- **Purpose / 目的**: User interface and user experience
- **Key Features / 关键功能**:
  - Feature 1 / 功能1
  - Feature 2 / 功能2

#### Backend Layer / 后端层
- **Technology / 技术**: [e.g., Node.js, Python, Java]
- **Purpose / 目的**: Business logic and API endpoints
- **Key Features / 关键功能**:
  - API management / API管理
  - Business logic / 业务逻辑
  - Data validation / 数据验证

#### Database Layer / 数据库层
- **Technology / 技术**: [e.g., PostgreSQL, MongoDB]
- **Purpose / 目的**: Data persistence and management
- **Key Features / 关键功能**:
  - Data storage / 数据存储
  - Query optimization / 查询优化
  - Backup and recovery / 备份和恢复

## Data Flow / 数据流

### Request Flow / 请求流程
1. User initiates request / 用户发起请求
2. Frontend processes input / 前端处理输入
3. API call to backend / 调用后端API
4. Backend processes request / 后端处理请求
5. Database interaction / 数据库交互
6. Response sent back / 返回响应

### Data Models / 数据模型
\`\`\`typescript
// Example data model
interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}
\`\`\`

## Technology Stack / 技术栈

### Frontend / 前端
- Framework: [Technology] / 框架: [技术]
- State Management: [Technology] / 状态管理: [技术]
- Styling: [Technology] / 样式: [技术]

### Backend / 后端
- Runtime: [Technology] / 运行时: [技术]
- Framework: [Technology] / 框架: [技术]
- Authentication: [Technology] / 认证: [技术]

### Database / 数据库
- Primary Database: [Technology] / 主数据库: [技术]
- Caching: [Technology] / 缓存: [技术]

### DevOps / 运维
- Containerization: [Technology] / 容器化: [技术]
- CI/CD: [Technology] / 持续集成/部署: [技术]
- Monitoring: [Technology] / 监控: [技术]

## Security Architecture / 安全架构

### Authentication / 认证
- Method: [e.g., JWT, OAuth2] / 方法: [例如: JWT, OAuth2]
- Implementation details / 实现细节

### Authorization / 授权
- Role-based access control / 基于角色的访问控制
- Permission management / 权限管理

### Data Protection / 数据保护
- Encryption at rest / 静态加密
- Encryption in transit / 传输加密
- Data anonymization / 数据匿名化

## Performance Considerations / 性能考虑

### Scalability Strategy / 可扩展性策略
- Horizontal scaling / 水平扩展
- Load balancing / 负载均衡
- Caching strategy / 缓存策略

### Performance Targets / 性能目标
- Response time: < 200ms / 响应时间: < 200ms
- Throughput: X requests/second / 吞吐量: X 请求/秒
- Availability: 99.9% / 可用性: 99.9%

## Deployment Architecture / 部署架构

### Environment Setup / 环境设置
- Development / 开发环境
- Staging / 测试环境
- Production / 生产环境

### Infrastructure / 基础设施
- Cloud provider: [e.g., AWS, Azure] / 云服务商: [例如: AWS, Azure]
- Container orchestration / 容器编排
- Database hosting / 数据库托管

## Monitoring and Logging / 监控和日志

### Monitoring Strategy / 监控策略
- Application performance monitoring / 应用性能监控
- Infrastructure monitoring / 基础设施监控
- User experience monitoring / 用户体验监控

### Logging Strategy / 日志策略
- Log levels and categories / 日志级别和分类
- Log aggregation and analysis / 日志聚合和分析
- Retention policies / 保留策略

## Risk Assessment / 风险评估

### Technical Risks / 技术风险
- Risk 1: Description and mitigation / 风险1: 描述和缓解措施
- Risk 2: Description and mitigation / 风险2: 描述和缓解措施

### Operational Risks / 运营风险
- Risk 1: Description and mitigation / 风险1: 描述和缓解措施
- Risk 2: Description and mitigation / 风险2: 描述和缓解措施

## Future Considerations / 未来考虑

### Planned Improvements / 计划改进
- Architecture evolution / 架构演进
- Technology upgrades / 技术升级
- Performance optimizations / 性能优化

### Scalability Roadmap / 可扩展性路线图
- Short-term (3-6 months) / 短期 (3-6个月)
- Medium-term (6-12 months) / 中期 (6-12个月)
- Long-term (1+ years) / 长期 (1年以上)
EOF
            ;;

        "API.md")
            cat > "$doc_path" << EOF
# API Specification Document $version
# API规范文档 $version

## Document Information / 文档信息
- **Version / 版本**: $version
- **Created / 创建**: $(date)
- **Last Updated / 最后更新**: $(date)
- **API Version / API版本**: v1

## API Overview / API概述

### Base Information / 基本信息
- **Base URL / 基础URL**: \`https://api.example.com/v1\`
- **Protocol / 协议**: HTTPS
- **Authentication / 认证**: Bearer Token
- **Response Format / 响应格式**: JSON

### Design Principles / 设计原则
- RESTful design / RESTful设计
- Consistent naming conventions / 一致的命名约定
- Comprehensive error handling / 全面的错误处理
- Proper HTTP status codes / 正确的HTTP状态码

## Authentication / 认证

### Bearer Token / 承载令牌
\`\`\`http
Authorization: Bearer <token>
\`\`\`

### Token Acquisition / 令牌获取
\`\`\`http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
\`\`\`

**Response / 响应**:
\`\`\`json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600,
  "user": {
    "id": "123",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
\`\`\`

## Core Endpoints / 核心端点

### Users / 用户

#### Get User Profile / 获取用户资料
\`\`\`http
GET /users/me
Authorization: Bearer <token>
\`\`\`

**Response / 响应**:
\`\`\`json
{
  "id": "123",
  "email": "user@example.com",
  "name": "John Doe",
  "avatar": "https://example.com/avatar.jpg",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
\`\`\`

#### Update User Profile / 更新用户资料
\`\`\`http
PATCH /users/me
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Jane Doe",
  "avatar": "https://example.com/new-avatar.jpg"
}
\`\`\`

### Projects / 项目

#### List Projects / 项目列表
\`\`\`http
GET /projects
Authorization: Bearer <token>
\`\`\`

**Query Parameters / 查询参数**:
- \`page\` (integer): Page number / 页码 (default: 1)
- \`limit\` (integer): Items per page / 每页项目数 (default: 10, max: 100)
- \`search\` (string): Search term / 搜索词
- \`status\` (string): Project status / 项目状态 (active, archived, draft)

**Response / 响应**:
\`\`\`json
{
  "data": [
    {
      "id": "proj_123",
      "name": "My Project",
      "description": "Project description",
      "status": "active",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 25,
    "totalPages": 3
  }
}
\`\`\`

#### Create Project / 创建项目
\`\`\`http
POST /projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "New Project",
  "description": "Project description",
  "tags": ["web", "api"]
}
\`\`\`

#### Get Project / 获取项目
\`\`\`http
GET /projects/{id}
Authorization: Bearer <token>
\`\`\`

#### Update Project / 更新项目
\`\`\`http
PATCH /projects/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Project Name",
  "description": "Updated description"
}
\`\`\`

#### Delete Project / 删除项目
\`\`\`http
DELETE /projects/{id}
Authorization: Bearer <token>
\`\`\`

## Data Models / 数据模型

### User Model / 用户模型
\`\`\`typescript
interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  role: 'user' | 'admin';
  createdAt: string;
  updatedAt: string;
}
\`\`\`

### Project Model / 项目模型
\`\`\`typescript
interface Project {
  id: string;
  name: string;
  description: string;
  status: 'draft' | 'active' | 'archived';
  tags: string[];
  ownerId: string;
  createdAt: string;
  updatedAt: string;
}
\`\`\`

## Error Handling / 错误处理

### Error Response Format / 错误响应格式
\`\`\`json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  }
}
\`\`\`

### Common Error Codes / 常见错误代码

| Status Code | Error Code | Description |
|------------|------------|-------------|
| 400 | VALIDATION_ERROR | Request validation failed / 请求验证失败 |
| 401 | UNAUTHORIZED | Authentication required / 需要认证 |
| 403 | FORBIDDEN | Access denied / 访问被拒绝 |
| 404 | NOT_FOUND | Resource not found / 资源未找到 |
| 409 | CONFLICT | Resource already exists / 资源已存在 |
| 429 | RATE_LIMITED | Too many requests / 请求过多 |
| 500 | INTERNAL_ERROR | Internal server error / 内部服务器错误 |

## Rate Limiting / 速率限制

### Limits / 限制
- **General endpoints / 一般端点**: 1000 requests/hour
- **Authentication endpoints / 认证端点**: 100 requests/hour
- **Upload endpoints / 上传端点**: 50 requests/hour

### Headers / 请求头
\`\`\`http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
\`\`\`

## Pagination / 分页

### Query Parameters / 查询参数
- \`page\`: Page number (starting from 1) / 页码（从1开始）
- \`limit\`: Items per page (max 100) / 每页项目数（最多100）

### Response Format / 响应格式
\`\`\`json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "totalPages": 10,
    "hasNext": true,
    "hasPrev": false
  }
}
\`\`\`

## Webhooks / 网络钩子

### Configuration / 配置
\`\`\`http
POST /webhooks
Authorization: Bearer <token>
Content-Type: application/json

{
  "url": "https://example.com/webhook",
  "events": ["project.created", "project.updated"],
  "secret": "webhook_secret_key"
}
\`\`\`

### Event Types / 事件类型
- \`user.created\` / 用户已创建
- \`user.updated\` / 用户已更新
- \`project.created\` / 项目已创建
- \`project.updated\` / 项目已更新
- \`project.deleted\` / 项目已删除

## SDK Examples / SDK示例

### JavaScript/TypeScript
\`\`\`typescript
import { ApiClient } from '@project/api-client';

const client = new ApiClient({
  baseURL: 'https://api.example.com/v1',
  token: 'your-auth-token'
});

// Get user profile
const user = await client.users.getMe();

// List projects
const projects = await client.projects.list({
  page: 1,
  limit: 10
});

// Create project
const newProject = await client.projects.create({
  name: 'My New Project',
  description: 'Project description'
});
\`\`\`

### Python
\`\`\`python
from project_api import ApiClient

client = ApiClient(
    base_url='https://api.example.com/v1',
    token='your-auth-token'
)

# Get user profile
user = client.users.get_me()

# List projects
projects = client.projects.list(page=1, limit=10)

# Create project
new_project = client.projects.create({
    'name': 'My New Project',
    'description': 'Project description'
})
\`\`\`

## Testing / 测试

### Test Environment / 测试环境
- **Base URL / 基础URL**: \`https://api-staging.example.com/v1\`
- **Test Credentials / 测试凭据**: Contact development team / 联系开发团队

### Postman Collection / Postman集合
[Link to Postman collection] / [Postman集合链接]

## Changelog / 更新日志

### Version $version
- Initial API documentation / 初始API文档
- Core endpoints implemented / 核心端点已实现
- Authentication system / 认证系统
- Error handling / 错误处理
EOF
            ;;

        "CHANGELOG.md")
            cat > "$doc_path" << EOF
# Changelog $version
# 更新日志 $version

## [$version] - $(date +%Y-%m-%d)

### Added / 新增
- Initial project setup / 初始项目设置
- Core documentation structure / 核心文档结构
- Version management system / 版本管理系统

### Changed / 更改
- Documentation templates updated / 文档模板已更新
- Project structure improvements / 项目结构改进

### Fixed / 修复
- Documentation consistency issues / 文档一致性问题
- Template formatting / 模板格式化

### Security / 安全
- Added security scanning / 添加安全扫描
- Implemented access controls / 实施访问控制

---

## Format / 格式说明

This changelog follows the [Keep a Changelog](https://keepachangelog.com/) format.
此更新日志遵循 [Keep a Changelog](https://keepachangelog.com/) 格式。

### Types of changes / 变更类型:
- **Added / 新增**: for new features / 新功能
- **Changed / 更改**: for changes in existing functionality / 现有功能的更改
- **Deprecated / 弃用**: for soon-to-be removed features / 即将删除的功能
- **Removed / 删除**: for now removed features / 现已删除的功能
- **Fixed / 修复**: for any bug fixes / 错误修复
- **Security / 安全**: in case of vulnerabilities / 安全漏洞修复
EOF
            ;;
    esac

    log_success "Created/updated $doc_name for $version"
    log_success "已创建/更新 $version 的 $doc_name"
}

# 1. Update current version documents
log_info "Updating documents for current version: $CURRENT_VERSION"
log_info "更新当前版本的文档: $CURRENT_VERSION"

CORE_DOCS=("PRD.md" "ARCHITECTURE.md" "API.md" "CHANGELOG.md")

for doc in "${CORE_DOCS[@]}"; do
    create_document_template "$doc" "$CURRENT_VERSION"
done

# 2. Check if we need to create a new version
if [ "$1" = "--new-version" ]; then
    VERSION_TYPE="${2:-minor}"  # patch, minor, major
    NEW_VERSION=$(increment_version "$CURRENT_VERSION" "$VERSION_TYPE")

    log_info "Creating new version: $NEW_VERSION"
    log_info "创建新版本: $NEW_VERSION"

    NEW_VERSION_DIR="$VERSIONS_DIR/$NEW_VERSION"
    mkdir -p "$NEW_VERSION_DIR"

    # Copy current version as base for new version
    if [ -d "$CURRENT_VERSION_DIR" ]; then
        cp -r "$CURRENT_VERSION_DIR"/* "$NEW_VERSION_DIR/"
        log_success "Copied $CURRENT_VERSION documents to $NEW_VERSION"
        log_success "已将 $CURRENT_VERSION 文档复制到 $NEW_VERSION"
    fi

    # Update changelog for new version
    create_document_template "CHANGELOG.md" "$NEW_VERSION"

    # Create CHANGES.md to document what changed from previous version
    cat > "$NEW_VERSION_DIR/CHANGES.md" << EOF
# Version Change Document 版本变更文档 $NEW_VERSION

## Basic Information 基础信息
- **Base Version 基于版本**: $CURRENT_VERSION
- **Target Version 目标版本**: $NEW_VERSION
- **Change Type 变更类型**: $VERSION_TYPE
- **Change Date 变更日期**: $(date)

## Summary 概要
Brief description of what changed in this version.
此版本变更的简要描述。

## Requirement Changes 需求变更

### New Features 新增功能
- Feature 1: Description / 功能1: 描述
- Feature 2: Description / 功能2: 描述

### Modified Features 修改功能
- Feature X: Change description / 功能X: 变更描述

### Removed Features 删除功能
- Feature Y: Removal reason / 功能Y: 删除原因

## Technical Changes 技术变更

### Architecture Adjustments 架构调整
- Change 1: Description and reason / 变更1: 描述和原因

### Database Changes 数据库变更
- Migration required: Yes/No / 是否需要迁移: 是/否
- Backup required: Yes/No / 是否需要备份: 是/否

### API Changes API变更
- Breaking changes: List any breaking changes / 破坏性变更: 列出任何破坏性变更
- New endpoints: List new endpoints / 新端点: 列出新端点

## Impact Analysis 影响分析

### Code Files 代码文件
- Files to modify 需要修改的文件: [To be determined]
- Files to add 需要新增的文件: [To be determined]
- Files to delete 需要删除的文件: [To be determined]

### Testing Requirements 测试要求
- New test cases 新增测试用例: [To be determined]
- Regression tests 回归测试: Required / 必需

## Claude Code Execution Instructions Claude Code 执行指令

\`\`\`bash
# Step 1: Analyze differences 步骤1: 分析差异
claude-code "Analyze differences between docs/versions/$CURRENT_VERSION and docs/versions/$NEW_VERSION"

# Step 2: Update implementation 步骤2: 更新实现
claude-code "Update code implementation based on changes documented in docs/versions/$NEW_VERSION/CHANGES.md"

# Step 3: Update tests 步骤3: 更新测试
claude-code "Add test cases for new features and update existing tests based on version changes"

# Step 4: Verify changes 步骤4: 验证变更
claude-code "Run tests and verify all functionality works correctly"
\`\`\`

## Deployment Checklist 部署清单
- [ ] Code changes implemented / 代码变更已实现
- [ ] Tests updated and passing / 测试已更新并通过
- [ ] Documentation updated / 文档已更新
- [ ] Database migration prepared (if needed) / 数据库迁移已准备（如需要）
- [ ] Deployment plan reviewed / 部署计划已审查
- [ ] Rollback plan prepared / 回滚计划已准备

---
Generated by Claude Code Documentation Version Manager
由Claude Code文档版本管理器生成
EOF

    log_success "Created CHANGES.md for $NEW_VERSION"
    log_success "已为 $NEW_VERSION 创建 CHANGES.md"

    # Update package.json version if it exists
    if [ -f "$PROJECT_ROOT/package.json" ]; then
        # Remove 'v' prefix for package.json
        PACKAGE_VERSION="${NEW_VERSION#v}"
        sed -i.bak "s/\"version\": *\"[^\"]*\"/\"version\": \"$PACKAGE_VERSION\"/" "$PROJECT_ROOT/package.json"
        rm -f "$PROJECT_ROOT/package.json.bak"
        log_success "Updated package.json version to $PACKAGE_VERSION"
        log_success "已将package.json版本更新为 $PACKAGE_VERSION"
    fi
fi

# 3. Generate version summary report
log_info "Generating version summary... 生成版本总结..."

SUMMARY_FILE="$DOCS_DIR/version-summary.md"
cat > "$SUMMARY_FILE" << EOF
# Documentation Version Summary
# 文档版本总结

Generated on: $(date)
生成时间: $(date)

## Available Versions / 可用版本
EOF

if [ -d "$VERSIONS_DIR" ]; then
    find "$VERSIONS_DIR" -maxdepth 1 -type d -name "v*" | sort -V | while read -r version_dir; do
        version_name=$(basename "$version_dir")
        echo "- **$version_name**: $(find "$version_dir" -name "*.md" | wc -l) documents" >> "$SUMMARY_FILE"
    done
else
    echo "No versions found / 未找到版本" >> "$SUMMARY_FILE"
fi

cat >> "$SUMMARY_FILE" << EOF

## Current Version / 当前版本
$CURRENT_VERSION

## Last Updated / 最后更新
$(date)

## Usage / 使用方法

### Create New Version / 创建新版本
\`\`\`bash
bash scripts/update-doc-versions.sh --new-version [patch|minor|major]
\`\`\`

### Examples / 示例
\`\`\`bash
# Create patch version (v1.0.0 -> v1.0.1)
bash scripts/update-doc-versions.sh --new-version patch

# Create minor version (v1.0.1 -> v1.1.0)
bash scripts/update-doc-versions.sh --new-version minor

# Create major version (v1.1.0 -> v2.0.0)
bash scripts/update-doc-versions.sh --new-version major
\`\`\`

---
Generated by Claude Code Documentation Version Manager
由Claude Code文档版本管理器生成
EOF

log_success "🎉 Documentation version update completed! 文档版本更新完成！"
log_info "Summary report generated: $SUMMARY_FILE"
log_info "总结报告已生成: $SUMMARY_FILE"

if [ "$1" = "--new-version" ]; then
    log_info "🚀 New version $NEW_VERSION created and ready for development"
    log_info "🚀 新版本 $NEW_VERSION 已创建并准备开发"
    log_info "Next steps / 下一步:"
    echo "  1. Review and update the CHANGES.md file"
    echo "     检查并更新 CHANGES.md 文件"
    echo "  2. Run Claude Code to implement changes"
    echo "     运行 Claude Code 实现变更"
    echo "  3. Test and validate the implementation"
    echo "     测试并验证实现"
fi

exit 0