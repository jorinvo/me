---
date: 2016-02-04T18:18:33+07:00
summary: |
  I'm excited about the future of HTTPS.
  And I did an experiment where I only used HTTPS for one month.
  In this post I share the results of this experiment.
title: Only HTTPS For One Month
---

I was really excited when [Let's Encrypt][letsencrypt] became available to the public.

In fact I was so excited, I moved my blog from Github Pages to my own server just to enable HTTPS.

If you would like to know more about why you should choose your own HTTPS and not rely on a third-party like CloudFlare,
I can recommend [this excellent article from Anselm][whyownhttps].

Because the future of HTTPS, was looking so bright, I decided to start an experiment:

__For the next month I would only access websites via HTTPS.__

Thanks to the [HTTPS Everywhere][everywhere] browser extension this was pretty easy.
<br>
The extension contains an option to _"Block all HTTP requests"_.

![screenshot of the "Block all HTTP requests" feature](/images/https-everywhere.png)

Whenever I encountered a blocked website, I first tried to manually change `http` to `https` in the address bar.
Most of the time this didn't help and I would go on and search for another site to find the information I was searching for.

In some rare cases when I really needed to see some content, I opened it in an incognito window.

I didn't include mobile in the experiment. But I don't use my phone much to browse websites.


### The Result

After continuing this experiment for all of January,
I would like to share the results.

_Note:_ __My intention is not to blame any company.__

Instead, I would love to find out the reasons companies have to not support HTTPS.

<br>

I'm not really surprised, most smaller websites and blogs don't support HTTPS. But it's nice to see, some people took the time to configure HTTPS for their personal website.

What is surprising to me, however, is how many popular websites are not accessible via HTTPS:

- I wasn't able to access some rather big newspapers:
<br>
https://nytimes.com,
https://theguardian.com,
https://qz.com,
https://forbes.com (Redirects to a different site),
https://discovermagazine.com

- Even some technology-focused newspapers only offer their website via HTTP:
<br>
https://theverge.com,
https://gizmodo.com,
https://wired.com,
https://mashable.com,
https://arstechnica.com,
https://pcworld.com

- It's the same for a few websites where developers publish content for other developers:
<br>
https://tutsplus.com,
https://w3schools.com <3,
https://sitepoint.com

- Also some other popular entertainment websites didn't work:
<br>
https://9gag.com,
https://buzzfeed.com

- But it's not just content I couldn't reach via HTTPS. Also popular applications didn't work:
<br>
https://meetup.com,
https://skyscanner.com,
https://codepen.io

- Many popular software projects have the same problem:
<br>
https://expressjs.com,
https://rubyonrails.org,
https://redis.io,
https://scala-lang.org,
https://postgresql.org

- And finally, not even my own projects running on `localhost` have HTTPS set up.


The main thing I take away from this experiment is, that we still have a long way to go to leave insecure connections behind us.

I look forward to seeing the situation improve in the coming years
and I'm interested to hear about the experiences others have with HTTPS!


[letsencrypt]: https://letsencrypt.org/
[everywhere]: https://www.eff.org/https-everywhere
[whyownhttps]: https://helloanselm.com/2016/choose-your-own-https/

