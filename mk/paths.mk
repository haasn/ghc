#################################################################################
#
#			    paths.mk
#
# 	This file defines Make variables for standard directories
#	and file lists
#
#################################################################################


#-----------------------------------------------------------------
#
# Installation setup
#

#-----------------------------------------------------------------------------
# install configuration
#
# The install standard target is guided by the following four variables
#
#  INSTALL_PROGS    (installed in $(bindir))
#  INSTALL_LIBS     (installed in $(libdir))
#  INSTALL_LIBEXECS (installed in $(libexecdir))
#  INSTALL_DATAS    (installed in $(datadir))
#
# see target.mk for more information.
#

#
# Setting user/group ownership for the installed entities
#
# this stuff about "who" does the installing doesn't have make vars
# as it is not intended to be run-time changeable.
#
ifneq "$(OWNER)" ""
INSTALL_OWNER 	= -o $(OWNER)
else
INSTALL_OWNER	=
endif

ifneq "$(GROUP)" ""
INSTALL_GROUP	= -g $(GROUP)
else
INSTALL_GROUP	=
endif

SRC_INSTALL_OPTS += $(INSTALL_OWNER) $(INSTALL_GROUP)

#
# Invocations of `install' for the three different classes
# of targets:
#

INSTALL_PROGRAM = $(INSTALL) -m 755
INSTALL_SCRIPT  = $(INSTALL) -m 755
INSTALL_DATA    = $(INSTALL) -m 644
INSTALL_DIR     = $(FPTOOLS_TOP)/glafp-utils/mkdirhier/mkdirhier

#
# The install variables does not have any defaults,
# what files to install have to be specified in the Makefiles.
#
#INSTALL_PROGS += $(HS_PROG) $(C_PROG)
#INSTALL_LIBS  += $(LIBRARY)
#INSTALL_DATAS += $(HS_IFACES)

#################################################################################
#
#		Standard variable names
#
#################################################################################

#
# The fptools mk setup defines a set of standard names which are used by the standard
# targets provided by mk. One example of this is the use of standard names
# for specifying what files to compile, their intermediate/object code, and
# the name of the final executable. Based on the settings of these variables, the
# standard targets will generate/expand rules that automatically compile and
# link your program.
#
# The general rules:
#
#   SRCS - sources, might be prefixed to indicate what type of source
#          they are.
#   OBJS - object files (possibly prefixed).
#
#   PROG - name of final executable

# We attempt to automatically devine the list of sources $(SRCS) to
# compile by looking in the current directory.  This is complicated by
# the fact that a .hsc file gives rise to a .hs file (which needs to
# be automatically included in $(SRCS)), but the .hs file might
# already be present in the current directory and we don't want to
# compile it twice.

# So we figure out the sources in three stages: first figure out
# what's in the current directory (this is $(PRE_SRCS)).  Then figure
# out all the "derived" sources (eg. A.hsc generates A.hs and
# A_hsc.c), and finally put all these together and remove duplicates
# (GNU make's handy sort function does the duplicate removing).
#
# BOOT_SRCS: list of machine generated Haskell modules.
# HS_SRCS:   list of Haskell modules you want to compile.
#             (also use by depend rule).
# HS_OBJS:   list of corresponding object files
# HS_PROG:   program that is ultimately linked.
# HS_IFACES: list of interface files generated
#             (caveat: assuming no funny use of -hisuf and that
#               file name and module name match)

PRE_SRCS    = $(wildcard *.lhs *.hs *.c *.prl *.lprl *.lit *.verb *.hsc)

HSC_SRCS     = $(filter %.hsc, $(PRE_SRCS))
DERIVED_SRCS = $(patsubst %.hsc, %.hs, $(HSC_SRCS)) \
	       $(patsubst %.hsc, %_hsc.c, $(HSC_SRCS)) \
	       $(patsubst %.hsc, %_hsc.h, $(HSC_SRCS))

# EXCLUDED_SRCS can be set in the Makefile, otherwise it defaults to empty.
EXCLUDED_HSC_SRCS     = $(filter %.hsc, $(EXCLUDED_SRCS))
EXCLUDED_DERIVED_SRCS = $(patsubst %.hsc, %.hs, $(EXCLUDED_HSC_SRCS)) \
			$(patsubst %.hsc, %_hsc.h, $(EXCLUDED_HSC_SRCS)) \
			$(patsubst %.hsc, %_hsc.c, $(HSC_SRCS))
# Exclude _hsc.c files; they get built as part of the cbits library,
# not part of the main library

CLOSED_EXCLUDED_SRCS  = $(sort $(EXCLUDED_SRCS) $(EXCLUDED_DERIVED_SRCS))

SRCS        = $(filter-out $(CLOSED_EXCLUDED_SRCS), \
	        $(sort $(PRE_SRCS) $(DERIVED_SRCS)))

