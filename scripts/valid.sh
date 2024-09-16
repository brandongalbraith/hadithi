#!/bin/bash

#########################################################################################################
#valid.sh script is designed to process batch directories containing images, validate that each directory 
#                   has exactly N images,and then copy those validated directories to the valid directory
#########################################################################################################

DB=$1
batch_size=$2
foundry_identifier=$3

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
log_directory="$foundry_directory/$foundry_identifier/log/"
batched_video_dataset="$foundry_directory/$foundry_identifier/batch/$DB/"
valid_batched_video_dataset="$foundry_directory/$foundry_identifier/valid/$DB/"

if [[ ! -d "${log_directory}" ]]; then
    echo "creating" $log_directory "directory" 1>&2
    mkdir -p $log_directory
fi

if [[ ! -d "${batched_video_dataset}" ]]; then
    echo "creating" $batched_video_dataset "directory" 1>&2
    mkdir -p $batched_video_dataset
fi

if [[ ! -d "${valid_batched_video_dataset}" ]]; then
    echo "creating" $valid_batched_video_dataset "directory" 1>&2
    mkdir -p $valid_batched_video_dataset
fi

function startup(){
    #regex to get video duration
    LEN_REGEX="Duration: ([0-9]*):([0-9]*):([0-9]*)\.([0-9]*), start"

    batched_video_dataset_count="$(find ${batched_video_dataset} -maxdepth 1 -type d ! -name "*.sh*" | wc -l)"

    if [[ $batched_video_dataset_count -eq 0 ]];then
        echo "no data found in "$batched_video_dataset" directory"1>&2
    else
        if [[ $batched_video_dataset_count -gt 0 ]];then
            
            rm -rf "$log_directory"data.txt
            rm -rf "$log_directory"batched.txt

            ls $batched_video_dataset |sort -R |tail -$batched_video_dataset_count |while read video_file; do
                if [[ $video_file ]]; then
                    echo "'$batched_video_dataset$video_file'" >> "$log_directory"batched.txt
                fi
            done

            while IFS= read -r line; do
                data_path="${line//\'/}"
                data_count="$(find "$data_path" -maxdepth 1 -type f  -name "*.png*" | wc -l)"
                if [[ $data_count -eq $batch_size ]]; then
                    echo $data_path >> "$log_directory"data.txt
                fi
            done < "$log_directory"batched.txt

             while IFS= read -r line; do
                dataset="${line//\'/}"
                cp -r $dataset $valid_batched_video_dataset
            done < "$log_directory"data.txt

            #generate frame rate 
            #bash "$(pwd)"/fps.sh $DB $foundry_identifier
        fi
    fi
}

#start batch directories validation process
startup
