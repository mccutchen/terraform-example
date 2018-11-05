#!/bin/sh

# Bootstrap an Amazon Linux-based EC2 instance for running docker.
#
# Adapted from:
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html#install_docker

set -e
set -u
set -o pipefail

function log() {
    echo -e 1>&2 "[bootstrap][$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

function install_docker() {
    log "installing docker ..."
    yum update -y
    yum install -y docker
    service docker start
    usermod -a -G docker ec2-user
}

function ebs_volume_present() {
    local ebs_device="$1"
    lsblk | grep -q $(basename $ebs_device)
}

function ebs_volume_unformatted() {
    local ebs_device="$1"
    file -s $ebs_device | grep -q "$ebs_device: data"
}

function mount_ebs_volume() {
    local ebs_device="$1"
    local mountpoint="$2"

    log "mounting ebs volume $ebs_device at $mountpoint ..."

    while ! ebs_volume_present $ebs_device; do
        log "waiting for $ebs_device to show up ..."
        sleep 1
    done

    if ebs_volume_unformatted $ebs_device; then
        log "formatting $ebs_device ..."
        mkfs -t ext4 $ebs_device
    fi

    log "updating /etc/fstab ..."
    mkdir -p $mountpoint
    echo -e "${ebs_device}\t${mountpoint}\tauto\tdefaults,noatime\t0\t2" >> /etc/fstab
    mount -a
}

install_docker
mount_ebs_volume "/dev/xvdb" "/data"
