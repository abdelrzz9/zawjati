# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in Zawjati, please report it privately.

**Do not report security vulnerabilities through public GitHub issues.**

Instead, please send an email to security@zawjati.app (or use the project's private reporting mechanism).

You should receive a response within 48 hours. If you don't, please follow up.

## Security Measures

### API
- Rate limiting: 60 requests per minute per IP
- CORS: Configurable origins
- CSP: Content Security Policy enforced
- HSTS: Strict Transport Security
- Input validation: Pydantic schemas
- Output sanitization: HTML tags stripped from tool output

### Authentication
- JWT-based authentication
- Refresh token rotation
- Session management
- Secure token storage (Flutter Secure Storage)

### Data Protection
- No plaintext secrets in code
- Environment-based configuration
- Secure logging (no secrets in logs)
- HTTPS enforcement in production

### Dependency Management
- Regular dependency audits
- Automated vulnerability scanning in CI

## Security Checklist

- [x] No hardcoded secrets
- [x] Input validation on all endpoints
- [x] Output sanitization
- [x] Rate limiting
- [x] Security headers
- [x] CSP enforcement
- [x] HSTS enabled
- [x] CORS configured
- [x] Non-root container user
- [x] Dependency scanning
- [x] Secure logging
