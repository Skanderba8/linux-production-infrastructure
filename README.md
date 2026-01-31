# Phase 1 COMPLETE - Infrastructure Summary

## 🎉 Congratulations! Phase 1 is 100% Complete!

You now have a fully functional, secured, multi-VM Linux infrastructure ready for automation.

---

## Infrastructure Overview

### Virtual Machines (5 Total)

| VM Name | Role | NAT Network IP | Host-Only IP | Status |
|---------|------|----------------|--------------|--------|
| baseline-template | Template (DO NOT USE) | 10.0.2.10 | 192.168.56.10 | Powered Off |
| control-node | Ansible Control Server | 10.0.2.11 | 192.168.56.11 | ✅ Running |
| web-server | Nginx Reverse Proxy | 10.0.2.12 | 192.168.56.12 | ✅ Running |
| app-server | Application/API Server | 10.0.2.13 | 192.168.56.13 | ✅ Running |
| db-server | Database Server | 10.0.2.14 | 192.168.56.14 | ✅ Running |

### Network Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Windows Host Machine                      │
│                   (192.168.56.1 - Host-Only)                 │
└────────────────────────────┬────────────────────────────────┘
                             │ SSH Access
                             │ (Host-Only Network)
        ┌────────────────────┼────────────────────┐
        │                    │                    │
   ┌────▼─────┐       ┌──────▼──────┐      ┌─────▼──────┐
   │ control  │       │ web-server  │      │ app-server │
   │  -node   │       │             │      │            │
   │.56.11    │       │  .56.12     │      │  .56.13    │
   └────┬─────┘       └──────┬──────┘      └─────┬──────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                        ┌────▼──────┐
                        │ db-server │
                        │           │
                        │  .56.14   │
                        └───────────┘

┌──────────────────────────────────────────────────────────────┐
│              NAT Network (InfraNet - 10.0.2.0/24)            │
│  All VMs can communicate with each other and the Internet   │
│                                                              │
│  control-node: 10.0.2.11    web-server:  10.0.2.12         │
│  app-server:   10.0.2.13    db-server:   10.0.2.14         │
└──────────────────────────────────────────────────────────────┘
                             │
                        ┌────▼─────┐
                        │ Internet │
                        └──────────┘
```

---

## Security Configuration (Applied to All VMs)

### ✅ SSH Hardening
- **Authentication**: SSH keys only (password auth disabled)
- **Root Login**: Disabled
- **Port**: 22 (standard)
- **Max Auth Tries**: 3
- **Public Key**: Configured for `sysadmin` user

### ✅ Firewall (UFW)
- **Status**: Active and enabled on boot
- **Default Policy**: Deny incoming, Allow outgoing
- **Allowed Ports**:
  - 22/tcp (SSH) - from anywhere
  - 9100/tcp (node_exporter) - from 10.0.2.0/24 only

### ✅ Intrusion Prevention (fail2ban)
- **Monitoring**: SSH login attempts
- **Max Retries**: 3 failed attempts
- **Ban Time**: 3600 seconds (1 hour)
- **Find Time**: 600 seconds (10 minutes)

### ✅ Automatic Security Updates
- **Service**: unattended-upgrades
- **Enabled**: Security updates only
- **Auto-reboot**: Disabled (manual control)
- **Old Kernel Cleanup**: Enabled

### ✅ Monitoring
- **Agent**: node_exporter v1.8.2
- **Port**: 9100
- **Metrics**: CPU, RAM, Disk, Network, System stats
- **Auto-start**: Enabled

---

## Quick Access Guide

### SSH Access from Windows

```powershell
# SSH to each VM using Host-Only network
ssh sysadmin@192.168.56.11  # control-node
ssh sysadmin@192.168.56.12  # web-server
ssh sysadmin@192.168.56.13  # app-server
ssh sysadmin@192.168.56.14  # db-server
```

### VM-to-VM Communication

All VMs can reach each other by hostname via the NAT Network (10.0.2.x):

```bash
# From any VM, you can:
ping web-server      # Resolves to 10.0.2.12
ping app-server      # Resolves to 10.0.2.13
ping db-server       # Resolves to 10.0.2.14
ping control-node    # Resolves to 10.0.2.11

# Or SSH between VMs
ssh sysadmin@web-server
ssh sysadmin@app-server
# etc.
```

### /etc/hosts Configuration (All VMs)

```
127.0.0.1       localhost
127.0.1.1       [hostname]

