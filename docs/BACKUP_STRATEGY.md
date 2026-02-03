# Backup Strategy

## What We Backup

### Database (PostgreSQL)
- **Type**: Full database dumps
- **Frequency**: Daily at 2:00 AM
- **Location**: `/var/backups/database/`
- **Retention**: 7 daily, 4 weekly, 3 monthly
- **Format**: SQL dump (compressed with gzip)

### Configurations
- **Files**:
  - PostgreSQL configs: `/etc/postgresql/`
  - Nginx configs: `/etc/nginx/`
  - Application code: `/opt/myapp/`
  - System configs: `/etc/ssh/`, `/etc/ufw/`, `/etc/fail2ban/`
- **Frequency**: Daily at 3:00 AM
- **Location**: `/var/backups/configs/`
- **Retention**: 7 daily, 4 weekly, 3 monthly
- **Format**: Tar archives (compressed)

## Backup Schedule

| Backup Type | Time | Script | Frequency |
|------------|------|--------|-----------|
| Database | 2:00 AM | backup-database.sh | Daily |
| Configs | 3:00 AM | backup-configs.sh | Daily |

## Retention Policy

- **Daily**: Keep last 7 days
- **Weekly**: Keep last 4 weeks (Sunday backups promoted)
- **Monthly**: Keep last 3 months (First Sunday of month promoted)

## Recovery Objectives

- **RTO** (Recovery Time Objective): 2 hours
- **RPO** (Recovery Point Objective): 24 hours (max data loss)

## Backup Location

- **Primary**: `/var/backups/` on control-node
- **Storage**: Local disk (backup VMs have separate disk space)

## Restore Process

1. Stop affected services
2. Restore configuration files
3. Restore database from backup
4. Restart services
5. Verify functionality

