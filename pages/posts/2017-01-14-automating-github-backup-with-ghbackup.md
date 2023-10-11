%{
    title: "Automating the Backup of GitHub Repositories Using ghbackup",
    description: "I explain my setup to keep backups of my repositories on my own server.",
    keywords: ["github", "backup", "automation", "automate", "git", "repository"],
    archive: true
}
---

As a software developer [GitHub](https://github.com/) has become a central part of my work.

The GitHub crew does a great job. But even for the best companies it's possible to get in trouble some day.

Instead of setting all on a single company,
it's a good idea to take advantage of the distributed nature of Git
and keep your own backups for emergency situations.

This can be easily automated so you don't have to worry about it anymore.


Here is how I did it:


I decided to setup a small [DigitalOcean server](https://m.do.co/c/3a2428eee4cc) to backup all my repositories.

The latest version is fetched every night and I get notified in [Slack](https://slack.com/).
When the notifications ever stop coming, I know something is wrong with my backups.

I use [ghbackup][g] to do this.
With [ghbackup][g] I can backup all public and private repositories I have access to in a single go,
and if a project owner would decide to remove me from a project I would still have a copy of the repositories.


**Note:** *Inline edit code snippets below before copy&pasting them.*


Follow these steps to create a similar setup or adopt it to your own needs:

We'll be using [ghbackup][g], [sleepto][s] and [systemd](https://freedesktop.org/wiki/Software/systemd/).

- First, you need a [GitHub token](https://github.com/settings/tokens) with at least the **repo** scope and you need a [Slack Webhook URL](https://slack.com/apps/new/A0F7XDUAZ-incoming-webhooks).

- All following steps happen on system level. To not prefix every command with `sudo `, let's login as *root:*

```
sudo -s
```

- `systemd` is already running on most Linux systems. Install [ghbackup][g] and [sleepto][s]. In this example we keep executables in the directory `/opt`:

```
curl -sL https://github.com/qvl/sleepto/releases/download/v1.6/sleepto_1.6_linux_64bit.tar.gz | tar -xzf - -C /opt sleepto
curl -sL https://github.com/qvl/ghbackup/releases/download/v1.8/ghbackup_1.8_linux_64bit.tar.gz | tar -xzf - -C /opt ghbackup
```

- Create a wrapper script to run the backup. Update the variables below with your own values:

```
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


- Create a new unit file to run the created `ghbackup-job` as a repeating service. We use [sleepto][s] to trigger it **every day at 1am**.

```
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

```
systemctl daemon-reload
systemctl enable --now ghbackup
```

- The service should be running now:

```
systemctl status ghbackup
```

If everything works you should get notifications about successful backups soon!

You can also trigger [sleepto][s] to run the backup job immediately:

```
systemctl kill -s ALRM ghbackup
```

After the first backup completed you find the repositories in `/srv/github-backup`.


This is how I setup my GitHub backups.
I hope this is helpful to others as well.

Please let me know if you run into any problems!


[g]: https://qvl.io/ghbackup
[s]: https://qvl.io/sleepto

