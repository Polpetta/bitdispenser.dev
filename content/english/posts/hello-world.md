---
title: Hello world!
description: The very first article of this blog
tags:
- blog
- tech
- hugo
date: 2021-05-18T22:22:00+02:00
---

If you are reading this it means either you are trying to understand who I am
(are you a recruiter by any chance?) or you are simply bored. In any way, this
is the very first blog post, and it means you have come to the end of the road
(since this is the beginning). I always loved to have a place where I can write
down my thoughts about a new technology, a framework or what I did in order to
achieve a goal in a hobby project. That is not all though: I was searching for a
place where I was also able to express my ideas regarding modern dilemmas like
privacy issues and decentralization. I am not the kind of guy who likes social
networks, so I never had the chance to express them. Until now.

## How this blog is built

### The website

This blog is a very simple [Hugo](https://gohugo.io/) website. If you do not
know what it is, its basically a static website generator. It takes Markdown
documents and converts them in HTML pages. If you applied a specific theme then
it builds the page according to that theme. Hugo has a huge selection of themes
in its [dedicated themes page](https://themes.gohugo.io/), so basically picking
up one and starting from there is very simple. If you are curious about how I
made it, you can check out the source at my [personal git server
instance](https://git.poldebra.me/polpetta/bitdispenser.dev), where I started
hosting my code when [Microsoft bought
Github](https://news.microsoft.com/announcement/microsoft-acquires-github/) (you
can find a copy of the repository on Github too, visiting [my
profile](https://github.com/Polpetta)). I have simply picked up the simpler and
cleanest blog theme out there, following Ludwig Mies van der Rohe's idea:

> less is more

It will be a success if more than two people actually starts reading what I
write here, at least I want them to read this blog without having their
eyes bleeding with an extravagant color combination.

Last but not least, the website icon is literally the Team Fortress 2 dispenser
(one of the games I love and one of the first game I started playing online as a
kid when a decent connection at home was finally available), taken from the RED
team and generated via a [favicon generator](https://realfavicongenerator.net/).
The name of the website partially came out from that, and from the fact that
basically every website is a dispenser of bits, and it is only thanks to our
beloved browsers we are able to actually "consume" what is distributed in the
first place.

{{< figure src="/content/hello-world/engiwithdispenser.png" alt=`Engineer with
his dispenser` caption=`Engineer class with a dispenser. Thanks to [Team
Fortress wiki](https://wiki.teamfortress.com) for providing the image I
shamelessly downloaded from them` >}}

I hope Valve will not sue me for taking that asset as my website favicon. I
swear I will change it, a day. Pinky promise.

### Hosting

The real problem of hosting a website now day is not how to build it (as you can
see) but _where_ you can host it. There are plenty of cloud provides: AWS,
Google Cloud, DigitalOcean, Scaleway, etc... every day there is a new one
popping up. They all offers the possibility to host your website pretty easily,
especially if the website is a static one like this (e.g. using a S3 bucket).
Since I like challenges and I also like to learn new stuff, I though that
hosting the website in this way was boring. At the same time, I wanted to have a
good uptime and to not meddle too much under the hood. My (dream) requirements
were:

* always up
* good response time
* possibility to host as much data as I want
* using a hosting free as in beer and (possibly) that could use free as in
  freedom technologies

Now, reading this I imagine you are thinking I am going crazy, and maybe I am, but
that is not the case. In fact, multiple weeks prior to writing this article,
while trying to kill the boredom caused by COVID-19 lockdown, I discovered
[IPFS](https://ipfs.io/). I already heard of it at University, but I never
bothered too much to understand what was about. I though "well, it surely is
some sort of filesystem". I was somewhat right, but not the way I thought.

IPFS acts like a peer-to-peer network, where nodes hash the content they want to
share to let other nodes grab it. You can grab this content using your local
node or using one of the many available gateways. Nodes can "pin" a file too, in
order to keep it locally and to serve it to other nodes. If a file gets pinned
by different nodes and gains traction it basically can not be deleted from the
web.

#### Choosing the right tools

Surely, as [the IPFS documentation
describes](https://docs.ipfs.io/how-to/websites-on-ipfs/multipage-website/), I
could have done it by myself. But there is a but. Holding all the infrastructure
manually means sacrifice the "always up" and "good response time" thingy for two
simple motives:

1. the [server where I host my drafts & codebase](https://git.poldebra.me) is
   hosted on a very small machine (2GB of RAM and 2vCPU), very easy to kill with
   the slightest of loads
2. in order to achieve a good response time, a CDN or some sort of caching is
   necessary (even if the application is stored in a distributed file system)

{{< figure src="/content/hello-world/fleek.png" caption=`Fleek website, that I
used to automate my deployment on IPFS and my DNS update` alt=`The fleek website
screenshot` class="right" >}}

Finally, in order to achieve full automation with DNS updates, I would have
needed to implement and use NameCheap APIs (currently it is the DNS provider I
use for most of my websites). "What's the difficulty?" one would ask. [Here is
the official documentation](https://www.namecheap.com/support/api/intro/), and
even if the APIs look promising, while studying them my will to live decreased a
little bit, and so I decided that if I wanted to get up and running with less
maintenance as possible, with a good uptime while having the maximum
automation possible I needed to rely on a dedicated service. Luckily
[fleek.co](https://fleek.co) was what I was searching for. They currently
provide the possibility to buy a domain from their website, giving them all the
hassle of updating the new website on IPFS, distributing it, refreshing a very
possible CDN and finally to update the DNS records accordingly. This, as you can
imagine, provides multiple benefits:

* I do not have to care about my very little dev machine getting hugged to death
  by request in the remote case any of my posts get any attention
* I do not have to focus on automating the process someone else has already done
  for me
* I can focus on writing posts after dinner instead of scratching my head trying
  to understand why the website does not load/the DNS is not properly updated
  
The only downside to this approach is that Fleek provides limitations on how
much data and bandwidth you can host. At the time of writing, you can only host
up to 3GB (enough for this website) and have a 50GB bandwidth (that is fine for
now) for the free version. [Upgrading you account](https://fleek.co/pricing/) to
one of the available plans give you extra space and bandwidth.

## Future improvements

For sure, this is only the beginning. Having an automatic workflow of spell
check, deployment and release would be the first milestone. Future features for
this website could be an automatic posting of every new article on a dedicated
Mastodon bot, so that people can possibly discuss about my thoughts on the
fediverse, a decentralized network.

To conclude, the frequency of this blog will be...whenever I have time to post
:grin: Of course I need content before posting something, and this require some
time for myself for experimenting with new technologies and learning new stuff,
so I do not expect very much posting, but only time will tell!
