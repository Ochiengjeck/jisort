# API Documentation

## Authentication

All authenticated endpoints require a Bearer token in the Authorization header:
`Authorization: Bearer {token}`

## Endpoints

### Authentication

#### POST /api/auth/register
Register a new user account.

**Request Body:**
```json
{
    "first_name": "John",
    "last_name": "Doe",
    "username Tuesday, July 22, 2025
username": "johndoe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "password": "password123",
    "password_confirmation": "password123"
}
```

#### POST /api/auth/login
Login with email/username and password.

**Request Body:**
```json
{
    "login": "john@example.com",
    "password": "password123"
}
```

#### GET /api/auth/me
Get current authenticated user information.

#### POST /api/auth/logout
Logout from current device.

#### POST /api/auth/logout-all
Logout from all devices.

### Users

#### GET /api/users
Get paginated list of users with optional search and filters.

**Query Parameters:**
- `search`: Search by name, email, or username
- `status`: Filter by user status (active, inactive, suspended)
- `role`: Filter by user role
- `sort_by`: Sort field (default: created_at)
- `sort_order`: Sort order (asc, desc - default: desc)
- `per_page`: Results per page (default: 15, max: 100)

#### GET /api/users/{id}
Get specific user details.

#### PUT /api/users/profile
Update current user's profile.

#### PUT /api/users/{id}/status
Update user status (admin only).

#### DELETE /api/users/{id}
Delete user (admin only).

### Health Check

#### GET /api/health
Check API health status.

## Error Responses

All endpoints return errors in the following format:
```json
{
    "message": "Error description",
    "errors": {
        "field": ["Validation error message"]
    }
}
```

## Rate Limiting

API requests are rate-limited to 100 requests per minute per user/IP.
Login attempts are limited to 5 attempts per 15 minutes per IP.
