#!/usr/bin/env bash

# Set the main variables
SCRIPTPATH=$(dirname $(realpath $0))
CONFIGEXAMPLE='example.ca.cfg'
CONFIGFILE='ca.cfg'
LOGPATH=${SCRIPTPATH}/'log'

# Assert a configuration file
if [[ ! -f ${SCRIPTPATH}/${CONFIGFILE} ]]; then
  cp ${SCRIPTPATH}/${CONFIGEXAMPLE} ${SCRIPTPATH}/${CONFIGFILE}
fi

# Import configuration
source ${SCRIPTPATH}/${CONFIGFILE}
