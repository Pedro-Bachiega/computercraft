--DEPENDENCIES: api/httpHelper

if not fs.exists("api/httpHelper") then
    shell.run("pastebin get mLW65yV0 api/httpHelper")
end

os.loadAPI("api/httpHelper")

function newMessage()
    Helper = {}

    function Helper:insert(key, value)
        Helper[key] = value
    end
    
    function Helper:contains(key)
        return Helper[key] ~= nil
    end

    function Helper:setSummary(summary)
        self:insert("summary", summary)
    end

    function Helper:setTitle(title)
        self:insert("title", title)
    end

    function Helper:setSubtitle(subtitle)
        self:insert("subtitle", subtitle)
    end

    function Helper:setPayload(facts)
        self:insert("facts", facts)
    end

    function Helper:setThemeColor(themeColor)
        self:insert("themeColor", themeColor)
    end

    function Helper:setWebhookUrl(url)
        self:insert("webhook_url", url)
    end

    function Helper:setImageUrl(imageUrl)
        self:insert("image_url", imageUrl)
    end

    function Helper:send()
        webhookUrl = ""
        summary = ""
        title = ""
        subtitle = ""
        facts = ""
        imageUrl = ""
        themeColor = "0076D7"
        isTesting = false

        if self:contains("webhook_url") then
            webhookUrl = Helper["webhook_url"]
        else
            error("Webhook url not set")
        end

        if self:contains("theme_color") then
            themeColor = Helper["theme_color"]
        end

        if self:contains("summary") then
            summary = Helper["summary"]
        else
            error("Summary not set")
        end

        if self:contains("title") then
            title = Helper["title"]
        else
            error("Title not set")
        end

        if self:contains("subtitle") then
            subtitle = Helper["subtitle"]
        else
            error("Subtitle not set")
        end

        if self:contains("facts") then
            facts = string.format(",\"facts\":%s", Helper["facts"])
        end

        if self:contains("image_url") then
            facts = string.format(",\"activityImage\":\"%s\"", Helper["image_url"])
        end
    
        payload = string.format("{\"@type\":\"MessageCard\",\"@context\":\"http://schema.org/extensions\",\"themeColor\":\"%s\",\"summary\":\"%s\",\"sections\":[{\"activityTitle\":\"%s\",\"activitySubtitle\":\"%s\"%s%s,\"markdown\":true}]}", themeColor, summary, title, subtitle, imageUrl, facts)

        if webhookUrl == "test" then
            print(payload)
        else
            httpHelper.newHelper():post(webhookUrl, payload)
        end
    end

    return Helper
end
