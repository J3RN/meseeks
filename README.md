# Meseeks

Can do! A simple Elixir authorization system!

<img src="https://media.giphy.com/media/DgLsbUL7SG3kI/source.gif" alt="Mr. Meseeks" />

## Getting Started

In order to reduce duplication of docs, please read the usage information in [the Meseeks documentation on Hexdocs](https://hexdocs.pm/meseeks).

## Installation

The package can be installed by adding `meseeks` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:meseeks, "~> 0.1.0"}
  ]
end
```

## When to use

If you are storing your permissions inside a JWT, you're probably looking for [Guardian](https://github.com/ueberauth/guardian#permissions). However, if you need a dead simple authorization system for RBAC otherwise, you've come to the right place!
