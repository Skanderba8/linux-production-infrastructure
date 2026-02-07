
> A production-style Linux infrastructure project demonstrating system administration, security hardening, and Infrastructure as Code (IaC) practices using Ansible automation.

[![Project Status](https://img.shields.io/badge/Status-Phase%202%20Complete-green)]()
[![Infrastructure](https://img.shields.io/badge/Infrastructure-VirtualBox-blue)]()
[![Automation](https://img.shields.io/badge/Automation-Ansible-red)]()
[![OS](https://img.shields.io/badge/OS-Linux%20Mint%2022-green)]()

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Infrastructure Architecture](#-infrastructure-architecture)
- [Project Phases](#-project-phases)
- [Current Progress](#-current-progress)
- [Security Implementations](#-security-implementations)
- [Technologies Used](#-technologies-used)
- [Quick Start](#-quick-start)
- [Command Reference](#-command-reference)
- [Skills Demonstrated](#-skills-demonstrated)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)
- [Author](#-author)

---

## 🎯 Project Overview

This project showcases the complete lifecycle of building, securing, and automating a multi-server Linux environment from scratch. It demonstrates real-world DevOps and system administration practices used in production environments.

### What This Project Demonstrates

- **Infrastructure as Code (IaC)**: Everything is reproducible and version-controlled
- **Security First**: Multi-layered security approach with automated hardening
- **Automation**: Manual tasks converted to reusable Ansible playbooks
- **Service Deployment**: Full 3-tier web application stack (Nginx → Node.js → PostgreSQL)
- **Monitoring Ready**: Metrics collection infrastructure with node_exporter
- **Professional Documentation**: Clear, comprehensive, and maintainable

### Project Goals

1. ✅ Build a multi-server Linux environment with proper networking
2. ✅ Implement security best practices (SSH hardening, firewalls, intrusion prevention)
3. ✅ Automate everything with Ansible for repeatability
4. ✅ Deploy production-ready services (web, application, database tiers)
5. ⏸️ Implement centralized monitoring and alerting
6. ⏸️ Create automated backup and disaster recovery procedures
7. ⏸️ Test failure scenarios and validate recovery processes
8. ⏸️ Document everything for knowledge transfer

**Time Investment**: ~40-50 hours (8 phases)  
**Current Time Spent**: ~15 hours

---

## 🏗️ Infrastructure Architecture

### Environment Specifications

- **Hypervisor**: VirtualBox 7.x on Windows 11 host
- **Operating System**: Linux Mint 22 (based on Ubuntu 24.04 LTS)
- **Network**: Dual-adapter setup (NAT + Host-Only)
- **Automation Platform**: Ansible 2.16+
- **Version Control**: Git / GitHub

### Server Topology

| Hostname | Role | NAT IP | Host-Only IP | vCPU | RAM | Disk | Status |
|----------|------|--------|--------------|------|-----|------|--------|
| **baseline-template** | Golden Image | 10.0.2.10 | 192.168.56.10 | 2 | 2GB | 25GB | 🔴 Powered Off |
| **control-node** | Ansible Controller | 10.0.2.11 | 192.168.56.11 | 2 | 2GB | 25GB | 🟢 Running |
| **web-server** | Nginx Reverse Proxy | 10.0.2.12 | 192.168.56.12 | 2 | 2GB | 25GB | 🟢 Running |
| **app-server** | Node.js Application | 10.0.2.13 | 192.168.56.13 | 2 | 2GB | 25GB | 🟢 Running |
| **db-server** | PostgreSQL Database | 10.0.2.14 | 192.168.56.14 | 2 | 4GB | 50GB | 🟢 Running |

### Network Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Windows 11 Host Machine                       │
│                  Your Workstation (SSH Client)                    │
│                   192.168.56.1 (Host-Only Gateway)               │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ SSH Access via Host-Only Network
                            │ (Management & Development)
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        │                   │                   │
   ┌────▼─────┐      ┌──────▼──────┐     ┌─────▼──────┐
   │ control  │      │ web-server  │     │ app-server │
   │  -node   │◄────►│   (nginx)   │◄───►│  (node.js) │
   │          │      │             │     │            │
   │.56.11    │      │  .56.12     │     │  .56.13    │
   └────┬─────┘      └──────┬──────┘     └─────┬──────┘
        │                   │                   │
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
                            │
                      ┌─────▼──────┐
                      │ db-server  │
                      │(postgresql)│
                      │            │
                      │  .56.14    │
                      └────────────┘

╔══════════════════════════════════════════════════════════════════╗
║       NAT Network (InfraNet - 10.0.2.0/24)                      ║
║   VM-to-VM Communication & Internet Access                       ║
║                                                                  ║
║   control-node: 10.0.2.11    web-server:  10.0.2.12            ║
║   app-server:   10.0.2.13    db-server:   10.0.2.14            ║
╚══════════════════════════════════════════════════════════════════╝
                            │
                            │ Internet Access
                            ▼
                    ┌───────────────┐
                    │   Internet    │
                    │ (via Windows) │
                    └───────────────┘
```

### Application Flow

```
Internet → [Web Server:80] → [App Server:3000] → [Database:5432]
            Nginx Proxy       Express.js API      PostgreSQL
            
Security: Each tier only accepts connections from the previous tier
```

---

## 📈 Project Phases

### Phase 1: Manual Base Configuration ✅ COMPLETE
**Objective**: Build the infrastructure foundation manually to understand every component
<img width="1900" height="1024" alt="infra2" src="https://github.com/user-attachments/assets/6b13de37-13a4-4a58-835c-d8c63c7c0190" />

**Tasks Completed**:
- [x] VirtualBox environment setup with NAT and Host-Only networks
- [x] Created baseline template VM with dual network adapters
- [x] Manual security hardening (SSH, firewall, fail2ban)
- [x] Installed monitoring agent (node_exporter)
- [x] Configured automatic security updates
- [x] Cloned and configured 4 production VMs
- [x] Established hostname resolution via /etc/hosts
- [x] Verified connectivity and services
- [x] Created snapshot: `Phase1-Complete-Baseline`

**Time Invested**: ~4 hours  
**Status**: ✅ 100% Complete

---

### Phase 2: Automation with Ansible ✅ COMPLETE
**Objective**: Convert all manual configurations into automated, repeatable Ansible playbooks

**Tasks Completed**:

#### Step 2.1: Ansible Control Node Setup ✅
- [x] Installed Ansible 2.16+ on control-node
- [x] Created complete project directory structure
- [x] Generated SSH keys for Ansible automation
- [x] Distributed SSH keys to all managed nodes
- [x] Configured passwordless sudo on all managed nodes
- [x] Created ansible.cfg with optimized settings
- [x] Created inventory file with logical host groups
- [x] Created group_vars/all.yml with global variables
- [x] Tested Ansible connectivity (ping module)
- [x] Initialized Git repository
- [x] Pushed to GitHub repository

#### Step 2.2: Base Security Hardening Automation ✅
- [x] Created 5 security roles:
  - `ssh_hardening` - SSH security configuration
  - `firewall` - UFW firewall rules  
  - `fail2ban` - Intrusion prevention system
  - `auto_updates` - Unattended security patches
  - `node_exporter` - Prometheus metrics exporter
- [x] Created base-hardening.yml playbook
- [x] Successfully executed on all 3 managed nodes
- [x] Tested and verified idempotency
- [x] Created verify-config.yml verification playbook
- [x] All security services running and verified

#### Step 2.3: Service-Specific Playbooks ✅
- [x] **Web Server Deployment**:
  - Created `nginx` role with reverse proxy configuration
  - Configured security headers
  - Created web-server.yml playbook
  - Deployed and verified Nginx
  - Opened firewall ports 80, 443
  
- [x] **Application Server Deployment**:
  - Created `nodejs_app` role
  - Deployed Express.js sample application
  - Configured systemd service (myapp.service)
  - Created app-server.yml playbook
  - Service running and health checks passing
  - Restricted access to web server only
  
- [x] **Database Server Deployment**:
  - Created `postgresql` role
  - Installed PostgreSQL 16
  - Created application database (appdb)
  - Created database user (appuser)
  - Configured network access from app server
  - Created db-server.yml playbook
  - Database accessible and verified

#### Step 2.4: End-to-End Testing ✅
- [x] Created comprehensive verification playbook
- [x] Tested Web → App connectivity
- [x] Tested App → Database connectivity
- [x] Verified full request flow (end-to-end)
- [x] All services passing health checks

**Deliverables Completed**:
- 8 Ansible roles (reusable components)
- 6 Ansible playbooks (automation scripts)
- Complete 3-tier application stack
- Full security hardening
- Monitoring foundation

**Time Invested**: ~11 hours  
**Status**: ✅ 100% Complete  
**Snapshot**: `Phase2-Complete-Full-Automation` (ready to create)

---

### Phase 3: Centralized Monitoring ✅ COMPLETE
**Objective**: Implement Prometheus and Grafana for infrastructure monitoring
<img width="1900" height="917" alt="dashboard1" src="https://github.com/user-attachments/assets/48c5435e-dada-4813-886f-78e20c71b7b6" />
<img width="1901" height="904" alt="dashboard2" src="https://github.com/user-attachments/assets/7b73fe91-9f73-4817-8310-974696bea6f9" />
**Tasks Completed**:

#### Step 3.1: Prometheus Deployment ✅
- [x] Created Prometheus role (`roles/prometheus/`)
- [x] Installed Prometheus 3.9.1 from GitHub releases
- [x] Created Prometheus system user and directories
- [x] Configured Prometheus to scrape all 4 node_exporters
- [x] Set up systemd service for Prometheus
- [x] Configured scraping targets:
  - control-node: 10.0.2.11:9100
  - web-server: 10.0.2.12:9100
  - app-server: 10.0.2.13:9100
  - db-server: 10.0.2.14:9100
- [x] Configured firewall to allow port 9090 from host-only network
- [x] Verified Prometheus is running and healthy

#### Step 3.2: Grafana Deployment ✅
- [x] Created Grafana role (`roles/grafana/`)
- [x] Installed Grafana 12.3.2 from official repository
- [x] Configured Grafana to run on port 3001
- [x] Set default admin password: admin123!
- [x] Configured Prometheus as default data source
- [x] Configured firewall to allow port 3001 from host-only network
- [x] Created provisioning for automatic data source configuration
- [x] Verified Grafana is running and accessible

#### Step 3.3: Dashboard Implementation ✅
- [x] Created monitoring dashboards via Grafana API
- [x] Imported and tested dashboard templates
- [x] Created working dashboards with proven queries:
  - "System Monitoring Dashboard" (comprehensive metrics)
  - "SIMPLE TEST - RAW METRICS" (debug dashboard)
  - "GUARANTEED WORKING - TABLE VIEW" (table format)
  - "GUARANTEED WORKING - STAT VIEW" (stat panels)
- [x] Tested all metrics are being collected and displayed

#### Step 3.4: Playbook Development ✅
- [x] Created `monitoring.yml` playbook for stack deployment
- [x] Created `verify-monitoring.yml` for validation
- [x] Created `open-monitoring-ports.yml` for firewall configuration
- [x] Tested idempotency of all playbooks
- [x] Documented access URLs and credentials

**Deliverables Completed**:
- ✅ Centralized monitoring with Prometheus + Grafana
- ✅ 2 new Ansible roles (prometheus, grafana)
- ✅ 3 new playbooks for monitoring stack
- ✅ 4+ operational dashboards
- ✅ Real-time metrics from all 4 servers
- ✅ Documentation and access guide

**Access URLs**:
- **Prometheus**: http://192.168.56.11:9090
- **Grafana**: http://192.168.56.11:3001
- **Grafana Credentials**: admin / admin123!

**Metrics Collected**:
- CPU usage and load averages
- Memory utilization
- Disk space and I/O
- Network traffic
- System uptime
- Running processes

**Time Invested**: ~6 hours  
**Status**: ✅ 100% Complete  
**Snapshot**: `Phase3-Complete-Monitoring-Stack` (ready to create)

---

### Phase 4: Centralized Logging ⏸️ PENDING
**Objective**: Implement centralized log management with rsyslog or ELK stack
<img width="1580" height="798" alt="backup1" src="https://github.com/user-attachments/assets/e6ed6aa7-39c6-41c8-b453-d5db0cf2ae2d" />

**Tasks Completed**:

#### Step 4.1: Log Server Setup ✅
- [x] Created `rsyslog_server` role for control-node
- [x] Configured rsyslog to receive logs on port 514 (UDP/TCP)
- [x] Set up log file organization by hostname
- [x] Configured firewall to allow syslog traffic from internal network
- [x] Created log directory structure in /var/log/remote/

#### Step 4.2: Log Client Configuration ✅
- [x] Created `rsyslog_client` role for managed nodes
- [x] Configured all managed nodes to forward logs to control-node
- [x] Set up reliable log forwarding with queue management
- [x] Tested log forwarding from all 3 servers

#### Step 4.3: Log Management ✅
- [x] Implemented log rotation policies
- [x] Configured retention: daily logs, weekly archives
- [x] Set up automatic compression of old logs
- [x] Created logrotate configuration for remote logs

#### Step 4.4: Testing and Verification ✅
- [x] Created `logging.yml` playbook for deployment
- [x] Created `verify-logging.yml` for validation
- [x] Tested log forwarding from all managed nodes
- [x] Verified centralized log collection
- [x] Confirmed log rotation is working

**Deliverables Completed**:
- ✅ Centralized log server on control-node
- ✅ Log forwarding from all managed nodes
- ✅ 2 new Ansible roles (rsyslog_server, rsyslog_client)
- ✅ 2 new playbooks for logging infrastructure
- ✅ Automated log rotation and retention
- ✅ Organized log directory structure

**Log Structure**:
```
/var/log/remote/
├── web-server/
│   └── syslog
├── app-server/
│   └── syslog
└── db-server/
    └── syslog
```

**Time Invested**: ~2 hours  
**Status**: ✅ 100% Complete

---

### Phase 5: Backup Automation ✅ COMPLETE
**Objective**: Implement automated backup system for critical data
<img width="700" height="687" alt="backupcapture" src="https://github.com/user-attachments/assets/dc5c27ed-6718-4c82-b36f-cb5fb9b99bf6" />

**Tasks Completed**:

#### Step 5.1: Backup Strategy Design ✅
- [x] Designed multi-tier backup retention strategy
- [x] Defined backup types: database and configuration
- [x] Established retention periods:
  - Daily: 7 days
  - Weekly: 28 days
  - Monthly: 90 days

#### Step 5.2: Database Backup Implementation ✅
- [x] Created `backup_postgresql` role
- [x] Implemented PostgreSQL backup script with pg_dump
- [x] Configured compression (gzip) for space efficiency
- [x] Set up automated retention management
- [x] Created cron job for daily execution (2:00 AM)
- [x] Deployed to db-server

#### Step 5.3: Configuration Backup Implementation ✅
- [x] Created `backup_configs` role
- [x] Implemented backup script for system configurations:
  - Nginx configurations
  - Application code
  - SSH configurations
  - Firewall rules
  - fail2ban settings
  - rsyslog configurations
  - Ansible infrastructure files
- [x] Configured compression and retention
- [x] Created cron job for daily execution (3:00 AM)
- [x] Deployed to web-server and app-server

#### Step 5.4: Backup Deployment and Testing ✅
- [x] Created `backup.yml` playbook
- [x] Fixed YAML syntax errors in backup roles
- [x] Deployed backup system to all servers
- [x] Created backup directories on all nodes
- [x] Verified backup scripts are executable
- [x] Tested manual backup execution
- [x] Confirmed cron jobs are scheduled
- [x] Validated backup files are created with content

**Deliverables Completed**:
- ✅ Automated database backups (PostgreSQL on db-server)
- ✅ Automated configuration backups (web-server, app-server)
- ✅ 2 new Ansible roles (backup_postgresql, backup_configs)
- ✅ 1 new playbook for backup deployment
- ✅ Multi-tier retention policy (7/28/90 days)
- ✅ Scheduled cron jobs for automation
- ✅ Backup verification capability

**Backup Architecture**:
```
┌─────────────────────────────────────────────────────────┐
│                    Backup Strategy                       │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  db-server (10.0.2.14)                                  │
│  ├── /var/backups/database/                             │
│  │   ├── daily/    (7 days retention)                   │
│  │   ├── weekly/   (28 days retention)                  │
│  │   └── monthly/  (90 days retention)                  │
│  └── Cron: Daily at 2:00 AM                             │
│                                                          │
│  web-server (10.0.2.12)                                 │
│  ├── /var/backups/configs/                              │
│  │   ├── daily/    (7 days retention)                   │
│  │   ├── weekly/   (28 days retention)                  │
│  │   └── monthly/  (90 days retention)                  │
│  └── Cron: Daily at 3:00 AM                             │
│                                                          │
│  app-server (10.0.2.13)                                 │
│  ├── /var/backups/configs/                              │
│  │   ├── daily/    (7 days retention)                   │
│  │   ├── weekly/   (28 days retention)                  │
│  │   └── monthly/  (90 days retention)                  │
│  └── Cron: Daily at 3:00 AM                             │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Backup Components**:

**1. Database Backups (db-server)**:
- Full PostgreSQL database dump (appdb)
- Backup location: `/var/backups/database/`
- Schedule: Daily at 2:00 AM
- Manual execution: `sudo /usr/local/bin/backup-database.sh`

**2. Configuration Backups (web-server, app-server)**:
- System and application configurations
- Backup location: `/var/backups/configs/`
- Schedule: Daily at 3:00 AM
- Manual execution: `sudo /usr/local/bin/backup-configs.sh`

**Time Invested**: ~2 hours  
**Status**: ✅ 100% Complete

---


### Phase 6: Disaster Recovery ⏸️ PENDING
**Objective**: Develop and test disaster recovery procedures

**Planned Tasks**:
- [ ] Create restore scripts for each service
- [ ] Develop full infrastructure rebuild procedure
- [ ] Test database restore from backup
- [ ] Test VM rebuild from Ansible playbooks
- [ ] Document Recovery Time Objective (RTO)
- [ ] Document Recovery Point Objective (RPO)
- [ ] Create disaster recovery playbook
- [ ] Test complete infrastructure recovery
- [ ] Create disaster recovery documentation

**Deliverables**:
- Disaster recovery procedures
- Restore verification tests
- RTO/RPO documentation
- Recovery playbooks

**Estimated Time**: 6-8 hours

---

### Phase 7: Failure Testing & Validation ⏸️ PENDING
**Objective**: Test infrastructure resilience and validate all procedures

**Planned Tasks**:
- [ ] Simulate VM failures
- [ ] Test automatic service recovery
- [ ] Simulate network failures
- [ ] Test monitoring and alerting
- [ ] Simulate disk full scenarios
- [ ] Test backup and restore procedures
- [ ] Validate disaster recovery processes
- [ ] Document all test results
- [ ] Create final project report

**Deliverables**:
- Failure test scenarios and results
- Infrastructure resilience report
- Final project documentation
- Lessons learned document

**Estimated Time**: 6-8 hours

---

## 📊 Current Progress

### Overall Project Status

```
Phase 1: ████████████████████████████████ 100% ✅ COMPLETE
Phase 2: ████████████████████████████████ 100% ✅ COMPLETE
Phase 3: ████████████████████████████████ 100% ✅ COMPLETE
Phase 4: ████████████████████████████████ 100% ✅ COMPLETE
Phase 5: ████████████████████████████████ 100% ✅ COMPLETE
Phase 6: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
Phase 7: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
═══════════════════════════════════════════════════════════
Overall: ████████████████████████░░░░░░░░  75% Complete
```

### Phase 2 Achievement Summary

**Infrastructure Automated**:
- ✅ 4 VMs fully configured via Ansible
- ✅ 8 reusable Ansible roles created
- ✅ 6 functional playbooks developed
- ✅ Complete 3-tier application stack deployed
- ✅ Zero manual configuration required
- ✅ Full idempotency verified

**Services Deployed**:
- ✅ Nginx reverse proxy (web-server)
- ✅ Express.js application (app-server)
- ✅ PostgreSQL 16 database (db-server)
- ✅ Security hardening (all servers)
- ✅ Monitoring agents (all servers)

**Testing Results**:
- ✅ All playbooks execute successfully
- ✅ Idempotency confirmed (safe to re-run)
- ✅ End-to-end connectivity verified
- ✅ All services healthy and responsive
- ✅ Security measures active and tested

---

### Phase 3 Achievement Summary

**Monitoring Infrastructure Deployed**:
- ✅ Prometheus 3.9.1 installed and configured on control-node
- ✅ Grafana 12.3.2 installed and configured on control-node
- ✅ All 4 servers being monitored (100% coverage)
- ✅ Real-time metrics collection every 15 seconds
- ✅ Dashboard visualization with multiple views
- ✅ Data source integration tested and working

**New Ansible Components**:
- ✅ `roles/prometheus/` - Complete Prometheus role
- ✅ `roles/grafana/` - Complete Grafana role
- ✅ `playbooks/monitoring.yml` - Monitoring stack deployment
- ✅ `playbooks/verify-monitoring.yml` - Monitoring validation
- ✅ `playbooks/open-monitoring-ports.yml` - Firewall configuration

**Dashboards Created**:
- ✅ "System Monitoring Dashboard" - Comprehensive metrics view
- ✅ "SIMPLE TEST - RAW METRICS" - Debug/verification dashboard
- ✅ "GUARANTEED WORKING - TABLE VIEW" - Tabular data display
- ✅ "GUARANTEED WORKING - STAT VIEW" - Stat panel dashboard


**Testing Results**:
- ✅ Prometheus scraping all 4 targets (all "UP")
- ✅ Grafana can query Prometheus successfully
- ✅ Dashboard panels showing real-time data
- ✅ All services healthy and responsive
- ✅ Firewall rules properly configured

### Time Investment
- **Phase 1**: 4 hours ✅
- **Phase 2**: 11 hours ✅
- **Phase 3**: 6 hours ✅
- **Phase 4**: 2 hours ✅
- **Phase 5**: 6 hours ✅
- **Total so far**: 25 hours
- **Estimated remaining**: 15-20 hours

### Last Updated
**Date**: February73, 2026  
**Current Phase**: Phase 4-5 - Complete ✅  

---

## 🔐 Security Implementations

### Multi-Layered Security Approach

#### 1. SSH Hardening ✅
- ✅ **Key-based authentication only** (password authentication disabled)
- ✅ **Root login disabled** via SSH
- ✅ **Public key authentication** configured for sysadmin user
- ✅ **MaxAuthTries**: Limited to 3 attempts
- ✅ **Automated via Ansible** (ssh_hardening role)

**Configuration File**: `/etc/ssh/sshd_config`

#### 2. Firewall (UFW) ✅
- ✅ **Default Policy**: Deny incoming, Allow outgoing
- ✅ **Service-Specific Rules**:
  - SSH (22/tcp) - Management access
  - HTTP (80/tcp) - Web server only
  - HTTPS (443/tcp) - Web server only
  - App (3000/tcp) - From web server only
  - PostgreSQL (5432/tcp) - From app server only
  - node_exporter (9100/tcp) - Internal network only
  - Syslog (514/udp, 514/tcp) - Internal network only
- ✅ **Automated via Ansible** (firewall role)

**Check Status**: `sudo ufw status verbose`

#### 3. Intrusion Prevention (fail2ban) ✅
- ✅ **Monitoring**: SSH login attempts
- ✅ **Max Retries**: 3 failed attempts
- ✅ **Ban Time**: 3600 seconds (1 hour)
- ✅ **Find Time**: 600 seconds (10 minutes)
- ✅ **Automatic IP banning** after threshold exceeded
- ✅ **Automated via Ansible** (fail2ban role)

**Configuration File**: `/etc/fail2ban/jail.local`  
**Check Status**: `sudo fail2ban-client status sshd`

#### 4. Automatic Security Updates ✅
- ✅ **Service**: unattended-upgrades
- ✅ **Update Type**: Security updates only
- ✅ **Auto-reboot**: Disabled (manual control)
- ✅ **Old Kernel Cleanup**: Enabled
- ✅ **Daily Update Check**: Automated
- ✅ **Automated via Ansible** (auto_updates role)

**Configuration File**: `/etc/apt/apt.conf.d/50unattended-upgrades`

#### 5. System Monitoring ✅
- ✅ **Agent**: Prometheus node_exporter v1.8.2
- ✅ **Metrics Port**: 9100
- ✅ **Metrics Collected**:
  - CPU usage and load averages
  - Memory and swap utilization
  - Disk space and I/O
  - Network traffic and errors
  - System uptime and processes
- ✅ **Automated via Ansible** (node_exporter role)

**Access Metrics**: `curl http://localhost:9100/metrics`

#### 6. Network Segmentation ✅
- ✅ **Web Tier**: Internet-facing (ports 80, 443)
- ✅ **App Tier**: Only accessible from web server
- ✅ **Database Tier**: Only accessible from app server
- ✅ **Management**: SSH restricted via firewall rules

---

## 🛠️ Technologies Used

### Operating Systems & Virtualization
- **Host OS**: Windows 11 Pro
- **Hypervisor**: Oracle VirtualBox 7.x
- **Guest OS**: Linux Mint 22 Wilma (based on Ubuntu 24.04 LTS)
- **Kernel**: Linux 6.8.x

### Automation & Configuration Management
- **Ansible**: 2.16+ (automation platform)
- **YAML**: Configuration and playbook syntax
- **Jinja2**: Template engine for dynamic configurations
- **Git**: Version control
- **GitHub**: Remote repository

### Security Tools
- **OpenSSH**: Secure remote access
- **UFW**: Firewall management (frontend for iptables)
- **fail2ban**: Intrusion prevention system
- **unattended-upgrades**: Automatic security patching

### Application Stack
- **Nginx**: Reverse proxy and web server
- **Node.js**: JavaScript runtime (v18.x)
- **Express.js**: Web application framework
- **PostgreSQL**: Relational database (v16)

### Monitoring & Observability
- **Prometheus node_exporter**: Metrics collection agent (v1.8.2)
- **Prometheus**: Time-series database and alerting (v3.9.1)
- **Grafana**: Visualization and dashboards (v12.3.2)

### Logging & Backup
- **rsyslog**: Centralized log management
- **logrotate**: Log rotation and retention
- **pg_dump**: PostgreSQL backup utility
- **cron**: Job scheduling for automated backups
- **Bash**: Backup and maintenance scripts

---
## 🚀 Quick Start

### Prerequisites

- **Hardware**: 16GB RAM minimum, 4+ CPU cores recommended
- **Software**: 
  - VirtualBox 7.x or later
  - Windows 10/11 (or any OS supporting VirtualBox)
  - SSH client (built into Windows 10+)
  - Git (for version control)

### Access the Infrastructure

#### SSH from Windows (PowerShell)
```powershell
# Access Ansible control node
ssh sysadmin@192.168.56.11

# Access web server
ssh sysadmin@192.168.56.12

# Access app server
ssh sysadmin@192.168.56.13

# Access database server
ssh sysadmin@192.168.56.14
```

#### Run Ansible Playbooks (from control-node)
```bash
# SSH into control node
ssh sysadmin@192.168.56.11

# Navigate to infrastructure directory
cd ~/infrastructure

# Test connectivity to all managed nodes
ansible managed_nodes -m ping

# Apply complete infrastructure automation
ansible-playbook playbooks/base-hardening.yml

# Deploy web server (Nginx)
ansible-playbook playbooks/web-server.yml

# Deploy application server (Node.js)
ansible-playbook playbooks/app-server.yml

# Deploy database server (PostgreSQL)
ansible-playbook playbooks/db-server.yml

# Deploy monitoring stack (Prometheus + Grafana)
ansible-playbook playbooks/monitoring.yml

# Deploy centralized logging
ansible-playbook playbooks/logging.yml

# Deploy backup system
ansible-playbook playbooks/backup.yml

# Verify all configurations and services
ansible-playbook playbooks/verify-config.yml
ansible-playbook playbooks/verify-all-services.yml
ansible-playbook playbooks/verify-monitoring.yml
ansible-playbook playbooks/verify-logging.yml

# Run in check mode (dry run - no changes)
ansible-playbook playbooks/base-hardening.yml --check

# Run with verbose output for troubleshooting
ansible-playbook playbooks/base-hardening.yml -vvv
```

#### Access Monitoring Dashboards
```bash
# From Windows browser:
# Prometheus: http://192.168.56.11:9090
# Grafana:    http://192.168.56.11:3001
#
# Grafana Credentials:
#   Username: admin
#   Password: admin123!
```

#### Check Centralized Logs
```bash
# From control-node, view centralized logs
# Web server logs
sudo tail -f /var/log/remote/web-server/syslog

# App server logs
sudo tail -f /var/log/remote/app-server/syslog

# Database server logs
sudo tail -f /var/log/remote/db-server/syslog

# View all logs
sudo ls -lh /var/log/remote/*/
```

#### Verify Backups
```bash
# Check backup directories exist
ansible all -m shell -a "ls -lh /var/backups/" -b

# Check database backup files
ansible db_servers -m shell -a "ls -lh /var/backups/database/daily/" -b

# Check configuration backup files
ansible managed_nodes -m shell -a "ls -lh /var/backups/configs/daily/" -b

# Verify cron jobs are scheduled
ansible all -m shell -a "crontab -l 2>/dev/null | grep backup || echo 'No backup cron jobs'" -b

# Manually trigger a test backup
# Database backup
ansible db_servers -m shell -a "/usr/local/bin/backup-database.sh" -b

# Configuration backup
ansible web_servers -m shell -a "/usr/local/bin/backup-configs.sh" -b
```

#### Test the Application Stack
```bash
# From Windows, test the web server
curl http://192.168.56.12

# From control-node, test app server health
ansible app_servers -m shell -a "curl -s http://localhost:3000/health"

# Test database connectivity
ansible app_servers -m shell -a 'PGPASSWORD=SecurePassword123\! psql -h 10.0.2.14 -U appuser -d appdb -c "SELECT version();"' -b

# Test end-to-end flow (Web → App → Database)
curl http://192.168.56.12/health
```

### Project Structure
```
infrastructure/
│
├── ansible.cfg                      # Ansible configuration file
├── .gitignore                       # Git ignore rules (secrets, keys)
├── README.md                        # This comprehensive documentation
│
├── inventory/
│   └── hosts.yml                    # Server inventory with host groups
│
├── group_vars/
│   └── all.yml                      # Global variables for all hosts
│
├── playbooks/                       # Ansible playbooks (automation scripts)
│   ├── base-hardening.yml           # Security hardening for all servers
│   ├── web-server.yml               # Nginx reverse proxy deployment
│   ├── app-server.yml               # Node.js application deployment
│   ├── db-server.yml                # PostgreSQL database deployment
│   ├── verify-config.yml            # Individual service verification
│   ├── verify-all-services.yml      # End-to-end testing
│   ├── monitoring.yml               # Monitoring stack deployment
│   ├── verify-monitoring.yml        # Monitoring validation
│   ├── open-monitoring-ports.yml    # Firewall for monitoring
│   ├── logging.yml                  # 📋 Centralized logging deployment
│   ├── verify-logging.yml           # 📋 Logging validation
│   └── backup.yml                   # 💾 Backup system deployment
│
├── roles/                           # Ansible roles (reusable components)
│   ├── ssh_hardening/               # SSH security configuration
│   ├── firewall/                    # UFW firewall configuration
│   ├── fail2ban/                    # Intrusion prevention
│   ├── auto_updates/                # Automatic security updates
│   ├── node_exporter/               # Monitoring agent
│   ├── nginx/                       # Web server and reverse proxy
│   ├── nodejs_app/                  # Node.js application
│   ├── postgresql/                  # PostgreSQL database
│   ├── prometheus/                  # Prometheus monitoring
│   ├── grafana/                     # Grafana visualization
│   ├── rsyslog_server/              # 📋 Centralized log server
│   ├── rsyslog_client/              # 📋 Log forwarding client
│   ├── backup_postgresql/           # 💾 Database backup automation
│   └── backup_configs/              # 💾 Configuration backup automation
│
└── files/                           # Static files (future use)
    └── scripts/
```

---

## 📚 Command Reference

### Phase 1: Manual Base Configuration Commands

<details>
<summary><b>Click to expand Phase 1 commands</b></summary>

#### Initial Network Configuration (baseline-template)
```bash
# Set static IP on NAT Network (enp0s3)
sudo nmcli connection modify "Wired connection 1" \
  ipv4.addresses 10.0.2.10/24 \
  ipv4.gateway 10.0.2.1 \
  ipv4.dns "8.8.8.8,8.8.4.4" \
  ipv4.method manual

# Apply changes
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"

# Set static IP on Host-Only Network (enp0s8)
sudo nmcli connection add type ethernet ifname enp0s8 con-name host-only \
  ipv4.addresses 192.168.56.10/24 \
  ipv4.method manual

# Activate Host-Only connection
sudo nmcli connection up host-only

# Verify network configuration
ip addr show
ip route show
```

#### Hostname Configuration
```bash
# Set hostname
sudo hostnamectl set-hostname baseline-template

# Edit /etc/hosts for proper resolution
sudo nano /etc/hosts
# Change 127.0.1.1 line to: 127.0.1.1  baseline-template

# Verify
hostname
hostnamectl
```

#### System Updates
```bash
# Update package lists
sudo apt update

# Upgrade all packages
sudo apt upgrade -y

# Install essential tools
sudo apt install -y vim curl wget git net-tools ufw fail2ban openssh-server

# Reboot to apply updates
sudo reboot
```

#### SSH Configuration
```bash
# Install OpenSSH server (usually pre-installed)
sudo apt install -y openssh-server

# Enable and start SSH service
sudo systemctl enable ssh
sudo systemctl start ssh

# Create SSH directory and set permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add your public key to authorized_keys (paste your key)
nano ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Backup original SSH configuration
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit SSH configuration
sudo nano /etc/ssh/sshd_config
# Set these values:
#   PermitRootLogin no
#   PasswordAuthentication no
#   PubkeyAuthentication yes
#   AuthorizedKeysFile .ssh/authorized_keys
#   MaxAuthTries 3

# Test configuration syntax
sudo sshd -t

# Restart SSH service
sudo systemctl restart ssh

# Verify SSH status
sudo systemctl status ssh
```

#### Firewall (UFW) Configuration
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status verbose
sudo ufw status numbered
```

#### fail2ban Installation and Configuration
```bash
# Install fail2ban
sudo apt install -y fail2ban

# Copy default configuration
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit configuration
sudo nano /etc/fail2ban/jail.local
# Configure [sshd] section:
#   enabled = true
#   port = 22
#   maxretry = 3
#   bantime = 3600
#   findtime = 600

# Enable and start fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Check status
sudo systemctl status fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

#### Automatic Security Updates
```bash
# Install unattended-upgrades
sudo apt install -y unattended-upgrades apt-listchanges

# Configure unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

# Edit configuration file
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
# Ensure security updates are enabled:
#   "${distro_id}:${distro_codename}-security";

# Enable and start service
sudo systemctl enable unattended-upgrades
sudo systemctl start unattended-upgrades

# Check status
sudo systemctl status unattended-upgrades
```

#### node_exporter Installation
```bash
# Download node_exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz

# Extract
tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz

# Move binary to system path
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/

# Create system user
sudo useradd --no-create-home --shell /bin/false node_exporter

# Set ownership
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create systemd service
sudo nano /etc/systemd/system/node_exporter.service
# Paste service configuration

# Reload systemd, enable and start service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Verify status
sudo systemctl status node_exporter

# Allow node_exporter through firewall (internal network only)
sudo ufw allow from 10.0.2.0/24 to any port 9100 proto tcp

# Test metrics endpoint
curl http://localhost:9100/metrics | head -20
```

</details>

---

### Phase 2: Ansible Automation Commands

<details>
<summary><b>Click to expand Phase 2 commands</b></summary>

#### Initial Setup on Control-Node
```bash
# SSH into control-node from Windows
ssh sysadmin@192.168.56.11

# Update system
sudo apt update && sudo apt upgrade -y

# Install Ansible
sudo apt install -y ansible

# Verify installation
ansible --version
```

#### Project Structure Creation
```bash
# Create main project directory
mkdir -p ~/infrastructure
cd ~/infrastructure

# Create subdirectories
mkdir -p inventory playbooks roles group_vars host_vars files templates

# Create initial files
touch ansible.cfg
touch inventory/hosts.yml
touch group_vars/all.yml
```

#### SSH Key Setup for Ansible
```bash
# Generate SSH key pair for Ansible (on control-node)
ssh-keygen -t ed25519 -C "ansible-control"
# Press ENTER for all prompts

# View the public key
cat ~/.ssh/id_ed25519.pub

# Copy SSH key to each managed node
ssh-copy-id sysadmin@web-server
ssh-copy-id sysadmin@app-server
ssh-copy-id sysadmin@db-server

# Test passwordless SSH
ssh sysadmin@web-server "hostname"
ssh sysadmin@app-server "hostname"
ssh sysadmin@db-server "hostname"
```

#### Test Ansible Connectivity
```bash
# Ping all managed nodes
ansible managed_nodes -m ping

# Check hostname
ansible managed_nodes -m command -a "hostname"

# Check uptime
ansible managed_nodes -m command -a "uptime"

# Test sudo access
ansible managed_nodes -m command -a "sudo whoami"
```

#### Deploy Service-Specific Playbooks
```bash
# Deploy web server (Nginx)
ansible-playbook playbooks/web-server.yml

# Deploy application server (Node.js)
ansible-playbook playbooks/app-server.yml

# Deploy database server (PostgreSQL)
ansible-playbook playbooks/db-server.yml

# Verify all services
ansible-playbook playbooks/verify-all-services.yml
```

</details>

---

### Phase 3: Monitoring Implementation Commands

<details>
<summary><b>Click to expand Phase 3 commands</b></summary>

#### Deploy Monitoring Stack
```bash
# Deploy Prometheus and Grafana
ansible-playbook playbooks/monitoring.yml

# Verify the monitoring stack
ansible-playbook playbooks/verify-monitoring.yml
```

#### Check Prometheus Status
```bash
# Check Prometheus service
sudo systemctl status prometheus

# Check Prometheus targets
curl http://localhost:9090/api/v1/targets | python3 -m json.tool

# Test Prometheus queries
curl "http://localhost:9090/api/v1/query?query=up" | python3 -m json.tool
```

#### Check Grafana Status
```bash
# Check Grafana service
sudo systemctl status grafana-server

# Test Grafana API
curl http://localhost:3001/api/health | python3 -m json.tool
```

</details>

---

### Phase 4: Centralized Logging Commands

<details>
<summary><b>Click to expand Phase 4 commands</b></summary>

#### Deploy Logging Infrastructure
```bash
# SSH into control-node
ssh sysadmin@192.168.56.11
cd ~/infrastructure

# Deploy centralized logging
ansible-playbook playbooks/logging.yml

# Verify logging setup
ansible-playbook playbooks/verify-logging.yml
```

#### Check rsyslog Server (on control-node)
```bash
# Check rsyslog service
sudo systemctl status rsyslog

# View rsyslog configuration
sudo cat /etc/rsyslog.d/50-remote.conf

# Check if rsyslog is listening on port 514
sudo netstat -tulpn | grep rsyslog
sudo ss -tulpn | grep 514

# View centralized logs
sudo ls -lh /var/log/remote/

# View logs from specific server
sudo tail -f /var/log/remote/web-server/syslog
sudo tail -f /var/log/remote/app-server/syslog
sudo tail -f /var/log/remote/db-server/syslog
```

#### Check rsyslog Client (on managed nodes)
```bash
# Check rsyslog service on all nodes
ansible managed_nodes -m systemd -a "name=rsyslog state=started enabled=yes" -b

# View rsyslog client configuration
ansible managed_nodes -m shell -a "cat /etc/rsyslog.d/50-forward.conf" -b

# Test log forwarding
ansible web_servers -m shell -a "logger 'Test log message from web-server'" -b

# Verify test message appeared on control-node
sudo grep "Test log message" /var/log/remote/web-server/syslog
```

#### Troubleshoot Logging Issues
```bash
# Check firewall allows syslog
ansible control -m shell -a "sudo ufw status | grep 514" -b

# Restart rsyslog on all nodes
ansible all -m systemd -a "name=rsyslog state=restarted" -b

# Check rsyslog errors
ansible all -m shell -a "sudo journalctl -u rsyslog -n 20" -b

# Test connectivity from client to server
ansible managed_nodes -m shell -a "nc -zv 10.0.2.11 514" -b
```

</details>

---

### Phase 5: Backup Automation Commands

<details>
<summary><b>Click to expand Phase 5 commands</b></summary>

#### Deploy Backup System
```bash
# SSH into control-node
ssh sysadmin@192.168.56.11
cd ~/infrastructure

# Deploy backup automation
ansible-playbook playbooks/backup.yml
```

#### Verify Backup Configuration
```bash
# 1. Verify backup directories exist
ansible all -m shell -a "ls -lh /var/backups/" -b

# 2. Check actual backup files were created
ansible db_servers -m shell -a "ls -lh /var/backups/database/daily/" -b
ansible managed_nodes -m shell -a "ls -lh /var/backups/configs/daily/" -b

# 3. Verify cron jobs are scheduled
ansible all -m shell -a "crontab -l 2>/dev/null | grep backup || echo 'No backup cron jobs'" -b

# 4. Check backup file sizes to confirm they have content
ansible db_servers -m shell -a "du -sh /var/backups/database/daily/* 2>/dev/null | head -3" -b
```

#### Manual Backup Execution
```bash
# Manually trigger database backup
ansible db_servers -m shell -a "/usr/local/bin/backup-database.sh" -b

# Manually trigger configuration backup
ansible web_servers -m shell -a "/usr/local/bin/backup-configs.sh" -b
ansible app_servers -m shell -a "/usr/local/bin/backup-configs.sh" -b

# View backup logs
ansible db_servers -m shell -a "tail -20 /var/backups/logs/backup.log" -b
ansible web_servers -m shell -a "tail -20 /var/backups/logs/backup.log" -b
```

#### Check Backup Status
```bash
# Database backups on db-server
ssh sysadmin@192.168.56.14
sudo ls -lh /var/backups/database/daily/
sudo ls -lh /var/backups/database/weekly/
sudo ls -lh /var/backups/database/monthly/

# Configuration backups on web-server
ssh sysadmin@192.168.56.12
sudo ls -lh /var/backups/configs/daily/
sudo ls -lh /var/backups/configs/weekly/
sudo ls -lh /var/backups/configs/monthly/

# Check cron schedule
crontab -l | grep backup
```

#### Test Backup Restoration (for future Phase 6)
```bash
# To restore database backup (example for Phase 6):
# sudo -u postgres pg_restore -d appdb /var/backups/database/daily/backup-YYYYMMDD.sql.gz

# To restore configuration files (example for Phase 6):
# sudo tar -xzf /var/backups/configs/daily/backup-YYYYMMDD.tar.gz -C /
```

</details>

---

### Common Troubleshooting Commands

<details>
<summary><b>Click to expand troubleshooting commands</b></summary>

#### Network Issues
```bash
# Check IP addresses
ip addr show

# Check routing table
ip route show

# Test connectivity
ping -c 4 8.8.8.8
ping -c 4 google.com
ping -c 4 web-server

# Check open ports
sudo netstat -tulpn
sudo ss -tulpn

# Test specific port
nc -zv hostname port
```

#### SSH Issues
```bash
# Check SSH service status
sudo systemctl status ssh

# View SSH logs
sudo journalctl -u ssh -n 50
sudo tail -f /var/log/auth.log

# Test SSH configuration
sudo sshd -t

# Debug SSH connection
ssh -vvv sysadmin@hostname
```

#### Firewall Issues
```bash
# Check UFW status
sudo ufw status verbose
sudo ufw status numbered

# View UFW logs
sudo tail -f /var/log/ufw.log
```

#### Service Management
```bash
# Check service status
sudo systemctl status SERVICE_NAME

# Start/Stop/Restart service
sudo systemctl start SERVICE_NAME
sudo systemctl stop SERVICE_NAME
sudo systemctl restart SERVICE_NAME

# Enable/Disable on boot
sudo systemctl enable SERVICE_NAME
sudo systemctl disable SERVICE_NAME

# View service logs
sudo journalctl -u SERVICE_NAME -n 50
sudo journalctl -u SERVICE_NAME -f
```

</details>

---

## 🎓 Skills Demonstrated

This project showcases a comprehensive set of skills valued in DevOps, Cloud Engineering, and System Administration roles:

### Technical Skills

**Linux System Administration:**
- Server installation and configuration
- Network configuration and troubleshooting
- User and permission management
- Service management with systemd
- Package management (apt)
- Log analysis and troubleshooting

**Security & Hardening:**
- SSH key-based authentication
- Firewall configuration (UFW/iptables)
- Intrusion detection and prevention
- Security patch management
- Principle of least privilege
- Network segmentation
- Security auditing

**Infrastructure as Code (IaC):**
- Ansible playbook development
- Role-based architecture
- Idempotent configuration
- Template management (Jinja2)
- Variable management
- Inventory organization
- Multi-tier application deployment

**Automation & Scripting:**
- Bash scripting
- Ansible automation
- Configuration management
- Automated deployment
- Service orchestration
- Cron job scheduling

**Application Deployment:**
- Reverse proxy configuration (Nginx)
- Application server setup (Node.js/Express)
- Database deployment (PostgreSQL)
- Service integration
- Health check implementation

**Monitoring & Observability:**
- Metrics collection (node_exporter)
- Service monitoring (Prometheus)
- Performance tracking and visualization (Grafana)
- Dashboard creation and customization
- Time-series data analysis
- Infrastructure observability
- Real-time monitoring implementation

**Logging & Auditing:**
- Centralized log management (rsyslog)
- Log forwarding configuration
- Log rotation and retention policies
- Log analysis and troubleshooting

**Backup & Recovery:**
- Automated backup strategies
- Database backup automation (pg_dump)
- Configuration backup procedures
- Multi-tier retention policies
- Backup verification and testing
- Disaster recovery planning

**Version Control:**
- Git workflow
- Repository management
- Commit best practices
- Documentation maintenance
- Change tracking

**Networking:**
- TCP/IP fundamentals
- DNS configuration
- Firewall rules
- Port management
- Network troubleshooting
- Multi-network setup (NAT + Host-Only)

### Soft Skills

**Documentation:**
- Clear, comprehensive README
- Command references
- Architecture diagrams
- Troubleshooting guides
- Progressive documentation

**Problem Solving:**
- Systematic debugging
- Root cause analysis
- Solution documentation
- Iterative improvement

**Project Management:**
- Phase-based approach
- Progress tracking
- Time estimation
- Milestone achievement
- Scope management

**Professional Development:**
- Self-directed learning
- Following best practices
- Continuous improvement
- Knowledge sharing

---

## 🔮 Future Enhancements

Potential additions to expand the project:

### Immediate Next Steps (Phase 6)
- [ ] Database restore procedures
- [ ] Configuration restore testing
- [ ] Full infrastructure rebuild automation
- [ ] RTO/RPO documentation
- [ ] Disaster recovery playbooks

### Infrastructure Improvements
- [ ] High Availability (HA) setup with keepalived
- [ ] Load balancing with HAProxy or Nginx
- [ ] Containerization with Docker
- [ ] Container orchestration with Kubernetes (K3s)
- [ ] Service mesh implementation (Istio/Linkerd)

### Security Enhancements
- [ ] VPN setup (OpenVPN/WireGuard)
- [ ] Certificate management with Let's Encrypt
- [ ] Web Application Firewall (ModSecurity)
- [ ] Security scanning (Lynis, OpenVAS)
- [ ] Compliance automation (CIS benchmarks)
- [ ] Vulnerability scanning

### Monitoring & Alerting
- [ ] APM (Application Performance Monitoring)
- [ ] Distributed tracing (Jaeger)
- [ ] Custom metrics and exporters
- [ ] PagerDuty/Slack integration
- [ ] SLA monitoring
- [ ] Log aggregation (ELK stack)

### CI/CD Pipeline
- [ ] Jenkins/GitLab CI setup
- [ ] Automated testing
- [ ] Blue-green deployments
- [ ] Canary releases
- [ ] Rollback procedures
- [ ] Pipeline automation

### Cloud Migration
- [ ] Terraform for AWS/Azure/GCP
- [ ] Cloud-native monitoring
- [ ] Auto-scaling groups
- [ ] Managed database services
- [ ] Cloud cost optimization

---

## 🤝 Contributing

This is a personal portfolio project, but feedback and suggestions are always welcome!

### How to Provide Feedback

1. **Issues**: Open an issue on GitHub for bugs or suggestions
2. **Discussions**: Start a discussion for questions or ideas
3. **Pull Requests**: Not accepting PRs as this is a learning project, but appreciate the interest!

### Learning Resources

If you're building a similar project, here are helpful resources:

**Ansible:**
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Pre-built roles
- [Jeff Geerling's Ansible for DevOps](https://www.ansiblefordevops.com/)

**Linux:**
- [Linux Journey](https://linuxjourney.com/)
- [The Linux Command Line (free book)](http://linuxcommand.org/tlcl.php)
- [OverTheWire Bandit](https://overthewire.org/wargames/bandit/) - Security practice

**DevOps:**
- [The Phoenix Project (book)](https://itrevolution.com/product/the-phoenix-project/)
- [DevOps Roadmap](https://roadmap.sh/devops)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)

**Prometheus & Grafana:**
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Node Exporter Guide](https://prometheus.io/docs/guides/node-exporter/)

**Logging & Backup:**
- [rsyslog Documentation](https://www.rsyslog.com/doc/)
- [PostgreSQL Backup Guide](https://www.postgresql.org/docs/current/backup.html)
- [Logrotate Manual](https://linux.die.net/man/8/logrotate)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

Feel free to use this project as a template or reference for your own learning!

---

## 👤 Author

**Skander Ba**

- 🌐 GitHub: [@Skanderba8](https://github.com/Skanderba8)
- 📧 Email: baskander5@gmail.com
- 💼 LinkedIn: [Skander Ben Abdallah](https://www.linkedin.com/in/skanderbena5/)
- 🌟 Portfolio: [Website](http://skander-portfolio-bucket2026.s3-website-eu-west-1.amazonaws.com/)

---

## 📞 Contact & Feedback

### Questions About This Project?

- **GitHub Issues**: For bugs or technical questions
- **GitHub Discussions**: For general questions and ideas
- **Email**: For collaboration or opportunities

### Acknowledgments

Special thanks to:
- The Ansible community for excellent documentation
- The Linux community for amazing tools and support
- The Prometheus and Grafana teams for outstanding monitoring tools
- The rsyslog and PostgreSQL communities for robust logging and database solutions
- Everyone who provides feedback and suggestions

---

## 📈 Project Stats

- **Started**: January 30, 2026
- **Phase 1 Complete**: January 31, 2026
- **Phase 2 Complete**: February 3, 2026
- **Phase 3 Complete**: February 3, 2026
- **Phase 4 Complete**: February 7, 2026
- **Phase 5 Complete**: February 7, 2026
- **Current Status**: Phase 5 Complete - Ready for Phase 6
- **Total Commits**: Check GitHub for latest count
- **Lines of Ansible Code**: ~2,000+
- **Documentation Pages**: 1 (comprehensive README)
- **Services Deployed**: 3-tier application stack + Monitoring + Logging + Backups
- **Ansible Roles**: 14 (security + services + monitoring + logging + backup)
- **Playbooks**: 11 (deployment + verification)

---

## 🏆 Milestones Achieved

- ✅ **2026-01-30**: Project initiated, Phase 1 planning complete
- ✅ **2026-01-31**: Phase 1 complete - All VMs configured manually
- ✅ **2026-02-02**: Ansible installed, SSH keys distributed, passwordless sudo configured
- ✅ **2026-02-02**: Git repository initialized and pushed to GitHub
- ✅ **2026-02-02**: Created all base security hardening roles
- ✅ **2026-02-02**: Base-hardening playbook tested and verified
- ✅ **2026-02-03**: Web server (Nginx) deployed successfully
- ✅ **2026-02-03**: Application server (Node.js) deployed successfully
- ✅ **2026-02-03**: Database server (PostgreSQL) deployed successfully
- ✅ **2026-02-03**: Phase 2 COMPLETE - Full automation verified
- ✅ **2026-02-03**: Prometheus deployed and configured
- ✅ **2026-02-03**: Grafana deployed and configured
- ✅ **2026-02-03**: Monitoring dashboards created and tested
- ✅ **2026-02-03**: Phase 3 COMPLETE - Centralized monitoring operational
- ✅ **2026-02-07**: rsyslog server configured on control-node
- ✅ **2026-02-07**: Log forwarding from all managed nodes working
- ✅ **2026-02-07**: Phase 4 COMPLETE - Centralized logging operational
- ✅ **2026-02-07**: Database backup automation deployed
- ✅ **2026-02-07**: Configuration backup automation deployed
- ✅ **2026-02-07**: Multi-tier retention policy implemented
- ✅ **2026-02-07**: Phase 5 COMPLETE - Automated backups operational
- 🎯 **Next**: Phase 6 - Disaster recovery testing

---

## 📊 Infrastructure Health Status

**Last Verified**: February 7, 2026

| Component | Status | Health Check |
|-----------|--------|--------------|
| Web Server (Nginx) | 🟢 Running | ✓ HTTP responding |
| App Server (Node.js) | 🟢 Running | ✓ Health endpoint OK |
| Database (PostgreSQL) | 🟢 Running | ✓ Accepting connections |
| SSH Security | 🟢 Active | ✓ Key-only auth |
| Firewall (UFW) | 🟢 Active | ✓ Rules enforced |
| fail2ban | 🟢 Active | ✓ Monitoring SSH |
| Auto Updates | 🟢 Configured | ✓ Security patches enabled |
| Node Exporter | 🟢 Running | ✓ Metrics available (all 4 servers) |
| **Prometheus** | **🟢 Running** | **✓ All 4 targets UP** ✅ |
| **Grafana** | **🟢 Running** | **✓ Dashboards operational** ✅ |
| **Centralized Logging** | **🟢 Running** | **✓ All nodes forwarding logs** ✅ |
| **Database Backups** | **🟢 Scheduled** | **✓ Cron job active (2:00 AM)** ✅ |
| **Config Backups** | **🟢 Scheduled** | **✓ Cron jobs active (3:00 AM)** ✅ |
| End-to-End Connectivity | 🟢 Verified | ✓ Web→App→DB working |
| **Full Stack** | **🟢 Verified** | **✓ Complete observability & backup** ✅ |

---

**Last Updated**: February 7, 2026  
**README Version**: 5.0  
**Status**: Living Document - Updated as project progresses

---

*Phase 5 is complete! Infrastructure now has automated backups with multi-tier retention policies. Database and configuration backups run daily with 7/28/90 day retention. Next: Test disaster recovery procedures and restore capabilities.*

---

<div align="center">

**If you found this project helpful or interesting, please consider giving it a ⭐ on GitHub!**

[⬆ Back to Top](#linux-production-infrastructure---automated-with-ansible)

</div>
