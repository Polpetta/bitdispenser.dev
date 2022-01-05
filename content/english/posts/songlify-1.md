---
title: "Building a Telegram bot in Rust: a journey through Songlify"
description: An adventure through Rust and Telegram
tags:
- blog
- tech
- rust
- telegram
- songlify
date: 2022-01-02T15:32:00+02:00
---

Some time passed since the last article I wrote there. A lot of stuff happened
meanwhile, especially with COVID, but here we are again. While busy dealing with
the mess of real life tasks, three months ago I started to write a little bot
for Telegram in Rust. It is a simple one, but I consider the journey interesting
and worth of writing it down. If I add new features worth mentioning I will
start a series about it, maybe.

## Telegram bots

Telegram bots are not something new to me and nowadays are pretty much easy to
make, so I consider them like a gym where to try out new technologies and
experiment with stuff. I wrote plentiful of them, some of those are open source
like for example <https://github.com/Augugrumi/TorreArchimedeBot> (which is
currently broken 😭) that was useful when going to University, because it
scraped the university free room web page and from there it was able to tell you
which rooms where without any lessons and for how much time, allowing you to
easily find a place where to study with your mates (yep, we didn't like library
too much).

{{< figure src="/content/songlify/telegramscreen.png" alt=`A screenshot of
TorreArchimedeBot in action.` caption=`A screenshot of TorreArchimedeBot in
action.` >}}

Also another one bot worthy of mention is
<https://github.com/Polpetta/RedditToTelegram>, that allowed our D&D group to
receive push notifications of our private Subreddit in our Telegram group.

As you can see, all of these bots are quite simple, but they have the added
value of teaching you some new programming concepts, technologies or frameworks
that can be later applied in something that can be more production environment.

## Rust

I started to approach Rust many years ago (I do not remember exactly when).
First interaction with it was quite interesting to say at least: there were way
less compiler features (for example now the compiler is able to understand
object lifetime at compile time most of the time alone, without specifying them)
that made it a... _not-so-pleasant programming experience_. It had potential
thought, so by following Rust news I picked it up last year again, noticing that
now it has improved a lot and it is more pleasant to write. Meanwhile, also
JetBrains developed a good support for IntelliJ, so now it is even possible to
debug and perform every operation directly from your IDE UI.

## Making the two worlds collide: Rust + Telegram

