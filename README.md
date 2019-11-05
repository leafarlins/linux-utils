# linux-utils
Usefull stuff for post-install linux.

## Usefull scripts

There are some scripts in this project.

### expandsrt

This is a simple tool to expand the length of a subtitle. Just inform the number in seconds you would like to expand. Each subtitle line will be expanded with x seconds, or until reach the next line.

    expandsrt subt.srt 2

The command above will expand in 2 seconds and create a modified srt file `subt.srt.2`.

### flacconvert

This script will convert all .flac files from the current directory to mp3 files. Just run `flacconvert`.

### funcoeszz

A set of useful functions from https://funcoeszz.net/ website. They all start with 'zz'.

## Tips

Command line tips.

### Video

* Matroska videos: to convert to same codec
`ffmpeg -i video.mkv -vcodec copy -acodec copy video2.mp4`

* To split a video
`ffmpeg -i Joy.mkv -vcodec copy -acodec copy -ss 01:05:00 -t 01:30:00 Joy-final.mkv`

* Convert avi using mp3codec
 `ffmpeg -i "input.mkv" -f avi -c:v mpeg4 -b:v 4000k -c:a libmp3lame -b:a 320k "converted.avi"`

### Image

* With the `convert` command, we can easely resize images.

    convert myfigure.png -resize 200x100 myfigure.jpg
    convert -resize 50% myfigure.png myfigure2.jpg
    for img in \*.jpg; do convert -resize 50% $img 50_$img; done

* Creating image
`convert -size 1200x600 xc:white -font "FreeMono" -pointsize 12 -fill black -draw @image imagem.png`

### Foremost

* Using foremost tool to recover jpegs
`sudo foremost -t jpg -i /dev/sdb1 -o /Backup/notebook`

## Problems

List of known problems.

#### Docker error in fedora 31

1. open `/etc/default/grub` as admin

2. Append value of GRUB_CMDLINE_LINUX with `systemd.unified_cgroup_hierarchy=0`

3. `sudo grub2-mkconfig > /boot/grub2/grub.cfg`

4. reboot
