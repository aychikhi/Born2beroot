#!/bin/bash

# Architecture

Arch=$(uname -a)

# CPU physical

CPUp=$(lscpu | grep "Socket" | awk '{printf $2 "\n"}')

# CPU virtual

CPUv=$(nproc)

# Memory usage

Memory_usage=$(free --mega | awk '$1 == "Mem:" {printf ("%d/%dMB (%.2f%%)\n" ,$3,$2,$3/$2*100)}')

# Disk usage

total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{a += $2} END {printf("%.2fGb\n", a / 1024)}')
used=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{a += $3} END {printf("%d\n", a )}')
percentage=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3} {total += $2} END {printf("(%d%%)\n"), use/total*100}')

# CPU load

CPU_load=$(mpstat 1 1 | tail -n 1 | awk '{printf "%.1f%%\n", 100 - $12}')

# Last boot

Last_boot=$(who -b | grep "system boot" | awk '{print $3" "$4}')

# LVM use

LVM_use=$(if [ $(lsblk | awk '{print $6}' | grep 'lvm' | wc -l) -gt 0 ]; then
  echo yes
else
  echo no
fi)

# Connection TCP

Connection_TCP=$(ss -tan | grep ESTAB | wc -l)

# User log
User_log=$(who | awk '{print $1}' | uniq | wc -l)

# Network

Network=$(echo "IP" "$(hostname -I)" "$(ip link show | grep 'ether' | awk '{printf("(%s)\n",$2)}')")

# Sudo

Sudo=$(sudo grep 'COMMAND=' /var/log/sudo/sudo_config | wc -l)

wall " Architecture : $Arch
        CPU physicale : $CPUp
        vCPU : $CPUv
        Memory Usage : $Memory_usage
	Disk Usage : $used/$total $percentage
        CPU Load : $CPU_load
        Last boot : $Last_boot
        LVM use : $LVM_use
        Connections TCP : $Connection_TCP ESTABLISHED
        User log : $User_log
        Network : $Network
        Sudo : $Sudo "