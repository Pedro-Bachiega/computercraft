function download(baseUrl, fileName)
    print("Downloading file:\n" .. fileName)

    if not fs.dir("scripts") then fs.makeDir("scripts") end

    local connection = http.get(baseUrl .. fileName)
    local content = connection.readAll()
    connection.close()

    local file = fs.open("scripts/" .. fileName, "w")
    file.write(content)
    file.close()

    print("File downloaded and saved to:", "scripts/" .. fileName .. ".lua")
end

function remove(absolutePath)
    if fs.exists(absolutePath) then
        fs.remove(absolutePath)
        print("Removed file:", absolutePath)
    end
end