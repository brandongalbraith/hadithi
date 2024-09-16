#!/bin/bash

#########################################################################################################
# name.sh script is designed to process video files from folder directory, rename them to replace certain 
#       characters with underscores, and then copy them to name directory with a new timestamp-based name
#########################################################################################################

DB=$1
width=$2
height=$3
batch_size=$4
video_duration=$5
foundry_identifier=$6

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
raw_video_dataset="$foundry_directory/$foundry_identifier/folder/$DB/"
renamed_video_dataset="$foundry_directory/$foundry_identifier/name/$DB/" 

if [[ ! -d "${raw_video_dataset}" ]]; then
    echo "creating" $raw_video_dataset "directory" 1>&2
    mkdir -p $raw_video_dataset
fi

if [[ ! -d "${renamed_video_dataset}" ]]; then
    echo "creating" $renamed_video_dataset "directory" 1>&2
    mkdir -p $renamed_video_dataset
fi

#start
function startup(){

    raw_video_dataset_count="$(find ${raw_video_dataset} -maxdepth 1 -type d  ! -name "*.sh*" | wc -l)"

    if [[ $raw_video_dataset_count -eq 0 ]];then
        echo "no data found in "$raw_video_dataset " directory"1>&2
    else
        if [[ $raw_video_dataset_count -gt 0 ]];then
            
            ls $raw_video_dataset |sort -R |tail -$raw_video_dataset_count |while read parent_folder; do
                
                Parent_Folder="$raw_video_dataset${parent_folder}"
                mv "${Parent_Folder}" "${Parent_Folder// /_}"
                parent_folder_count="$(find ${Parent_Folder} -maxdepth 1 -type f  -name "*.mp4" | wc -l)"
                parent=$raw_video_dataset$parent_folder
                echo "parent ----------------------------------------" $parent " ------- count ------- "$parent_folder_count
                ls $parent |sort -R |tail -$parent_folder_count |while read child_file; do
                    video_file="$parent"/"$child_file"
                    mv "${video_file}" "${video_file//[ ()@$]/_}" 
                    cp -r "$video_file" $renamed_video_dataset"$(date -r "$video_file" +"%Y%m%d%H%M%S%N").mp4" 
                done

            done

            #segments generation
            bash "$(pwd)"/segment.sh $DB $width $height $batch_size $video_duration $foundry_identifier
        fi
    fi
}

#start  timestamped videos renaming process
startup
