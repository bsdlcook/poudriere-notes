# Contents
- [Getting started](#getting-started)
  - [Installing Poudriere](#installing-poudriere)
  - [Configuration](#configuration)
  - [Ports repository](#ports-repository)
  - [Poudriere jails](#poudriere-jails)
  - [Building ports](#building-ports)
- [Optional configuration](#optional-configuration)
  - [Ccache](#ccache)
  - [Memcached](#memcached)

# Getting started

A brief tutorial on getting kick-started with Poudriere on a new system. This file is mostly for
self-documentation and highly subjective to my needs.

### Installing Poudriere

```sh
# pkg install poudriere
```

### Configuration
Basic configuration file located at **/usr/local/etc/poudriere.conf**. Assuming you've had prior experience,
I won't detail what the options are.

```sh
ZPOOL=zroot
ZROOTFS=/poudriere
FREEBSD_HOST=https://download.FreeBSD.org
RESOLV_CONF=/etc/resolv.conf
BASEFS=/usr/local/poudriere
USE_PORTLINT=yes
USE_TMPFS=yes
DISTFILES_CACHE=/usr/local/poudriere/ports/default/distfiles
RESTRICT_NETWORKING=no
ALLOW_MAKE_JOBS=yes
BUILDER_HOSTNAME=inferno
PRIORITY_BOOST="llvm* rust* gcc* chromium*"
```

### Ports repository

```sh
# poudriere ports -c -m svn+https
```

### Poudriere jails

To easily distinguish between a jails userland/version, use the following format for naming:
[**BRANCH**]-[**MAJOR**/**MINOR**]-[**ARCH**]. For example, a machine on 12.2-RELEASE amd64,
**releng-122-amd64** would suffice. 13.0-STABLE i386, on the other hand would yield **stable-130-i386**
and so forth. It really is just semantics, so whatever works for you; however, bare in mind the
jail cannot have a greater version than the host system. Otherwise, you'll run into unexpected
side-effects as a result of the kernel/userland version mismatch.

```sh
# poudriere jail -c -j releng-122-amd64 -v 12.2-RELEASE -a amd64 # 12.2-RELEASE amd64
# poudriere jail -c -j stable-130-i386 -v 13.0-STABLE -a i386 # 13.0-STABLE i386
```

*Only explicitly pass the -a (architecture) flag when creating jails that are different from the hosts architecture.*

### Building ports

You have one of two options when building one/many port(s).

* testport: Builds desired port, namely for testing as oppose to exporting.
* bulk: Exports the built port as a binary package to a package repository, which you can then install.

For a more detailed clarification please refer to **poudriere(8)**.

```sh
# poudriere testport -j releng-122-amd64 devel/gh
```

Using the examples above, this will build the port **devel/gh** using the jail **releng-122-amd64**
(12.2-RELEASE amd64) using the **default** tree. You can also optionally pass the -i (interactive)
flag that drops you to a shell inside the jail post-build, allowing you to test the port freely.

```sh
# poudriere bulk -j releng-122-amd64 devel/gh audio/spotify-tui
```
This will build both **devel/gh** and **audio/spotify-tui**, committing those packages to the custom
package repository for installation. There is no limit on how many ports you pass as arguments.

# Optional configuration

If your server is beefy enough, you can tweak Poudriere to make better use of its resources. There are
a few ways of doing this, and I will go into both ccache and memcached below.

### Ccache

In short, compiler-cache is a way of speeding up compilation times by reusing previously built build-objects.
So when recompiling an application, that stored cache can be used instead, opposed to rebuilding it again
for no reason or merit.

```sh
# pkg install ccache
# mkdir -p /var/cache/ccache
```

Now in your **poudriere.conf**, add the following:

```sh
CCACHE_DIR=/var/cache/ccache
```

To increase the amount of cache stored, change **max_size** in **/var/cache/ccache** to whatever value you wish,
of course, constraint to the available space. Typically I set around 50G (max_size = 50.0G).

Pulling up ccache stats is as easy as:

```sh
# CCACHE_DIR=/var/cache/ccache ccache -s
cache directory                     /var/cache/ccache
primary config                      /var/cache/ccache/ccache.conf
secondary config      (readonly)    /usr/local/etc/ccache.conf
stats updated                       Tue Jan 19 13:04:40 2021
cache hit (direct)                 62008
cache hit (preprocessed)           11155
cache miss                        248553
cache hit rate                     22.74 %
called for link                    38956
called for preprocessing           30851
multiple source files                 61
compiler produced no output           18
compile failed                      9938
ccache internal error                156
preprocessor error                  5104
can't use precompiled header          20
couldn't find the compiler             1
bad compiler arguments              1659
unsupported source language          142
autoconf compile/link              43905
unsupported compiler option          828
unsupported code directive            30
no input file                       9762
cleanups performed                    16
files in cache                     70258
cache size                         106.9 MB
max cache size                      50.0 GB
```

As you can see it's a very hit-and-miss solution, but it works.

### Memcached

Granted, your machine has enough ram to store the build cache, memcached is a great
solution to speeding up build times. Rather than write the cache to disk, you
can use both stored cache and in-memory cache.

Once again, amend your **poudriere.conf**:

```sh
CCACHE_STATIC_PREFIX=/usr/local
RESTRICT_NETWORKING=no
```

Likewise in your **ccache.conf**:

```sh
memcached_conf = --SERVER=localhost:11211
memcached_only = true
```

Run the following:

```sh
# pkg install cache-memcached-static
# sysrc memcached_enable=YES
# sysrc memcached_flags="-l localhost -m $mb" # Replace $mb with the amount of megabytes you want to allocate
# service memcached start
```

And done! Startup a Poudriere build and watch your ram spike up as it's filled with cache. Happy hacking!
