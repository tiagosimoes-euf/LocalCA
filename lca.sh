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
echo -e "\n+-----------------------------+"
echo -e "| \033[1mLocal \033[1mC\033[0mertificate \033[1mA\033[0muthority |"
echo -e "+-----------------------------+\n"

# Check the main variables
echo -e "\033[1mChecking configuration...\033[0m\n"
echo -e "Certificate Authority name:  \033[36m${LCAPREFIX}\033[0m"
echo -e "Path for root certificate:   \033[36m${ROOTEXPORTPATH}\033[0m"
echo -e "Path for new certificates:   \033[36m${CERTEXPORTPATH}\033[0m"

# Check for an existing root key
ROOTKEY="${LCAPREFIX}.key"

if [[ -f ${ROOTEXPORTPATH}/${ROOTKEY} ]]; then
  echo -e "\n\033[42m[success]\033[0m Key exists for the root certificate:"
  echo -e "\n\033[36m${ROOTEXPORTPATH}/${ROOTKEY}\033[0m"
else
  echo -e "\n\033[43m[notice]\033[0m No root key is present."

  # Prompt to proceed with creating a root key
  echo
  while true; do
    read -p "Do you wish to create a root key? [Y/N] " yn
    case $yn in
      [Yy]* )
        echo -e "\n\033[43m[notice]\033[0m \
You will be asked for a passphrase when creating the key. \
This passphrase is needed to sign new certificates with this key, \
\033[1mso don't lose it!\033[0m\n"
        read -p "Press Enter to continue..."
        echo

        # Generate the root key
        openssl genrsa -des3 -out ${ROOTEXPORTPATH}/${ROOTKEY} 2048
        echo -e "\n\033[42m[success]\033[0m Generated root key:"
        echo -e "\n\033[36m${ROOTEXPORTPATH}/${ROOTKEY}\033[0m"
        break
        ;;

      [Nn]* )
        echo -e "\n\033[1mBye!\033[0m"
        exit 0
        ;;

      * ) echo -e "\n\033[41m[error]\033[0m Please answer yes or no.\n";;
    esac
  done
fi

# Check for an existing root certificate
ROOTPEM="${LCAPREFIX}.pem"
ROOTCRT="${LCAPREFIX}.crt"

if [[ -f ${ROOTEXPORTPATH}/${ROOTPEM} ]]; then
  echo -e "\n\033[42m[success]\033[0m Root certificate (PEM) already exists:"
  echo -e "\n\033[36m${ROOTEXPORTPATH}/${ROOTPEM}\033[0m"
elif [[ -f ${ROOTEXPORTPATH}/${ROOTCRT} ]]; then
  echo -e "\n\033[42m[success]\033[0m Root certificate (CRT) already exists:"
  echo -e "\n\033[36m${ROOTEXPORTPATH}/${ROOTCRT}\033[0m"
else
  echo -e "\n\033[43m[notice]\033[0m No root certificate is present."

  # Prompt to proceed with creating a root certificate
  echo
  while true; do
    read -p "Do you wish to create a root certificate? [Y/N] " yn
    case $yn in
      [Yy]* )
        echo -e "\nThe certificate will be created with the following values:"
        echo -e "\n\033[1m[Subject values]\033[0m"
        echo -e "Country Name (2 letter code):                 ${S_C}"
        echo -e "State or Province Name (full name):           ${S_ST}"
        echo -e "Locality Name (eg, city):                     ${S_L}"
        echo -e "Organization Name (eg, company):              ${S_O}"
        echo -e "Organizational Unit Name (eg, section):       ${S_OU}"
        echo -e "Common Name (e.g. server FQDN or YOUR name):  ${S_CN}"

        # Prompt to confirm certificate subject variables
        echo
        while true; do
          read -p "Are these values correct? [Y/N] " yn
          case $yn in
            [Yy]* )

              # Generate the root certificate (PEM)
              openssl req -x509 -new -nodes -key ${ROOTEXPORTPATH}/${ROOTKEY} \
              -sha256 -days 1825 -out ${ROOTEXPORTPATH}/${ROOTPEM} -subj \
              "/C=${S_C}/ST=${S_ST}/L=${S_L}/O=${S_O}/OU=${S_OU}/CN=${S_CN}"
              echo -e "\n\033[42m[success]\033[0m Generated root certificate:"
              echo -e "\n\033[36m${ROOTEXPORTPATH}/${ROOTPEM}\033[0m"
              break
              ;;

            [Nn]* )
              echo -e "\n\033[43m[notice]\033[0m Interrupted!"
              echo -e "\nEdit ${CONFIGFILE} and run the script again."
              echo -e "\n\033[1mBye!\033[0m"
              exit 0
              ;;

            * ) echo -e "\n\033[41m[error]\033[0m Please answer yes or no.\n";;
          esac
        done
        break
        ;;

      [Nn]* )
        echo -e "\n\033[1mBye!\033[0m"
        exit 0
        ;;

      * ) echo -e "\n\033[41m[error]\033[0m Please answer yes or no.\n";;
    esac
  done
fi

echo ""
read -p "Press Enter to continue..."

echo -e "\n\033[43m[notice]\033[0m \
This root certificate must be added \033[1mmanually\033[0m to your browser(s)."

echo -e "\nOn Firefox,\
\n  type \033[36mabout:preferences#privacy\033[0m in the address bar;\
\n  scroll to the end of the page and click on \033[1mView certificates\033[0m;\
\n  in the Certificate Manager > Authorities, click on \033[1mImport...\033[0m;\
\n  navigate to \033[36m${ROOTEXPORTPATH}\033[0m;\
\n  select the root certificate \033[36m${ROOTPEM}\033[0m;\
\n  check \"Trust this CA to identify websites\" and click \033[1mOK\033[0m;\
\n  this CA is now listed under \033[36m${S_O}\033[0m."

echo -e "\nOn Chrome / Chromium,\
\n  type \033[36mchrome://settings/certificates\033[0m in the address bar;\
\n  in the Authorities tab, click on \033[1mImport\033[0m;\
\n  navigate to \033[36m${ROOTEXPORTPATH}\033[0m;\
\n  select the root certificate \033[36m${ROOTPEM}\033[0m;\
\n  check \"Trust this CA to identify websites\" and click \033[1mOK\033[0m;\
\n  this CA is now listed under \033[36morg-${S_O}\033[0m."

echo ""
read -p "Press Enter to continue..."

echo -e "\n\033[1mBye!\033[0m"
