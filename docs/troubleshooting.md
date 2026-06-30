# Troubleshooting Guide

## Common Issues

### Backend won't start

**Symptoms:**
- `uvicorn` fails to start
- Port already in use error
- Module import errors

**Solutions:**
```bash
# Check if port is in use
lsof -i :8000

# Verify Python version
python --version  # Must be 3.12+

# Reinstall dependencies
pip install -r requirements.txt --force-reinstall

# Check for syntax errors
python -m py_compile app/main.py
```

### Environment variables not loading

**Solution:**
```bash
# Ensure .env file exists
cp .env.example .env

# Verify pydantic-settings is installed
pip install pydantic-settings
```

### LLM API errors

**Symptoms:**
- `RateLimitError`
- `AuthenticationError`
- `ModelNotFoundError`

**Solutions:**
- Verify API key is set in `.env`
- Check rate limits for your API tier
- Verify model name is correct
- Check API provider status page

### CORS errors (Web frontend)

**Symptoms:**
- Browser console shows CORS errors
- API requests blocked

**Solutions:**
- Verify `CORS_ORIGINS` includes your frontend URL
- Check for protocol mismatch (http vs https)
- Ensure no trailing slashes in origins

### WebSocket disconnections

**Symptoms:**
- Chat stops responding
- "WebSocket disconnected" in logs

**Solutions:**
- Check network stability
- Verify WebSocket URL is correct (ws:// vs wss://)
- Check for proxy/load balancer WebSocket support
- The client will auto-reconnect with exponential backoff

### Flutter build failures

**Solutions:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check Dart SDK version
dart --version  # Must be 3.11+
```

### Memory issues

**Symptoms:**
- Slow responses
- High memory usage
- Stale memories

**Solutions:**
- Reduce `max_history_messages` in config
- Reduce `max_context_tokens`
- Clear conversation history
- Restart the server (in-memory stores reset)

### Rate limiting

**Symptoms:**
- 429 Too Many Requests responses

**Solutions:**
- Increase `RATE_LIMIT_PER_MINUTE` in config
- Add more backend instances behind a load balancer
- Implement client-side throttling

## Diagnostic Commands

```bash
# Check backend health
curl http://localhost:8000/health

# Check readiness
curl http://localhost:8000/ready

# Get metrics
curl http://localhost:8000/api/metrics

# Test chat endpoint
curl -X POST http://localhost:8000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Hello","user_id":"test"}'
```

## Getting Help

- Check the FAQ in the repository
- Search existing GitHub issues
- Open a new issue with:
  - Steps to reproduce
  - Expected behavior
  - Actual behavior
  - Logs and error messages
  - Environment details