# Infrastructure VMs
10.0.2.11       control-node
10.0.2.12       web-server
10.0.2.13       app-server
10.0.2.14       db-server
```

---

## Services Running on Each VM

| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| SSH | 22 | Remote access | ✅ Running |
| UFW | - | Firewall | ✅ Active |
| fail2ban | - | Intrusion prevention | ✅ Running |
| unattended-upgrades | - | Auto security updates | ✅ Running |
| node_exporter | 9100 | Metrics collection | ✅ Running |

---

## Verification Commands

### Check System Status on Any VM

```bash
# System info
hostname
whoami
uptime

# Network configuration
ip addr show
ip route show

# Security services
sudo systemctl status ssh
sudo systemctl status fail2ban
sudo ufw status verbose

# Monitoring
sudo systemctl status node_exporter
curl http://localhost:9100/metrics | head -20

# Check for updates
sudo apt update
sudo apt list --upgradable
```

### Test Connectivity Between VMs

```bash
# From control-node, test all VMs
ping -c 2 web-server
ping -c 2 app-server
ping -c 2 db-server

# Test internet access
ping -c 2 google.com

# Test SSH to other VMs
ssh sysadmin@web-server "hostname"
ssh sysadmin@app-server "hostname"
ssh sysadmin@db-server "hostname"
```

---

## Configuration Files Reference

### Important Files Modified

| File Path | Purpose |
|-----------|---------|
| `/etc/ssh/sshd_config` | SSH server configuration |
| `/etc/ssh/sshd_config.backup` | Original SSH config backup |
| `/etc/fail2ban/jail.local` | fail2ban configuration |
| `/etc/apt/apt.conf.d/50unattended-upgrades` | Auto-update settings |
| `/etc/hosts` | Hostname to IP resolution |
| `/etc/systemd/system/node_exporter.service` | node_exporter service |
| `~/.ssh/authorized_keys` | SSH public keys |

### Log Files to Monitor

| Log File | Purpose |
|----------|---------|
| `/var/log/auth.log` | SSH authentication attempts |
| `/var/log/fail2ban.log` | fail2ban actions and bans |
| `/var/log/ufw.log` | Firewall events |
| `/var/log/unattended-upgrades/` | Auto-update logs |
| `/var/log/syslog` | General system logs |

---

## Complete Command Reference

### Phase 1 - Step by Step Commands

<details>
<summary>Click to expand full command history</summary>

#### Initial Setup (baseline-template)
```bash
# Set static IP on NAT Network
sudo nmcli connection modify "Wired connection 1" \
  ipv4.addresses 10.0.2.10/24 \
  ipv4.gateway 10.0.2.1 \
  ipv4.dns "8.8.8.8,8.8.4.4" \
  ipv4.method manual
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"

# Set static IP on Host-Only
sudo nmcli connection add type ethernet ifname enp0s8 con-name host-only \
  ipv4.addresses 192.168.56.10/24 \
  ipv4.method manual
sudo nmcli connection up host-only

# Set hostname
sudo hostnamectl set-hostname baseline-template
sudo nano /etc/hosts  # Change to baseline-template

# Update system
sudo apt update && sudo apt upgrade -y
sudo apt install -y vim curl wget git net-tools ufw fail2ban openssh-server
sudo reboot
```

#### SSH Configuration
```bash
# Install SSH server
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Configure SSH keys
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys  # Paste public key
chmod 600 ~/.ssh/authorized_keys

# Harden SSH
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudo nano /etc/ssh/sshd_config
# Set: PermitRootLogin no, PasswordAuthentication no, etc.
sudo sshd -t
sudo systemctl restart ssh
```

#### Firewall Configuration
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw enable
sudo ufw status verbose
```

#### fail2ban Setup
```bash
sudo apt install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local  # Configure [sshd] section
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo fail2ban-client status sshd
```

#### Automatic Updates
```bash
sudo apt install -y unattended-upgrades apt-listchanges
sudo dpkg-reconfigure -plow unattended-upgrades
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
sudo systemctl enable unattended-upgrades
sudo systemctl start unattended-upgrades
```

#### node_exporter Installation
```bash
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/
sudo useradd --no-create-home --shell /bin/false node_exporter

# Create systemd service
sudo nano /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Firewall
sudo ufw allow from 10.0.2.0/24 to any port 9100 proto tcp
```

