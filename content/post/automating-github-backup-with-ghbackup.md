---
date: 2017-01-14T20:14:09+01:00
summary: |
  I explain my setup to keep backups of my repositories on my own server.
title: Automating backup of GitHub repositories using ghbackup
---

As a software developer [GitHub](https://github.com/) has become a central part of my work.

They do a great job. But even for the best companies it's possible to get in trouble some day.

Instead of setting all on a single company,
it's probably a good idea to take advantage of the distributed nature of Git
and keep my own backups for emergency situations.

<br>

This can be easily automated so I don't have to worry about it myself anymore.

<br>

I decided to setup a small [DigitalOcean server](https://m.do.co/c/3a2428eee4cc) to backup all my repositories.

The latest version is fetched every night and I get notified in [Slack](https://slack.com/).
When the notifications should ever stop coming I know something is wrong with my backups.

I use [ghbackup](https://qvl.io/ghbackup) to do this.
With `ghbackup` I can backup all public and private repositories I have access to in one go.
And if a project owner would decide to remove me from a project I would still have a copy of the repositories.

<br>

**Note:** *Directly edit code snippets below before copy&pasting them.*

<br>

Follow these steps to create a similar setup or adopt it to your own needs:

We'll be using [ghbackup](https://qvl.io/ghbackup), [sleepto](https://qvl.io/sleepto) and [systemd](https://freedesktop.org/wiki/Software/systemd/).

- First, you need a [GitHub token](https://github.com/settings/tokens) with at least the **repo** scope and you need a [Slack Webhook URL](slack.com/apps/new/A0F7XDUAZ-incoming-webhooks).

- All following steps happen on system level. To not prefix every command with `sudo `, let's login as *root*:

```sh
sudo -s
```

- `sytemd` is already running on most Linux systems. Install `ghbackup` and `sleepto`. In this example we keep executables in the directory `/opt`:

```sh
curl -sL https://github.com/qvl/sleepto/releases/download/v1.1/sleepto_Linux_x86_64.tar.gz | tar -xzf - -C /opt sleepto
curl -sL https://github.com/qvl/ghbackup/releases/download/v1.5/ghbackup_Linux_x86_64.tar.gz | tar -xzf - -C /opt ghbackup
```

- Create a wrapper script to run the backup. Update the variables below with your own values:

```sh
touch /opt/ghbackup-job && chmod +x $_ && echo > $_ '#!/usr/bin/env bash

github_token=""
slack_hook=""
backup_dir="/srv/github-backup"

/opt/ghbackup -secret $github_token $backup_dir \
  && curl -X POST --data-urlencode \
  "payload={\"text\": \"Successful GitHub backup.\"}" \
  $slack_hook
'
```


- Create a new unit file to run the created `ghbackup-job` as a repeating service. We use `sleepto` to trigger it **every day at 1am**.

```sh
touch /etc/systemd/system/ghbackup.service && chmod 644 $_ && echo > $_ '
[Unit]
Description=Github backup
After=network.target

[Service]
ExecStart=/opt/sleepto -hour 1 /opt/ghbackup-job
Restart=always

[Install]
WantedBy=multi-user.target
'
```

- Now the only thing left to do is to enable this service. We make sure it's automatically started when the system boots:

```sh
systemctl daemon-reload
systemctl start ghbackup
systemctl enable ghbackup
```

- The service should be running now:

```sh
systemctl status ghbackup
```

If everything works you should get notifications about successful backups soon!

You can also trigger `sleepto` to run the backup job immediately:

```sh
systemctl kill -s ALRM ghbackup
```

After the first backup completed you find the repositories in `/srv/github-backup`.

<br>

This is how I setup my GitHub backups.
I hope this is helpful to others as well.

Please let me know if you run into any problems!


<script>
  document.querySelectorAll('code').forEach(function(el) {
    el.contentEditable = true
  })
</script>
