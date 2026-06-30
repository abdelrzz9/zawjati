# Release Guide

## Versioning

Zawjati follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.x.x): Breaking changes
- **MINOR** (x.1.x): New features, backward compatible
- **PATCH** (x.x.1): Bug fixes, backward compatible

## Release Process

### 1. Prepare Release

```bash
# Ensure main branch is up to date
git checkout main
git pull origin main

# Run all tests
cd backend && pytest tests/ -v && cd ..
cd frontend/mobile && flutter test --coverage && cd ../..
cd frontend/web && npm test && cd ../..
```

### 2. Create Release Branch

```bash
git checkout -b release/v1.x.x
```

### 3. Update Version

Update version in:
- `backend/app/main.py` — version string
- `frontend/web/package.json` — version
- `frontend/mobile/pubspec.yaml` — version
- `CHANGELOG.md` — add release notes

### 4. Final Testing

```bash
# Backend tests
pytest tests/ -v --cov=backend.app

# Flutter tests
cd frontend/mobile && flutter test --coverage && cd ../..

# Next.js tests
cd frontend/web && npm test && npm run build && cd ../..
```

### 5. Tag and Release

```bash
git add .
git commit -m "chore: release v1.x.x"
git tag -a v1.x.x -m "Zawjati v1.x.x"
git push origin main --tags
```

The CI/CD pipeline will automatically:
1. Build Docker images
2. Push to GitHub Container Registry
3. Create a GitHub Release
4. Generate release notes

### 6. Deploy

```bash
# Pull the new Docker image
docker pull ghcr.io/yourusername/zawjati/backend:v1.x.x

# Deploy
docker compose up -d
```

### 7. Post-Release

- Monitor health checks
- Verify metrics endpoint
- Check error rates
- Update documentation if needed

## Hotfix Process

```bash
git checkout main
git checkout -b hotfix/v1.x.x
# Fix the issue
git commit -m "fix: description"
git tag -a v1.x.x -m "Hotfix v1.x.x"
git push origin main --tags
```
