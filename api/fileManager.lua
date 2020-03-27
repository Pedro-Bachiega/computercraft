function getContent(url)
    local connection = http.get(baseUrl .. fileName)
    local content = connection.readAll()
    connection.close()
    return content
end

function saveFile(fileName, content)
    local file = fs.open(fileName, "w")
    file.write(content)
    file.close()
end

function download(baseUrl, fileName)
    print("Downloading file:\n" .. fileName .. "\n")

    if not fs.dir("scripts") then fs.makeDir("scripts") end

    local content = getContent(baseUrl .. fileName)
    local filePath = "scripts/" .. fileName
    saveFile(filePath, content)

    print("File downloaded and saved to:", "scripts/" .. fileName .. ".lua")
end

function remove(absolutePath)
    if fs.exists(absolutePath) then
        fs.remove(absolutePath)
        print("Removed file:", absolutePath)
    end
end