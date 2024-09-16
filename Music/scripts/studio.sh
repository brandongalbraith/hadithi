#!/usr/bin/bash

######################################################
#
######################################################

#PARAMS
width=960
height=720
batch_size=32
frame_rate=12
video_duration=1000 #ms
video_directory=$1
foundry_identifier=$(date +"%Y%m%d%H%M%S%N")

if [[ -d "${video_directory}" ]]; then

    mp4_file_count="$(find ${video_directory} -maxdepth 1 -type f  -name "*.mp4*" | wc -l)"
    if [[ $mp4_file_count -gt 0 ]];then
        
        #create foundry directories
        script_directory="$(dirname "$(pwd)")"
        foundry_directory=$script_directory/foundry
        processing_directory=$foundry_directory/"$foundry_identifier"

        if [[ ! -d "${processing_directory}" ]]; then
            echo "creating" $processing_directory "directory"
            mkdir -p $processing_directory
        fi

        log_directory=$processing_directory/"log"
        if [[ ! -d "${log_directory}" ]]; then
            echo "creating" $log_directory "directory"
            mkdir -p $log_directory
        fi

        raw_directory=$processing_directory/"folder"
        if [[ ! -d "${raw_directory}" ]]; then
            echo "creating" $raw_directory "directory"
            mkdir -p $raw_directory
        fi

        renamed_directory=$processing_directory/"name"
        if [[ ! -d "${renamed_directory}" ]]; then
            echo "creating" $renamed_directory "directory"
            mkdir -p $renamed_directory
        fi

        clean_directory=$processing_directory/"motion"
        if [[ ! -d "${clean_directory}" ]]; then
            echo "creating" $clean_directory "directory"
            mkdir -p $clean_directory
        fi

        clips_directory=$processing_directory/"clip"
        if [[ ! -d "${clips_directory}" ]]; then
            echo "creating" $clips_directory "directory"
            mkdir -p $clips_directory
        fi

        data_directory=$processing_directory/"valid"
        if [[ ! -d "${data_directory}" ]]; then
            echo "creating" $data_directory "directory"
            mkdir -p $data_directory
        fi

        noaudio_directory=$processing_directory/"noaudio" 
        if [[ ! -d "${noaudio_directory}" ]]; then
            echo "creating" $noaudio_directory "directory"
            mkdir -p $noaudio_directory
        fi

        chunked_directory=$processing_directory/"scale"
        if [[ ! -d "${chunked_directory}" ]]; then
            echo "creating" $chunked_directory "directory"
            mkdir -p $chunked_directory
        fi

        annotated_directory=$processing_directory/"time"
        if [[ ! -d "${annotated_directory}" ]]; then
            echo "creating" $annotated_directory "directory"
            mkdir -p $annotated_directory
        fi

        v2pic_directory=$processing_directory/"batch"
        if [[ ! -d "${v2pic_directory}" ]]; then
            echo "creating" $v2pic_directory "directory"
            mkdir -p $v2pic_directory
        fi

        train_directory=$processing_directory/"fps"
        if [[ ! -d "${train_directory}" ]]; then
            echo "creating" $train_directory "directory"
            mkdir -p $train_directory
        fi

        echo "directory" $video_directory " exist with " $mp4_file_count  "supported .mp4 videos"
        #Organize each *.mp4 into individual folders
        bash "$(pwd)"/folder.sh "$(date +"%Y%m%d%H%M%S%N")" "$width" "$height" "$batch_size" "$video_duration" "$mp4_file_count" "$video_directory" "$foundry_identifier" "$frame_rate"
         
    else
        echo "sorry .mp4 file(s) not found.We currently support .mp4 format.See our github on converting other formats to .mp4"
    fi

else
    echo "Enter data directory in the format /hadithi/data/ where data is folder containing raw .mp4 video(s).Other formats will have to be converted to mp4.Test with a data/sample video ~ 4MB"
fi
