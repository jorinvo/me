---
title: "Learn Elixir by Creating a Command Line Application"
date: 2018-04-09T07:22:56+02:00
favorite: true
---

I'd like to share my experience of getting started with Elixir by writing a simple command line application
and introduce the setup for basic Elixir projects.<!--more-->

Lately I have been fascinated by [Elixir](https://elixir-lang.org/). It is a nice little language built on a rock-solid foundation: the BEAM - Erlang's virtual machine.
Not just the syntax, which is pretty easy on the eyes with its Ruby-esque look, but also available posts and tooling welcome you with simple instructions and intuitive to use interfaces.

Building on Erlang which has been a functional language from the beginning, functional concepts are center to Elixir and they don't feel misplaced or like an afterthought as I often get the feeling with functional languages built on top of the JVM or JavaScript runtimes.

[Pattern matching](https://elixir-lang.org/getting-started/pattern-matching.html) is an incredibly elegant way of writing declarative code and filtering out surprises from the input. [Recursion](https://elixir-lang.org/getting-started/recursion.html) is well supported. Data is [immutable](https://madlep.com/presentations/immutable_data_in_elixir/). And instead of stateful programs you elegantly handle state in the same consistent way you handle concurrency and communication with external services: through the [actor model](https://theerlangelist.blogspot.de/2013/01/actors-in-erlangelixir.html) and message passing. Building resilient, fault-tolerant systems is a core part of Erlang and Elixir through the concept of [processes and supervisor](https://elixir-lang.org/getting-started/mix-otp/supervisor-and-application.html) which is a concept of accepting errors as part of a system and allowing parts of your program to fail gracefully without taking down the whole system.

The Elixir community has done a great job: editor support, tooling, the standard library and third-party packages are a pleasure to use and easy to get started.

A big focus of the Elixir ecosystem is around [Phoenix](https://phoenixframework.org/), a full-featured web framework similar to [Ruby on Rails](https://rubyonrails.org/). Phoenix is a great piece of software and definitely helpful for building web applications. It is also [modular](https://theerlangelist.com/article/phoenix_is_modular) and you do not need to use all parts of it if you only require a small subset of its features.
Besides that, Elixir is well-suited for many other use cases, even writing [embedded software](https://nerves-project.org/).

However to start learning a language it is more helpful to focus on the language itself first and learn about Phoenix and other abstractions built on top of the language later.

--------------------

To get a feeling for workflow and tooling in Elixir I created a really basic example project.

[prepend](https://github.com/jorinvo/prepend) is a very simple command line tool, which prepends a given string to each line it receives on stdin and writes that to stdout.

Using it looks like this:

```
$ echo -e "ice cream\npizza\ncats" | ./prepend "I like "
I like ice cream
I like pizza
I like cats
```

To get started writing a plain Elixir application such as this CLI, you create a new project using [Mix](https://hexdocs.pm/mix/Mix.html), Elixir's built-in build tool: `mix new prepend`

All build configuration and dependencies are defined in a file called `mix.exs`.
I edited the file to configure [escript](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html) which lets you build a single file from your Elixir project that includes Elixir itself and all your additional dependencies and can run on any machine with the Erlang VM installed.

If you write really simple scripts without dependencies and you have Elixir installed anyways, you can also save them in a file ending with `.exs` and run it as Elixir script directly without compiling: `elixir myscript.exs`.

Before writing any actual code, I setup [credo](http://credo-ci.org/) and made sure my editor showed me linting warnings inline
and I also set up my editor to automatically run [`mix format`](https://hexdocs.pm/mix/master/Mix.Tasks.Format.html) so I don't have to worry about that myself.

It was easy to find out that for reading and writing from stdin and to stdout, I could use the [`IO.Stream`](https://hexdocs.pm/elixir/IO.Stream.html) module and the docs explain that it implements [`Enumerable`](https://hexdocs.pm/elixir/Enumerable.html), which is the protocol I can use for transforming the input.

For transforming the input I want to use the [`Stream`](https://hexdocs.pm/elixir/Stream.html) module, because - unlike [`Enum`](https://hexdocs.pm/elixir/Enum.html) - it works lazily and allows to process one line at a time without reading everything from its input first. This way `prepend` can process files faster and with consistent memory usage even for large files.

Since `Enumerable` is a protocol I can implement the core logic first without using actual standard input and output.
I decided to try things out in the REPL first.
Elixir comes with [IEx](https://hexdocs.pm/iex/IEx.html).
You can start a REPL anywhere by typing `iex`.

Since [lists](https://hexdocs.pm/elixir/List.html) also implement `Enumerable` I can experiment with them before using actual lines:

```elixir
iex> ["one", "two"] |> Enum.map(&("$ " <> &1))
["$ one", "$ two"]
```

The actual logic here is super simple, but for experimenting I had to use `Enum` since the output of `Stream` looks like this:

```elixir
iex> ["one", "two"] |> Stream.map(&("$ " <> &1))
#Stream<[enum: ["one", "two"], funs: [#Function<48.58052446/1 in Stream.map/2>]]>
```

But `Stream` also does the right thing, which you can see after extracting the result:

```elixir
iex> ["one", "two"] |> Stream.map(&("$ " <> &1)) |> Enum.to_list()
["$ one", "$ two"]
```

When creating a new project, Mix automatically creates a module in the `lib/` directory.

I added my code from the REPL as function in there:

```elixir
def stream_lines(in_stream, str) do
  in_stream |> Stream.map(&(str <> &1))
end
```

Now I can start a REPL in my project using `iex -S mix` and play with the module directly:

```elixir
["one", "two"] |> Prepend.stream_lines("$ ") |> Enum.to_list
["$ one", "$ two"]
```

After changing anything in the code I can always type `r Prepend` to reload the code from within the REPL and see if everything still works.

`iex` has other useful shortcuts such as `h` to lookup docs - for example `h Stream.map`.

Another really cool tool I discovered is `:observer.start`.
This starts up a GUI which actually comes from Erlang not Elixir, but it shows you all the details you could imagine you would ever want to know about your application state and the underlying runtime.

When writing long-running applications instead of CLIs, you can connect to the running process with a `iex` REPL and use all the same tools.

I wrapped my working `Prepend` in a [`Prepend.CLI`](https://github.com/jorinvo/prepend/blob/master/lib/prepend/cli.ex) module which receives arguments from the system on startup and creates a `IO.stream`. This is the module I actually added in my `escript` configuration and I tested it directly from the command line.

But I didn't stop there. I decided to reuse my experiments from the REPL as tests and explore different ways of testing.

I added a simple test to `test/prepend_test.exs`:

```elixir
test "handles multiple words" do
  expected = ["I like ice cream", "I like pizza", "I like cats"]

  received =
    ["ice cream", "pizza", "cats"]
    |> Prepend.stream_lines("I like ")
    |> Enum.to_list()

  assert received == expected
end
```

Since I didn't want to re-type `mix test` all the time, I installed [`mix_test_watch`](https://github.com/lpil/mix-test.watch). It re-runs the tests every time I press save.

Next I documented my function and realized that I can also add tests directly as examples in the doc string and it is still being executed as test:

```elixir
@doc """
Prepend the given string to each line if a stream
and returns a stream of the resulting lines.

## Example:

iex> ["one", "two"] |> Prepend.stream_lines("$ ") |> Enum.to_list
["$ one", "$ two"]

"""
```

I also added a type spec annotation to my function in the same way I saw it in the docs of the standard library:

```elixir
@spec stream_lines(Enumerable.t(), String.t()) :: Enumerable.t()
```

I used [Dialyxir](https://github.com/jeremyjh/dialyxir) to check for errors in the types.
Dialyxir is a wrapper around the Erlang tool [Dialyzer](https://erlang.org/doc/apps/dialyzer/dialyzer_chapter.html), which works for all languages running on the BEAM. It's great to see how well the Elixir and Erlang ecosystems work together and it allows to use many battle-proven tools and libraries.

After this I decided to add a property test for the module using the [StreamData](https://hexdocs.pm/stream_data/) package:

```elixir
@tag timeout: 300_000
property "streams" do
  check all lines <- list_of(string(:printable)),
            prefix <- string(:printable),
            max_runs: 1000 do
    lines
    |> Prepend.stream_lines(prefix)
    |> Stream.each(&String.starts_with?(&1, prefix))
  end
end
```

I had to up the timeout for the test when using increasing `max_runs` and I didn't want to run this every time when running `mix test` so I modified `test/test_helper.exs` to exclude property tests:

```elixir
ExUnit.start(exclude: [:property])
```

They can still be run explicitly: `mix test --only property`

As last thing I wrapped my module in a [Mix task](https://github.com/jorinvo/prepend/blob/master/lib/mix/prepend.ex).
This way it can be used from within the project directory as `mix prepend` directly instead of compiling to a binary first.

--------------------

Although this is a trivial example with an over-engineered solution I enjoyed the ease of getting started and the simplicity of available tooling.

All the source code can be found on [Github](https://github.com/jorinvo/prepend) and I would love to hear about tooling I missed out on and get feedback on my solution. I am sure there are more idiomatic ways of doing things and I would be more than glad to find out about the Elixir way of doing things.
