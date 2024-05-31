# rec.sh

A small bash script using [`wf-recorder`](https://github.com/ammen99/wf-recorder) or
[`wl-screenrec`](https://github.com/russelltg/wl-screenrec) and [`ffmpeg`](https://ffmpeg.org)
to record GIFs of your screen.

```
Usage: rec-sh [OPTIONS...] [FILE]
A simple bash script to record your screen

Use Ctrl+C to stop recording

With no FILE is provided, the output file will be ./rec.gif

Options:

  -r|--region [REGION] [REGION]
  Area that will be passed to wf-recorder -r [REGION] [REGION], if none is passed, the script
  will try to use slurp if it is installed.

  -c|--compress <true|false|1|0> DEFAULT=true
  Use FFmpeg to compress the output file.

  -y DEFAULT=true
  Overwrite output file it exists.

  -v|--verbose
  Increase the logging verbosity level.

  -h|--help
  Show this help screen.

Configs:

  RECSH_RECORDER=<path to recorder binary>
  Command/path to binary of the recorder to be used instead of wf-recorder or wl-screenrec
  in your PATH.

2024 (c) Gustavo "Guz" L. de Mello <contact.guz013@gmail.com>
Licensed under WTFPL license. PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
```

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
to use it on NixOS **using flakes**:

### Dependencies

- [`wf-recorder`](https://github.com/ammen99/wf-recorder),
  [`wl-screenrec`](https://github.com/russelltg/wl-screenrec), or another command
  which accepts `-g` to pass a area geometry and `-f` to define a video file output.
  You can set the custom command using the `RECSH_RECORDER` environment variable.

- [`ffmpeg`](https://ffmpeg.org) to convert the video file into a GIF or the passed
  file output type.

- **Optional:** [`slurp`](https://github.com/emersion/slurp), if `-r`or `--region`
  is passed without any values, the script tries to use `slurp` to select a area
  in the screen.

- **Wayland**, this script is made for wayland compositors, ~~I hope you already noticed
  that~~.

### Installation

#### Add the flake
```nix
# flake.nix
{
    inputs = {
        rec-sh.url = "git+https://codeberg.org/dot013/rec.sh"
        # Using the GitHub mirror:
        # rec-sh.url = "github:dot013/rec.sh"
    };
    outputs = { nixpkgs, ... }@inputs: {
        # ...
    };
}
```

#### Installation methods

##### Install as a NixOS module
```nix
# configuration.nix
{ inputs, ... }: {
    imports = [
        inputs.rec-sh.nixosModules.rec-sh
    ];

    programs.rec-sh.enable = true;
}
```

##### Install as a Home Manager module
```nix
# home.nix
{ inputs, ... }: {
    imports = [
        inputs.rec-sh.homeManagerModules.rec-sh
    ];

    programs.rec-sh.enable = true;
}
```

##### Install as a package
```nix
# configuration.nix
{ inputs, pkgs, ... }: {
    environment.systemPackages = [
        inputs.rec-sh.packages.${pkgs.system}.rec-sh
        # or inputs.rec-sh.legacyPackages.${pkgs.system}.rec-sh
    ];
}
```

```nix
# home.nix
{ inputs, pkgs, ... }: {
    home.packages = [
        inputs.rec-sh.packages.${pkgs.system}.rec-sh
        # or inputs.rec-sh.legacyPackages.${pkgs.system}.rec-sh
    ];
}
```

### Usage

```bash
$ rec-sh [OPTIONS...] [FILE]
```

By default the script will just run `wf-recorder` or `wl-screenrec` depending on
who is installed, and transform the resulting video into a GIF called `rec.gif`
in the current working directory.

All the available options are available using the `-h` or `--help` option and
documented [on the top of this file](#recsh).

---

2024 &copy; Gustavo "Guz" L. de Mello <[contact.guz013@gmail.com](mailto:contact.guz013@gmail.com)>
Licensed under [WTFPL license](./LICENSE).

PROVIDED "AS IS" WITHOUT ANY WARRANTY OF ANY KIND.
