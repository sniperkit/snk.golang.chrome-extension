#!/bin/sh

# NOTE -- this file based on Google's example available
# at https://chromium.googlesource.com/chromium/src/+/master/chrome/common/extensions/docs/examples/api/nativeMessaging/README.txt

# Copyright 2013 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -e

HOST_NAME=${HOST_NAME:-"org.blx.shell"}
HOST_SCRIPT=${HOST_SCRIPT:-"blx-chrome-shell"}

DIR="$( cd "$( dirname "$0" )" && pwd )"
if [ "$(uname -s)" == "Darwin" ]; then
  if [ "$(whoami)" == "root" ]; then
    TARGET_DIR="/Library/Google/Chrome/NativeMessagingHosts"
  else
    TARGET_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"

    # TODO chromium compat
    #TARGET_DIR="$HOME/Library/Application Support/Chromium/NativeMessagingHosts"
  fi
else
  if [ "$(whoami)" == "root" ]; then
    TARGET_DIR="/etc/opt/chrome/native-messaging-hosts"
  else
    TARGET_DIR="$HOME/.config/google-chrome/NativeMessagingHosts"
  fi
fi

# Create directory to store native messaging host.
mkdir -p "$TARGET_DIR"

# Copy native messaging host manifest.
# Update host path in the manifest.
HOST_PATH=$DIR/$HOST_SCRIPT
ESCAPED_HOST_PATH=${HOST_PATH////\\/}
sed -e "s/HOST_PATH/$ESCAPED_HOST_PATH/" "$DIR/$HOST_NAME.json" \
    > "$TARGET_DIR/$HOST_NAME.json"

# Set permissions for the manifest so that all users can read it.
chmod o+r "$TARGET_DIR/$HOST_NAME.json"

echo "Native messaging host $HOST_NAME has been installed."