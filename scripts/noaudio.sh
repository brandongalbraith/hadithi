#!/bin/bash

########################################################################
#noaudio.sh script processes video files in motion directory by removing  
#        their audio tracks and  saving the results in noaudio directory
########################################################################

DB=$1
width=$2
height=$3
batch_size=$4
video_duration=$5
foundry_identifier=$6

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
motioned_video_dataset="$foundry_directory/$foundry_identifier/motion/$DB/"
noaudio_video_dataset="$foundry_directory/$foundry_identifier/noaudio/$DB"

if [[ ! -d "${motioned_video_dataset}" ]]; then
    echo "creating" $motioned_video_dataset "directory" 1>&2
    mkdir -p $motioned_video_dataset
fi

if [[ ! -d "${noaudio_video_dataset}" ]]; then
    echo "creating" $noaudio_video_dataset "directory" 1>&2
    mkdir -p $noaudio_video_dataset
fi

#start process
function startup(){

    motioned_video_dataset_count="$(find ${motioned_video_dataset} -maxdepth 1 -type f ! -name "*.sh*" | wc -l)"

    if [[ $motioned_video_dataset_count -eq 0 ]];then
        echo "no data found in "$motioned_video_dataset " directory"1>&2
    else
        if [[ $motioned_video_dataset_count -gt 0 ]];then
            
            ls $motioned_video_dataset |sort -R |tail -$motioned_video_dataset_count |while read video_file; do
                if [[ $video_file ]]; then
                    video=$motioned_video_dataset$video_file
                    ffmpeg -i $video -vcodec copy -an $noaudio_video_dataset/$video_file < /dev/null
                fi
            done
            
            #Filter videos < 1 second
            bash "$(pwd)"/time.sh $DB $width $height $batch_size $video_duration $foundry_identifier
        fi
    fi
}

#start audio removal process
startup
