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

#

# TESTING

echo -e "Name for root key and root certificate:      ${LCANAME}"
echo -e "Path to export the root certificate:         ${ROOTEXPORTPATH}"
echo -e "Path to export the new certificates:         ${CERTEXPORTPATH}"

echo -e "\n[Subject variables]"
echo -e "Country Name (2 letter code):                ${SUBJ_C}"
echo -e "State or Province Name (full name):          ${SUBJ_ST}"
echo -e "Locality Name (eg, city):                    ${SUBJ_L}"
echo -e "Organization Name (eg, company):             ${SUBJ_O}"
echo -e "Organizational Unit Name (eg, section):      ${SUBJ_OU}"
echo -e "Common Name (e.g. server FQDN or YOUR name): ${SUBJ_CN}"
