# Check Service Performance

Analyze and test the performance of MasterFabric Serverpod services.

## Usage

```
/check-performance-service [service_name] [options]
```

## Arguments

- `service_name` - Optional. Specific service to check (e.g., `greeting`, `health`, `translation`)
- If omitted, checks all services

## Performance Checks

### 1. Health Endpoint Check

Test server health and get all service statuses:

```bash
# Using curl
curl -X POST http://localhost:8080/health/check \
  -H "Content-Type: application/json" \
  -d '{}'

# Expected response includes:
# - Database latency
# - Cache latency  
# - Translation service status
# - Overall health status
```

### 2. Quick Ping Test

Minimal latency check:

```bash
curl -X POST http://localhost:8080/health/ping \
  -H "Content-Type: application/json" \
  -d '{}'
# Returns: "pong"
```

### 3. Endpoint Latency Test

Test specific endpoint response times:

```bash
# Greeting endpoint (with rate limit info)
time curl -X POST http://localhost:8080/greeting/hello \
  -H "Content-Type: application/json" \
  -d '{"name": "performance-test"}'

# Translation endpoint
time curl -X POST http://localhost:8080/translation/getTranslations \
  -H "Content-Type: application/json" \
  -d '{"locale": "en"}'

# App config endpoint
time curl -X POST http://localhost:8080/appConfig/getConfig \
  -H "Content-Type: application/json" \
  -d '{}'
```

### 4. Rate Limit Status Check

Check current rate limit status from response:

```bash
# Response includes:
# - rateLimitMax: Maximum requests allowed
# - rateLimitRemaining: Requests left in window
# - rateLimitResetInSeconds: Time until reset
```

### 5. Load Test (Multiple Requests)

```bash
# Test 10 sequential requests
for i in {1..10}; do
  echo "Request $i:"
  time curl -s -X POST http://localhost:8080/health/ping \
    -H "Content-Type: application/json" \
    -d '{}' > /dev/null
done

# Parallel requests (requires GNU parallel)
seq 10 | parallel -j5 'curl -s -X POST http://localhost:8080/health/ping \
  -H "Content-Type: application/json" -d "{}"'
```

## Performance Metrics to Check

| Metric | Good | Degraded | Bad |
|--------|------|----------|-----|
| Health ping | < 50ms | 50-200ms | > 200ms |
| Database query | < 100ms | 100-500ms | > 500ms |
| Cache operation | < 50ms | 50-100ms | > 100ms |
| API endpoint | < 200ms | 200-1000ms | > 1s |

## Server-Side Logging

Check server logs for performance data:

```bash
# View recent logs with timing info
tail -f masterfabric_serverpod_server/logs/server.log | grep -E "(ms|latency|duration)"

# Or if using Docker
docker compose logs -f masterfabric_serverpod_server
```

## Database Performance

```bash
# Check PostgreSQL connection pool
docker compose exec postgres psql -U postgres -d masterfabric_serverpod -c "
  SELECT count(*) as active_connections 
  FROM pg_stat_activity 
  WHERE datname = 'masterfabric_serverpod';
"

# Check slow queries
docker compose exec postgres psql -U postgres -d masterfabric_serverpod -c "
  SELECT query, calls, mean_exec_time, total_exec_time 
  FROM pg_stat_statements 
  ORDER BY mean_exec_time DESC 
  LIMIT 5;
"
```

## Redis/Cache Performance

```bash
# Check Redis info
docker compose exec redis redis-cli INFO stats | grep -E "(hits|misses|ops)"

# Check memory usage
docker compose exec redis redis-cli INFO memory | grep used_memory_human
```

## Flutter Client Performance

Test from Flutter app's service test screen:
1. Open app → Service Test → Health tab
2. Click "Refresh" to see latency for each service
3. Check API Test tab for endpoint-specific timings

## Automated Performance Script

Create this script to run all checks:

```bash
#!/bin/bash
# save as: check-performance.sh

echo "=== MasterFabric Performance Check ==="
echo ""

BASE_URL="http://localhost:8080"

echo "1. Ping Test"
time curl -s -X POST $BASE_URL/health/ping -H "Content-Type: application/json" -d '{}'
echo ""

echo "2. Health Check"
curl -s -X POST $BASE_URL/health/check -H "Content-Type: application/json" -d '{}' | jq '.totalLatencyMs'
echo "ms total"

echo ""
echo "3. Greeting (with rate limit)"
curl -s -X POST $BASE_URL/greeting/hello -H "Content-Type: application/json" \
  -d '{"name":"perf-test"}' | jq '{remaining: .rateLimitRemaining, max: .rateLimitMax}'

echo ""
echo "4. Translation"
time curl -s -X POST $BASE_URL/translation/getTranslations \
  -H "Content-Type: application/json" -d '{"locale":"en"}' > /dev/null

echo ""
echo "=== Done ==="
```

## Troubleshooting Slow Performance

| Issue | Check | Solution |
|-------|-------|----------|
| High latency | Health endpoint | Check DB/Redis connections |
| Rate limited | `rateLimitRemaining` | Wait for reset or increase limits |
| Timeout | Server logs | Check for blocking operations |
| Memory issues | Docker stats | Restart services or increase memory |

## Quick Commands

```bash
# Check if server is running
curl -s http://localhost:8080/health/ping && echo "OK" || echo "FAIL"

# Get full health report
curl -s -X POST http://localhost:8080/health/check \
  -H "Content-Type: application/json" -d '{}' | jq '.'

# Check Docker resource usage
docker stats --no-stream
```
