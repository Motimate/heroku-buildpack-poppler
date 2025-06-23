heroku-buildpack-poppler
------------------------

## Using

Simply add the buildpack to your Heroku app, e.g.

```
heroku buildpacks:add -a MY-APP https://github.com/Motimate/heroku-buildpack-poppler
```

## Out of Memory error during package compilation in Docker

Reduce number of cores used for `make` in Dockerfile, eg.

`make -j$(nproc --all) && \` => `make -j2 && \`

## Upgrading

1. Update `version` in Dockerfile
2. `docker build . -t heroku-buildpack-poppler:latest --platform=linux/amd64`
3. `docker run --rm -it heroku-buildpack-poppler:latest bash` and `cd poppler/build && ls -la` and note the name of the poppler .deb file (eg. `poppler_25.03.0-1_amd64.deb`)
4. `docker create --name temp-container heroku-buildpack-poppler`
5. `docker cp temp-container:/poppler/build/poppler_25.03.0-1_amd64.deb .`
6. `docker rm temp-container`
7. Update `bin/compile` with the new .deb file

