bitdispenser.dev
===

[![Build Status](https://ci.poldebra.me/api/badges/polpetta/bitdispenser.dev/status.svg)](https://ci.poldebra.me/polpetta/bitdispenser.dev)

This is my personal website where I like to keep my thoughts mostly about
technology & software. The site is statically generated thanks to
[Hugo](https://gohugo.io/), and it huses the [Hermit
theme](https://github.com/Track3/hermit). Posts are written in Markdown and then
checked with Aspell.

Note: for all the people reading this on Github, the repository is Just a
mirror. If you want to clone from the real source, you need to head to my
personal [Gitea instance](https://git.poldebra.me). You can clone the repository
with:
```sh
git clone https://git.poldebra.me/polpetta/bitdispenser.dev.git
```

## Building the website

You can have a live preview of the website locally using the following command:
```sh
hugo serve
```

Note that this repository uses Git LFS, so you need to enable it and pull binary
objects first before building the site, otherwise you will likely have missing
images & assets. If you don't have git LFS, type:
```sh
git lfs install
git lfs pull
```

## Lint & spellchecker checks

Lint & spellchecker are respectively done with a npm package and a bash script.
For running them you need node installed.

For lint checking:
```sh
npm install
npm run lint
```

For spell check:
```sh
npm run spellchecker
```
or
```sh
./tools/spellchecker.sh en
```

## License

Images and all the other content taken on internet are of their rispective
owners. All the other content is to consider under CC-BY-SA 4.0. Code snippets
otherwise specified are to be considered under MIT license.
