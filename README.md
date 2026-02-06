# SonarQube Docker Setup

[![Docker](https://img.shields.io/badge/Docker-20.10+-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Docker Compose](https://img.shields.io/badge/Docker%20Compose-V2-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![SonarQube](https://img.shields.io/badge/SonarQube-Community-4E9BCD?logo=sonarqube&logoColor=white)](https://www.sonarqube.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A production-ready Docker Compose setup for SonarQube with PostgreSQL database.

## ✨ Features

- 🚀 Quick setup with Docker Compose
- 🔒 PostgreSQL database with health checks
- 📊 Persistent data volumes
- ⚙️ Resource limits for stability
- 🔄 Automatic restart policies
- 📝 Comprehensive documentation
- 🛠️ Management commands via Makefile
- 🔐 Security best practices

## 📋 Prerequisites

- Docker Engine 20.10+
- Docker Compose V2
- At least 4GB RAM available for containers
- At least 2 CPU cores recommended

## 🚀 Quick Start

### Using Makefile (Recommended)

```bash
# First-time setup and start
make quick-start

# View logs
make logs-follow

# Check status
make status
```

### Manual Setup

1. **Clone the repository**

   ```bash
   git clone <your-repository-url>
   cd SonarQube
   ```

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```

3. **Configure environment variables**
   Edit `.env` file with your desired settings:
   ```bash
   nano .env
   ```

4. **Start services**
   ```bash
   docker compose up -d
   ```

5. **Access SonarQube**
   - Open browser: http://localhost:9000
   - Default credentials:
     - Username: `admin`
     - Password: `admin`
   - ⚠️ **Change the default password immediately after first login!**

## 🛠️ Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_USER` | PostgreSQL username | `sonar` |
| `POSTGRES_PASSWORD` | PostgreSQL password | `sonar` |
| `POSTGRES_DB` | PostgreSQL database name | `sonar` |
| `SONARQUBE_PORT` | SonarQube web interface port | `9000` |
| `SONAR_JDBC_URL` | JDBC connection URL | `jdbc:postgresql://db:5432/sonar` |
| `SONAR_JDBC_USERNAME` | Database username for SonarQube | `sonar` |
| `SONAR_JDBC_PASSWORD` | Database password for SonarQube | `sonar` |
| `SONARQUBE_JAVA_OPTS` | JVM options for SonarQube | `-Xmx2g -Xms512m` |

### Resource Limits

- **PostgreSQL**: 1 CPU core, 1GB RAM
- **SonarQube**: 2 CPU cores, 3GB RAM

Adjust these in `docker-compose.yml` if needed.

## 📊 Volumes

The setup creates persistent volumes for:
- `pg_data`: PostgreSQL database data
- `sq_data`: SonarQube data
- `sq_extensions`: SonarQube plugins and extensions
- `sq_logs`: SonarQube logs

## 🔧 Management Commands

### Start services
```bash
docker compose up -d
```

### Stop services
```bash
docker compose down
```

### View logs
```bash
docker compose logs -f
docker compose logs -f sonarqube  # SonarQube only
docker compose logs -f db         # PostgreSQL only
```

### Restart services
```bash
docker compose restart
```

### Remove all data (⚠️ destructive)
```bash
docker compose down -v
```

## 📈 System Requirements

### Minimum
- 2 CPU cores
- 4GB RAM
- 10GB disk space

### Recommended
- 4+ CPU cores
- 8GB+ RAM
- 50GB+ disk space (for large projects)

### Operating System Configuration

For Linux systems, increase virtual memory:
```bash
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
```

To make permanent, add to `/etc/sysctl.conf`:
```
vm.max_map_count=524288
fs.file-max=131072
```

## 🔐 Security Best Practices

1. **Change default credentials** immediately after first login
2. **Use strong passwords** in production environments
3. **Keep credentials in `.env`** file (never commit to git)
4. **Regularly update** Docker images:
   ```bash
   docker compose pull
   docker compose up -d
   ```
5. **Use reverse proxy** (nginx/traefik) with SSL/TLS for production
6. **Enable authentication** and configure user permissions

## 🐛 Troubleshooting

### SonarQube won't start

1. Check logs:
   ```bash
   docker compose logs sonarqube
   ```

2. Verify system requirements (especially memory)

3. Check PostgreSQL health:
   ```bash
   docker compose exec db pg_isready -U sonar
   ```

### Database connection issues

Ensure database is healthy before SonarQube starts:

```bash
docker compose up -d db
# Wait 30 seconds
docker compose up -d sonarqube
```

### Performance issues

- Increase JVM heap size in `.env`:

  ```env
  SONARQUBE_JAVA_OPTS=-Xmx4g -Xms1g
  ```

- Increase Docker resource limits in `docker-compose.yml`

For more detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## 📂 Project Structure

See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for detailed information about:
- File organization
- Configuration files
- Docker volumes
- Network setup

## 📚 Documentation

- [Complete Troubleshooting Guide](TROUBLESHOOTING.md)
- [Project Structure](PROJECT_STRUCTURE.md)
- [Security Policy](SECURITY.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [SonarQube Documentation](https://docs.sonarqube.org/latest/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 🔒 Security

For security concerns, please review our [Security Policy](SECURITY.md).

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [SonarQube](https://www.sonarqube.org/) - Continuous code quality inspection
- [PostgreSQL](https://www.postgresql.org/) - Powerful open-source database
- [Docker](https://www.docker.com/) - Containerization platform
