#!/usr/bin/env bash
# das4_find_free_cluster.sh ---
#
# Filename: das4_find_free_cluster.sh
# Description:
# Author: Elric Milon
# Maintainer:
# Created: Mon May 30 15:12:19 2016 (+0200)

# Commentary:
#
#
#
#

# Change Log:
#
#
#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
#
#

# Code:

HEAD_NODES="fs0.das5.cs.vu.nl fs1.das5.liacs.nl fs2.das5.science.uva.nl fs3.das5.tudelft.nl fs4.das5.science.uva.nl fs5.das5.astron.nl"
#HEAD_NODES="das5_astron das5_lu das5_mn das5_tud das5_uva das5_vu"

if [ ! -z "$1" ]; then
    source $1
fi

function get_availability {
    for HOST in $HEAD_NODES; do
        AVAILABLE=`ssh $HOST sinfo | grep "^defq.*idle " | awk '{print $4}'`
        echo $AVAILABLE $HOST
    done
}

BEST=`get_availability | sort -nr | head -1`

BEST_NODES=`echo $BEST | awk '{print $1}'`
BEST_HOST=`echo $BEST | awk  '{print $2}'`

echo "The cluster with the most free nodes is $BEST_HOST ($BEST_NODES)"

if [ ! -z "$DAS4_NODE_AMOUNT" -a $DAS4_NODE_AMOUNT -gt $BEST_NODES ]; then
    echo "This is not enough, waiting for 30 seconds before retrying, press ^C to abort"
    sleep 30
    exec $0
fi

>&2 echo $BEST_HOST


#
# das4_find_free_cluster.sh ends here
