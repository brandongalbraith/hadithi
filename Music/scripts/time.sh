#!/bin/bash

##############################################################################################
#time.sh script is designed to process video files in noaudio directory by filtering out those 
#       that are shorter than N seconds and then copying the remaining files to time directory              
##############################################################################################

DB=$1
width=$2
height=$3
batch_size=$4
video_duration=$5
foundry_identifier=$6

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
noaudio_video_dataset="$foundry_directory/$foundry_identifier/noaudio/$DB/"
time_filtered_video_dataset="$foundry_directory/$foundry_identifier/time/$DB/" #TIME

if [[ ! -d "${log_directory}" ]]; then
    echo "creating" $log_directory "directory" 1>&2
    mkdir -p $log_directory
fi

if [[ ! -d $noaudio_video_dataset ]]; then
    echo "creating" $noaudio_video_dataset "directory" 1>&2
    mkdir -p $noaudio_video_dataset
fi

if [[ ! -d $time_filtered_video_dataset ]]; then
    echo "creating" $time_filtered_video_dataset "directory" 1>&2
    mkdir -p $time_filtered_video_dataset
fi

#start
function startup(){

     #regex to get video duration
    LEN_REGEX="Duration: ([0-9]*):([0-9]*):([0-9]*)\.([0-9]*), start"
    noaudio_video_dataset_count="$(find ${noaudio_video_dataset} -maxdepth 1 -type f ! -name "*.sh*" | wc -l)"

    if [[ $noaudio_video_dataset_count -eq 0 ]];then
        echo "no data found in "$noaudio_video_dataset " directory"1>&2
    else
        if [[ $noaudio_video_dataset_count -gt 0 ]];then

            ls $noaudio_video_dataset |sort -R |tail -$noaudio_video_dataset_count |while read video_file; do
                if [[ $video_file ]]; then

                    video=$noaudio_video_dataset$video_file

                    #remove videos with length < 1s
                    video_info=$(ffmpeg -i $video 2>&1) 
                    # Extract length using reges; Groups 1=hr; 2=min; 3=sec; 4=sec(decimal fraction)                                                                                                                       
                    [[ $video_info =~ $LEN_REGEX ]]  
                     # Calculate length of video in MS from above regex extraction                                                                                                                       
                    LENGTH_MS=$(bc <<< "scale=2; ${BASH_REMATCH[1]} * 3600000 + ${BASH_REMATCH[2]} * 60000 + ${BASH_REMATCH[3]} * 1000 + ${BASH_REMATCH[4]} * 10")

                    if [[ $LENGTH_MS -ge $video_duration ]];then
                        echo $video " -------------  " $LENGTH_MS 
                        cp -r "$video" $time_filtered_video_dataset$video_file
                    fi
                fi
            done

            #rescale video frames
            bash "$(pwd)"/resolution.sh $DB $width $height $batch_size $foundry_identifier
        fi
    fi
}

#start video filtering process
startup
