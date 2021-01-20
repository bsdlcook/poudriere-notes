# Contents
- [Configuration](#configuration)
  - [Installation](#installation)
- [Commands](#commands)
  - [Build-Pkg](#build-pkg)
  - [Ports-Mgmt](#ports-mgmt)

Collection of adhoc Poudriere scripts to make my life easier.

# Configuration

Before properly using the scripts in conjuction with Poudriere it's assumed
everything is ready to go. If not, refer to the [SETUP.md](SETUP.md) guide.

You will notice an [Environment](scripts/Environment) script that defines the
default builder, ports tree and other default values for commands. Update this
accordingly to your Poudriere settings, the variable names are self-explanatory.

Command-specific default values tie in with their acccording command, so there
is no wrong or right value. Update them to your liking.

### Installation

```sh
# cd scripts/
# make install
install -m 555 Build-Pkg /usr/local/sbin
install -m 555 Port-Mgmt /usr/local/sbin
install -m 644 Environment /usr/local/etc/pdt
- truncated -
```

That's it.


# Commands

### [Build-Pkg](scripts/Build-Pkg)

```sh
usage: Build-Pkg [-p category/port] [-b builder] [-t tree] [-d port dir] [-g report dir] [-ricu]

Arguments:
	-p 	-- Target package
	-b	-- Target builder
	-t	-- Target ports tree
	-d	-- Target port directory
	-g	-- Target report directory

Flags:
	-r	-- Generate report
	-i	-- Interactive shell
	-c      -- Configure package before build
	-u 	-- Bulk build
```

### [Port-Mgmt](scripts/Port-Mgmt)

```sh
usage: Port-Mgmt [-d port dir] [-csu]

Arguments:
	-d	-- Target port directory
	-l(n)	-- List (n) last SVN commit logs

Flags:
	-c	-- Clean port directory commits
	-s	-- Show port directory SVN status
	-u	-- Update port directory
```
