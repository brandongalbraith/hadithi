```
1.0 studio.sh sets up directories and sub-directories.Automates data colection.
```
```
2.0 folder.sh script is designed to organize each video files
from source directory into individual folders then moving them to folder directory.
```
```
3.0 name.sh script is designed to process video files from folder directory, rename
them to replace certain characters with underscores, and then copy them to name directory
with a new timestamp-based name.
```
```
4.0 segment.sh script is designed to process video files in the name directory, create segments using ffmpeg and store them in the clip directory.The script also handles empty directories and logs relevant paths.
```
```
5.0 motion.sh script processes video files in clip directory, applies a scene detection filter using ffmpeg and then moves the resulting files to motion directory for further processing.
```
```
6.0 noaudio.sh script processes video files in motion directory by removing their audio tracks and saving the results in noaudio directory.
```
```
7.0 time.sh script is designed to process video files in noaudio directory by filtering out those that are shorter than N seconds and then copying the remaining files to time directory.
```
```
8.0 resolution.sh script is designed to process (rescale/change)  video files width and height usually smaller than original video file from time directory.It uses ffmpeg to generate image frames from each video.These frames are saved in the scale directory.
```
```
9.0 batch.sh script is designed to organize video files from scale directory into N batches, store them in batch directory, structure them,and then log the paths of the processed files.
```
```
10.0 valid.sh script is designed to process batch directories containing images, validate that each directory has exactly N images,and then copy those validated directories to the valid directory.
```
```
11.0 fps.sh script is designed to concanate image files from valid directory into videos at specific frame rate then moving them into to fps directory.
```
