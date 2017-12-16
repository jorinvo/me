---
title: "Docker Things"
date: 2017-12-10T12:57:03+01:00
draft: true
---

- Use COPY instead of ADD, it is simpler and ADD does some magic like fetching content from URLS and unpack archives.
- Copy package.json and package-lock.json first, run npm install, then copy rest. Don't need to reinstall deps if nothing changed.
  Don't forget the lock file.
- docker system prune
- docker system ds
- docker stats
- docker network inspect
- Don't copy your local node_modules into container, add it to .dockerignore file.
  Mount src into container for development, Make sure to not mount node_modules.
  Can prevent that using -v /home/node/node_modules.
- docker-compose makes things much simpler:
  - Create a network to access other containers by their hostname
  - Have all your config via env vars in one file
  - Reuse env vars and secrets by keeping them in a .env file
  - By setting the build context to a level above, you can reuse deps and a Dockerfile and pass specifics to the build using build-args
- Pass variables such as NODE_ENV via build-args to build a dev container.
  In Dockerfile you can set default value for build-args to production.
- If you need some node deps only for building container you can install dev deps first,
  then set NODE_ENV=production and run npm prune.
- You cannot rename file from one partition to another.
  If you want to move a file to a volume you have to copy it instead.

