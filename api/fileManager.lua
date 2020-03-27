function getContent(url)
    local connection = http.get(url)
    local content = connection.readAll()
    connection.close()
    return content
end

function saveFile(fileName, content)
    if fs.exists(fileName) then fs.delete(fileName) end

    local file = fs.open(fileName, "w")
    file.write(content)
    file.close()
end

function download(url, fileName)
    print("Downloading file:\n" .. fileName .. "\n")

    if not fs.dir("scripts") then fs.makeDir("scripts") end

    local content = getContent(url)
    saveFile("scripts/" .. fileName, content)
end

function remove(absolutePath)
    if fs.exists(absolutePath) then
        fs.remove(absolutePath)
        print("Removed file:", absolutePath)
    end
end