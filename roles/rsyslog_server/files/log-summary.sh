#!/bin/bash
# Log summary script for centralized logging

LOG_DIR="/var/log/remote"

echo "=== Centralized Logging Summary ==="
echo "Generated: $(date)"
echo ""

echo "=== Log Storage Overview ==="
du -sh $LOG_DIR/* 2>/dev/null | sort -h
echo ""

echo "=== Recent Activity by Host ==="
for host_dir in $LOG_DIR/*; do
    if [ -d "$host_dir" ]; then
        host=$(basename "$host_dir")
        echo "[$host]"
        echo "  Log files: $(find "$host_dir" -name "*.log" | wc -l)"
        echo "  Total size: $(du -sh "$host_dir" 2>/dev/null | cut -f1)"
        echo "  Last update: $(find "$host_dir" -name "*.log" -type f -exec stat -c '%y' {} \; 2>/dev/null | sort -r | head -1)"
        echo ""
    fi
done

echo "=== Error Summary (Last 24h) ==="
find $LOG_DIR -name "*.log" -type f -mtime -1 -exec grep -i "error\|fail\|critical" {} + 2>/dev/null | wc -l
echo "error/fail/critical messages found"
echo ""

echo "=== Recent Test Messages ==="
find $LOG_DIR -name "*.log" -type f -exec grep "ANSIBLE_TEST" {} + 2>/dev/null | tail -5
