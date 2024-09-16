#!/bin/bash

#########################################################################################################
#segment.sh script is designed to process video files in the name directory, create segments using ffmpeg 
#   and store them in the clip directory.The script also handle empty directories and logs relevant paths                                   
#########################################################################################################

DB=$1
width=$2
height=$3
batch_size=$4
video_duration=$5
foundry_identifier=$6

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
log_directory="$foundry_directory/$foundry_identifier/log/"
renamed_video_dataset="$foundry_directory/$foundry_identifier/name/$DB/"
clipped_video_dataset="$foundry_directory/$foundry_identifier/clip/$DB/"

if [[ ! -d "${log_directory}" ]]; then
    echo "creating" $log_directory "directory" 1>&2
    mkdir -p $log_directory
fi

if [[ ! -d "${renamed_video_dataset}" ]]; then
    echo "creating" $renamed_video_dataset "directory" 1>&2
    mkdir -p $renamed_video_dataset
fi

if [[ ! -d "${clipped_video_dataset}" ]]; then
    echo "creating" $clipped_video_dataset "directory" 1>&2
    mkdir -p $clipped_video_dataset
fi

#start
function startup(){

    renamed_video_dataset_count="$(find ${renamed_video_dataset} -maxdepth 1 -type f ! -name "*.sh*" | wc -l)"
    if [[ $renamed_video_dataset_count -eq 0 ]];then
        echo "no data found in "$renamed_video_dataset " directory"1>&2
    else
        if [[ $renamed_video_dataset_count -gt 0 ]];then

            rm -rf "$log_directory"cutscenes.txt
            ls $renamed_video_dataset |sort -R |tail -$renamed_video_dataset_count |while read video_file; do
                pods=$clipped_video_dataset${video_file%.mp4}
                mkdir $pods
                echo "'$renamed_video_dataset$video_file'" >> "$log_directory"cutscenes.txt
            done

            while IFS= read -r line; do
                if [  -f "${line:1:${#line}-2}" ]; then
                    echo "${line:1:${#line}-2}" "  -----------------  " $(basename -- ""${line:1:${#line}-6}"")
                    ffmpeg -y -i "${line:1:${#line}-2}" -vf yadif -c:v libx264 -profile:v high -preset:v fast -x264opts min-keyint=15:keyint=1000:scenecut=20 -b:v 2000k \
                    -f segment -segment_format mp4 -segment_time 0.01 -segment_format_options movflags=faststart $clipped_video_dataset$(basename -- ""${line:1:${#line}-6}"")"/"v-%05d.mp4 < /dev/null
                fi
            done < "$log_directory"cutscenes.txt

            #validate empty directories
            ls $clipped_video_dataset|sort -R |tail -$clip_folder_count |while read clip_folder; do
                clip_dir=$clipped_video_dataset$clip_folder
                if [ -z "$(ls -A $clip_dir)" ]; then
                    
                    video=$renamed_video_dataset$clip_folder".mp4"
                    echo "'$video'" >> "$log_directory"emptycutscenes.txt
                fi
            done
            
            #motion scene detection
            bash "$(pwd)"/motion.sh $DB $width $height $batch_size $video_duration $foundry_identifier
        fi

    fi
}

#start clip generation process
startup
