#!/usr/bin/bash

#############################################################################
#folder.sh script is designed to organize each video files from *source  into 
#       directory into individualfolders then moving them to folder directory
#############################################################################

DB=$1
width=$2
height=$3
batch_size=$4
video_duration=$5
video_directory=$7
foundry_identifier=$8

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
raw_video_dataset="$foundry_directory/$foundry_identifier/folder/$DB/"

if [[ ! -d "${raw_video_dataset}" ]]; then
    mkdir -p $raw_video_dataset
fi

i=0;
for video_file in "${video_directory}"/*; do
    if [[ -f "$video_file" ]]; then
        raw_data_folder_sub_folder=${raw_video_dataset}/$(printf %01d $((i/1+1))); 
        mkdir -p $raw_data_folder_sub_folder;
        mv "$video_file" $raw_data_folder_sub_folder;
        let i++;
    fi
done

#rename files with timestamps
bash "$(pwd)"/name.sh $DB $width $height $batch_size $video_duration $foundry_identifier
