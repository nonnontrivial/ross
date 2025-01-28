# Ross

keyboard-driven RSS reader for macOS.

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
- add the RSS feeds you want to track:
```toml
[hackernews]
url = "https://hnrss.org/frontpage"
poll = 300 # seconds

[github]
url = "https://github.blog/feed/"
poll = 300 # seconds

```
- reload your hammerspoon config
- cmd+opt+h to open the reader
- esc to close the reader
