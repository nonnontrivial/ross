local Toml = dofile(hs.spoons.resourcePath("toml.lua"))
local Feed = dofile(hs.spoons.resourcePath("feed.lua"))

local Ross = {
    name = "Ross",
    version = "0.2.0",
    author = "Kevin Donahue <nonnontrivial@gmail.com>",
    license = "https://opensource.org/license/mit",

    config = nil,
    chooser = nil,
    showingChooser = false,
    rssFeeds = {}
}

function Ross:updateFeedData(url, data)
    self.rssFeeds[url] = data
end

function Ross:sortItems(items)
    table.sort(items, function(a, b)
        return a.pubDate > b.pubDate
    end)
end

function Ross:updateChoices()
    local allItemsAcrossFeeds = {}
    for _, data in pairs(self.rssFeeds) do
        for _, item in ipairs(data.items) do
            table.insert(allItemsAcrossFeeds, item)
        end
    end
    self:sortItems(allItemsAcrossFeeds)
    local choices = {}
    for _, item in ipairs(allItemsAcrossFeeds) do
        table.insert(choices, { ["text"] = item.title, ["subText"] = item.link })
    end
    self.chooser:choices(choices)
end

function Ross:setupChooser()
    local function onChoice(choice)
        if not choice then
            return
        end
        local link = choice.subText
        hs.urlevent.openURL(link)
    end
    self.chooser = hs.chooser.new(onChoice)
end

function Ross:start()
    self:setupChooser()
    local toml = Toml:new()
    local configPath = hs.spoons.resourcePath("./config.toml")
    self.config = toml:parse(configPath)
end

function Ross:show()
    for section, data in pairs(self.config) do
        local feed = Feed:new(data.url)
        local parsedRSSBody = feed:getData()
        print("updating feed with new data from " .. section)
        self:updateFeedData(data.url, parsedRSSBody)
        self:updateChoices()
    end
    self.chooser:show()
end

function Ross:bindHotKeys(mapping)
    local spec = {
        showReader = hs.fnutils.partial(self.show, self),
    }
    hs.spoons.bindHotkeysToSpec(spec, mapping)
    return self
end

return Ross
