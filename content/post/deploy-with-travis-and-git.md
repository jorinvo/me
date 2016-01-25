---
date: 2016-01-25T11:57:23+07:00
summary: I explain how I automated the deployment of an open source project with Travis CI.
title: Deploy with Travis CI and Git
---

I automated the deployment of one  open source projects I'm involved in ([Litewrite][litewrite]) and would like to share how it works.


We can't use a [webhook][webhooks] directly because our tests should run first.
Also our hosting solution ([5apps][5apps]) is not a server we own and we can't pull the latest changes from Github.

Instead 5apps provides a Git origin where we need to push to.

Before, I used to push manually from my local machine,
because I need to have an SSH key the server trusts.

The new solution is to let [Travis CI][travis] push the changes for us.

Travis CI works great for automating things like tests and is even free to use for open source projects.

The [configuration][travisyml] for Travis CI is really simple.

We need Travis CI to run our tests first
and call a custom deploy script for the `master` branch if the tests are successful:

```yaml
language: node_js # Node runs `npm install` and `npm test` automatically
node_js: node # Uses the latest version (via nvm)
sudo: false # Allows Travis to run this project in container
deploy:
  provider: script
    script: scripts/deploy.sh
      on:
          branch: master
```

To deploy we need an SSH key that's added to 5apps, but the key shouldn't be public.

We can hide the key by putting it in an [environment variable][envvars] on Travis CI.
You just need to make sure to preserve the new lines while adding the key.

Now, in our [deploy script][deploy] we can retrieve the key and use it to push via Git:

```bash
eval "$(ssh-agent -s)" # Start the ssh agent
echo "$DEPLOY_KEY" > deploy_key.pem
chmod 600 deploy_key.pem # This key should have push access
ssh-add deploy_key.pem
git remote add deploy $REPO_URI
git push deploy master
```

With this set up, we don't need to deploy manually ever again.

All we need to do, is to publish our latest changes on the [`master`][master] branch.



[litewrite]: https://litewrite.net
[webhooks]: https://developer.github.com/webhooks
[travis]: https://travis-ci.org/litewrite/litewrite
[5apps]: https://5apps.com/deploy/home
[travisyml]: https://github.com/litewrite/litewrite/blob/gh-pages/.travis.yml
[envvars]: https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings
[deploy]: https://github.com/litewrite/litewrite/blob/gh-pages/scripts/deploy.sh
[master]: https://github.com/litewrite/litewrite/tree/master