#### VM Cloning and Configuration
```bash
# For each cloned VM (control-node, web-server, app-server, db-server):

# Example for control-node:
sudo hostnamectl set-hostname control-node
sudo sed -i 's/baseline-template/control-node/g' /etc/hosts
sudo nmcli connection modify "Wired connection 1" ipv4.addresses 10.0.2.11/24
sudo nmcli connection modify "host-only" ipv4.addresses 192.168.56.11/24
sudo nmcli connection down "Wired connection 1" && sudo nmcli connection up "Wired connection 1"
sudo nmcli connection down "host-only" && sudo nmcli connection up "host-only"
sudo reboot

# After reboot, add to /etc/hosts on all VMs:
sudo nano /etc/hosts
# Add:
# 10.0.2.11    control-node
# 10.0.2.12    web-server
# 10.0.2.13    app-server
# 10.0.2.14    db-server
```

</details>

---

## Phase 1 Achievements Summary

### ✅ What You've Accomplished

1. **Infrastructure Setup**
   - Created 5 VMs with proper networking
   - Configured dual network adapters (NAT + Host-Only)
   - Established VM-to-VM and host-to-VM connectivity

2. **Security Hardening**
   - SSH key-based authentication across all VMs
   - Disabled password authentication and root login
   - Active firewall on all systems
   - Intrusion detection with fail2ban
   - Automatic security patching

3. **Monitoring Foundation**
   - Metrics collection agent on all VMs
   - Ready for centralized monitoring (Phase 3)

4. **Documentation**
   - Complete command history
   - Network diagrams
   - Configuration reference
   - Troubleshooting notes

### 📊 Time Invested
Approximately **3-4 hours** of hands-on work

### 🎯 Skills Demonstrated
- Linux system administration
- Network configuration
- Security hardening
- SSH key management
- Firewall configuration
- Service management (systemd)
- VM cloning and templating

---

## What's Next - Phase 2: Automation with Ansible

Now that everything is configured manually, Phase 2 will **automate everything** you just did using Ansible.

### Phase 2 Goals
- Install Ansible on control-node
- Create playbooks to replicate all Phase 1 configurations
- Prove you can rebuild the entire infrastructure from scratch
- Make configurations idempotent and repeatable

### Phase 2 Deliverables
- Ansible inventory file
- Base hardening playbook
- Service-specific playbooks (web, app, db)
- Monitoring setup playbook
- Complete documentation

### Estimated Time
**8-12 hours**

---

## Quick Start Guide for Phase 2

When you're ready to start Phase 2, here's what you'll do:

1. **SSH into control-node**
   ```powershell
   ssh sysadmin@192.168.56.11
   ```

2. **Install Ansible**
   ```bash
   sudo apt update
   sudo apt install -y ansible
   ansible --version
   ```

3. **Create project structure**
   ```bash
   mkdir -p ~/infrastructure
   cd ~/infrastructure
   ```

4. **Set up SSH keys from control-node to other VMs**
   ```bash
   ssh-keygen -t ed25519
   ssh-copy-id sysadmin@web-server
   ssh-copy-id sysadmin@app-server
   ssh-copy-id sysadmin@db-server
   ```

5. **Create inventory file**
   ```bash
   nano inventory/hosts.yml
   ```

But don't worry about this yet - we'll go through it step by step when you're ready!

---

## Current Status

**Phase 1**: ✅ **100% COMPLETE**  
**Phase 2**: ⏸️ Ready to Start  
**Phase 3**: ⏸️ Pending  
**Phase 4**: ⏸️ Pending  
**Phase 5**: ⏸️ Pending  
**Phase 6**: ⏸️ Pending  

---

## Important Notes

### VM Management Tips
- Keep `baseline-template` powered off - it's your golden image
- Take snapshots before major changes
- All 4 active VMs should be running for the project
- Resource usage: ~8GB RAM total when all running

### Backup Strategy
- `baseline-template` snapshot: "Phase1-Complete-Baseline"
- Consider taking snapshots of each configured VM before Phase 2
- Document any configuration changes

### Cost
- **$0** - Everything is running locally on your machine
- No cloud costs, no subscriptions needed

---

## Troubleshooting Quick Reference

### Can't SSH to a VM?
```bash
# Check if SSH is running
sudo systemctl status ssh

# Check firewall
sudo ufw status

# Check IP address
ip addr show
```

### VMs can't ping each other?
```bash
# Check routing
ip route show

# Check /etc/hosts
cat /etc/hosts

# Verify network interfaces are up
ip link show
```

### Internet not working?
```bash
# Check DNS
cat /etc/resolv.conf

# Test connectivity
ping 8.8.8.8
ping google.com

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

---

**Last Updated**: 2026-01-31  
**Infrastructure Status**: ✅ Fully Operational  
**Ready for**: Phase 2 - Ansible Automation