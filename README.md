# Linux Production Infrastructure - Automated with Ansible

> A production-style Linux infrastructure project demonstrating system administration, security hardening, and Infrastructure as Code (IaC) practices using Ansible automation.

[![Project Status](https://img.shields.io/badge/Status-Phase%202%20In%20Progress-yellow)]()
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
- **Monitoring & Observability**: Metrics collection and alerting capabilities
- **Disaster Recovery**: Backup and restore procedures with validation
- **Professional Documentation**: Clear, comprehensive, and maintainable

### Project Goals

1. ✅ Build a multi-server Linux environment with proper networking
2. ✅ Implement security best practices (SSH hardening, firewalls, intrusion prevention)
3. 🚧 Automate everything with Ansible for repeatability
4. ⏸️ Deploy production-ready services (web, application, database tiers)
5. ⏸️ Implement centralized monitoring and alerting
6. ⏸️ Create automated backup and disaster recovery procedures
7. ⏸️ Test failure scenarios and validate recovery processes
8. ⏸️ Document everything for knowledge transfer

**Time Investment**: ~40-50 hours (8 phases)

---

## 🏗️ Infrastructure Architecture

### Environment Specifications

- **Hypervisor**: VirtualBox 7.x on Windows 11 host
- **Operating System**: Linux Mint 22 (based on Ubuntu 24.04 LTS)
- **Network**: Dual-adapter setup (NAT + Host-Only)
- **Automation Platform**: Ansible 2.x
- **Version Control**: Git / GitHub

### Server Topology

| Hostname | Role | NAT IP | Host-Only IP | vCPU | RAM | Disk | Status |
|----------|------|--------|--------------|------|-----|------|--------|
| **baseline-template** | Golden Image | 10.0.2.10 | 192.168.56.10 | 2 | 2GB | 25GB | 🔴 Powered Off |
| **control-node** | Ansible Controller | 10.0.2.11 | 192.168.56.11 | 2 | 2GB | 25GB | 🟢 Running |
| **web-server** | Nginx Reverse Proxy | 10.0.2.12 | 192.168.56.12 | 2 | 2GB | 25GB | 🟢 Running |
| **app-server** | Application Server | 10.0.2.13 | 192.168.56.13 | 2 | 2GB | 25GB | 🟢 Running |
| **db-server** | Database Server | 10.0.2.14 | 192.168.56.14 | 2 | 4GB | 50GB | 🟢 Running |

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

### Network Explanation

**Two Network Adapters per VM:**

1. **NAT Network (enp0s3)** - `10.0.2.0/24`
   - VM-to-VM communication using hostnames
   - Internet access for updates and packages
   - Internal service communication
   - **Used by Ansible** for automation

2. **Host-Only Network (enp0s8)** - `192.168.56.0/24`
   - SSH access from Windows host
   - Management and administration
   - Development and debugging

---

## 📈 Project Phases

### Phase 1: Manual Base Configuration ✅ COMPLETE
**Objective**: Build the infrastructure foundation manually to understand every component

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

### Phase 2: Automation with Ansible 🚧 IN PROGRESS
**Objective**: Convert all manual configurations into automated, repeatable Ansible playbooks

**Current Progress**:
- [x] Installed Ansible on control-node
- [x] Created project directory structure
- [x] Generated SSH keys for Ansible
- [x] Distributed SSH keys to managed nodes
- [x] Configured passwordless sudo on all managed nodes
- [x] Created ansible.cfg configuration
- [x] Created inventory file with host groups
- [x] Tested Ansible connectivity with ping module
- [x] Created .gitignore for repository
- [x] Initialized Git repository
- [x] Pushed to GitHub repository
- [ ] Create roles directory structure
- [ ] Develop SSH hardening role
- [ ] Develop firewall (UFW) role
- [ ] Develop fail2ban role
- [ ] Develop auto-updates role
- [ ] Develop node_exporter monitoring role
- [ ] Create base-hardening.yml playbook
- [ ] Create verify-config.yml playbook
- [ ] Test playbook idempotency
- [ ] Create snapshot: `Phase2-Complete-Ansible-Automation`

**Estimated Time**: 8-12 hours  
**Status**: 🚧 40% Complete  
**Next Steps**: Create Ansible roles for each security component

---

### Phase 3: Service Deployment ⏸️ PENDING
**Objective**: Deploy production-ready services using Ansible

**Planned Tasks**:
- [ ] Deploy Nginx as reverse proxy on web-server
- [ ] Configure SSL/TLS certificates
- [ ] Deploy sample Node.js/Python application on app-server
- [ ] Install and configure PostgreSQL on db-server
- [ ] Set up database users and permissions
- [ ] Configure service communication between tiers
- [ ] Implement health checks
- [ ] Create service-specific playbooks
- [ ] Test full application stack
- [ ] Document service architecture

**Deliverables**:
- Working web → app → database architecture
- Service configuration playbooks
- Health check scripts
- Architecture documentation

**Estimated Time**: 8-10 hours

---

### Phase 4: Centralized Monitoring ⏸️ PENDING
**Objective**: Implement Prometheus and Grafana for infrastructure monitoring

**Planned Tasks**:
- [ ] Install Prometheus on control-node
- [ ] Configure Prometheus to scrape all node_exporters
- [ ] Install Grafana for visualization
- [ ] Create custom dashboards (CPU, RAM, Disk, Network)
- [ ] Set up alerting rules
- [ ] Configure notification channels (email/webhook)
- [ ] Test alert conditions
- [ ] Create monitoring playbook
- [ ] Document monitoring setup

**Deliverables**:
- Centralized monitoring dashboard
- Automated alerting system
- Monitoring documentation

**Estimated Time**: 6-8 hours

---

### Phase 5: Centralized Logging ⏸️ PENDING
**Objective**: Implement centralized log management with rsyslog or ELK stack

**Planned Tasks**:
- [ ] Set up centralized log server
- [ ] Configure rsyslog on all VMs to forward logs
- [ ] Implement log rotation policies
- [ ] Create log parsing rules
- [ ] Set up log-based alerts
- [ ] Create logging playbook
- [ ] Test log forwarding
- [ ] Document logging architecture

**Deliverables**:
- Centralized log collection system
- Log retention policies
- Log analysis capabilities

**Estimated Time**: 5-7 hours

---

### Phase 6: Backup Automation ⏸️ PENDING
**Objective**: Implement automated backup and retention policies

**Planned Tasks**:
- [ ] Create backup scripts for each service
- [ ] Implement database backup automation
- [ ] Set up backup retention policies
- [ ] Configure backup to remote location (simulated S3/NFS)
- [ ] Create cron jobs for scheduled backups
- [ ] Implement backup verification
- [ ] Create backup playbook
- [ ] Test backup procedures
- [ ] Document backup strategy

**Deliverables**:
- Automated backup system
- Backup verification scripts
- Retention policies
- Backup documentation

**Estimated Time**: 5-7 hours

---

### Phase 7: Disaster Recovery ⏸️ PENDING
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

### Phase 8: Failure Testing & Validation ⏸️ PENDING
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
Phase 2: ████████████░░░░░░░░░░░░░░░░░░░░  40% 🚧 IN PROGRESS
Phase 3: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
Phase 4: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
Phase 5: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
Phase 6: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
Phase 7: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
Phase 8: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% ⏸️  PENDING
═══════════════════════════════════════════════════════════
Overall: ████████░░░░░░░░░░░░░░░░░░░░░░░░  25% Complete
```

### Time Investment
- **Phase 1**: 4 hours ✅
- **Phase 2**: 3 hours (ongoing) 🚧
- **Total so far**: 7 hours
- **Estimated remaining**: 38-48 hours

### Last Updated
**Date**: February 2, 2026  
**Current Phase**: Phase 2 - Ansible Automation (40% complete)  
**Next Milestone**: Complete all Ansible roles and test base-hardening playbook

---

## 🔐 Security Implementations

### Multi-Layered Security Approach

#### 1. SSH Hardening
- ✅ **Key-based authentication only** (password authentication disabled)
- ✅ **Root login disabled** via SSH
- ✅ **Public key authentication** configured for sysadmin user
- ✅ **MaxAuthTries**: Limited to 3 attempts
- ✅ **Port**: Standard port 22 (can be changed in production)

**Configuration File**: `/etc/ssh/sshd_config`

#### 2. Firewall (UFW - Uncomplicated Firewall)
- ✅ **Default Policy**: Deny incoming, Allow outgoing
- ✅ **Allowed Services**:
  - SSH (22/tcp) - from anywhere for management
  - node_exporter (9100/tcp) - restricted to internal network only
- ✅ **Enabled on boot**: Automatically starts with system

**Check Status**: `sudo ufw status verbose`

#### 3. Intrusion Prevention (fail2ban)
- ✅ **Monitoring**: SSH login attempts
- ✅ **Max Retries**: 3 failed attempts
- ✅ **Ban Time**: 3600 seconds (1 hour)
- ✅ **Find Time**: 600 seconds (10 minutes)
- ✅ **Automatic IP banning** after threshold exceeded

**Configuration File**: `/etc/fail2ban/jail.local`  
**Check Status**: `sudo fail2ban-client status sshd`

#### 4. Automatic Security Updates
- ✅ **Service**: unattended-upgrades
- ✅ **Update Type**: Security updates only
- ✅ **Auto-reboot**: Disabled (manual control preferred)
- ✅ **Old Kernel Cleanup**: Enabled
- ✅ **Daily Update Check**: Automated

**Configuration File**: `/etc/apt/apt.conf.d/50unattended-upgrades`

#### 5. System Monitoring
- ✅ **Agent**: Prometheus node_exporter v1.8.2
- ✅ **Metrics Port**: 9100
- ✅ **Metrics Collected**:
  - CPU usage and load averages
  - Memory and swap utilization
  - Disk space and I/O
  - Network traffic and errors
  - System uptime and processes

**Access Metrics**: `curl http://localhost:9100/metrics`

#### 6. Passwordless Sudo Configuration
- ✅ **User**: sysadmin
- ✅ **Configuration**: `/etc/sudoers.d/sysadmin`
- ✅ **Permissions**: 0440 (read-only, validated)
- ✅ **Purpose**: Required for Ansible automation
- ✅ **Security Context**: Limited to key-based SSH access

---

## 🛠️ Technologies Used

### Operating Systems & Virtualization
- **Host OS**: Windows 11 Pro
- **Hypervisor**: Oracle VirtualBox 7.x
- **Guest OS**: Linux Mint 22 Wilma (based on Ubuntu 24.04 LTS)
- **Kernel**: Linux 6.8.x

### Automation & Configuration Management
- **Ansible**: 2.x (automation platform)
- **YAML**: Configuration and playbook syntax
- **Jinja2**: Template engine for dynamic configurations
- **Git**: Version control

### Security Tools
- **OpenSSH**: Secure remote access
- **UFW**: Firewall management (frontend for iptables)
- **fail2ban**: Intrusion prevention system
- **unattended-upgrades**: Automatic security patching

### Monitoring & Observability
- **Prometheus node_exporter**: Metrics collection agent
- **Prometheus**: Time-series database (Phase 4)
- **Grafana**: Visualization and dashboards (Phase 4)

### Future Tech Stack (Upcoming Phases)
- **Nginx**: Reverse proxy and web server
- **Node.js / Python**: Application layer
- **PostgreSQL**: Relational database
- **rsyslog / ELK**: Centralized logging
- **Bash**: Backup and maintenance scripts
- **Cron**: Job scheduling

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

# Apply base hardening configuration (when ready)
ansible-playbook playbooks/base-hardening.yml

# Verify all configurations
ansible-playbook playbooks/verify-config.yml

# Run in check mode (dry run)
ansible-playbook playbooks/base-hardening.yml --check

# Run with verbose output for troubleshooting
ansible-playbook playbooks/base-hardening.yml -vvv
```

### Project Structure

```
infrastructure/
│
├── ansible.cfg                 # Ansible configuration file
├── .gitignore                 # Git ignore file (secrets, keys)
├── README.md                  # This file
│
├── inventory/
│   └── hosts.yml              # Server inventory (host definitions)
│
├── group_vars/
│   └── all.yml                # Global variables for all hosts
│
├── host_vars/                 # Host-specific variables (future)
│   ├── web-server.yml
│   ├── app-server.yml
│   └── db-server.yml
│
├── playbooks/                 # Ansible playbooks
│   ├── base-hardening.yml     # Main security hardening playbook
│   ├── verify-config.yml      # Configuration verification
│   ├── web-server.yml         # Web server deployment
│   ├── app-server.yml         # Application deployment
│   └── db-server.yml          # Database deployment
│
├── roles/                     # Ansible roles (reusable components)
│   ├── ssh_hardening/         # SSH security configuration
│   │   ├── tasks/
│   │   ├── handlers/
│   │   ├── templates/
│   │   └── defaults/
│   ├── firewall/              # UFW firewall configuration
│   ├── fail2ban/              # Intrusion prevention
│   ├── auto_updates/          # Automatic security updates
│   ├── node_exporter/         # Monitoring agent
│   ├── nginx/                 # Web server (Phase 3)
│   ├── postgresql/            # Database (Phase 3)
│   └── backup/                # Backup automation (Phase 6)
│
├── files/                     # Static files to copy to servers
│   └── scripts/
│
└── templates/                 # Jinja2 templates for dynamic configs
    └── *.j2
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
# Paste service configuration:
# [Unit]
# Description=Node Exporter
# After=network.target
#
# [Service]
# User=node_exporter
# Group=node_exporter
# Type=simple
# ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9100
#
# [Install]
# WantedBy=multi-user.target

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

#### VM Cloning Configuration

For each cloned VM (control-node, web-server, app-server, db-server):

```bash
# Example for control-node (repeat for each VM with appropriate values)

# Set hostname
sudo hostnamectl set-hostname control-node

# Update /etc/hosts
sudo nano /etc/hosts
# Change: 127.0.1.1  control-node
# Add VM resolution:
# 10.0.2.11    control-node
# 10.0.2.12    web-server
# 10.0.2.13    app-server
# 10.0.2.14    db-server

# Update NAT Network IP
sudo nmcli connection modify "Wired connection 1" ipv4.addresses 10.0.2.11/24
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"

# Update Host-Only Network IP
sudo nmcli connection modify "host-only" ipv4.addresses 192.168.56.11/24
sudo nmcli connection down "host-only"
sudo nmcli connection up "host-only"

# Verify configuration
hostname
ip addr show
ping -c 2 google.com
ping -c 2 web-server

# Reboot for all changes to take effect
sudo reboot
```

#### Verification Commands

```bash
# Check all services
sudo systemctl status ssh
sudo systemctl status fail2ban
sudo systemctl status node_exporter
sudo systemctl status unattended-upgrades

# Check firewall
sudo ufw status verbose

# Test connectivity
ping -c 2 control-node
ping -c 2 web-server
ping -c 2 app-server
ping -c 2 db-server
ping -c 2 google.com

# Check SSH to other VMs
ssh sysadmin@web-server "hostname"
ssh sysadmin@app-server "hostname"
ssh sysadmin@db-server "hostname"
```

</details>

---

### Phase 2: Ansible Automation Commands

<details>
<summary><b>Click to expand Phase 2 commands (current phase)</b></summary>

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
# Press ENTER for all prompts (use defaults, no passphrase)

# View the public key
cat ~/.ssh/id_ed25519.pub

# Copy SSH key to each managed node
ssh-copy-id sysadmin@web-server
# Type "yes" when prompted, enter password

ssh-copy-id sysadmin@app-server
# Type "yes" when prompted, enter password

ssh-copy-id sysadmin@db-server
# Type "yes" when prompted, enter password

# Test passwordless SSH to each node
ssh sysadmin@web-server "hostname"
ssh sysadmin@app-server "hostname"
ssh sysadmin@db-server "hostname"
```

#### Configure Passwordless Sudo (on managed nodes)

From **Windows PowerShell**, SSH into each managed node and configure:

```bash
# For web-server (repeat for app-server and db-server)
ssh sysadmin@192.168.56.12

# Create sudoers file
echo "sysadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sysadmin

# Set correct permissions
sudo chmod 0440 /etc/sudoers.d/sysadmin

# Test sudo without password
sudo whoami
# Should return: root (without asking for password)

# Validate sudoers syntax
sudo visudo -c
# Should show: parsed OK

# Exit back to Windows
exit
```

#### Ansible Configuration Files

**Create ansible.cfg:**

```bash
cd ~/infrastructure
nano ansible.cfg
```

Paste this configuration:

```ini
[defaults]
inventory = ./inventory/hosts.yml
host_key_checking = False
remote_user = sysadmin
private_key_file = ~/.ssh/id_ed25519
retry_files_enabled = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False

[ssh_connection]
pipelining = True
```

**Create inventory file:**

```bash
nano inventory/hosts.yml
```

Paste this inventory:

```yaml
all:
  children:
    control:
      hosts:
        control-node:
          ansible_host: 10.0.2.11
    
    web_servers:
      hosts:
        web-server:
          ansible_host: 10.0.2.12
    
    app_servers:
      hosts:
        app-server:
          ansible_host: 10.0.2.13
    
    db_servers:
      hosts:
        db-server:
          ansible_host: 10.0.2.14
    
    managed_nodes:
      children:
        web_servers:
        app_servers:
        db_servers:
```

**Create group variables:**

```bash
nano group_vars/all.yml
```

Paste these variables:

```yaml
---
# Global variables for all hosts

# User configuration
admin_user: sysadmin

# SSH configuration
ssh_port: 22
ssh_permit_root_login: 'no'
ssh_password_authentication: 'no'
ssh_pubkey_authentication: 'yes'

# Firewall configuration
ufw_default_incoming: deny
ufw_default_outgoing: allow
ufw_ssh_from_anywhere: true

# fail2ban configuration
fail2ban_maxretry: 3
fail2ban_bantime: 3600
fail2ban_findtime: 600

# node_exporter configuration
node_exporter_version: "1.8.2"
node_exporter_port: 9100

# Network configuration
nat_network: "10.0.2.0/24"
```

#### Test Ansible Connectivity

```bash
# Ping all managed nodes
ansible managed_nodes -m ping

# Expected output: SUCCESS for all nodes

# Check hostname on all nodes
ansible managed_nodes -m command -a "hostname"

# Check uptime
ansible managed_nodes -m command -a "uptime"

# Check disk space
ansible managed_nodes -m shell -a "df -h /"

# Test sudo access
ansible managed_nodes -m command -a "sudo whoami"
# Should return: root
```

#### Git Repository Setup

```bash
cd ~/infrastructure

# Create .gitignore
nano .gitignore
```

Paste this content:

```gitignore
# Ansible temporary files
*.retry
.ansible/
/tmp/ansible_facts/

# SSH keys (NEVER commit these!)
*.pem
*.key
id_rsa
id_rsa.pub
id_ed25519
id_ed25519.pub

# Secrets and passwords
*secret*
*password*
*.vault
vault-pass.txt

# OS files
.DS_Store
Thumbs.db

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Python
__pycache__/
*.pyc
*.pyo

# Logs
*.log
```

**Configure Git:**

```bash
# Set Git identity
git config --global user.name "Skander Ba"
git config --global user.email "your-email@example.com"

# Verify configuration
git config --global --list
```

**Initialize Git and commit:**

```bash
# Initialize repository
git init

# Check status
git status

# Stage files (respects .gitignore)
git add .

# Create initial commit
git commit -m "Initial commit: Ansible infrastructure setup

- Added Ansible configuration and inventory
- Created directory structure for roles and playbooks
- Added .gitignore for security"

# Add GitHub remote (replace with your repo URL)
git remote add origin https://github.com/Skanderba8/linux-production-infrastructure.git

# Verify remote
git remote -v
```

**Merge with GitHub and push:**

```bash
# Configure merge strategy
git config pull.rebase false

# Pull existing content from GitHub
git pull origin main --allow-unrelated-histories
# If editor opens, save and exit (Ctrl+X, Y, Enter in nano)

# Check status
git status
ls -la

# Push to GitHub
git push -u origin main
# Enter GitHub username: Skanderba8
# Enter Personal Access Token as password
```

**Future Git workflow:**

```bash
# After making changes
git status
git add .
git commit -m "Descriptive commit message"
git push
```

#### Ansible Ad-Hoc Commands (Useful for Testing)

```bash
# Run any command on all managed nodes
ansible managed_nodes -m command -a "COMMAND"

# Examples:
ansible managed_nodes -m command -a "free -h"
ansible managed_nodes -m command -a "df -h"
ansible managed_nodes -m command -a "who"
ansible managed_nodes -m shell -a "ps aux | grep ssh"

# Copy a file to all nodes
ansible managed_nodes -m copy -a "src=/path/to/local/file dest=/path/on/remote"

# Install a package on all nodes
ansible managed_nodes -m apt -a "name=htop state=present"

# Restart a service on all nodes
ansible managed_nodes -m systemd -a "name=ssh state=restarted"

# Gather facts about all nodes
ansible managed_nodes -m setup

# Check specific fact
ansible managed_nodes -m setup -a "filter=ansible_distribution*"
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

# Check DNS resolution
cat /etc/resolv.conf
resolvectl status

# Test connectivity
ping -c 4 8.8.8.8          # Test internet
ping -c 4 google.com       # Test DNS
ping -c 4 web-server       # Test internal hostname

# Check open ports
sudo netstat -tulpn
sudo ss -tulpn

# Test specific port
nc -zv hostname port       # Example: nc -zv web-server 22
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

# Check SSH keys
ls -la ~/.ssh/
cat ~/.ssh/authorized_keys

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

# Temporarily disable for testing (NOT recommended in production)
sudo ufw disable

# Re-enable
sudo ufw enable
```

#### fail2ban Issues

```bash
# Check fail2ban status
sudo systemctl status fail2ban

# Check all jails
sudo fail2ban-client status

# Check specific jail
sudo fail2ban-client status sshd

# View banned IPs
sudo fail2ban-client get sshd banip

# Unban an IP
sudo fail2ban-client set sshd unbanip IP_ADDRESS

# View fail2ban logs
sudo tail -f /var/log/fail2ban.log
```

#### Ansible Issues

```bash
# Test connectivity
ansible all -m ping

# Run with verbose output
ansible-playbook playbook.yml -v    # Verbose
ansible-playbook playbook.yml -vv   # More verbose
ansible-playbook playbook.yml -vvv  # Very verbose

# Run in check mode (dry run)
ansible-playbook playbook.yml --check

# Run only on specific host
ansible-playbook playbook.yml --limit web-server

# View Ansible configuration
ansible-config dump

# List all hosts in inventory
ansible-inventory --list
ansible-inventory --graph

# Check syntax of playbook
ansible-playbook playbook.yml --syntax-check
```

#### System Performance

```bash
# Check CPU usage
top
htop

# Check memory usage
free -h
vmstat 1 5

# Check disk space
df -h
du -sh /path/to/directory

# Check disk I/O
iostat -x 1 5
iotop

# Check network usage
iftop
nethogs

# View system logs
sudo journalctl -xe
sudo tail -f /var/log/syslog
```

#### Service Management

```bash
# Check service status
sudo systemctl status SERVICE_NAME

# Start a service
sudo systemctl start SERVICE_NAME

# Stop a service
sudo systemctl stop SERVICE_NAME

# Restart a service
sudo systemctl restart SERVICE_NAME

# Enable service on boot
sudo systemctl enable SERVICE_NAME

# Disable service on boot
sudo systemctl disable SERVICE_NAME

# View service logs
sudo journalctl -u SERVICE_NAME -n 50
sudo journalctl -u SERVICE_NAME -f    # Follow logs
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
- Security auditing

**Infrastructure as Code (IaC):**
- Ansible playbook development
- Role-based architecture
- Idempotent configuration
- Template management (Jinja2)
- Variable management
- Inventory organization

**Automation & Scripting:**
- Bash scripting
- Ansible automation
- Cron job scheduling
- Automated deployment
- Configuration management

**Monitoring & Observability:**
- Metrics collection (Prometheus)
- Dashboard creation (Grafana)
- Alert configuration
- Log aggregation
- Performance monitoring

**Version Control:**
- Git workflow
- Repository management
- Commit best practices
- Documentation maintenance

**Networking:**
- TCP/IP fundamentals
- DNS configuration
- Firewall rules
- Port management
- Network troubleshooting

### Soft Skills

**Documentation:**
- Clear, comprehensive README
- Command references
- Architecture diagrams
- Troubleshooting guides

**Problem Solving:**
- Systematic debugging
- Root cause analysis
- Solution documentation

**Project Management:**
- Phase-based approach
- Progress tracking
- Time estimation
- Milestone achievement

**Professional Development:**
- Self-directed learning
- Following best practices
- Continuous improvement

---

## 🔮 Future Enhancements

Potential additions to expand the project:

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

### Monitoring & Alerting
- [ ] APM (Application Performance Monitoring)
- [ ] Distributed tracing (Jaeger)
- [ ] Custom metrics and exporters
- [ ] PagerDuty/Slack integration
- [ ] SLA monitoring

### CI/CD Pipeline
- [ ] Jenkins/GitLab CI setup
- [ ] Automated testing
- [ ] Blue-green deployments
- [ ] Canary releases
- [ ] Rollback procedures

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

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

Feel free to use this project as a template or reference for your own learning!

---

## 👤 Author

**Skander Ba**

- 🌐 GitHub: [@Skanderba8](https://github.com/Skanderba8)
- 📧 Email: [baskander5@gmail.com]
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
- Everyone who provides feedback and suggestions

---

## 📈 Project Stats

- **Started**: January 30, 2026
- **Current Status**: Phase 2 (40% complete)
- **Total Commits**: Check GitHub for latest count
- **Lines of Configuration**: ~500+ (growing)
- **Documentation Pages**: 1 (comprehensive README)

---

## 🏆 Milestones Achieved

- ✅ **2026-01-30**: Project initiated, Phase 1 planning complete
- ✅ **2026-01-31**: Phase 1 complete - All VMs configured manually
- ✅ **2026-02-02**: Ansible installed, SSH keys distributed, passwordless sudo configured
- ✅ **2026-02-02**: Git repository initialized and pushed to GitHub
- 🎯 **Next**: Complete all Ansible roles for base hardening

---

**Last Updated**: February 2, 2026  
**README Version**: 2.0  
**Status**: Living Document - Updated as project progresses

---

*This project is actively being developed. Check back for updates!*

---

<div align="center">

**If you found this project helpful or interesting, please consider giving it a ⭐ on GitHub!**

[⬆ Back to Top](#linux-production-infrastructure---automated-with-ansible)

</div>
