# Dan's macOS dotfiles with Nix

In January 2025, with the maturity of flakes, I was seeing quite a few examples simpler than what I
was running, so I started over from scratch. This is the result.

The overall philosophy is to use nix-darwin when possible, then home-manager, then homebrew only as
absolutely needed. Although I do put some things in home-manager that might be do-able in nix-darwin
and/or packages but the home-manager options are just easier.

A few programs I find easier to manage outside of Nix, notably Alfred, helix, kitty, and Zed. For
these I use the traditional config file formats here and link them from `~/.config/` or similar.
