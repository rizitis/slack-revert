# Slack-Revert

## Overview
*slack-revert is part of [Slackware-Commander](https://github.com/rizitis/Slackware-Commander)*

The `slack-revert` command allows you to create and manage "snapshots" of the official package versions on your Slackware system. You can revert your system to any previously created snapshot, effectively rolling back to a specific date.
- *Supported Slackware- 32bit, 64bit, stable and current*

## Usage
- To create a snapshot of your current system:
  - Run `# slack-revert`. This will create a snapshot containing all officially installed package versions at the current time.
- You can create as many snapshots as needed.
- You can also take /etc backup if you ask yes.

### Reverting to a Snapshot
- To revert to a specific snapshot:
  - Run `# slack-revert`.
  - When prompted, enter "revert" and choose the desired snapshot date.
  - The command will download from [slackware.uk](https://slackware.uk/cumulative/) the correct versions of the required packages.
  - Before upgrading or downgrading, you will be prompted to confirm your choice.
  - Also if some packages failed to download  they will appear in terminal screen. 

## Limitations
1. `slack-revert` only works with officially installed Slackware packages. It does not support 3rd-party repositories (like SlackBuilds, Alien, etc.).
2. Added support for /etc backup and revert in future is very risky, dont use it if you dont know what you are doing. 

`For example you created a slackware-packages snapshot 1/1/2024 the same day a /etc backup.`
```
The corect revert-system action if you also need to revert /etc/{rc.d/,*conf} fileis to revert the exaclty day /etc backup also.
BUT if you had *.conf.new in your backup and run slackpkg new-config, then new conf will replace current reverted conf files.  
So before you make a new slapshot for /etc be sure you dont have conf.new inside.
If you need them install them, or remove them before you take the /etc backup.
```

## Installation

```
   install -m 755 slack-revert slack-revert-revert.sh /usr/local/bin/
  ```
