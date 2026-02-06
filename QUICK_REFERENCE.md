# Quick Reference Guide

## 🚀 Quick Commands

### Using Makefile (Recommended)

```bash
make help           # Show all available commands
make quick-start    # First-time setup (creates .env and starts services)
make up             # Start services
make down           # Stop services  
make restart        # Restart services
make logs-follow    # Follow logs in real-time
make status         # Show service status
make health         # Check service health
make clean          # Stop and remove containers (keeps data)
make clean-all      # Remove everything including data (⚠️ DESTRUCTIVE)
```

### Using Docker Compose

```bash
docker compose up -d           # Start services
docker compose down            # Stop services
docker compose restart         # Restart services
docker compose logs -f         # Follow logs
docker compose ps              # Show status
docker compose pull            # Pull latest images
docker compose down -v         # Remove everything with volumes
```

## 🔑 Default Credentials

- **SonarQube Web UI**
  - URL: http://localhost:9000
  - Username: `admin`
  - Password: `admin`
  - ⚠️ **Change immediately after first login!**

- **PostgreSQL Database**
  - Host: `localhost` (internal: `db`)
  - Port: `5432`
  - Database: `sonar`
  - Username: `sonar`
  - Password: `sonar` (configured in `.env`)

## 📁 Important Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Main configuration |
| `.env` | Environment variables (git-ignored) |
| `.env.example` | Environment template |
| `Makefile` | Management commands |
| `README.md` | Main documentation |
| `TROUBLESHOOTING.md` | Detailed problem solving |
| `SECURITY.md` | Security best practices |

## 🔧 Environment Variables

```env
# Database
POSTGRES_USER=sonar
POSTGRES_PASSWORD=sonar
POSTGRES_DB=sonar

# SonarQube
SONARQUBE_PORT=9000
SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar
SONAR_JDBC_USERNAME=sonar
SONAR_JDBC_PASSWORD=sonar

# JVM Options
SONARQUBE_JAVA_OPTS=-Xmx2g -Xms512m
```

## 📊 Resource Requirements

### Minimum
- 2 CPU cores
- 4GB RAM
- 10GB disk space

### Recommended
- 4+ CPU cores
- 8GB+ RAM
- 50GB+ disk space

## 🐳 Docker Volumes

```bash
sonarqube_pg_data         # PostgreSQL data
sonarqube_sq_data         # SonarQube data
sonarqube_sq_extensions   # Plugins
sonarqube_sq_logs         # Logs
```

## 🔍 Troubleshooting Quick Fixes

### Services won't start
```bash
docker compose down
docker compose up -d
```

### Database connection failed
```bash
docker compose down
docker compose up -d db
sleep 30
docker compose up -d sonarqube
```

### Performance issues
Edit `.env`:
```env
SONARQUBE_JAVA_OPTS=-Xmx4g -Xms1g
```
Then restart:
```bash
docker compose restart sonarqube
```

### Port already in use
Edit `.env`:
```env
SONARQUBE_PORT=9001
```
Then restart:
```bash
docker compose down
docker compose up -d
```

### View detailed logs
```bash
docker compose logs sonarqube | tail -100
docker compose logs db | tail -100
```

### Fresh restart (removes data)
```bash
docker compose down -v
docker compose up -d
```

## 🔐 Security Checklist

- [ ] Change default admin password (admin/admin)
- [ ] Update `.env` with strong passwords
- [ ] Never commit `.env` to git
- [ ] Use HTTPS in production (reverse proxy)
- [ ] Regularly update images: `docker compose pull`
- [ ] Configure firewall rules
- [ ] Enable authentication
- [ ] Review user permissions

## 📦 Backup & Restore

### Backup
```bash
make backup-volumes
# Or manually:
mkdir -p backups
docker run --rm \
  -v sonarqube_sq_data:/data \
  -v $(PWD)/backups:/backup \
  alpine tar czf /backup/sq_data_$(date +%Y%m%d).tar.gz -C /data .
```

### Restore
```bash
docker compose down
docker volume rm sonarqube_sq_data
docker volume create sonarqube_sq_data
docker run --rm \
  -v sonarqube_sq_data:/data \
  -v $(PWD)/backups:/backup \
  alpine tar xzf /backup/sq_data_YYYYMMDD.tar.gz -C /data
docker compose up -d
```

## 🆘 Getting Help

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. View logs: `make logs-follow`
3. Check status: `make health`
4. Create GitHub issue with:
   - Error messages
   - `docker compose ps` output
   - Relevant logs
   - System info (OS, Docker version)

## 🔗 Useful Links

- [Main Documentation](README.md)
- [Troubleshooting Guide](TROUBLESHOOTING.md)
- [Security Policy](SECURITY.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Project Structure](PROJECT_STRUCTURE.md)
- [SonarQube Docs](https://docs.sonarqube.org/latest/)
- [Docker Docs](https://docs.docker.com/)

---

**Quick Start for New Users:**
```bash
make quick-start
```

This will:
1. Create `.env` from `.env.example`
2. Start all services
3. Display access information
