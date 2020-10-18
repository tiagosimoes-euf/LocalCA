#!/usr/bin/env bash

# Set the main variables
SCRIPTPATH=$(dirname $(realpath $0))
CONFIGEXAMPLE='example.ca.cfg'
CONFIGFILE='ca.cfg'

# Assert a configuration file
if [[ ! -f ${SCRIPTPATH}/${CONFIGFILE} ]]; then
  cp ${SCRIPTPATH}/${CONFIGEXAMPLE} ${SCRIPTPATH}/${CONFIGFILE}
fi

# Import configuration
source ${SCRIPTPATH}/${CONFIGFILE}

# Assert a certs directory
if [[ ! -d ${CERTEXPORTPATH} ]]; then
  mkdir -p ${CERTEXPORTPATH}
fi

# Check for a root CA directory definition or use a default
if [[ ! ${ROOTEXPORTPATH} ]]; then
  ROOTEXPORTPATH=${CERTEXPORTPATH}/${LCANAME}
fi

# Assert a root CA directory
if [[ ! -d ${ROOTEXPORTPATH} ]]; then
  mkdir -p ${ROOTEXPORTPATH}
fi


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
