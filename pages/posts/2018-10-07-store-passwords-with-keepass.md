%{
  title: "Store Passwords With KeePass",
  description: "Let me show you why KeePass is more fun than your cloud-based password manager.",
  keywords: ["password", "manager", "keepass", "secure"],
  archive: true
}
---

It's 2018 and passwords are still a pain we haven't figured out. Bigger companies often work around this by relying on products that support [Single Sign-on](https://en.wikipedia.org/wiki/Single_sign-on) or similar. But individuals and smaller companies are stuck with managing passwords themselves or relying on third-party authentication from Google, Facebook and so on.

I guess I don't need to explain why it is not a good idea trusting all your logins to one single company - especially when the core business of the company is collecting as much as possible information about as many people as possible.

If you are a person that cares about being in control of their logins and keeping the logins secure, you are in need of some way of managing a big number of different and complicated passwords.

That's why there are password managers.

They help you remember and generate secure passwords for all your digital services. It's nice to have all your logins in one place and to only have to remember a single password *(please make it a secure password - don't try putting super many complicated symbols in there but make it long, make it a sentence of a few words)*.

This is not a new idea and there are enough companies that offer solid services to help you with this - such as [1Password](https://1password.com/) or [LastPass](https://www.lastpass.com).

Now these services only have a small issues: You need to pay for it and they make you put all your passwords on the servers of a single company with little flexibility in case you don't feel like trusting them anymore.

So let's have a look at a 14 years old free and open source alternative: [KeePass](https://keepass.info/).

![Keepass Screenshot](/images/keepass/keepass-screenshot.png)

If you think this looks scary, you are not on your own.

So why KeePass?

Not only is KeePass free and open source, but it is simple. It focuses on managing passwords.

It doesn't try to also solve cloud storage and sync for you. Your passwords are simply stored in a secure encrypted file. What you do with that file is up to you. This makes it very flexible and allows you to combine it with any storage of your choice: You can put this file in Google Drive, Dropbox or simply keep it on an USB drive. It's up to you.

And even better: KeePass does not have to be what you see in the screenshot above. At the core of KeePass is the [.kdbx](https://keepass.info/help/kb/kdbx_4.html) file format. Any developer can take this format and build software that can work with it!

And people did this:

If you are looking for a modern, pretty looking program for working with .kdbx files, have a look at [MacPass](https://macpassapp.org/):

[![MacPass Screenshot](/images/keepass/macpass-screenshot.png)](https://macpassapp.org/)

Or [KeeWeb](https://keeweb.info/):

[![KeeWeb Screenshot](/images/keepass/keeweb-screenshot.png)](https://keeweb.info/)

Personally I prefer [KeePassXC](https://keepassxc.org/):

[![KeePassXC Screenshot](/images/keepass/keepassxc-screenshot.png)](https://keepassxc.org/)

It appears less pretty but it is the most pleasant to use:

- Searching, copying, editing - all its features can be controlled entirely with keyboard shortcuts.
- It supports filling passwords in your browser with a global shortcut.
- It allows storing and unlocking SSH keys.
- You can add another factor of authentication by using a [YubiKey](https://www.yubico.com/).
- And it even supports setting up TOTP for [two factor authentication](https://www.securenvoy.com/en-gb/two-factor-authentication/what-is-2fa) (please enable this for all your important services) which can be a nice alternative to [Google Authenticator](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2).

Of course you also want your passwords on your phone. And you can. I had good experience with [Keepass2Android Password Safe](https://play.google.com/store/apps/details?id=keepass2android.keepass2android).

KeePass might not only be a great help for your personal use but even your workplace can profit from it: Sharing secrets with coworkers is very simple and flexible. All you have to deal with is sharing files.

