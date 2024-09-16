#!/bin/bash

#################################################################################################
#motion.sh script processes video files in clip directory, applies a scene detection filter using
#            ffmpeg and then moves the resulting files to motion directory for further processing                                                                 
#################################################################################################

DB=$1
width=$2
height=$3
batch_size=$4
video_duration=$5
foundry_identifier=$6

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
log_directory="$foundry_directory/$foundry_identifier/log/"
clipped_video_dataset="$foundry_directory/$foundry_identifier/clip/$DB/"
motioned_video_dataset="$foundry_directory/$foundry_identifier/motion/$DB/"

if [[ ! -d "${log_directory}" ]]; then
    echo "creating" $log_directory "directory" 1>&2
    mkdir -p $log_directory
fi

if [[ ! -d "${clipped_video_dataset}" ]]; then
    echo "creating" $clipped_video_dataset "directory" 1>&2
    mkdir -p $clipped_video_dataset
fi

if [[ ! -d "${motioned_video_dataset}" ]]; then
    echo "creating" $motioned_video_dataset "directory" 1>&2
    mkdir -p $motioned_video_dataset
fi

#start 
function startup(){

    rm -rf "$log_directory"emptycleans.txt
    touch "$log_directory"emptycleans.txt
    
    clipped_video_dataset_count="$(find ${clipped_video_dataset} -maxdepth 1 -type d | wc -l)"

    if [[ $clipped_video_dataset_count -eq 0 ]];then
        echo "no data found in "$clipped_video_dataset " directory"1>&2
    else
        if [[ $clipped_video_dataset_count -gt 0 ]];then

            ls $clipped_video_dataset |sort -R |tail -$clipped_video_dataset_count |while read clip_folder; do
                clip_dir_path=$clipped_video_dataset$clip_folder
                clip_dir_count="$(find ${clip_dir_path} -maxdepth 1 -type f | wc -l)"
                if [[ $clip_dir_count -gt 0 ]];then
                    
                    ls $clip_dir_path |sort -R |tail -$clip_dir_count |while read clip_file; do
                        clip=$clip_dir_path"/"$clip_file
                        echo "'$clip'" >> "$log_directory"emptycleans.txt
                    done   
                fi
            done

            while IFS= read -r line; do
                if [  -f "${line:1:${#line}-2}" ]; then
                    echo "${line:1:${#line}-2}" "  -----------------  " $(basename -- ""${line:1:${#line}-6}"")
                    ffmpeg -i "${line:1:${#line}-2}" -vf "select=gt(scene\,0.001),setpts=N/(25*TB)"  -strftime 1 $motioned_video_dataset"$(date +"%Y%m%d%H%M%S%N").mp4" < /dev/null
                fi
            done <  "$log_directory"emptycleans.txt

            #remove audio tracks
            bash "$(pwd)"/noaudio.sh $DB $width $height $batch_size $video_duration $foundry_identifier
        fi
    fi
}

#start scene detection process
startup
