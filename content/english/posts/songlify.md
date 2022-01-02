---
title: "Building a Telegram bot in Rust: a journey"
description: An adventure through Rust and Telegram
tags:
- blog
- tech
- rust
- telegram
date: 2022-01-02T15:32:00+02:00
---

Some time passed since the last article I wrote there. A lot of stuff happened
meanwhile, especially with COVID, but here we are again. While busy dealing with
the mess of real life tasks, three months ago I started to write a little bot
for Telegram in Rust. It is a simple one, but I consider the journey interesting
and worth of writing it down.

## Telegram bots

Telegram bots are not something new to me and nowdays are pretty much easy to
make, so I consider them like a gym where to try out new technologies and
experiment with stuff. I wrote plentiful of them, some of those are open source
like for example https://github.com/Augugrumi/TorreArchimedeBot (I checked it
out and now it is broken 😭) that was useful when going to University, because
it scraped the university free room web page and from there it was able to tell
you which rooms where without any lessons and for how much time, allowing you to
easily find a place where to study with your mates (yep, we didn't like library
too much).

{{< figure src="/content/songlify/telegramscreen.png" alt=`A screenshot of
TorreArchimedeBot in action.` caption=`A screenshot of TorreArchimedeBot in
action.` >}}

Also another one bot worthy of mention is
https://github.com/Polpetta/RedditToTelegram, that allowed our D&D group to
receive push notifications of our private Subreddit in our Telegram group.

As you can see, all of these bots are quite simple, but they have the added
value of teaching you some new programming concepts, technologies or frameworks
that can be later applied in something that can be more production environment.

## Rust

I started to approach Rust many years ago (I don't remember exactly when). First
interaction with it was quite interesting to say at least: there were way less
compiler features (for example now the compiler is able to understand object
lifetime at compile time most of the time alone, without specifying them) that
made it a... _not-so-pleasant programming experience_. It had potential thought,
so by following Rust news I picked it up last year again, noticing that now it
has improved a lot and it is more pleasant to write. Meanwhile, also JetBrains
developed a good support for IntelliJ, so now it is even possible to debug and
perform every operation directly from your IDE UI.

## World collision: Rust + Telegram

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

So, after choosing what was going to use to build the bot, I needed a _reason_ to build it. 
