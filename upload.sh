#!/bin/bash

set -euo pipefail

rm -rf ./public
zola build

# run `rclone config` to configure an SFTP endpoint called yali if this is a new machine

rclone sync -v ./public yali:/home/thejpster/www/www.thejpster.org.uk/
