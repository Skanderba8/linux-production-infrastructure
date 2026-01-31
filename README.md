# Phase 1: Baseline Configuration - Progress Summary

## Project: Linux Infrastructure with Automation & Security

---

## What We've Accomplished

### ✅ Step 1.1: VirtualBox Environment Setup
**Completed:**
- Cleaned up old VMs
- Created NAT Network: `InfraNet` (10.0.2.0/24)
- Downloaded Linux Mint 22 ISO
- Created VM: `baseline-template`
  - 2GB RAM, 2 CPUs, 25GB disk
  - Connected to InfraNet (Adapter 1)
  - Host-Only Network (Adapter 2) for SSH access from Windows

**Network Configuration:**
- **Adapter 1 (NAT Network)**: `10.0.2.10/24` - For internet & VM-to-VM communication
- **Adapter 2 (Host-Only)**: `192.168.56.10/24` - For SSH from Windows host

---

### ✅ Step 1.2: Manual Base Configuration

#### 1.2a-d: Initial Setup
**What we did:**
- Installed Linux Mint 22 via unattended installation
- User created: `sysadmin` with sudo access
- Hostname set to: `baseline-template`
- Configured static IP addresses on both network adapters
- Updated system packages

**Commands used:**
```bash
# Set static IP on NAT Network adapter (enp0s3)
sudo nmcli connection modify "Wired connection 1" \
  ipv4.addresses 10.0.2.10/24 \
  ipv4.gateway 10.0.2.1 \
  ipv4.dns "8.8.8.8,8.8.4.4" \
  ipv4.method manual
sudo nmcli connection down "Wired connection 1"
sudo nmcli connection up "Wired connection 1"

# Set static IP on Host-Only adapter (enp0s8)
sudo nmcli connection add type ethernet ifname enp0s8 con-name host-only \
  ipv4.addresses 192.168.56.10/24 \
  ipv4.method manual
sudo nmcli connection up host-only

# Change hostname
sudo hostnamectl set-hostname baseline-template
sudo nano /etc/hosts  # Changed 127.0.1.1 line to baseline-template

# Update system
sudo apt update
sudo apt upgrade -y
sudo apt install -y vim curl wget git net-tools ufw fail2ban openssh-server
sudo reboot
```

**Verification:**
```bash
hostname                    # Shows: baseline-template
ip addr show enp0s3         # Shows: 10.0.2.10/24
ip addr show enp0s8         # Shows: 192.168.56.10/24
```

---

#### 1.2e: SSH Setup
**What we did:**
- Installed OpenSSH server on VM
- Generated SSH key pair on Windows host
- Configured key-based authentication
- Successfully established SSH connection from Windows to VM

**Commands used:**

**On Windows (PowerShell):**
```powershell
# Generate SSH key pair
ssh-keygen -t ed25519 -C "sysadmin@infrastructure-project"
# Location: C:\Users\YourName\.ssh\id_ed25519

# View public key
type $env:USERPROFILE\.ssh\id_ed25519.pub

# SSH to VM
ssh sysadmin@192.168.56.10
```

**On VM:**
```bash
# Install SSH server
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Add public key
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys  # Paste public key here
chmod 600 ~/.ssh/authorized_keys
```

**Result:** ✅ Can SSH from Windows to VM at `192.168.56.10`

---

#### 1.2f: SSH Hardening
**What we did:**
- Disabled root login via SSH
- Disabled password authentication (SSH keys only)
- Limited authentication attempts
- Disabled unnecessary features

**Commands used:**
```bash
# Backup original config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit SSH config
sudo nano /etc/ssh/sshd_config
```

**Changes made to `/etc/ssh/sshd_config`:**
```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
PermitEmptyPasswords no
MaxAuthTries 3
X11Forwarding no
```

```bash
# Test and restart
sudo sshd -t
sudo systemctl restart ssh
```

**Result:** ✅ SSH is hardened - only key-based authentication allowed, no root login

---

#### 1.2g: Firewall Configuration
**What we did:**
- Enabled UFW (Uncomplicated Firewall)
- Set default deny on incoming traffic
- Allowed SSH traffic
- Verified firewall is active

**Commands used:**
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
```

**Current firewall rules:**
```
Status: active
Default: deny (incoming), allow (outgoing)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
2222/tcp                   ALLOW IN    Anywhere
```

**Result:** ✅ Firewall active and protecting the system

---

#### 1.2h: Fail2ban Installation
**What we did:**
- Installed fail2ban for intrusion prevention
- Configured to monitor SSH login attempts
- Set to ban IPs after 3 failed attempts for 1 hour

**Commands used:**
```bash
# Install fail2ban
sudo apt install -y fail2ban

# Create local config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit config
sudo nano /etc/fail2ban/jail.local
```

**Configuration for `[sshd]` jail:**
```ini
[sshd]
enabled = true
port = ssh
maxretry = 3
bantime = 3600
findtime = 600
```

```bash
# Enable and start
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Check status
sudo fail2ban-client status sshd
```

**Result:** ✅ fail2ban monitoring SSH, ready to ban attackers

---

#### 1.2i: Automatic Security Updates
**What we did:**
- Configured automatic installation of security updates
- System will auto-update security patches without manual intervention

**Commands used:**
```bash
# Install unattended-upgrades
sudo apt install -y unattended-upgrades apt-listchanges

# Enable automatic updates
sudo dpkg-reconfigure -plow unattended-upgrades  # Selected "Yes"

# Edit configuration
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

**Key settings enabled:**
- Automatic security updates: ✅
- Remove unused dependencies: ✅
- Remove old kernels: ✅
- Automatic reboot: ❌ (manual control)