HS_SRCS	    = $(filter %.lhs %.hs %.hc,$(sort $(SRCS) $(BOOT_SRCS)))
HS_OBJS     = $(addsuffix .$(way_)o,$(basename $(HS_SRCS)))
HS_HCS      = $(addsuffix .$(way_)hc,$(basename $(HS_SRCS)))
HS_SS       = $(addsuffix .$(way_)s,$(basename $(HS_SRCS)))
HS_IFACES   = $(addsuffix .$(way_)hi,$(basename $(HS_SRCS)))

HSC_C_OBJS  = $(addsuffix _hsc.$(way_)o,$(basename $(filter %.hsc,$(SRCS))))

C_SRCS      = $(filter %.c,$(SRCS))
C_OBJS      = $(addsuffix .$(way_)o,$(basename $(C_SRCS)))

# SCRIPT_SRCS:  list of raw script files (in literate form)
# SCRIPT_OBJS:  de-litted scripts
SCRIPT_SRCS=$(filter %.lprl,$(SRCS))
SCRIPT_OBJS=$(addsuffix .prl,$(basename $(SCRIPT_SRCS)))

OBJS=$(HS_OBJS) $(C_OBJS) $(SCRIPT_OBJS)

#
# Note that as long as you use the standard variables for setting
# which C & Haskell programs you want to work on, you don't have
# to set any of the clean variables - the default should do the Right
# Thing.
#

#------------------------------------------------------------------
#
# make depend defaults
#
# The default set of files for the dependency generators to work on
# is just their source equivalents.
#

ifneq "$(BootingFromHc)" "YES"
MKDEPENDHS_SRCS=$(HS_SRCS)
else
MKDEPENDHS_SRCS=
endif

MKDEPENDC_SRCS=$(C_SRCS)

#------------------------------------------------------------------
#
# make TAGS defaults
#
# The default set of files for the dependency generators to work on
# is just their source equivalents.
#
TAGS_HS_SRCS=$(HS_SRCS)
TAGS_C_SRCS=$(C_SRCS)

#------------------------------------------------------------------
# Clean file make-variables.
#
# The following three variables are used to control
# what gets removed when doing `make clean'
#
# MOSTLYCLEAN_FILES   object code etc., but not stuff
#                     that is slow to recompile and/or stable
#
# CLEAN_FILES  all files that are created by running make.
#
# MAINTAINER_CLEAN_FILES also clean out machine-generated files
#                        that may require extra tools to create.
#
#
MOSTLY_CLEAN_FILES += $(HS_OBJS) $(C_OBJS)
CLEAN_FILES        += $(HS_PROG) $(C_PROG) $(SCRIPT_PROG) $(SCRIPT_LINK) \
		      $(PROG) $(LIBRARY) $(HS_IFACES) $(HS_SS) a.out \
		      $(DERIVED_SRCS)

# Don't clean the .hc files if we're bootstrapping
ifneq "$(BootingFromHc)" "YES"
CLEAN_FILES += $(HS_HCS)
endif

DIST_CLEAN_FILES += .depend
MAINTAINER_CLEAN_FILES += $(BOOT_SRCS)

#
# `Standard' set of files to clean out.
#
MOSTLY_CLEAN_FILES += \
 *.CKP *.ln *.BAK *.bak .*.bak *.o *core a.out errs ,* *.a .emacs_*  \
 tags TAGS *.ind *.ilg *.idx *.idx-prev *.aux *.aux-prev *.dvi *.log \
 *.toc *.lot *.lof *.blg *.cb *_stub.c *_stub.h *.raw_s *.a.list

#------------------------------------------------------------------
#
# Distribution setup
#
# Following variables are used for creating source and binary distributions:
#
#  SRC_DIST_NAME && BIN_DIST_NAME  -- the package names
#
#  SRC_DIST_FILES = list of extra files to include from a build tree into a source
#                   distribution
#
#  SRC_DIST_DIR  = what the current directory in the source/build tree
#                  maps to in the source distrib. tree being created.
#
SRC_DIST_NAME=$(ProjectNameShort)-$(ProjectVersion)

#
# Binary distributions proceeds as follows:
#
# Fromthe top of a build tree, you do `make binary-dist'. The
# canned rule for this  (in target.mk) will then do a binary
# install to a temporary directory before packaging it all up.
# The following variables guide the binary-dist:
#
#  BIN_DIST_TMPDIR= the absolute path to where the temporary directory
#		    structure of a binary distribution should be created.
#		    [Default: toplevel from which you issue `make binary-dist']
#  BIN_DIST_NAME=   what to call the thing.
#
#  BIN_DIST_DIRS=   at the toplevel, list of directories to descend into when
#		    building the distribution tree.
#
#  An extra directory variable that is set during bin-dists is $(bindist_top), giving
#  the abs. path to the root of the binary installation tree. (useful when punting
#  stuff like README and ANNOUNCE into a distrib, for instance)
#
#  The layout of a binary distribution is described in the
#  installation documentation.
#


# Directory in which DLLs are dumped so as not to get picked up by running
# programs (e.g. ghc or hsc) that run in the build tree

DLL_PEN = $(FPTOOLS_TOP)/dll

