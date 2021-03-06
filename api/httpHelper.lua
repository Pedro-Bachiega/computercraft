function newHelper()
    HttpHelper = {}

    function HttpHelper:get(url)
        local connection = http.get(url)
        local content = connection.readAll()
        connection.close()
        return content
    end
    
    function HttpHelper:saveFile(fileName, content)
        local file = fs.open(fileName, "w")
        file.write(content)
        file.close()
    end
    
    function HttpHelper:download(url, fileName)
        if not string.find(url, ".lua") then
            url = url .. ".lua"
        end

        local content = self:get(url)
        self:saveFile(fileName, content)
        print("Downloaded file:\n" .. fileName .. "\n")
    end
    
    function HttpHelper:remove(absolutePath)
        if fs.exists(absolutePath) or fs.isDir(absolutePath) then
            fs.remove(absolutePath)
            print("Removed file:", absolutePath)
        end
    end
    
    function HttpHelper:post(url, data)
        local connection = http.post(url, data)
        local content = connection.readAll()
        connection.close()
        return content
    end
    
    function HttpHelper:update()
        self:download("https://raw.githubusercontent.com/Pedro-Bachiega/computercraft/master/api/httpHelper.lua", "api/httpHelper")
    end

    return HttpHelper
end

function update(localFileName)
    if localFileName == nil then
        error("Usage: httpHelper update <file_name>")
    end

    os.loadAPI("constants")
    newHelper():download(constants.GITHUB_URL .. localFileName, localFileName)
end