```bash
# Test configuration
sudo unattended-upgrades --dry-run --debug

# Enable service
sudo systemctl enable unattended-upgrades
sudo systemctl start unattended-upgrades
```

**Result:** ✅ System will automatically install security updates

---

## Current System State

### Security Hardening Summary
- ✅ SSH key-based authentication only (no passwords)
- ✅ Root login disabled
- ✅ Firewall enabled (UFW) - deny all except SSH
- ✅ fail2ban monitoring for brute-force attempts
- ✅ Automatic security updates enabled
- ✅ Minimal attack surface

### Network Configuration
| Interface | IP Address | Purpose |
|-----------|------------|---------|
| enp0s3 | 10.0.2.10/24 | NAT Network - Internet & VM communication |
| enp0s8 | 192.168.56.10/24 | Host-Only - SSH from Windows |

### Services Running
- ✅ SSH (port 22)
- ✅ UFW Firewall
- ✅ fail2ban
- ✅ unattended-upgrades
- ✅ node_exporter (port 9100)

---

## Verification Commands

Run these to verify the baseline configuration:

```bash
# System info
hostname
whoami
ip addr show

# SSH status
sudo systemctl status ssh
sudo ss -tulpn | grep :22

# Firewall status
sudo ufw status verbose

# fail2ban status
sudo fail2ban-client status
sudo fail2ban-client status sshd

# Automatic updates
sudo systemctl status unattended-upgrades

# Check for updates
sudo apt update
sudo apt list --upgradable
```

---

## What's Next - Phase 1, Step 1.3

### ✅ Baseline Configuration: COMPLETE
All manual configuration is done! The baseline-template is hardened, monitored, and ready.

### 🎯 Next Step: Clone and Configure VMs

**Step 1.3a: Take Snapshot**
- Install node_exporter for Prometheus metrics
- Configure to start on boot
- Test metrics endpoint

#### 1.2j: Monitoring Agent Installation ✅ COMPLETED
**What we did:**
- Installed node_exporter v1.8.2
- Created systemd service for node_exporter
- Configured auto-start on boot
- Exposed metrics on port 9100
- Configured firewall to allow metrics access from NAT Network

**Commands used:**
```bash
# Download and install
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/
node_exporter --version

# Create user
sudo useradd --no-create-home --shell /bin/false node_exporter

# Create systemd service file at /etc/systemd/system/node_exporter.service

# Enable and start
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Allow firewall access from NAT Network
sudo ufw allow from 10.0.2.0/24 to any port 9100 proto tcp

# Test
curl http://localhost:9100/metrics
```

**Result:** ✅ node_exporter running and exposing system metrics

---

## ✅ PHASE 1 COMPLETE!

The baseline-template VM is now fully configured with:
- ✅ Security hardening (SSH, firewall, fail2ban)
- ✅ Automatic updates
- ✅ Monitoring agent (node_exporter)
- ✅ All services configured to auto-start on boot

**This VM is ready to be cloned!**

---

### Step 1.3: Clone VMs (NEXT STEP)
- Take VM snapshot (backup before cloning)
- Clone baseline-template 4 times
- Create and configure:
  - control-node (10.0.2.11 / 192.168.56.11)
  - web-server (10.0.2.12 / 192.168.56.12)
  - app-server (10.0.2.13 / 192.168.56.13)
  - db-server (10.0.2.14 / 192.168.56.14)
- Configure each with unique hostnames and IPs
- Verify connectivity between all VMs

### Documentation
- ✅ All commands documented
- ✅ Runbook created
- Ready for automation in Phase 2

---

## Next Steps

1. **Install node_exporter** (monitoring agent)
2. **Take VM snapshot** (backup before cloning)
3. **Clone baseline-template** to create other VMs
4. **Test connectivity** between all VMs
5. **Begin Phase 2**: Convert manual steps to Ansible playbooks

---

## Important Files & Locations

### Configuration Files Modified
- `/etc/ssh/sshd_config` - SSH hardening
- `/etc/ssh/sshd_config.backup` - Original SSH config backup
- `/etc/fail2ban/jail.local` - fail2ban configuration
- `/etc/apt/apt.conf.d/50unattended-upgrades` - Auto-update settings
- `/etc/hosts` - Hostname configuration
- `~/.ssh/authorized_keys` - SSH public key

### Log Files to Monitor
- `/var/log/auth.log` - SSH authentication attempts
- `/var/log/fail2ban.log` - fail2ban actions
- `/var/log/ufw.log` - Firewall logs
- `/var/log/unattended-upgrades/` - Auto-update logs

---

## Lessons Learned

1. **NAT Network vs NAT**: NAT Network allows VM-to-VM communication but isolates VMs from host. Need Host-Only adapter for SSH from Windows.

2. **SSH Socket Activation**: Modern systemd uses socket activation for SSH, which can override sshd_config port settings. Keeping port 22 is simpler for lab environments.

3. **NetworkManager**: Linux Mint uses NetworkManager (nmcli) for network configuration, not traditional /etc/network/interfaces.

4. **fail2ban jail names**: Use `sshd` not `ssh` for the jail name.

5. **Firewall before services**: Always configure firewall rules BEFORE enabling services to avoid lockouts.

---

## Time Spent on Phase 1
Approximately 2-3 hours (including troubleshooting)

## Ready for Phase 2?
Once monitoring is installed and VMs are cloned, we'll be ready to begin automating everything with Ansible!

---

**Last Updated:** 2026-01-31  
**VM Name:** baseline-template  
**Status:** ✅ Phase 1 COMPLETE - Baseline configured and ready for cloning!