One of the features I wanted to learn this time regarding Rust was the
asynchronous support it offers. Rust started to have `async` support with
[Tokio](https://tokio.rs/) framework, and recently the Rust team started to
build the asynchronous functionality inside Rust itself. Even if in the first
steps, it looks promising and the idea of a low-level language, without GC, with
automatic memory management and so much safety having asynchronous support is
exciting to me! 🥳 So the only option left, at this point, was to start messing
around with it. I started by picking up one of the many frameworks that provides
a layer for the Telegram APIs, [Teloxide](https://github.com/teloxide/teloxide).
In particular, as you can see from its _README_, one of the examples starts by
using `#[tokio:main]` macro:

```rust
use teloxide::prelude::*;

#[tokio::main]
async fn main() {
    teloxide::enable_logging!();
    log::info!("Starting dices_bot...");

    let bot = Bot::from_env().auto_send();

    teloxide::repl(bot, |message| async move {
        message.answer_dice().await?;
        respond(())
    })
    .await;
}
```

This was the reason I picked it up, given that it looked the most promising by
the time I started the project.

### Building _Songlify_

So, after choosing what was going to use to build the bot, I needed a _reason_
to build it.

With my friends we usually share a lot of songs (via Spotify links), so I
thought it was a good idea to build a bot around it. I integrated a Spotify API
library in it and started hacking up a bot.

> ⚠ Note that at the time of writing I have just noticed that the library I use
> for speaking with Spotify, [aspotify](https://crates.io/crates/aspotify) has
> been deprecated in favour of [rspotify](https://crates.io/crates/rspotify)

The first bot version was something very simple, and it was a single-file
program with nothing very fancy (I have written it in a night):

```rust
use crate::SpotifyURL::Track;
use aspotify::{Client, ClientCredentials};
use teloxide::prelude::*;

enum SpotifyURL {
    Track(String),
}

fn get_spotify_entry(url: &str) -> Option<SpotifyURL> {
    if url.contains("https://open.spotify.com/track/") {
        let track_id = url.rsplit('/').next().and_then(|x| x.split('?').next());
        return match track_id {
            Some(id) => Some(SpotifyURL::Track(id.to_string())),
            None => None,
        };
    }
    return None;
}

struct TrackInfo {
    name: String,
    artist: Vec<String>,
}

async fn get_spotify_track(spotify: Box<Client>, id: &String) -> Option<TrackInfo> {
    match spotify.tracks().get_track(id.as_str(), None).await {
        Ok(track) => Some(TrackInfo {
            name: track.data.name,
            artist: track.data.artists.iter().map(|x| x.name.clone()).collect(),
        }),
        Err(_e) => None,
    }
}

#[tokio::main]
async fn main() {
    teloxide::enable_logging!();
    log::info!("Starting Songlify...");

    let bot = Bot::from_env().auto_send();
    teloxide::repl(bot, |message| async move {
        let spotify_creds =
            ClientCredentials::from_env().expect("CLIENT_ID and CLIENT_SECRET not found.");
        let spotify_client = Box::new(Client::new(spotify_creds));

        log::info!("Connected to Spotify");
        let text = message.update.text().and_then(get_spotify_entry);
        match text {
            Some(spotify) => match spotify {
                Track(id) => {
                    let track_info = get_spotify_track(spotify_client, &id).await;
                    match track_info {
                        Some(info) => {
                            let reply = format!(
                                "Track information:\n\
                                Track name: {}\n\
                                Artists: {}",
                                info.name,
                                info.artist.join(", ")
                            );
                            Some(message.reply_to(reply).await?)
                        }
                        None => None,
                    }
                }
            },
            None => None,
        };
        respond(())
    })
    .await;

    log::info!("Exiting...");
}
```

As you can see, basically every time a request arrived to the bot, login to
Spotify was performed and track information and name retrieved from there. Of
course this was only the beginning (also you can "appreciate" the number of
nested blocks there...). Now the bot supports albums and playlists too, with the
possibility to go through each song in the playlist and collect general
information such as how many artists are in that playlist, how many songs and
other little information like that. If you see the [bot
repository](https://git.poldebra.me/polpetta/Songlify) you can see now that
Spotify functions live in a separate module.

#### Packaging and distribution

The obvious choice for a software like that was to incorporate it into a OCI
image. I wrote a very simple Dockerfile that, once the program was built, took
the artifact and using the [multi-stage Docker build
functionality](https://docs.docker.com/develop/develop-images/multistage-build/)
and put it into a separate container, in order to avoid having build
dependencies inside the final image. I used the images distributed by the
[Distroless project](gcr.io/distroless/) (you can find the source on their
[Github repository](https://github.com/GoogleContainerTools/distroless)) in
order to obtain the smallest possible image. The final result?

```txt
λ ~/Desktop/git/songlify/ docker images
REPOSITORY               TAG                    IMAGE ID       CREATED          SIZE
test/test                latest                 8ac7a7018719   5 seconds ago    34MB
<none>                   <none>                 4bc7fb0699e0   12 seconds ago   1.53GB
rust                     1.56.1-slim-bullseye   d3e070c5ffa7   6 weeks ago      667MB
gcr.io/distroless/base   latest-amd64           24787c1cd2e4   52 years ago     20.2MB
```

A part from the 52 years old image pulled from `gcr`, you can see that
`test/test` (actually Songlify) is only of **34MB**. Not much if you consider
that inside that image there are shared dynamic libraries to make the executable
able to run, which by default weights 20MB. A plus of these images is that they
do not run as root user and they do not have any shell of bash integrated,
making a possible surface attack smaller (not that Docker is secure anyway...).
I upload the images on Docker Hub, where you can find them here
<https://hub.docker.com/r/polpetta/songlify>

Finally, to run the bot I use a very simple docker-compose definition, that can
be found in my [server-dotfiles
repository](https://git.poldebra.me/polpetta/server-dotfiles/src/commit/7e7e1780b2db45f475510c49bf1a2f9e76c4c166/songlify/docker-compose.yml).
This allows me to easily upgrade the bot by just changing the version and
running `docker-compose up -d`.

#### Plans for the future

Currently I work on the bot only when I feel like I wanna add something. An
interesting feature to add could be to insert a persistence layer (using a
database for instance) and add various stats (which is the most shared song? Who
_is that guy_ that shares the most songs in a group?). Persistence can be
achieved quite easily by using [Diesel](https://diesel.rs/), an ORM compatible
with various databases.

Another cool feature could be to add the _inline bot_ functionality, where you
can search for songs directly in Spotify. Since I currently have a domain
available for that I could set it up for receive web-hook notifications, instead
of performing polling like the bot is currently doing (one requisite for inline
bots is indeed to receive web-hooks). There are platforms like Heroku where you
could make the bot run, but currently I prefer to use my box since it gives me
more flexibility. Experimenting with Heroku could lead to cool results though
😏.

Finally, link translation could be something very useful. I have a friend that
does not use Spotify but prefers to listen to music via YouTube. So an
interesting feature would be, given a Spotify link, to "convert" it into a
YouTube link and, of course, _vice-versa_. This could lead to translate
playlists and albums too into YouTube-based playlists, which of course could be
very useful if you are trying to avoid the infamous _vendor lock-in_, in this
case being stuck with Spotify because all you music collection, saved songs, etc
is there.
