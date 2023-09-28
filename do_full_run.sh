#!/usr/bin/env bash

# Condition: validate `getopt` version
getopt -T
if [ "$?" != 4 ]; then
    echo 2>&1 "Wrong version of 'getopt' detected, exiting..."
    exit 1
fi

# Environment: exit on error, prevent override, return last status value, error on unset variables,
set -o errexit -o noclobber -o pipefail -o nounset

# Function: Print a help message.
usage() {
  echo "Usage: sh ./$0 <[options]>
        Options:
                -b    --batch_size        The number od simulations to run in one batch, strictly integer and positive
                -p    --population_size   The size of a population, strictly integer and positive
                -s    --start_year        The year simulation starts, from 2010 to 2023
                -e    --end_year          The year simulation ends, from 2010 to 2023, greater or equal than \`-s\`
                -g    --gui               GUI flag, \`true\` or \`false\` to enable/disable GUI support" 1>&2
}

# Function: print usage and exit with error.
exit_abnormal() {
  usage
  exit 1;
}

# parse input arguments
VALID_ARGS="$(getopt -o b:p:s:e:g: -l batch-size:,population:,start_year:,end_year:,gui: --name "$0" -- "$@")"

eval set -- "$VALID_ARGS"

# Regex: match years in range [2010 : 2023]
re_is_year='^20(1[0-9]|2[0-3])$'

# Regex: match whole positive numbers only
re_isanum='^[0-9]*[1-9][0-9]*$'

while true
do
    case "$1" in
        -b|--batch_size)
            # if $2 not whole:
            if ! [[ $2 =~ $re_isanum ]]
            then
                echo "Error: batch size must be a positive, whole number." >&2
                # Exit abnormally.
                exit_abnormal
            fi
            # Set BATCH_SIZE to specified value.
            BATCH_SIZE=$2
            shift 2
            ;;
        -p|--population)
            # if $2 not whole:
            if ! [[ $2 =~ $re_isanum ]]
            then
                echo "Error: population size must be a positive, whole number." >&2
                # Exit abnormally.
                exit_abnormal
            fi
            # Set POPULATION_SIZE to specified value.
            POPULATION_SIZE=$2
            shift 2
            ;;
        -s|--start_year)
            # if $2 not in range:
            if ! [[ $2 =~ $re_is_year ]]
            then
              echo "Error: start year must be in range [2010 : 2023]" >&2
              # Exit abnormally.
              exit_abnormal
            fi
            # Set START_YEAR to specified value.
            START_YEAR=$2
            shift 2
            ;;
        -e|--end_year)
            # if $2 not in range:
            if ! [[ $2 =~ $re_is_year ]]
            then
              echo "Error: end year must be in range [2010 : 2023]" >&2
              # Exit abnormally.
              exit_abnormal
            fi
            # Set END_YEAR to specified value.
            END_YEAR=$2
            shift 2
            ;;
        -g|--gui)
            re_is_bool='^(true|false)$'
            # if $2 not boolean:
            if ! [[ $2 =~ $re_is_bool ]]
            then
              echo "Error: must be either \`true\` or \`false\`, case-sensitive" >&2
              # Exit abnormally.
              exit_abnormal
            fi
            # Set GUI to specified value.
            GUI=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Not implemented: $1" >&2
            exit_abnormal
            ;;
    esac
done

if ! [[ $START_YEAR -le $END_YEAR ]]
then
  echo "End year must be greater or equal than start year" >&2
  exit_abnormal
fi

# Runs 1,000 runs as 50 sequential runs of n=20 with 50 unique starting seeds
seq 100 100 5000 | parallel java -cp simpaths.jar simpaths.experiment.SimPathsMultiRun -r {} -n $BATCH_SIZE \
                                                                                             -p $POPULATION_SIZE \
                                                                                             -s $START_YEAR \
                                                                                             -e $END_YEAR \
                                                                                             -g $GUI \
                                                                                             -f

# Tidy output folders, removing empty database folders and redundant input folders (keeps csvs)
rm -r ./output/202*/database ./output/202*/input

# csv files are poorly formatted, we fix it here by removing trailing commas/spaces
# WARNING: I/O heavy, saturates SATA3, requires extra temporary space
sh ./remove_trailing_commas.sh

# Text myself that it's all done
{ # try
  curl "https://api.telegram.org/bot${Notify_bot_key}/sendMessage?text=Done%20copying%20all%20files&chat_id=${telegram_chatid}" &&
} || { # catch
  echo "Failed to send a confirmation, logging success anyway."
}
