                             ┌──────────────┐
                             │ studio.sh    │
                             │ Setup        │
                             │ Directories  │
                             └─────┬────────┘
                                   │
                                   ▼
                             ┌──────────────┐
                             │ folder.sh    │
                             │ Organize     │
                             │ Videos       │
            ┌────────────────┘ to folder/   └────────────────┐
            ▼                                                 ▼
   ┌──────────────────┐                                ┌───────────────┐
   │ name.sh          │                                │ segment.sh    │
   │ Rename           │                                │ Segment       │
   │ Videos to name/  │                                │ Videos to     │
   └──────────────────┘                                │ clip/         │
                                                        └───────────────┘
                                                              │
                                                              ▼
                                                       ┌───────────────┐
                                                       │ motion.sh     │
                                                       │ Scene Detect  │
                                                       │ Videos to     │
                                                       │ motion/       │
                                                       └──────┬────────┘
                                                              │
                                                              ▼
                                                       ┌───────────────┐
                                                       │ noaudio.sh    │
                                                       │ Remove Audio  │
                                                       │ Save to       │
                                                       │ noaudio/      │
                                                       └──────┬────────┘
                                                              │
                                                              ▼
                                                       ┌───────────────┐
                                                       │ time.sh       │
                                                       │ Filter Videos │
                                                       │ by Length     │
                                                       │ Save to time/ │
                                                       └──────┬────────┘
                                                              │
                                                              ▼
                                                       ┌───────────────┐
                                                       │ resolution.sh │
                                                       │ Rescale and   │
                                                       │ Extract Frames│
                                                       │ to scale/     │
                                                       └──────┬────────┘
                                                              │
                                                              ▼
                                                       ┌───────────────┐
                                                       │ batch.sh      │
                                                       │ Organize      │
                                                       │ into Batches  │
                                                       │ in batch/     │
                                                       └──────┬────────┘
                                                              │
                                                              ▼
                                                       ┌───────────────┐
                                                       │ valid.sh      │
                                                       │ Validate Image│
                                                       │ Count to      │
                                                       │ valid/        │
                                                       └──────┬────────┘
                                                              │
                                                              ▼
                                                       ┌───────────────┐
                                                       │ fps.sh        │
                                                       │ Generate Video│
                                                       │ from Frames   │
                                                       │ Save to fps/  │
                                                       └───────────────┘
