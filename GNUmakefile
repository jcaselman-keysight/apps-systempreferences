#
#  Main Makefile for system preference framework and application
#  
#  Copyright (C) 2006 Free Software Foundation, Inc.
#
#  Written by:	Richard Frith-Macdonald <rfm@gnu.org>
#
#  This framework is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 31 Milk Street #960789 Boston, MA 02196 USA
#
#

VERSION = 1.2.1
PACKAGE_NAME = SystemPreferences 
SVN_MODULE_NAME = systempreferences
SVN_BASE_URL=svn+ssh://svn.gna.org/svn/gnustep/apps

# This usually happens when you source GNUstep.sh, then run ./configure,
# then log out, then log in again and try to compile
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif

ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to run the GNUstep configuration script before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# The list of subproject directories
#
SUBPROJECTS = PreferencePanes Modules SystemPreferences

-include Makefile.preamble

-include GNUmakefile.local

include $(GNUSTEP_MAKEFILES)/aggregate.make

-include Makefile.postamble

