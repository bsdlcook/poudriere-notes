#!/usr/bin/env perl
#
# Change the options below to fit your needs,
# ensuring that the values are valid too.
#

#
# Used for the (-a) all flag.
#
our @_all_builders = qw(releng-130-amd64 releng-130-i386 releng-122-amd64 releng-122-i386 releng-114-amd64 releng-114-i386);

#
# Default arguments.
#
our $_builder = "releng-130-amd64";
our $_tree    = "default";
our $_dir     = "/usr/local/poudriere/ports/default";

#
# Default flags.
#
our $_interactive = 0;
our $_configure   = 0;
our $_bulk        = 0;
our $_tmux        = 0;

#
# Misc.
#
our $_author   = "Lewis Cook <lcook\@FreeBSD.org>";
our $_revision = "1.21";

1;
