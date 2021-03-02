# Poudriere build-tools
- [Hierarchy](#hierarchy)
- [Configuration](#configuration)
  - [Installation](#installation)
- [Manpage](#manpage)

Small adhoc Perl script(s) to make working with Poudriere a
little easier. Refer to the [manpage](#manpage) and
[hierarchy](#hierarchy) for further elaboration.

## Hierarchy 

```.
.
├── script - Example directory for post-build scripts
│   └── gen-summary - Generates a summary ready-for Phabricator
├── BSDmakefile - Installation Makefile
├── build-pkg   - Poudriere build-script
├── config.pm   - Configuration module
└── README.md   - Documentation
```

## Configuration

Before properly using the scripts in conjunction with Poudriere, it's assumed
everything is ready to go. If not, refer to the [getting started guide](../README.md).

You will notice a [perl module](config.pm) that defines the default
builder, ports tree and other default values for commands. Update this
accordingly to your Poudriere settings. The variable names are self-explanatory.

Command-specific default values tie-in with their according to command, so there
is no wrong or right value. Update them to your liking.

### Installation

```sh
# make install
mkdir -p /usr/local/etc/build-tools
mkdir -p /usr/local/share/build-tools
install -m 500 script/* /usr/local/share/build-tools
install -m 500 config.pm /usr/local/etc/build-tools
install -m 500 build-pkg /usr/local/sbin
```
## Manpage
```
SYNOPSIS
	build-pkg [-b builders] [-p packages] [-d portdir] [-s script] [-t tree]
	      	[-achinu]

DESCRIPTION
	This script is a build wrapper around poudriere(8) which conveniently
	creates a tmux session where build output is shown while displaying an
	informative status-line including package information, builder, build 
	phase and running build time.

	author: 	Lewis Cook <lcook@FreeBSD.org>
	revision: 	1.16

OPTIONS
	-a 		Build all targets listed in the configuration,
			useful for building on various architectures. 
        -b builders	Comma-delimited list of Poudriere jails to use
			as the building environment.
        -c		Configure package before build (the equivalent of
			running `make config` in the port directory).
        -d dir		Directory containing the ports tree collection.
        -h		Displays this help page.
	-i		Enable interactive shell post-build.
	-n		Dry-run, don't execute any commands, just output
			them instead.
        -p packages	Comma-delimited list of resulting ports to build.
	-s script	Execute script post-build provided with a set of
			environment variables: $PORTNAME, $PORTVERSION,
			$PORTMAINTAINER, $BUILDER, $BUILDERVERSION,
			$BUILDERARCH, $BUILDTIME, $PHASE, $PORTDIR,
			$TREE, $BUILDNAME. Values are retrospective of
			their command-line option, configuration and
			builder environment.
        -t tree		Poudriere ports tree.
        -u		Bulk build package.

EXAMPLES
	% build-pkg -p devel/gh -i
		Attempt to build package 'devel/gh', automatically
		attach to the tmux session and start an interactive
		shell inside the builder once built (must connect
		to the session).

	% build-pkg -p devel/gh -d /path/to/ports -t custom-tree -u
		Attempt to build package 'devel/gh', while overriding
		the (-d) ports tree location and (-t) poudriere tree,
		lastly (-u) making a ready-to-export package tree upon
		post-build allowing you to pkg install 'devel/gh'
		assuming the repository has been configured correctly.
	
	% build-pkg -h
		Displays this helpful page.
```
