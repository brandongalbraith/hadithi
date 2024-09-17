# Video Processing Workflow

This workflow outlines the sequence of steps to process videos using various scripts and directories.

## 1. Data Collection & Setup
- **Script:** `studio.sh`
- **Input Directory:** N/A
- **Output Directory:** Structure setup for video processing directories

## 2. Organizing Video Files
- **Script:** `folder.sh`
- **Input Directory:** `source/`
- **Output Directory:** `folder/`
  - Each video file is moved into an individual folder.

## 3. Renaming Video Files
- **Script:** `name.sh`
- **Input Directory:** `folder/`
- **Output Directory:** `name/`
  - Video files are renamed with a timestamp-based convention and certain characters replaced with underscores.

## 4. Segmenting Videos
- **Script:** `segment.sh`
- **Input Directory:** `name/`
- **Output Directory:** `clip/`
  - Video files are segmented using `ffmpeg`, and empty directories are handled.

## 5. Scene Detection
- **Script:** `motion.sh`
- **Input Directory:** `clip/`
- **Output Directory:** `motion/`
  - Scene detection is applied to the videos using `ffmpeg`.

## 6. Removing Audio
- **Script:** `noaudio.sh`
- **Input Directory:** `motion/`
- **Output Directory:** `noaudio/`
  - Audio tracks are removed from the videos.

## 7. Filtering Videos by Duration
- **Script:** `time.sh`
- **Input Directory:** `noaudio/`
- **Output Directory:** `time/`
  - Videos shorter than N seconds are filtered out.

## 8. Rescaling & Extracting Frames
- **Script:** `resolution.sh`
- **Input Directory:** `time/`
- **Output Directory:** `scale/`
  - Video resolution is rescaled and image frames are extracted using `ffmpeg`.

## 9. Organizing Videos into Batches
- **Script:** `batch.sh`
- **Input Directory:** `scale/`
- **Output Directory:** `batch/`
  - Videos are organized into N batches and logged.

## 10. Validating Image Count
- **Script:** `valid.sh`
- **Input Directory:** `batch/`
- **Output Directory:** `valid/`
  - Ensures each directory has exactly N images.

## 11. Generating Videos from Images
- **Script:** `fps.sh`
- **Input Directory:** `valid/`
- **Output Directory:** `fps/`
  - Image frames are concatenated into videos at a specified frame rate.

---

## Directory Structure

```plaintext
├── source/
├── folder/
├── name/
├── clip/
├── motion/
├── noaudio/
├── time/
├── scale/
├── batch/
├── valid/
└── fps/
