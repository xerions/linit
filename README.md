Linit
=====

Very simple backoff initializer.

Example of using:

```elixir
worker(Linit, [fn() -> :do_it end, ms: 1000])
```
