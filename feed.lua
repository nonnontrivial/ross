local Feed = {}

function Feed:new(url, pollingIntervalSeconds)
    local instance = { url = url, interval = pollingIntervalSeconds, data = {} }
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Feed:getLink(itemBlock)
    local descriptionBlock = itemBlock:match("<description>(.-)</description>")
    local cdata = descriptionBlock:match("<!%[CDATA%[(.-)%]%]>") or nil
    local link = nil
    if cdata then
        link = cdata:match('<a%s+href="(.-)"[^>]*')
    else
        link = itemBlock:match("<link>(.-)</link>")
    end
    return link
end

function Feed:getTitle(itemBlock)
    local title = itemBlock:match("<title><!%[CDATA%[(.-)%]%]></title>")
    return title or itemBlock:match("<title>(.-)</title>")
end

function Feed:getPubData(itemBlock)
    local pubDate = itemBlock:match("<pubDate>(.-)</pubDate>")
    local function toUnixTime(date)
        local day, month, year, hour, min, sec = date:match(
            "(%d+)%s+(%a+)%s+(%d+)%s+(%d+):(%d+):(%d+)"
        )
        local months = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }
        local timeTable = {
            year = tonumber(year),
            month = months[month],
            day = tonumber(day),
            hour = tonumber(hour),
            min = tonumber(min),
            sec = tonumber(sec)
        }
        return os.time(timeTable)
    end
    return toUnixTime(pubDate)
end

function Feed:parseRSSBody(rss)
    local items = {}
    for itemBlock in rss:gmatch("<item>(.-)</item>") do
        local item = {
            link = self:getLink(itemBlock),
            title = self:getTitle(itemBlock),
            pubDate = self:getPubData(itemBlock)
        }
        if not (item.link and item.title and item.pubDate) then
            goto continue
        end
        table.insert(items, item)
        ::continue::
    end
    return {
        channel = {
            title = rss:match("<title>(.-)</title>")
        },
        items = items
    }
end

function Feed:poll(onRSSData)
    local function getRSSData()
        print("fetching RSS feed from " .. self.url)
        local status, body, headers = hs.http.get(self.url)
        if status ~= 200 then
            error("got " .. status .. " from " .. self.url)
        end
        if not body then
            error("got empty response body")
        end
        self.data = self:parseRSSBody(body)
        onRSSData(self.data)
    end
    getRSSData()
    hs.timer.new(self.interval, getRSSData):start()
end

return Feed
