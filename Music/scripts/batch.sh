#!/bin/bash

###############################################################################################
#batch.sh script is designed to organize video files from scale directory into N batches, store  
#         them in batch directory, structure them,and then log the paths of the processed files                               
###############################################################################################

DB=$1
batch_size=$2
foundry_identifier=$3

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
log_directory="$foundry_directory/$foundry_identifier/log/"
rescaled_video_dataset="$foundry_directory/$foundry_identifier/scale/$DB/"
batched_video_dataset="$foundry_directory/$foundry_identifier/batch/$DB/"

if [[ ! -d "${log_directory}" ]]; then
    echo "creating" $log_directory "directory" 1>&2
    mkdir -p $log_directory
fi

if [[ ! -d "${rescaled_video_dataset}" ]]; then
    echo "creating" $rescaled_video_dataset "directory" 1>&2
    mkdir -p $rescaled_video_dataset
fi

if [[ ! -d "${batched_video_dataset}" ]]; then
    echo "creating" $batched_video_dataset "directory" 1>&2
    mkdir -p $batched_video_dataset
fi

function startup(){
    #regex to get video duration
    LEN_REGEX="Duration: ([0-9]*):([0-9]*):([0-9]*)\.([0-9]*), start"
    
    batched_video_dataset_count="$(find ${batched_video_dataset} -maxdepth 1 -type d ! -name "*.sh*" | wc -l)"
    rescaled_video_dataset_count="$(find ${rescaled_video_dataset} -maxdepth 1 -type d ! -name "*.sh*" | wc -l)"

    if [[ $rescaled_video_dataset_count -eq 0 ]];then
        echo "no data found in "$rescaled_video_dataset_count" directory"1>&2
    else
        if [[ $rescaled_video_dataset_count -gt 0 ]];then

            rm -rf "$log_directory"val.txt
            rm -rf "$log_directory"batched.txt
            rm -rf "$log_directory"chunked.txt

            ls $rescaled_video_dataset |sort -R |tail -$rescaled_video_dataset_count |while read video_file; do
                if [[ $video_file ]]; then
                    echo "'$rescaled_video_dataset$video_file'" >> "$log_directory"chunked.txt
                fi
            done

            i=0;
            while IFS= read -r line; do
                data_path="${line//\'/}"'/*'
                for f in $data_path; 
                do 
                    d=$(printf %03d $((i/$batch_size+1))); 
                    mkdir -p $batched_video_dataset$(basename -- ""${line//\'/}"")$d; 
                    mv "$f"  $batched_video_dataset$(basename -- ""${line//\'/}"")$d; 
                    let i++; 
                done
            done < "$log_directory"chunked.txt

            ls $batched_video_dataset |sort -R |tail -$batched_video_dataset_count |while read batched_video_file; do
                if [[ $batched_video_file ]]; then
                    echo "'$batched_video_dataset$batched_video_file'" >> "$log_directory"batched.txt
                fi
            done

            #batched data validation
            bash "$(pwd)"/valid.sh $DB $batch_size $foundry_identifier
        fi
    fi
}

#start batching process
startup
