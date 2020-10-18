#!/usr/bin/env bash

# Set the main variables
SCRIPTPATH=$(dirname $(realpath $0))
CONFIGEXAMPLE='example.lca.cfg'
CONFIGFILE='lca.cfg'

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
  ROOTEXPORTPATH=${CERTEXPORTPATH}/${LCAPREFIX}
fi

# Assert a root CA directory
if [[ ! -d ${ROOTEXPORTPATH} ]]; then
  mkdir -p ${ROOTEXPORTPATH}
fi

# START

echo -e "\n+---------+"
echo -e "| \033[1mLocalCA\033[0m |"
echo -e "+---------+\n"

# Check the main variables

echo -e "Checking configuration...\n"
echo -e "Prefix for root key and certificate:         ${LCAPREFIX}"
echo -e "Path to export the root certificate:         ${ROOTEXPORTPATH}"
echo -e "Path to export the new certificates:         ${CERTEXPORTPATH}"

# Check for an existing root key
ROOTKEY="${LCAPREFIX}.key"

if [[ -f ${ROOTEXPORTPATH}/${ROOTKEY} ]]; then
  echo -e "\nKey exists for the root certificate:       \
  ${ROOTEXPORTPATH}/${ROOTKEY}"
else
  echo -e "\nNo root key is present."

  # Prompt to proceed with creating a root key
  echo
  while true; do
    read -p "Do you wish to create a root key? [Y/N] " yn
    case $yn in
      [Yy]* )
        echo -e "\n\
You will be asked for a passphrase when creating the key."
        echo -e "\
This passphrase is needed to sign new certificates with this key, \
\033[1mso don't lose it!\033[0m\n"
        read -p "Press Enter to continue..."
        openssl genrsa -des3 -out ${ROOTEXPORTPATH}/${ROOTKEY} 2048
        break
        ;;
      [Nn]* )
        echo "Bye!"
        exit 0
        ;;
      * ) echo "Please answer yes or no.";;
    esac
  done
fi

# Check for an existing root certificate
ROOTPEM="${LCAPREFIX}.pem"
ROOTCRT="${LCAPREFIX}.crt"

if [[ -f ${ROOTEXPORTPATH}/${ROOTPEM} ]]; then
  echo -e "\nRoot certificate (PEM) already exists:       \
  ${ROOTEXPORTPATH}/${ROOTPEM}"
elif [[ -f ${ROOTEXPORTPATH}/${ROOTCRT} ]]; then
  echo -e "\nRoot certificate (CRT) already exists:       \
  ${ROOTEXPORTPATH}/${ROOTCRT}"
else
  echo -e "\nNo root certificate is present."

  # Prompt to proceed with creating a root certificate
  echo
  while true; do
    read -p "Do you wish to create a root certificate? [Y/N] " yn
    case $yn in
      [Yy]* )
        #

        break
        ;;
      [Nn]* )
        echo "Bye!"
        exit 0
        ;;
      * ) echo "Please answer yes or no.";;
    esac
  done
fi


echo ""
read -p "Press Enter to continue..."

echo -e "\n[Subject variables]"
echo -e "Country Name (2 letter code):                ${SUBJ_C}"
echo -e "State or Province Name (full name):          ${SUBJ_ST}"
echo -e "Locality Name (eg, city):                    ${SUBJ_L}"
echo -e "Organization Name (eg, company):             ${SUBJ_O}"
echo -e "Organizational Unit Name (eg, section):      ${SUBJ_OU}"
echo -e "Common Name (e.g. server FQDN or YOUR name): ${SUBJ_CN}"
