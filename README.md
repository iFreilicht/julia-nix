**julia-nix** is a [Julia][julia] fork with patches to make building and
development work with [Nix and NixOS][nix]. Patches related to specific release
branches are kept in their respective branches with names mirroring the
[upstream Julia repository][upstream]; `master` tracks the ongoing development
upstream but with patches added to make hacking on Julia feasible from NixOS.

[julia]: https://julialang.org
[nix]: https://nixos.org
[upstream]: https://github.com/JuliaLang/julia

For example, this is how you build the latest `master`:

```sh
> git clone git@git.sr.ht:~ninjin/julia-nix
…
> cd julia-nix
> git pull --rebase git@github.com:JuliaLang/julia.git
…
> nix-shell --pure --run make
…
> ./julia --print VERSION
v"1.7.0-DEV.909"
```

From this point onward you can hack on Julia as usual, produce patches, and
submit them upstream. Alternatively, you can export and apply the patches from
this repository to your own Julia fork.

Beware that rebases and history edits are common as the goal of this repository
is not to track the development of the Nix-specific patches themselves, but
rather to keep the history minimally different relative to the upstream Julia
repository.

Lastly, if you want to talk about Nix/NixOS and Julia, feel free to join us in
the #nix channel over on the [official Julia Slack][slack].

[slack]: https://julialang.org/slack
