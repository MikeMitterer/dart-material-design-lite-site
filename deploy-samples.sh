#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Deploys sample to LightSail II
#
# rsync-destination must be defined in a .rsync-file for each sample
# -----------------------------------------------------------------------------

# Vars die in .bashrc gesetzt werden. ~ (DEV_DOCKER, DEV_SEC, DEV_LOCAL) ~~~~~~
# [] müssen entfernt werden (IJ Bug https://goo.gl/WJQGMa) 
if [ -z ${DEV_DOCKER+set} ]; then echo "Var 'DEV_DOCKER' nicht gesetzt!"; exit 1; fi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Abbruch bei Problemen (https://goo.gl/hEEJCj)
#
# Wenn ein Fehler nicht automatisch zu einem exit führen soll dann
# kann 'command || true' verwendet werden
#
# Für die $1, $2 Abfragen kann 'CMDLINE=${1:-}' verwendet werden
#
# -e Any subsequent(*) commands which fail will cause the shell script to exit immediately
# -o pipefail sets the exit code of a pipeline to that of the rightmost command
# -u treat unset variables as an error and exit
# -x print each command before executing it
set -eou pipefail

APPNAME="`basename $0`"

SCRIPT=`realpath $0`           
SCRIPTPATH=`dirname ${SCRIPT}`

#------------------------------------------------------------------------------
# Einbinden der globalen Build-Lib
#   Hier sind z.B. Farben, generell globale VARs und Funktionen definiert
#

GLOBAL_DIR="${DEV_DOCKER}/_global"
LIB_DIR="${GLOBAL_DIR}/lib"

SAMPLES_LIB="samples.lib.sh"

if [[ ! -f "${LIB_DIR}/${SAMPLES_LIB}" ]]
then
    echo "Samples-lib ${LIB_DIR}/${SAMPLES_LIB} existiert nicht!"
    exit 1
fi

. "${LIB_DIR}/${SAMPLES_LIB}"


#------------------------------------------------------------------------------
# BASIS

#------------------------------------------------------------------------------
# Functions
#

#------------------------------------------------------------------------------
# Options
#

#------------------------------------------------------------------------------
# Options
#

usage() {
    echo
    echo "Usage: ${APPNAME} [ options ]"
    echo -e "\t-l | --list    [example_name]            Lists all examples from '${YELLOW}${EXAMPLE_FOLDER}'${NC}-folder"
    echo -e "\t-d | --deploy  [example_name]            Creates 'deploy'-dir for Dart"
    echo -e "\t-p | --publish [example_name] [--force]  Publish samples to AWS/S3 (only on day ${PUBLISH_ONLY_ON_DAY})"
    echo -e "\t                                             use --force to ignore Monday as publishing day"
}

CMDLINE=${1:-}
OPTION1=${2:-}
OPTION2=${3:-}

case "${CMDLINE}" in
    -l|list|-list|--list)
        if [ -n "${OPTION1+set}" -a "${OPTION1}" != ""  ]; then
            listSamples "${EXAMPLE_FOLDER}/${OPTION1}"
        else
            listSamples "${EXAMPLES[@]}"
        fi
    ;;

    -d|deploy|-deploy|--deploy)
        if [ -n "${OPTION1+set}" -a "${OPTION1}" != ""  ]; then
            deploySamples "${EXAMPLE_FOLDER}/${OPTION1}"
        else
            deploySamples "${EXAMPLES[@]}"
        fi
    ;;

    -p|publish|-publish|--publish)
        if [ -n "${OPTION1+set}" -a "${OPTION1}" != "--force"  ]; then
            publishSamples "${EXAMPLE_FOLDER}/${OPTION1}"
        else
            publishSamples "${EXAMPLES[@]}"
        fi
    ;;


    -g|generate|-generate|--generate)
        if [ -n "${OPTION1+set}" -a "${OPTION1}" != "--force"  -a "${OPTION1}" != "" ]; then
            generateRsyncSetting "${EXAMPLE_FOLDER}/${OPTION1}"
        else
            generateRsyncSetting "${EXAMPLES[@]}"
        fi
    ;;

    -h|-help|--help|*)
        usage
    ;;

esac

#------------------------------------------------------------------------------
# Alles OK...

exit 0
