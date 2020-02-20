---
title: "Two Kinds of Software"
date: 2020-02-16T15:01:22+01:00
---

Let's talk about the difference between two kinds of software systems.
<!--more-->

This might be controversial but for me it helps to use the terms *Software Engineering* and *Software Development* to differentiate between two fundamental modes of creating software.

That said, neither of the two directions is right or wrong and both are necessary to create actually useful software systems. Basically every software system is made up of software of both kinds. The systems are often highly entangled which makes it so easy to ignore the fundamental different modes of thinking they require.


## Software Engineering

Engineering is about *designing, building and working with machines*.

Software engineering should strive for the same rigorousness as other engineering disciplines. It should use scientific methods and formalism to ensure correctness of software.

Engineering is the right approach for creating a solid foundation:

If you implement internet protocols, build a database, write a compiler, architect a distributed key-value store, create a file system - these systems require an engineering approach and we should strive for perfecting correctness.


## Software Development

The concept of development is about *bringing something into existence* and it entails the notion of *growing something into a more advanced form*.

I like to see software development as the discipline we use to create software systems that interact with the rest of the world.

Whenever we can encapsulate and precisely define a problem, an engineering approach will be very effective for producing software of high quality.

However, once a system interacts with humans or other external systems in the world, things suddenly are much less fixed. It becomes hard to foresee all possible interactions and inputs our system will receive from the outside world. External systems can exhibit faulty behaviour or can even become malicious. Being situated in an ever-evolving world, the requirement we expect our systems to fulfill are in constant flux and change fundamentally over time.

Rigorous planning a correct solution is not a viable option when requirements are extremely dynamic and it is not something that can be achieved with any reasonable amount of effort.

We need different methods when working on such systems:

- The first step is to accept that there will be mistakes and optimise your system to adapt and learn from errors.
- Keeping your system flexible becomes one of the top priorities when decisions become invalid at any moment.
- Being able to empirically try out different experiments is a useful tool when you cannot foresee the consequences of your system's behavior upfront.
- Having visibility through monitoring your software in production becomes even more crucial when you are unable to verify correctness upfront.

Creating social networks and online shops, but also building resource planning systems or working in financial markets - these systems keep on changing and should be development dynamically over time.


----


Once we accept that there is such a difference between the kinds of software systems we build, then we can making better decisions on how to build them.

For the first category, putting effort into upfront planning and all sort of efforts towards proving correctness can be very effective.

For the second category, instead of finding a perfect solution upfront we start with our best guess. The most important property of such a system is to build it in away that allows us to adopt it quickly and to observe it over time.


If we take apart our work, identify different sub-systems and judge them separately, then we can make more educated decisions for selecting the most effective methods and tools.


**You need a different mindset to build a bridge than you do for planning a city.**

