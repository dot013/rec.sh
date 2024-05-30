# rec.sh

A small bash script using [`wf-recorder`](https://github.com/ammen99/wf-recorder) or
[`wl-screenrec`](https://github.com/russelltg/wl-screenrec) and [`ffmpeg`](https://ffmpeg.org)
to record GIFs of your screen.

---

## Why?

I wanted to stop needing to type something like `wf-recorder -g $(slurp) ./temp.mp4`
and then going out to the internet to know what FFmpeg magic spell I needed to use to convert
the file to a usable GIF. And using OBS Studio is just overkill.

"But why create a package/repository instead of a simple script/alias?"
Mostly because I wanted to learn how to package and create a NixOS and Home Manager
module/flake. So why not over-engineer this simple bash script y'know? Yes, I wasted
an evening doing this, but at least now I know how to create these modules and can
package future projects and tools that I make.

## Should I use this?

Probably not. This is something that you can create yourself easily, and probably should,
maybe you learn something new in the process idk. Also, adding this to your config is another
dependency to manage and trust. But if you want to use, probably just copy and paste
[the script](./rec.sh), place somewhere on your system, and create an alias to use it.
The code is licensed is public domain under the [WTFPL license](./LICENSE) anyway. And
the dependencies are under the [dependencies section](#dependencies).

## How to use

First, did you read [the "Should I use this?" section](#should-i-use-this)?
Second, again, just copy and paste it, this <code>README.md</code> has literally more
lines and bytes than the script itself. Third, if you really want it, here's the process
to use it on NixOS:

TODO

---

2024 &copy; Gustavo "Guz" L. de Mello <[contact.guz013@gmail.com](mailto:contact.guz013@gmail.com)>
Licensed under [WTFPL license](./LICENSE).

PROVIDED "AS IS" WITHOUT ANY WARRANTY OF ANY KIND.
