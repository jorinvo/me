---
title: "The Cloud Is the New OS - A Developer's Perspective"
date: 2018-11-28T23:31:30+01:00
---

It already happened a few times in the history of computing that the level of abstraction the majority of us work on has been raised.<!--more-->

There are, and probably always will be, people that write and understand assembler. But most developers don't worry about the exact instruction they send to their CPU on a day to day basis. Most developers nowadays don't even worry about allocating memory manually. [Syscalls](https://en.wikipedia.org/wiki/System_call) to talk to our Operation System is the lowest level the majority of developers has in mind. Mostly it's not even syscalls but an API which the language runtime provides.

_I think we are close to a point where the general level of abstraction of computing will be raised once more:_

My prediction is that in the near future it will be normal to not think about which physical machine the program we are writing is running on.

**We are moving to the cloud.**

*Of course this is not a new idea.* I never have new ideas. But it took me a while to realise the implications of moving to the cloud.

Also please forgive me for using such a buzzword - Cloud is the best description for software with invisible hardware that I have heard of.

From a consumer's point of view this doesn't sound like a new idea. It has become totally normal to have all your files, all your data somewhere in the internet and access it from all your devices whenever you want.

People stopped caring where the cloud actually physically is already a long time ago *(this is not completely true: here in Germany everyone is still worried and trying hard to find the cloud)*.

Our social and working tools have basically all moved already.  The laptops and phones we own don't need to offer much. They are becoming commodity. They simply provide a window to interact with the cloud.

In some cases such as gaming the hardware you own is still critical but personal, high-end gaming PCs are also [a thing of the past](https://en.wikipedia.org/wiki/Games_as_a_service).


For consumers and workplaces the convenience of not having to worry about hardware is such a huge gain, it was an easy move. People just don't care about how technology works. They don't want to know. They don't want to bother. They want their services and tools to simply work and do their job. Let someone else do the maintenance.

*Having control over your computer is simply a burden for most people.*

**But we developers like technology**. We want to be in full control over our system and our data, right? I doubt it. Not the majority at least. We are also simply humans. We own or work for companies that try to run a business. If there is a more efficient way and the gain is big enough, we also move.

Our production systems are largely running in the cloud already. We rent virtual servers from Amazon, Google, Microsoft. We push static content to CDN services. More and more of the functionality we need is now available as a service and we don't have to manage them ourselves anymore:<br>databases, search engines, firewalls, message queues, file storage, load balancers, web servers, build servers, test runners, registries, secret management, user authentication, …<br>There is a service for basically every generic piece of software out there *(if you see one missing, make sure you are the first one to build it!)*.

**The only thing that makes our software unique is our own, custom business logic of how we connect the pieces together.**

*Surprisingly it is generally still the case that we express business logic as software in the same programming languages and runtimes we used when we were thinking about a physical machines*. We put great efforts into taking the existing environments we have in the form of operation systems such as Windows and Linux, faking a virtual environment that is identical to the OS we have from the past and executing our business logic in there nested in unnecessary layers of indirection with OSes in OSes in OSes, ten layers deep.

*What if we let go of the past, let go of the control and create efficient platforms suited for expressing our business logic?*

**If we want to tackle more complex problems, we need a solid foundation**. We need to raise the level of abstraction. More complex business domains require us to be able to focus on them exclusively. We need to separate the work of building the foundation from the next layer.

The foundation is important and critical to get right. *There will always be a need for great people to work on the foundation of computing*. But the majority of problems developers are trying to solve today and an even bigger percentage of what we will have to solve in the future is not about technology in itself - it is all the problems in the world where technology has the potential to help us solve them. And there are plenty. We better get good at using technology effectively instead of fighting against the complexity we created through layers of unhelpful abstractions. Let's admit that it's time for a new abstraction. Let's use our existing languages, platforms and tools for what they are good at and build another solid, efficient layer as next abstraction.

A programming platform for this level of expression has different characteristics than lower-level platforms:<br>It is mostly glue connecting lower-level components. There needs to be a good API of primitives to talk to available components. The concept of starting and stopping the system is handled by the underlying platform which allows this layer to be much more dynamic, loading only what is needed at this time. Performance critical tasks are most likely handled by lower-level primitives.<br>There are many more properties to define for such as system.

**Did I mention before that we are giving up control? And you know that [software is eating the world](https://a16z.com/2016/08/20/why-software-is-eating-the-world/)?**

*If we don't want all power to end up in the hands of a selected few that run these new platforms, we better make sure we get this right.*

Let’s not wait for the big infrastructure companies to come up with a platform. Let’s not wait for them to bind us to their specific ideas and their products. Let’s make sure we create a healthy system with a multitude of options and diversity of ideas.

It is great to see alternatives to the big cloud providers showing up. Shout out to [netlify](https://www.netlify.com/), [fastly](https://www.fastly.com/), [DigitalOcean](https://www.digitalocean.com/) and friends! A healthy market needs competition.

*Similar to the variety of operating systems and programming languages out there, we should aim for a variety of cloud platforms that are compatible with each other and share standards and protocols.*

This is how technology like email and the web became this widely adopted.

The greatest efforts I see at the moment is the work happening under the umbrella of the [Cloud Native Computing Foundation](https://www.cncf.io/). We need more initiatives like [cloudevents](https://cloudevents.io/) and [openmetrics](https://openmetrics.io/)!


One of the next big steps I see is in **developer tooling**. Developers like to and need to be in control of their systems to test, monitor and debug them. It cannot be the right way that developers have to emulate a [cloud on their laptop](https://github.com/kubernetes/minikube). Instead, *let's move development environments into the cloud*. And developers need good tools to be productive. A web interface is not enough. We should have realtime APIs on which we can build tooling on top of.
There is still a lot of room in this space waiting to be filled. [Moving](https://codenvy.com/) [IDEs](https://coder.com/) into the [cloud](https://c9.io/announcement) is only a very first step.




Fellow developers, beware of the level of abstraction the problem you are trying to solve is on. Be ready to development in the cloud. Let's work together to make our new platforms a great place to work in.

*Thank you.*


**Update:** [The Dark language](https://medium.com/darklang/how-dark-deploys-code-in-50ms-771c6dd60671) is doing awesome things in this direction!
