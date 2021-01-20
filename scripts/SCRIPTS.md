## Build-Pkg

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

## Port-Mgmt

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
