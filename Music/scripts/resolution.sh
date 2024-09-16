#!/bin/bash

##################################################################################################
#resolution.sh script is designed to process rescale(change)  video files width and height usually 
#     smaller than original video file from time directory.It uses ffmpeg to generate image frames     
#                                    from each video.These frames are saved in the scale directory
##################################################################################################

DB=$1
width=$2
height=$3
batch_size=$4
foundry_identifier=$5

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
log_directory="$foundry_directory/$foundry_identifier/log/"
time_filtered_video_dataset="$foundry_directory/$foundry_identifier/time/$DB/"
rescaled_video_dataset="$foundry_directory/$foundry_identifier/scale/$DB/"

if [[ ! -d "${log_directory}" ]]; then
    echo "creating" $log_directory "directory" 1>&2
    mkdir -p $log_directory
fi

if [[ ! -d "${time_filtered_video_dataset}" ]]; then
    echo "creating" $time_filtered_video_dataset "directory" 1>&2
    mkdir -p $time_filtered_video_dataset
fi

if [[ ! -d "${rescaled_video_dataset}" ]]; then
    echo "creating" $rescaled_video_dataset "directory" 1>&2
    mkdir -p $rescaled_video_dataset
fi

#start process
function startup(){

    image_video_dataset_count="$(find ${time_filtered_video_dataset} -maxdepth 1 -type f ! -name "*.sh*" | wc -l)"

    if [[ $image_video_dataset_count -eq 0 ]];then
        echo "no data found in "$time_filtered_video_dataset " directory"1>&2
    else
        if [[ $image_video_dataset_count -gt 0 ]];then

            rm -rf "$log_directory"batchscenes.txt

            ls $time_filtered_video_dataset |sort -R |tail -$image_video_dataset_count |while read video_file; do
                if [[ $video_file ]]; then
                    pods=$rescaled_video_dataset${video_file%.mp4}
                    mkdir $pods
                    echo "'$time_filtered_video_dataset$video_file'" >> "$log_directory"batchscenes.txt
                fi
            done

            while IFS= read -r line; do
                if [  -f "${line:1:${#line}-2}" ]; then
                    ffmpeg -i "${line:1:${#line}-2}" -vf "scale=$width:$height" $rescaled_video_dataset$(basename -- ""${line:1:${#line}-6}"")"/"0%05d.png < /dev/null
                fi
            done < "$log_directory"batchscenes.txt
            
            #split rescaled data
            bash "$(pwd)"/batch.sh $DB $batch_size $foundry_identifier
        fi
    fi
}

#start video resizing HxW process
startup
