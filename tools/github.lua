local command = arg[1]
local fileName = arg[2]
local url = ""

if fs.exists("tools/constants.lua") then
    os.loadAPI("tools/constants.lua")
    url = constants.GITHUB_URL
else
    url = arg[3]
end

os.loadAPI("api/fileManager.lua")

local function saveFile(content, savedFileName)
    if savedFileName == nil then
        savedFileName = fileName
    end
    
    fileManager.saveFile(content, savedFileName)
end

local function parseXml(xmlText)
    os.loadAPI("api/xmlParser.lua")
    return xmlParser.newParser():ParseXmlText(xmlText)
end

local dirs = {}

local function gatherChildrenInfo(node, dirName)
    if node ~= nil then
        local nodeType = node:name()
        local nodeName = node["@name"]
        
        if nodeType == "dir" then
            if dirName == nil then
                dirs[nodeName] = {}
            else
                dirs[dirName][nodeName] = {}
            end
        elseif nodeType == "script" then
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
                print(tableName .. "/" .. tostring(v))
            end
        end
    else
        print(tableName .. "/" .. value)
    end
end

local function processXml(content)
    local parserPath = "api/xmlParser.lua"
    if not fs.exists(parserPath) then
        fileManager.download(baseUrl .. parserPath, parserPath)
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

local content = fileManager.getContent(baseUrl .. fileName)

if command == "get" and fileName ~= "index.xml" and not fs.exists(fileName) then
    saveFile(content)
elseif command == "show" and fileName == "index.xml" then
    processXml(content)
    print("Index:")
    printTableValues(nil, dirs)
elseif command == "show" then
    write(content)
    print("\n")
end