+++
tags = [
  "blog",
  "project",
]
title = "Using ffmpeg to generate a lifting compilation video"
description = "ffmpeg"
date = "2025-04-06"
+++

I have a friend who is my (power)lifting coach. Coaches and trainers are very useful for exercise selection, bouncing new ideas off of and to help guide you along. Improving one's lifting numbers is non-linear and I love having someone I can always discuss approaches with. Results boil down to the usual suspects (eg. consistency, intensity, recovery, etc.) but i've found it very beneficial.

We use a spreadsheet to communicate exercises, and numbers for the each training week. At the end of each week, I send an email with all of my lifts, notes and videos of specific lifts. The videos reside on Google Photos and I generate a shareable link, embed it in the email and share it with him. This has worked fine, but didn't feel _great_. Why not make a single video containing all weekly lifts instead of having him click on links to short clips? I did not want to do this with a video editor, and thus began my dive into `ffmpeg`.

### ffmpeg

FFMPEG is a CLI tool for manipulating audio and video files. It feels like a swiss-army knife. Good at the core use-cases and many others you aren't even aware of. I knew of it because I know VLC used it, or its internal libraries for most of its functionality.

All I needed `ffmpeg` for was to:
- Take in a list of filepaths containing lifting videos. Each filepath would be named something like `B13WXDY_BenchPress_225x10.mp4`. `B13WXDY` translates to Block 13, Week X and Day Y which is the structure of my training programs. I'd pass this via `stdin`
- Add a text overlay containing the filepath stem (basename without the file extension) at the bottom of each file. For the previous file, `B13WXDY_BenchPress_225x10` should be in text at the bottom.
- Concatenate all of the new video files containing text overlays into 1 video
- Wrap in a bash script.

Like any good programmer in 2025, I had an LLM do the first pass. I used Anthropic Claude 3.7 Sonnet to get started.


### ffmpeg primer
Adding text to a video using ffmpeg was very easy. The first key call to ffmpeg added the overlay and did a few other transformations to speed up the process.

```bash
ffmpeg -nostdin -i "$filename" \
    -vf "drawtext=text='$file_stem':\
fontcolor=white:\
fontsize=72:\
box=1:\
boxcolor=black@0.5:\
boxborderw=5:\
x=(w-text_w)/2:\
y=h-th-10,\
scale=iw/3:-2" \
	-c:v libx265 \
	-crf 30 \
	-preset veryfast \
	-c:a copy \
	"$output_temp" > /dev/null 2> /dev/null
```

The number of options may look like a lot but it isn't.
- `-i` : specify a filename
- `drawtext=text='$name_no_ext'`:    # Adds text overlay using the filename
- `fontcolor=white`:    Sets text color to white
- `fontsize=72`:  Sets font size to 72 pixels
- `box=1`:   Enables a background box behind the text
- `boxcolor=black@0.5`:   Sets box color to semi-transparent black
- `boxborderw=5`:  Sets box border width to 5 pixels
- `x=(w-text_w)/2`:    Centers text horizontally (w=video width, text_w=text width)
- `y=h-th-10`:  Positions text near bottom (h=video height, th=text height)
- `scale=iw/3:-2`  Scales video width to 1/3 original size, height auto-scaled to maintain aspect ratio

For the text positioning, the upper left hand corner of a video frame is (0,0) with the x axis increasing as usual, and y axis increasing downward. That is why the y coordinate is so large despite it being at the bottom. The positioning syntax gives you access to the video width `w`, height `h`, the text width `text_w` and text height `th`. This is cool and lets you customize the positioning easily.

- The `-c:v libx265` specify the encoding of the videos. My Pixel generates videos in the H265 format vs. H264 so I set it explicitly.
- The `-crf 30` is the `Constant Rate Factor`. Higher yields lower quality videos but makes transcoding faster.
- The `-preset` is another option that helps you set the encoding speed + compression. Faster makes transcoding faster at the cost of compression.  These videos don't have to be 4K so setting this to `veryfast` was fine. I spot checked the video quality after and it was perfect.
- The `-c:a copy` copies the audio

The second `ffmpeg` command was to concatenate videos. It was relatively simple compared to the above.

```bash
ffmpeg -f concat -safe 0 -i "file_list.txt" -c:v libx265 -crf 23 -preset medium -c:a copy "../output_concatenated.mp4"
```


### No-free lunch

Despite the script looking good, it was failing to do what I wanted. It was not processing all of the files I passed to it. It looked like it kept skipping some of them.

```bash
# files to process
dang3r@wintermute:~/dev/forge/workout-videos-create$ find B13W1/ -type f | sort
B13W1/B13W1D1_InclineDBPress_75x8.mp4
B13W1/B13W1D1_PausedBenchPress_245x6.mp4
B13W1/B13W1D2_Pullups_15x7.mp4
B13W1/B13W1D3_GobletSquat_70x10.mp4
B13W1/B13W1D3_RomanianDeadlift_215x7.mp4
B13W1/B13W1D4_InclineSmith_225x6.mp4

# It only processed two?
dang3r@wintermute:~/dev/forge/workout-videos-create$ find B13W1/ -type f | sort | ./create_compilation.sh
Processing: 'B13W1/B13W1D1_InclineDBPress_75x8.mp4'
Processing: '3W1/B13W1D3_GobletSquat_70x10.mp4'
```

After adding the ffmpeg logging back, I got a clue.

```bash
dang3r@wintermute:~/dev/forge/workout-videos-create$ find B13W1/ -type f | sort | ./create_compilation.sh
...
...
1/B13W1D3_GobletSquat_70x10.mp4: No such file or directory
```

I then tried only processing D1 videos.

```bash
dang3r@wintermute:~/dev/forge/workout-videos-create$ find B13W1/ -type f | grep D1 | sort
B13W1/B13W1D1_InclineDBPress_75x8.mp4
B13W1/B13W1D1_PausedBenchPress_245x6.mp4

dang3r@wintermute:~/dev/forge/workout-videos-create$ find B13W1/ -type f | grep D1 | sort | ./create_compilation.sh
...
Done! Final video saved as output_concatenated.mp4

# only shows the incline db press video!
dang3r@wintermute:~/dev/forge/workout-videos-create$ open output_concatenated.mp4 
```

 After some frustration, Claude came back with the answer. 

By default, `ffmpeg` reads bytes from `stdin`. Even when I pass it the filepath via `-i`. The filepaths were being passed as `stdin` to the parent script and consumed by the file-loop. And then, `ffmpeg` would also reads bytes from stdin, causing the outer loop to fail. Something like:

- Parent script reads in the first line `B13W1/B13W1D1_InclineDBPress_75x8.mp4`
- `ffmpeg` consumes some of stdin
- The next filepath read by the parent script is not the next filepath, but a broken path. Broken filepaths are skipped by `ffmpeg`

The solution? Add `-nostdin` to the inner `ffmpeg`calls.  This prevents the stdin over-reading and everything generated correctly!

### final-thoughts

I was able to generate the compilation video just fine. It is [here](https://www.youtube.com/watch?v=JgX48OQrOu8). For the code, see [github](https://github.com/dang3r/forge/tree/master/workout-videos-create).

Despite the single issue, I love how easy it is to use `ffmpeg`. Google photos does now have the ability to edit photos and aggregate clips (I suspect you can add text on top too). However, I like this CLI-based approach I can use again with no effort.



