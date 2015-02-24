# .deb Assembly Container
This package is intended to be used to generate a
[Docker](https://www.docker.com/) container that is able to take your package's
source code, binaries, and other content; and package it into a `.deb` file.

## Usage

### Building *[The Container]*

*No caveats here...*

```sh
docker build -t debasm .
```

### Entrypoint

+ `-n <string>` Your package name
+ `-v <version string>` Your package/upstream version
+ `-r <pkgversion string>` *(Optional)* Packaged version
+ `-d <deb filename string>` *(Optional)* Override of the outputting `.deb`
filename
+ `-e <email string>` *(Optional)* Email of package maintainer

### Example Package Build

```
docker run \
    -i -t \
    -v /path/to/your/source:/pkgsrc:ro \
    -v /path/to/your/DEBIAN:/DEBIAN:ro \
    -v /path/to/your/deb/dst:/deb \
    debasm \
        -n mypackage \
        -v 1.0 \
        -r 1
```

## Roadmap
1. Assist in creation of new `DEBIAN/` control structure if not present
1. Allow for more interactive control of the build process
1. Assist in `changelog` management
1. [lintian](https://lintian.debian.org/)