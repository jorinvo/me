---
title: "Getting started building a data-driven business"
date: 2023-10-06T17:40:19+07:00
---

Making effective use of data is non-trivial. Let me share what worked for us.
<!--more-->

You know you should work more data-driven. You hear it everywhere. A manager or an investor probably urged you to do so at some point or another.

But turning this wish into reality is hard. Hiring data analysts and data engineers is expensive. Buying a ready solution is overwhelming. There are so many products, they all use the same confusing buzzwords.
<br>
You might have a setup for data analytics already, but getting people to actually use it is another story.

I spent the last 5 years as one of the early engineers at a startup figuring out through trial and error how to enable the rest of the company to use data effectively. Let me share what I would do if I would start over:


## How to start

Each team has their own view of which data is relevant to them.

Start with the data teams already use through domain-specific tools such as Google Analytics, Hubspot, Segment or Mixpanel.

**Use the tools you already have as long as they get the job done.**

But sooner or later you will come across requests that require you to combine different data sources.
<br>
At this point it's easy to think that you need to setup your own data platform to continue.
You might end up researching data warehouses, stream processing, ETLs, business intelligence and many other new vocabulary. Not only can the data tooling landscape be overwhelming to understand, but even if you decide for a setup, it can be a challenge to integrate it into your workflows.

**Introduce new tools, but do so slowly.**

You can go further than you think with simple solutions such as Excel and a few custom scripts.

**More important than tooling is mindset: You need to understand what you want out of the data.**

Start with business intelligence dashboards to support decision makers. Then provide teams the data they need to perform their everyday operational work.


## Using business intelligence to support decision making

To make impactful decisions the company management and team leads need to know where they stand.

**It's not trivial to figure out what metrics to focus on and metrics are different for every role.**

It took us a long time of trying out different things until we knew which metrics are truly important and which ones not. It's not enough to talk once about the requirements, implement it and be done with it. This work might also require more complex queries that bring together different data sources.

**A technical person should pair with the individual decision makers to implement metrics.**

Decision makers mostly use these metrics in regular intervals. Instead of a live dashboard this can also be a PDF or an email.

**Figuring out what's truly important for the business is as essential as the resulting metrics.**

The whole point of these metrics is to support decision making by quantifying the important data points. The data doesn't have to be 100% accurate, but it has to point into a useful direction.
The most interesting insights for strategic decisions are anomalies.

**People want to find out something they don't already know.**

If you do this well data has the potential to point to unknown threads & new opportunities.


## Using data to optimise operational workflows

Apart from decision making, data is part of everyday work across the company: Think of support requests that need to trace a user across different data sources to answer a user's question.

Unlike decision making, this work doesn't require summaries across many data points, but it requires searching and filtering until you find specific data. Some of these workflows might be already built into your product's admin interface, but there are always things that are not possible yet.

**You want to give the whole company the option to access any data they might need.**

Supporting operational work is often a balance between building specialized tools and just giving the team all data so they can do whatever they want with it.
<br>
If you build a dashboard, users will ask for ever more options until no one knows anymore how to use the dashboard. Then users will ask to be able to just download all the data and analyze it manually in Excel. When users get tired of their manual workflow, they will ask you to automate it by turning it into a dashboard.

**Lean on the side of manual work as much as possible.**

Let users figure out what they really need. Excel and some small scripts allow for fast iteration.
<br>
Building a self-serve UI that covers all needs is a really complex task. Just think what it takes to build something like Google Analytics. They also offer courses and certificates to educate users on how to use it.


## In conclusion

You don't need a dedicated data team to start using data effectively. 

Be ready to spend some time figuring out what you actually want out of the data.

Have a technical person sit together with each decision maker in the company to create specialized dashboards to support their specific needs.

Provide manual access to data for operational workflows and only productise solutions once you know the requirements very well.

I will go into implementation and specific tools in a follow-up post.
