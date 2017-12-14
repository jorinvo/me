---
title: "How to Generate Test Data in Go"
date: 2017-11-05T09:03:15+01:00
draft: true
---

- Fake data
- Golden files
- Fuzzer

https://kev.inburke.com/kevin/faker-js-problems/

Hi, I definitely agree with you about not having random behavior in your test suite.
A non-predictable test suite can be the source of a lot of suffering. Tests need to be reproducible to be able to identify bugs or otherwise you might better save the time of writing them all together.

However, I think that generating random data still has valid use cases in other places:
You can use a tool like faker to create a large set of test data, save it to a file and commit it with your tests. These are sometimes also referred to as Golden Files.
Automating the creation of tests cases can be definitely useful for complicated logic.

Fuzzers like QuickCheck are another great tool to find even more edge cases.
Since running a fuzzer is rather expensive in terms of computing, you probably don't want it as part of your standard test suite. Instead the fuzzing results should be added to the corresponding unit tests.
While fuzzing is great to find additional edge cases, you want to have a decent initial data set that guides the fuzzer to look in the right direction to find any meaningful cases in a tolerable time frame.
