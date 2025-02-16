# `present.nvim`

Hey, this is a plugin for presenting markdown files!!

# Features

Can execute code in lua blocks, when you have them in a slide:

```lua
print("Hello world", 42)

```

# Multi-Lang support

If configured, other language than lua can be executed:

```javascript
console.log("Hello Node", 23);
console.log({myfield: true, other:false});
```

# Usage

```lua
require("present").start_presentation {}
```

Use `n`, and `p` to navigate markdown slides
