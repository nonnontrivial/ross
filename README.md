# Ross

keyboard-driven RSS reader for macOS.

https://github.com/user-attachments/assets/d9468512-f116-4321-9b81-e73bef2121b3

## known issues

- [ ] will only support continuous polling when single feed is defined
- [ ] poll will stop when machine sleeps

## install

> n.b. assumes you have [hammerspoon](https://www.hammerspoon.org) installed.

> n.b. [hammerspoon timer](https://www.hammerspoon.org/docs/hs.timer.html) uses a macOS API which will pause on sleep; accounting for this remains an open issue


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
poll = 120 # seconds

```
- reload your hammerspoon config
- cmd+opt+h to open the reader
- esc to close the reader
