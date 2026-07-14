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

1. Update `version` in the `Dockerfile`.
2. Run `bin/upgrade`. This builds the image, extracts the freshly built poppler
   `.deb` into the repo, removes the previous `.deb`, and updates `bin/compile`
   to point at the new one.
3. Update `CHANGELOG.md` for the new version and commit the changes
   (the new `.deb`, `bin/compile`, and `Dockerfile`).

> Note: the build target is `heroku-22`, which constrains how new poppler can
> be (see the comments in the `Dockerfile`). Security patches carried on top of
> the pinned release live in `patches/` and are applied at build time; see
> `CHANGELOG.md` for which CVEs each version addresses.

