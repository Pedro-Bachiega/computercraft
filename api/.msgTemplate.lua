--DEPENDENCIES: api/teamsMsg,api/httpHelper

if not fs.exist("api/httpHelper") then
    shell.run("pastebin get mLW65yV0 api/httpHelper")
end

os.loadAPI("api/httpHelper")
helper = httpHelper.newHelper()

if not fs.exist("api/teamsMsg") then
    helper:download("https://raw.githubusercontent.com/Pedro-Bachiega/computercraft/master/api/teamsMsg.lua", "api/teamsMsg")
end

os.loadAPI("api/teamsMsg")

webhookUrl = helper:get("http://127.0.0.1:5000/webhook/PBNacust")

message:setSummary("Summary")
message:setTitle("Title")
message:setSubtitle("Subtitle")
message:setPayload("[{\"name\":\"Name\",\"value\":\"Value\"}]")
message:setWebhookUrl(webhookUrl)
message:send()