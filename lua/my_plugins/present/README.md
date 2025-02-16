# `present.nvim`

Hey, this is a plugin for presenting markdown files!!

Love goes out to TJ DeVries.
https://www.youtube.com/watch?v=VGid4aN25iI

# Features

Can execute code in lua blocks, when you have them in a slide:

```lua
print("Hello world", 42)

```

# Multi-Lang support, example 1

If configured via `opts.executors`, other languages than lua can be executed:
(Currently JavaScript and Python configured per default.)

```javascript
console.log("Hello Node", 23);
console.log({myfield: true, other:false});
```


# Multi-Lang support, example 2

If configured, other language than lua can be executed:

```python
import math
print(math.pi)
print(type(math.pi))
```

# Usage

```lua
require("present").start_presentation {}
```

Use `PresentMarkdown` as a command.
Use `n`, and `p` to navigate markdown slides.
Use `q` or `<Esc>` to exit the markdown float.
