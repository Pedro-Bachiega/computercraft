--DEPENDENCIES: api/teamsMsg,api/httpHelper

if not fs.exist("api/httpHelper") then
    shell.run("pastebin get mLW65yV0 api/httpHelper")
end

if not fs.exist("api/teamsMsg") then
    os.loadAPI("api/httpHelper")
    httpHelper.newHelper():download("https://raw.githubusercontent.com/Pedro-Bachiega/computercraft/master/api/teamsMsg.lua", "api/teamsMsg")
end

os.loadAPI("api/teamsMsg")

message:setSummary("Summary")
message:setTitle("Title")
message:setSubtitle("Subtitle")
message:setPayload("[{\"name\":\"Name\",\"value\":\"Value\"}]")
message:setWebhookUrl("WEBHOOK_URL")
message:send()