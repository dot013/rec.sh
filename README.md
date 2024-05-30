# rec.sh

A small bash script using [`wf-recorder`](https://github.com/ammen99/wf-recorder) or
[`wl-screenrec`](https://github.com/russelltg/wl-screenrec) and [`ffmpeg`](https://ffmpeg.org)
to record GIFs of your screen.

<details>
    <summary><small><i>Why?</i></small></summary>
    <section>
        <h2 id="why">Why?</h2>
        <p>
            I wanted to stop needing to type something like <code>wf-recorder -g $(slurp) ./temp.mp4</code>
            and then going out to the internet to know what FFmpeg magic spell I needed to use to convert
            the file to a usable GIF. And using OBS Studio is just overkill.
        </p>
        <p>
            "But why create a package/repository instead of a simple script/alias?"
            Mostly because I wanted to learn how to package and create a NixOS and Home Manager
            module/flake. So why not over-engineer this simple bash script y'know? Yes, I wasted
            an evening doing this, but at least now I know how to create these modules and can
            package future projects and tools that I make.
        </p>
    </section>
    <section>
        <h2 id="should-i-use-it">Should I use this?</h2>
        <p>
            Probably not. This is something that you can create yourself easily, and probably should,
            maybe you learn something new in the process idk. Also, adding this to your config is another
            dependency to manage and trust. But if you want to use, probably just copy and paste
            <a href="./rec.sh">the script</a>, place somewhere on your system, and create an alias to use it.
            The code is licensed is public domain under the <a href="./LICENSE">WTFPL license</a> anyway. And
            the dependencies are under the <a href="#dependencies">dependencies section</a>.
        </p>
    </section>
    <section>
        <h2 id="how-to-use">How to use</h2>
        <p>
            First, did you read <a href="#should-i-use-it">the "Should I use this?" section</a>?
            Second, again, just copy and paste it, this <code>README.md</code> has literally more
            lines and bytes than the script itself. Third, if you really want it, here's the process
            to use it on NixOS:
        </p>
        <p>TODO</p>
    </section>
</details>

---

2024 &copy; Gustavo "Guz" L. de Mello <[contact.guz013@gmail.com](mailto:contact.guz013@gmail.com)>
Licensed under [WTFPL license](./LICENSE).

PROVIDED "AS IS" WITHOUT ANY WARRANTY OF ANY KIND.
