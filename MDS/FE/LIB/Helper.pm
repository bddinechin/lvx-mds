#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# The signature of an operator helper (DOC/MDD.dtd's Helper).  Unlike Storage and the
# others there is no null entry to emit: nothing refers to a Helper by IDREF, and a helper
# that is not declared is precisely one that keeps the container.  The Helper.pl that
# yml2pl.pl writes calls MDS::make("Helper", ...) for each entry, and needs no more from
# here than the package.

use MDS;

1;

# vim: set ts=4 sw=4 et:
