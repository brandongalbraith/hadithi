#!/bin/bash

#############################################################################
#fps.sh script is designed to concanate image files from scale directory into 
#        videos at specific frame rate then moving them into to fps directory
#############################################################################

DB=$1
foundry_identifier=$2

script_directory="$(dirname "$(pwd)")"
foundry_directory=$script_directory/foundry
log_directory="$foundry_directory/$foundry_identifier/log/"
valid_batched_video_dataset="$foundry_directory/$foundry_identifier/valid/$DB/"
training_batched_video_dataset="$foundry_directory/$foundry_identifier/fps/$DB/" 

if [[ ! -d "${log_directory}" ]]; then
    echo "creating" $log_directory "directory" 1>&2
    mkdir -p $log_directory
fi

if [[ ! -d "${valid_batched_video_dataset}" ]]; then
    echo "creating" $valid_batched_video_dataset "directory" 1>&2
    mkdir -p $valid_batched_video_dataset
fi

if [[ ! -d "${training_batched_video_dataset}" ]]; then
    echo "creating" $training_batched_video_dataset "directory" 1>&2
    mkdir -p $training_batched_video_dataset
fi

#start process
function startup(){

    #regex to get video duration
    LEN_REGEX="Duration: ([0-9]*):([0-9]*):([0-9]*)\.([0-9]*), start"
    valid_batched_video_dataset_count="$(find ${valid_batched_video_dataset} -maxdepth 1 -type d ! -name "*.sh*" | wc -l)"

    if [[ $valid_batched_video_dataset_count -eq 0 ]];then
        echo "no data found in "$valid_batched_video_dataset" directory"1>&2
    else
        if [[ $valid_batched_video_dataset_count -gt 0 ]];then
            
            rm -rf "$log_directory"val.txt
            rm -rf "$log_directory"test.txt
            rm -rf "$log_directory"train.txt

            ls $valid_batched_video_dataset |sort -R |tail -$valid_batched_video_dataset_count |while read video_file; do
                if [[ $video_file ]]; then
                    mkdir $training_batched_video_dataset$(basename -- ""$valid_batched_video_dataset$video_file"")
                    echo "'$valid_batched_video_dataset$video_file'" >> "$log_directory"train.txt
                fi
            done

            while IFS= read -r line; do
                training_data_path="${line//\'/}"
                video_data="$(find "$training_data_path" -maxdepth 1 -type f  -name "*.png*")"
                if [[ $video_data ]]; then
                    echo "'$video_data'" >> "$log_directory"val.txt
                fi  
            done < "$log_directory"train.txt

            while IFS= read -r line; do
                training_data_path="${line//\'/}"
                data_dir=$(basename -- ""$training_data_path"")"/"xyz
                mkdir $training_batched_video_dataset$data_dir
                echo "'$data_dir'" >> "$log_directory"test.txt
            done < "$log_directory"train.txt

            while IFS= read -r line; do
                val_data_path="${line//\'/}"
                echo $val_data_path --------------- $(basename -- ""$val_data_path"") -- $(basename -- ""${val_data_path%$(basename -- ""$val_data_path"")}"")
                cp -r $val_data_path  $training_batched_video_dataset$(basename -- ""${val_data_path%$(basename -- ""$val_data_path"")}"")'/xyz/' 
            done < "$log_directory"val.txt
           
            while IFS= read -r line; do
                data=$training_batched_video_dataset$(basename -- ""${line//\'/}"")'/xyz/'
                echo $data
                a=1
                for i in $data*.png; do
                    new=$(printf "0%05d.png" "$a")
                    echo $i ---$a $new
                    mv -i -- "$i" $data"$new"
                    let a=a+1
                done
            done < "$log_directory"train.txt

            echo "TRAINING DATA FOR PROJECT" $DB "------> DONE"
            
        fi
    fi
}

#start unsupervised  learning process
startup
