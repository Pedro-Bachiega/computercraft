function get(url)
    local connection = http.get(url)
    local content = connection.readAll()
    connection.close()
    return content
end

function saveFile(fileName, content)
    local file = fs.open(fileName, "w")
    file.write(content)
    file.close()
end

function download(url, fileName)
    local content = get(url)
    saveFile(fileName, content)
    print("Downloaded file:\n" .. fileName .. "\n")
end

function remove(absolutePath)
    if fs.exists(absolutePath) or fs.isDir(absolutePath) then
        fs.remove(absolutePath)
        print("Removed file:", absolutePath)
    end
end

function post(url, data)
    local connection = http.post(url, data)
    local content = connection.readAll()
    connection.close
    return content
end

function update()
    download("https://raw.githubusercontent.com/Pedro-Bachiega/computercraft/master/api/httpHelper", "api/httpHelper")
end

local command = arg[1]

if command ~= nil then
    if command == "get" then
        local url = arg[2]
        
        if url == nil then error("Usage:\n httpHelper get <url>") end
        return get(arg[2])
    elseif command == "saveFile" then
        local fileName = arg[2]
        local content = arg[3]

        if fileName == nil or content == nil then error("Usage:\n httpHelper saveFile <fileName> <content>") end
        saveFile(fileName, content)
    elseif command == "download" then
        local url = arg[2]
        local fileName = arg[3]
        
        if url == nil or fileName == nil then error("Usage:\n httpHelper download <url> <fileName>") end
        download(url, fileName)
    elseif command == "remove" then
        local absolutePath = arg[2]
        
        if absolutePath == nil then error("Usage:\n httpHelper remove <absolutePath>") end
        remove(absolutePath)
    elseif command == "update" then
        update()
    end
end