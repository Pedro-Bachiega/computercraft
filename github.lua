--DEPENDENCIES: api/httpHelper,api/xmlParser

local command = arg[1]
local fileName = arg[2]
local baseUrl = "https://raw.githubusercontent.com/Pedro-Bachiega/computercraft/master/"

if fs.exists("constants") then
    os.loadAPI("constants")
    baseUrl = constants.GITHUB_URL
end

if not fs.exists("api/httpHelper") then
    shell.run("pastebin get mLW65yV0 api/httpHelper")
end

os.loadAPI("api/httpHelper")
helper = httpHelper.newHelper()

local function parseXml(xmlText)
    os.loadAPI("api/xmlParser")
    return xmlParser.newParser():ParseXmlText(xmlText)
end

local dirs = {}

local function gatherChildrenInfo(node, dirName)
    if node ~= nil then
        local nodeType = node:name()
        local nodeName = node["@name"]
        local nodeDependencies = node["@dependencies"]
        
        if nodeType == "dir" then
            if dirName == nil then
                dirs[nodeName] = {}
            else
                dirs[dirName][nodeName] = {}
            end
        elseif nodeType == "script" then
            if nodeDependencies ~= nil then
                nodeName = nodeName .. " - Requires: " .. nodeDependencies
            end
            if dirName == nil then
                dirName = "root"
                dirs[dirName] = {}
            end

            table.insert(dirs[dirName], nodeName)
        end
        
        local children = node:children()
        if #children > 0 then
            for i=1, #children do
                gatherChildrenInfo(children[i], nodeName)
            end 
        end
    end
end

local function printTableValues(tableName, value)
    if type(value) == "table" then
        for i, v in pairs(value) do
            if type(v) == "table" then
                if tableName == nil then
                    printTableValues(tostring(i), v)
                else
                    printTableValues(tableName .. "/" .. tostring(i))
                end
            else
                if tableName == "root" then
                    print("\n" .. tostring(v))
                else
                    print("\n" .. tableName .. "/" .. tostring(v))
                end
            end
        end
    else
        print(tableName .. "/" .. value)
    end
end

local function processXml(content)
    local parserPath = "api/xmlParser"
    if not fs.exists(parserPath) then
        helper:download("https://raw.githubusercontent.com/Pedro-Bachiega/computercraft/master/api/xmlParser.lua", parserPath)
    end
    
    local xml = parseXml(content)
    local children = xml:children()
    
    for i = 1, #children do
        gatherChildrenInfo(children[i], nil)
    end
end

if fileName == nil or command == nil then
    error("Usage: \'github <get|show> <file_name>\'\n")
elseif fileName == "index" then
    fileName = "index.xml"
elseif not string.find(fileName, ".lua") then
    fileName = fileName .. ".lua"
elseif command ~= "get" and command ~= "show" then
    error("Unknown argument for param: command")
end

if command == "get" and fileName ~= "index.xml" and not fs.exists(fileName) then
    helper:download(baseUrl .. fileName, string.gsub(fileName, ".lua", ""))
elseif command == "show" and fileName == "index.xml" then
    local content = helper:get(baseUrl .. fileName)
    processXml(content)
    print("Index:")
    printTableValues(nil, dirs)
elseif command == "show" then
    local content = helper:get(baseUrl .. fileName)
    write(content)
    print("\n")
end