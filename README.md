# [govanityurls](https://github.com/GoogleCloudPlatform/govanityurls)

> Google Cloud Platform's
> [`govanityurls`](https://github.com/GoogleCloudPlatform/govanityurls)
> packaged for Docker.

## Why

[`govanityurls`](https://github.com/GoogleCloudPlatform/govanityurls) is a
great little Go vanity URL server. However, the original authors do not publish
any containerised distribution of their software. This repository has one
purpose: Package the existing source code for Docker without creating another
fork that needs to be maintained (even though the upstream project seems to be
pretty stale).

## Usage

```
docker run -p 8080:8080 -v $(pwd)/vanity.yaml:/vanity.yaml ghcr.io/mariuskiessling/govanityurls:latest
```

You must mount your [`govanityurls` configuration
file](https://github.com/GoogleCloudPlatform/govanityurls#configuration-file)
at `/vanity.yaml` for the container to start successfully.

> :warning: **You should never use the latest tag in production.** If you plan
> to use this image in production, use a version tag or, even better, the
> image's digest.

You should also not trust any random container image from the internet; this
includes mine. All generated images are signed with sigstore's
[`Cosign`](https://github.com/sigstore/cosign) utility using the [`Fulcio`
PKI-supported key-less signature
method](https://github.com/sigstore/cosign/blob/39fb8d6bc845d8096b5db2b44c583163072ed6d9/KEYLESS.md).

The following attributes are signed for every image:

* `upstream-commit`: The commit hash of the upstream
  [`govanityurls`](https://github.com/GoogleCloudPlatform/govanityurls) project
  that the container image is based on.
* `upstream-version`: The Git version tag of the upstream
  [`govanityurls`](https://github.com/GoogleCloudPlatform/govanityurls) project
  that the container image is based on.
* `github-run-id`: The ID of the GitHub Action run which built the container
  image.

You can verify that one or more of these attributes match your expectations by
running this command:

```
COSIGN_EXPERIMENTAL=1 cosign verify -a upstream-version=v0.1.0 ghcr.io/mariuskiessling/govanityurls:latest
```

If you don't trust me at all (*good attitude*), you can use the GitHub Workflow
SHA claim ([OID
`1.3.6.1.4.1.57264.1.3`](https://github.com/sigstore/fulcio/blob/4b5fdf01cb86aaa3c1ab1fdb4a3d620a750f3865/docs/oid-info.md))
to verify that I didn't use a hidden commit to generate a malicious container
image that just pretends to contain the claimed upstream source code version.
