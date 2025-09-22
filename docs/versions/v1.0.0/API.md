# API Specification Document v1.0.0
# API规范文档 v1.0.0

## Document Information / 文档信息
- **Version / 版本**: v1.0.0
- **Created / 创建**: 2025年09月22日 11:13:42
- **Last Updated / 最后更新**: 2025年09月22日 11:13:42
- **API Version / API版本**: v1

## API Overview / API概述

### Base Information / 基本信息
- **Base URL / 基础URL**: `https://api.example.com/v1`
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
```http
Authorization: Bearer <token>
```

### Token Acquisition / 令牌获取
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response / 响应**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600,
  "user": {
    "id": "123",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

## Core Endpoints / 核心端点

### Users / 用户

#### Get User Profile / 获取用户资料
```http
GET /users/me
Authorization: Bearer <token>
```

**Response / 响应**:
```json
{
  "id": "123",
  "email": "user@example.com",
  "name": "John Doe",
  "avatar": "https://example.com/avatar.jpg",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

#### Update User Profile / 更新用户资料
```http
PATCH /users/me
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Jane Doe",
  "avatar": "https://example.com/new-avatar.jpg"
}
```

### Projects / 项目

#### List Projects / 项目列表
```http
GET /projects
Authorization: Bearer <token>
```

**Query Parameters / 查询参数**:
- `page` (integer): Page number / 页码 (default: 1)
- `limit` (integer): Items per page / 每页项目数 (default: 10, max: 100)
- `search` (string): Search term / 搜索词
- `status` (string): Project status / 项目状态 (active, archived, draft)

**Response / 响应**:
```json
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
```

#### Create Project / 创建项目
```http
POST /projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "New Project",
  "description": "Project description",
  "tags": ["web", "api"]
}
```

#### Get Project / 获取项目
```http
GET /projects/{id}
Authorization: Bearer <token>
```

#### Update Project / 更新项目
```http
PATCH /projects/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Project Name",
  "description": "Updated description"
}
```

#### Delete Project / 删除项目
```http
DELETE /projects/{id}
Authorization: Bearer <token>
```

## Data Models / 数据模型

### User Model / 用户模型
```typescript
interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  role: 'user' | 'admin';
  createdAt: string;
  updatedAt: string;
}
```

### Project Model / 项目模型
```typescript
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
```

## Error Handling / 错误处理

### Error Response Format / 错误响应格式
```json
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
```

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
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

## Pagination / 分页

### Query Parameters / 查询参数
- `page`: Page number (starting from 1) / 页码（从1开始）
- `limit`: Items per page (max 100) / 每页项目数（最多100）

### Response Format / 响应格式
```json
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
```

## Webhooks / 网络钩子

### Configuration / 配置
```http
POST /webhooks
Authorization: Bearer <token>
Content-Type: application/json

{
  "url": "https://example.com/webhook",
  "events": ["project.created", "project.updated"],
  "secret": "webhook_secret_key"
}
```

### Event Types / 事件类型
- `user.created` / 用户已创建
- `user.updated` / 用户已更新
- `project.created` / 项目已创建
- `project.updated` / 项目已更新
- `project.deleted` / 项目已删除

## SDK Examples / SDK示例

### JavaScript/TypeScript
```typescript
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
```

### Python
```python
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
```

## Testing / 测试

### Test Environment / 测试环境
- **Base URL / 基础URL**: `https://api-staging.example.com/v1`
- **Test Credentials / 测试凭据**: Contact development team / 联系开发团队

### Postman Collection / Postman集合
[Link to Postman collection] / [Postman集合链接]

## Changelog / 更新日志

### Version v1.0.0
- Initial API documentation / 初始API文档
- Core endpoints implemented / 核心端点已实现
- Authentication system / 认证系统
- Error handling / 错误处理
