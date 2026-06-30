# Changelog

## [1.0.0] - 2026-06-30

### Added
- Complete automated testing suite for Flutter, Next.js, and backend
- GitHub Actions CI/CD workflows with merge gates
- WebSocket reliability with exponential backoff, jitter, heartbeat, and duplicate prevention
- Content Security Policy and security headers
- Internationalization support (English, Arabic, French)
- Accessibility improvements with skip links, semantic labels, and keyboard navigation
- Performance optimization for markdown rendering, image caching, and lazy loading
- Release pipeline with Docker image builds and semantic versioning
- Developer experience documentation (README, CONTRIBUTING, API docs, ARCHITECTURE)

### Changed
- Enhanced security middleware with HSTS, CSP, and permission policies
- Improved rate limiting middleware
- Optimized Flutter theme system
- Updated all configurations for production readiness

### Fixed
- WebSocket reconnection logic
- Token refresh handling
- Missing API type definitions
- Duplicate message prevention in WebSocket
