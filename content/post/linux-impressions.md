---
title: "Linux Impressions"
date: 2020-07-01T19:58:58+02:00
---

One year ago I still had a MacBook Pro for work and a MacBook Air at home.
Now I have a Thinkpad T490 running Manjaro + KDE and a Dell XPS 13 running Ubuntu + Gnome.
<!--more-->

I have been using Linux way before I even started programming, but the last 7 years I was on MacOS, since that's what all the cool devs use.

Since a while now I am back to two Linux machines.
The main conclusion for me definitely is that they are all good enough for what I do.

Still, there are differences:

## Let's start with the hardware

What still stands out are the touchpad and the speakers of the MacBook.
Personally I do most things with the keyboard though for which which I prefer, both, the Thinkpad and Dell. And I either use headphones or connect to external speakers anyways.

The Thinkpad is impressive for the amount of ports it has: HDMI, LAN, SIM card, USB and many more. The other two machines are mostly only USB-C and headphone adapter.

The Dell is probably my favorite for its size, keyboard, touchpad and overall feel.

## Now let's talk about software

Most notable software I use are [Firefox](https://www.mozilla.org/en-US/firefox/), [Alacritty](https://github.com/alacritty/alacritty), [Neovim](https://neovim.io/), Dropbox, Spotify, [KeepassXC](https://keepassxc.org/) plus YubiKey. Then for work there is also Slack, Docker, VirtualBox and Google Drive. Occasionally I also use [Kdenlive](https://kdenlive.org/), [Krita](https://krita.org/en/), [OBS Studio](https://obsproject.com/) and Steam.

Luckily all of them work on all of the systems.

Docker feels 10x faster on Linux. Probably related to us doing a lot of volume mounting. That is a huge productivity win for my work since we run everything in Docker.

Google does not provide a Linux client for Google Drive. For me it is enough to use the web version. Plus, [as a nice commenter told me](https://lobste.rs/s/gepn5p/linux_impressions#c_k7qqcb), there is an [integration for KDE's file browser](https://community.kde.org/KIO_GDrive) which allows me to access file transparently. There are also some promising open source and paid 3rd-party clients if you need to access files offline.

Monitor, printers, Bluetooth speakers and Bluetooth XBox controller worked for me with all the devices so far.


## Package management

Installing software is not a big deal on any of the systems.

With [Manjaro](https://manjaro.org/) I found all the software I need right in the available repositories, which also include [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository) from Arch Linux. That experience has been nicer than [Homebrew](https://brew.sh/) on Mac, which is often slowing you down since it's updating all the time and it's nicer than apt on [Ubuntu](https://ubuntu.com/), where packages are often outdated or non-existent.

I also like the rolling releases of Manjaro itself. There are no big scary upgrades as you get with Ubuntu and MacOS. I also really like the settings UI in Manjaro/KDE to configure all this - you can even switch the Linux kernel in there.

[![Manjaro Kernel Settings](/images/kde/manjaro-kernel-settings.png)](/images/kde/manjaro-kernel-settings.png)


Also interesting has been that on the Mac I actually had to install more software than on Linux: Starting with Homebrew for package management, [Spectacle](https://www.spectacleapp.com/) for aligning windows, [Tunnelblick](https://tunnelblick.net/) for VPN and also many [basic command line tools](https://github.com/jorinvo/dotfiles/blob/mac/brew.txt).


## Configuration

From my experience MacOS has actually been the most annoying out of them. While in general it is pretty polished, there have been some rather annoying issues.
With both the Linux distros there are also issues, but you have enough flexibility and there is enough help online to fix all of it (especially nice is the [Arch wiki](https://wiki.archlinux.org/) when using Manjaro).

I definitely tweaked more settings on Linux, but I don't think I spent more time on it since there are simply a lot of options available, while I had to work around less issues.

I found things much easier to configure in [KDE](https://kde.org/plasma-desktop) than [Gnome](https://www.gnome.org/). For Gnome you definitely want to install the [Gnome Tweak Tool](https://itsfoss.com/gnome-tweak-tool/). But even then it has much less settings and many things can only be configured in the terminal.

On Linux you definitely want to enjoy the freedom to theme and setup your desktop the way you like.
The small time effort seems totally worth it to me even if it improves the experience of staring at this screen for hours every day just a little bit.
You can theme everything from apps like [Alacritty](https://github.com/jorinvo/dotfiles/blob/master/alacritty.yml), [Neovim](https://github.com/arcticicestudio/nord-vim), [Slack](https://slackthemes.net/#/nord) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/arc-dark-theme-we/) to the [desktop](https://store.kde.org/p/1327093/) and [icons](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme).

[![KDE Nordic Theme Desktop Screenshot](/images/kde/kde-nordic-desktop-screenshot.png)](/images/kde/kde-nordic-desktop-screenshot.png)

But I rather keep the effort here low since it's mostly a one time thing to setup things.
While I happily work in vim and ssh into servers all day long, I gladly use a GUI to configure my desktop environment.

KDE definitely shines here. The system settings allow you to search, download and install themes for everything.

[![KDE Settings - Global Theme](/images/kde/kde-settings-global-theme.png)](/images/kde/kde-settings-global-theme.png)

Also icons sets can be installed in here which I had to do in the terminal when using Gnome.

[![KDE Settings - Icons](/images/kde/kde-settings-icon-theme.png)](/images/kde/kde-settings-icon-theme.png)

Also relevant is that KDE is built on top of [QT](https://www.qt.io/) while Gnome is built with [GTK](https://www.gtk.org/).
I use, both, apps built with QT and apps built with GTK.
KDE does a nicer job of integrating apps from both GUI toolkits.
It's also straight forward to theme GTK2 and GTK3 right in the KDE settings.

[![KDE Settings - GTK Theme](/images/kde/kde-settings-gtk-theme.png)](/images/kde/kde-settings-gtk-theme.png)

## Performance

I won't try to do any benchmarking here. More interesting to me is the perceived performance.

Here I can say that the biggest difference is as, already mentioned, Docker.

Apart from that file search in my editor and also starting applications are both definitely faster on Linux.
*KRunner* in KDE also feels  faster than searching in Gnome or Spotlight on a Mac.

I mostly cannot tell a difference between Manjaro+KDE and Ubuntu+Gnome, but looking at the system status you can see that Manjaro+KDE consumes less ressources and has less systemd services running. For me it was definitely a surprise to find out that in 2020 KDE is more lightweight than Gnome. That used to be very different.

Booting the system I have to say that Dell BIOS seems to be the fastest and Lenovo Thinkpad the slowest. Or Lenovo prefers likes to show their giant red logo for a bit longer.

The actual Linux distros are both pretty fast. I find that KDE gives you a smoother booting experience and Manjaro doesn't have a loading screen while Ubuntu shows a loading screen for 1-2 seconds.

One point for the MacBooks is that their sleep mode (closing the laptop lid) lasts longer. I think the Mac switches to hibernate automatically. While hibernate works on the Linux laptops, it seems to be not faster than rebooting from scratch.


## Conclusion

I hope this experience report is helpful.
Of course it only applies to the specifics of my use case and preferences, but there might be still some takeaways for others in here.

Please reach out and tell me about your experiences, preferences and thoughts!
Also, feel free to ask for any additional info or help.
