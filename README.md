# Slack-Revert

## Overview
*slack-revert is part of [Slackware-Commander](https://github.com/rizitis/Slackware-Commander)*

The `slack-revert` command allows you to create and manage "snapshots" of the official package versions on your Slackware system. You can revert your system to any previously created snapshot, effectively rolling back to a specific date.
- *Supported Slackware- 32bit, 64bit, stable and current*

## Usage
- To create a snapshot of your current system:
  - Run `# slack-revert`. This will create a snapshot containing all officially installed package versions at the current time.
- You can create as many snapshots as needed.

### Reverting to a Snapshot
- To revert to a specific snapshot:
  - Run `# slack-revert`.
  - When prompted, enter "revert" and choose the desired snapshot date.
  - The command will download from [slackware.uk](https://slackware.uk/cumulative/) the correct versions of the required packages.
  - Before upgrading or downgrading, you will be prompted to confirm your choice.
  - Also if some packages failed to download  they will appear in terminal screen. 

## Limitations
1. `slack-revert` only works with officially installed Slackware packages. It does not support 3rd-party repositories (like SlackBuilds, Alien, etc.).
2. The command does not revert configuration files. It's up to you to manage your own configuration files, either by keeping the current ones or installing new ones (e.g., `conf.new`). Note that there are no "snapshot.conf" files to use. Future versions might address this limitation.

## Installation

```
   install -m 755 slack-revert slack-revert-revert.sh /usr/local/bin/
  ```
