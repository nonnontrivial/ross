# Ross

keyboard-driven RSS reader for macOS.

https://github.com/user-attachments/assets/d9468512-f116-4321-9b81-e73bef2121b3

## install

> n.b. assumes you have [hammerspoon](https://www.hammerspoon.org) installed.

- clone this repo
- move it to `~/.hammerspoon/Spoons/Ross.spoon`
- edit `~/.hammerspoon/init.lua` to have the following:

```lua
hs.loadSpoon("Ross"):bindHotKeys({
    showReader = { { "cmd", "alt" }, "h" },
}):start()

```

- create `~/.hammerspoon/Spoons/Ross.spoon/config.toml`
- add the RSS feed(s) you want to track:

```toml
[hackernews]
url = "https://hnrss.org/frontpage"

[wired]
url = "https://www.wired.com/feed/tag/ai/latest/rss"

```
- reload your hammerspoon config
- cmd+opt+h to open the reader
- esc to close the reader
