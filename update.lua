function downloadClone()
    local url = "https://gist.githubusercontent.com/SquidDev/e0f82765bfdefd48b0b15a5c06c0603b/raw/06be706a772fa0a64195be1146bff6360c04d27c/clone.lua"
    local filePath = "crom/programs/clone.lua"
    
    -- Make sure to check if the HTTP API is available
    if not http then
        return 1  -- Return 1 if HTTP API is not available
    end

    -- Perform the HTTP GET request
    local response = http.get(url)
    if not response then
        return 1  -- Return 1 on failure
    end

    -- Read the response body and save it to a file
    local file = fs.open(filePath, "w")
    if not file then
        return 1  -- Return 1 if the file cannot be opened for writing
    end

    file.write(response.readAll())  -- Write the response body to the file
    file.close()  -- Close the file
    response.close()  -- Close the response

    return 0  -- Return 0 on success
end
function UpdateVersion(ver)
    local filePath = "/crom/apis/fkernel.lua"
    
    -- Open the file in read mode to get all its contents
    local file = fs.open(filePath, "r")
    if not file then
        return 1  -- Return 1 if the file cannot be opened
    end

    -- Read the entire content of the file
    local lines = {}
    local line = file.readLine()
    while line do
        table.insert(lines, line)
        line = file.readLine()
    end
    file.close()  -- Close the file after reading
    
    if #lines > 0 then
        -- Replace the first line with the new version
        lines[1] = 'local OS_VER = "' .. ver .. '"'
    else
        return 1  -- Return 1 if the file is empty
    end
    
    -- Open the file in write mode to save the modified content
    file = fs.open(filePath, "w")
    if not file then
        return 1  -- Return 1 if the file cannot be opened for writing
    end

    for _, l in ipairs(lines) do
        file.writeLine(l)
    end
    file.close()  -- Close the file after writing
    
    return 0  -- Return 0 on success
end
function createHelpFile()
    local helpFilePath = "/crom/help/clone.txt"
    
    -- Open the file in write mode
    local file = fs.open(helpFilePath, "w")
    if not file then
        return 1  -- Return 1 if the file cannot be opened for writing
    end

    -- Define the content to write to the file
    local content = [[
clone is able to clone and download entire github repo

Written by SquidDev (Thanks https://gist.github.com/SquidDev/e0f82765bfdefd48b0b15a5c06c0603b)

clone.lua URL [name]
]]

    -- Write the content to the file
    file.write(content)
    file.close()  -- Close the file after writing

    return 0  -- Return 0 on success
end

function updateFiles_0_1_1()
    local startupPath = "/crom/startup.lua"
    local fkernelPath = "/boot/fkernel.lua"
    
    -- Open the startup.lua file in read mode
    local startupFile = fs.open(startupPath, "r")
    if not startupFile then
        return 1  -- Return 1 if the startup file cannot be opened
    end

    -- Read the entire content of the startup.lua file
    local lines = {}
    local line = startupFile.readLine()
    while line do
        table.insert(lines, line)
        line = startupFile.readLine()
    end
    startupFile.close()  -- Close the startup file after reading

    -- Check if the file has at least 175 lines
    if #lines < 175 then
        return 1  -- Return 1 if the startup file has fewer than 175 lines
    end

    -- Modify lines 161 and 162
    lines[161] = "local function checkUpdateFile()"
    lines[162] = "    if fs.exists(\"/boot/update.lua\") then"

    -- Prepare the new lines to insert after line 174
    local newLines = {
        'if checkUpdateFile() == 0 then',
        '    shell.run("/boot/update.lua")',
        'else',
        '    shell.run("clear")',
        '    printError("Fr0stOS:/boot/update.lua was not found. Can\'t Boot")',
        '    print("Press any key to enter...")',
        '    os.pullEvent("key") -- Waits for any key to be pressed',
        '    os.reboot() -- Reboots the system',
        'end'
    }

    -- Insert the new lines after line 174 (index 175)
    for i = #newLines, 1, -1 do
        table.insert(lines, 175, newLines[i])
    end

    -- Open the startup file in write mode to save the modified content
    startupFile = fs.open(startupPath, "w")
    if not startupFile then
        return 1  -- Return 1 if the startup file cannot be opened for writing
    end

    for _, l in ipairs(lines) do
        startupFile.writeLine(l)
    end
    startupFile.close()  -- Close the startup file after writing

    -- Now remove the last line from fkernel.lua
    local fkernelFile = fs.open(fkernelPath, "r")
    if not fkernelFile then
        return 1  -- Return 1 if the fkernel file cannot be opened
    end

    -- Read the entire content of the fkernel.lua file
    local fkernelLines = {}
    line = fkernelFile.readLine()
    while line do
        table.insert(fkernelLines, line)
        line = fkernelFile.readLine()
    end
    fkernelFile.close()  -- Close the fkernel file after reading

    -- Check if the fkernel file has at least one line
    if #fkernelLines > 0 then
        -- Remove the last line
        table.remove(fkernelLines)
    end

    -- Open the fkernel file in write mode to save the modified content
    fkernelFile = fs.open(fkernelPath, "w")
    if not fkernelFile then
        return 1  -- Return 1 if the fkernel file cannot be opened for writing
    end

    for _, l in ipairs(fkernelLines) do
        fkernelFile.writeLine(l)
    end
    fkernelFile.close()  -- Close the fkernel file after writing

    return 0  -- Return 0 on success
end

function updateFKernel_0_1_2()
    local filePath = "/boot/fkernel.lua"
    
    -- Open the file in read mode
    local file = fs.open(filePath, "r")
    if not file then
        return 1  -- Return 1 if the file cannot be opened
    end

    -- Read the entire content of the file
    local lines = {}
    local line = file.readLine()
    while line do
        table.insert(lines, line)
        line = file.readLine()
    end
    file.close()  -- Close the file after reading

    -- Check if the file has at least 282 lines
    if #lines < 282 then
        return 1  -- Return 1 if the file has fewer than 282 lines
    end

    -- Prepare the lines to insert after line 282
    local newLines = {
        '    local function checkinitFile()',
        '        if fs.exists("/boot/init.lua") then',
        '            return 0 -- File exists',
        '        else',
        '            return 1 -- File does not exist',
        '        end',
        '    end',
        '    if checkinitFile() ~= 0 then',
        '        shell.run("clear")',
        '        printError("Fr0stOS:/boot/init.lua was not found. Can\'t Boot")',
        '        print("Press any key to enter...")',
        '        os.pullEvent("key") -- Waits for any key to be pressed',
        '        os.reboot() -- Reboots the system',
        '    end'
    }

    -- Insert the new lines after line 282 (index 283)
    for i = #newLines, 1, -1 do
        table.insert(lines, 283, newLines[i])
    end

    -- Append the new last line to run /boot/init.lua
    table.insert(lines, 'shell.run("/boot/init.lua")')

    -- Open the file in write mode to save the modified content
    file = fs.open(filePath, "w")
    if not file then
        return 1  -- Return 1 if the file cannot be opened for writing
    end

    for _, l in ipairs(lines) do
        file.writeLine(l)
    end
    file.close()  -- Close the file after writing

    return 0  -- Return 0 on success
end


function Update0_1_1()
    local filePath = "/boot/login.lua"
    
    -- Open the file in read mode
    local file = fs.open(filePath, "r")
    if not file then
        return 1  -- Return 1 if the file cannot be opened
    end

    -- Read the entire content of the file
    local lines = {}
    local line = file.readLine()
    while line do
        table.insert(lines, line)
        line = file.readLine()
    end
    file.close()  -- Close the file after reading

    -- Check if the file has at least 12 lines
    if #lines >= 12 then
        -- Remove lines 10, 11, and 12
        table.remove(lines, 12)  -- Remove line 12
        table.remove(lines, 11)  -- Remove line 11
        table.remove(lines, 10)  -- Remove line 10

        -- Check if the function `ttl` is already present
        local functionExists = false
        for _, l in ipairs(lines) do
            if l:find("local function ttl()") then
                functionExists = true
                break
            end
        end

        -- Insert the new function at line 10 only if it doesn't exist
        if not functionExists then
            table.insert(lines, 10, 'local function ttl()')
            table.insert(lines, 11, '    local versionText = "Fr0stOS " .. fkernel.getVersion()')
            table.insert(lines, 12, '    local idText = "Computer ID:" .. os.computerID()')
            table.insert(lines, 13, '    local width = term and term.getSize() or 51')
            table.insert(lines, 14, '    local spaces = width - #versionText - #idText')
            table.insert(lines, 15, '    return versionText .. string.rep(" ", spaces) .. idText')
            table.insert(lines, 16, 'end')
        end
    else
        return 1  -- Return 1 if the file has fewer than 12 lines
    end

    -- Open the file in write mode to save the modified content
    file = fs.open(filePath, "w")
    if not file then
        return 1  -- Return 1 if the file cannot be opened for writing
    end

    for _, l in ipairs(lines) do
        file.writeLine(l)
    end
    file.close()  -- Close the file after writing
    downloadClone()
    updateFiles_0_1_1()
    return 0  -- Return 0 on success
end

function Update0_1_2()
    shell.run("move /crom/autorun/init.lua /boot/init.lua")
    shell.run("rm /crom/help/changelog.md")
    shell.run("rm /crom/help/credits.md")
    shell.run("rm /crom/help/speaker.md")
    shell.run("rm /crom/help/whatsnew.md")
    createHelpFile()
    updateFKernel_0_1_2()
end

function StartupFileUpdate0_1_3()
    local filePath = "/crom/startup.lua"
    local aliasLine = 'shell.setAlias("cls", "clear")'

    -- Open the file for reading
    local file = fs.open(filePath, "r")
    local lines = {}
    
    -- Read all lines into a table
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()

    -- Insert the alias line after line 20
    table.insert(lines, 21, aliasLine)

    -- Open the file for writing and write the updated content
    local fileWrite = fs.open(filePath, "w")
    for _, line in ipairs(lines) do
        fileWrite.writeLine(line)
    end
    fileWrite.close()
end

function CD2Home2Init0_1_3()
	local shellFilePath = "/crom/programs/shell.lua"
    local initFilePath = "/boot/init.lua"
    local startLine = 442
    local endLine = 445

    -- Open /crom/programs/shell.lua for reading
    local file = fs.open(shellFilePath, "r")
    local lines = {}
    local storedLines = {}

    -- Read all lines and store lines 442-445
    local lineNumber = 0
    while true do
        local line = file.readLine()
        if not line then break end
        lineNumber = lineNumber + 1
        if lineNumber >= startLine and lineNumber <= endLine then
            -- Remove leading whitespace from the stored lines
            local trimmedLine = string.gsub(line, "^%s+", "")
            table.insert(storedLines, trimmedLine)
        else
            table.insert(lines, line)
        end
    end
    file.close()

    -- Write remaining lines back to /crom/programs/shell.lua
    local fileWrite = fs.open(shellFilePath, "w")
    for _, line in ipairs(lines) do
        fileWrite.writeLine(line)
    end
    fileWrite.close()

    -- Open /boot/init.lua for reading
    local initFile = fs.open(initFilePath, "r")
    local initLines = {}

    -- Read all lines from /boot/init.lua
    while true do
        local line = initFile.readLine()
        if not line then break end
        table.insert(initLines, line)
    end
    initFile.close()

    -- Insert stored lines after line 3
    for i = 1, #storedLines do
        table.insert(initLines, 4 + i - 1, storedLines[i])
    end

    -- Write the updated /boot/init.lua file
    local initFileWrite = fs.open(initFilePath, "w")
    for _, line in ipairs(initLines) do
        initFileWrite.writeLine(line)
    end
    initFileWrite.close()
end

function createBrainfuckHelpFile()
    local helpFilePath = "/crom/help/bf.txt"
    local helpContent = [[
USAGE: bf <bf file>

You can also run BF on its own without arguments to use the interpreter/visualizer.

It's also global, and you can run .bf programs just like Lua programs.

No need to type bf <filename>; just simply type your BF file example.bf and it will run.
]]

    -- Open the file for writing
    local file = fs.open(helpFilePath, "w")

    -- Write the Brainfuck usage instructions to the file
    file.write(helpContent)

    -- Close the file
    file.close()
end

local function insertFsCopyFunction()
    local filePath = "/boot/fkernel.lua"
    
    -- Read the file content
    local file = fs.open(filePath, "r")
    local lines = {}
    
    -- Store all lines in a table
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()
    
    -- Insert the new function after line 173
    local newFunction = [[
_G["fs"]["copy"] = function(fromPath, toPath)
    fromPath = normalizePath(fromPath)
    toPath = normalizePath(toPath)

    -- Check if either 'fromPath' or 'toPath' is read-only
    if isReadOnly(fromPath) or isReadOnly(toPath) then
        return nil
    else
        return old_fsCopy(fromPath, toPath)
    end
end
]]

    -- Insert the new function after line 173
    table.insert(lines, 174, newFunction)
    
    -- Write the modified content back to the file
    file = fs.open(filePath, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end
local function removeLines174To206()
    local filePath = "/boot/fkernel.lua"
    
    -- Read the file content
    local file = fs.open(filePath, "r")
    local lines = {}
    
    -- Store all lines in a table
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()
    
    -- Remove lines 174 to 206 (inclusive)
    for i = 206, 174, -1 do
        table.remove(lines, i)
    end
    
    -- Write the modified content back to the file
    file = fs.open(filePath, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end
local function removeLines144To173()
    local filePath = "/boot/fkernel.lua"
    
    -- Read the file content
    local file = fs.open(filePath, "r")
    local lines = {}
    
    -- Store all lines in a table
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()
    
    -- Remove lines 144 to 173 (inclusive)
    for i = 173, 144, -1 do
        table.remove(lines, i)
    end
    
    -- Write the modified content back to the file
    file = fs.open(filePath, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end

local function insertFsCopyFunctionAfter159()
    local filePath = "/boot/fkernel.lua"
    
    -- Read the file content
    local file = fs.open(filePath, "r")
    local lines = {}
    
    -- Store all lines in a table
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()
    
    -- Define the new function to insert
    local newFunction = [[
_G["fs"]["copy"] = function(fromPath, toPath)
    fromPath = normalizePath(fromPath)
    toPath = normalizePath(toPath)

    -- Check if either 'fromPath' or 'toPath' is read-only
    if isReadOnly(fromPath) or isReadOnly(toPath) then
        return nil
    else
        return old_fsCopy(fromPath, toPath)
    end
end
]]

    -- Insert the new function after line 159
    table.insert(lines, 160, newFunction)
    
    -- Write the modified content back to the file
    file = fs.open(filePath, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end

local function insertFsMoveFunctionAfter170()
    local filePath = "/boot/fkernel.lua"
    
    -- Read the file content
    local file = fs.open(filePath, "r")
    local lines = {}
    
    -- Store all lines in a table
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()
    
    -- Define the new function to insert
    local newFunction = [[
_G["fs"]["move"] = function(fromPath, toPath)
    fromPath = normalizePath(fromPath)
    toPath = normalizePath(toPath)

    -- Check if either 'fromPath' or 'toPath' is read-only
    if isReadOnly(fromPath) or isReadOnly(toPath) then
        return nil
    else
        return old_fsMove(fromPath, toPath)
    end
end
]]

    -- Insert the new function after line 170
    table.insert(lines, 171, newFunction)
    
    -- Write the modified content back to the file
    file = fs.open(filePath, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end

local function CleanUp0_1_3()
    local filePath = "/boot/fkernel.lua"
    
    -- Read the file content
    local file = fs.open(filePath, "r")
    local lines = {}
    
    -- Store all lines in a table
    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(lines, line)
    end
    file.close()
    
    -- Remove lines 183 and 182 (in reverse order)
    table.remove(lines, 183)  -- Remove line 183 first
    table.remove(lines, 182)  -- Remove line 182 next
    
    -- Write the modified content back to the file
    file = fs.open(filePath, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end

function Update0_1_4()
    -- First, modify /crom/apis/fkernel.lua
    local fkernelPath = "/crom/apis/fkernel.lua"
    local fkernelInsertionLine = 15
    
    -- Define the sanitizePath function to be inserted
    local sanitizeFunctionCode = [[
function sanitizePath(path)
    -- Remove all `?` and `*` characters
    path = path:gsub("[%?%*]", "")
    
    -- Replace instances of double slashes `//` with a single slash `/`
    while path:find("//") do
        path = path:gsub("//", "/")
    end

    return path
end
]]
    
    -- Read /crom/apis/fkernel.lua into a table of lines
    local file = fs.open(fkernelPath, "r")
    local fkernelLines = {}

    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(fkernelLines, line)
    end
    file.close()
    
    -- Insert the sanitizePath function at line 15
    table.insert(fkernelLines, fkernelInsertionLine, sanitizeFunctionCode)
    
    -- Write the modified /crom/apis/fkernel.lua back to the file
    file = fs.open(fkernelPath, "w")
    for _, line in ipairs(fkernelLines) do
        file.writeLine(line)
    end
    file.close()
    
    -- Now, modify /crom/programs/shell.lua
    local shellPath = "/crom/programs/shell.lua"
    local shellReplaceLine = 432
    
    -- Define the content for replacement and insertion
    local shellReplaceLineContent = [[        write(fkernel.sanitizePath(shell.dir()) .. "> ")]]
    local shellInsertLineContent = [[        shell.setDir(fkernel.sanitizePath(shell.dir()))]]
    
    -- Read /crom/programs/shell.lua into a table of lines
    file = fs.open(shellPath, "r")
    local shellLines = {}

    while true do
        local line = file.readLine()
        if not line then break end
        table.insert(shellLines, line)
    end
    file.close()
    
    -- Replace line 432 and insert a line before it
    shellLines[shellReplaceLine] = shellReplaceLineContent
    table.insert(shellLines, shellReplaceLine, shellInsertLineContent)
    
    -- Write the modified /crom/programs/shell.lua back to the file
    file = fs.open(shellPath, "w")
    for _, line in ipairs(shellLines) do
        file.writeLine(line)
    end
    file.close()
end




function Update0_1_3()
	StartupFileUpdate0_1_3()
	CD2Home2Init0_1_3()
	createBrainfuckHelpFile()
	removeLines174To206()
	removeLines144To173()
	insertFsCopyFunctionAfter159()
	insertFsMoveFunctionAfter170()
	CleanUp0_1_3()
end

if fkernel.getVersion() == "0.1" then
	Update0_1_1()
	UpdateVersion("0.1.1")
	os.reboot()
end

if fkernel.getVersion() == "0.1.1" then
	Update0_1_2()
	UpdateVersion("0.1.2")
	os.reboot()
end

if fkernel.getVersion() == "0.1.2" then
	Update0_1_3()
	UpdateVersion("0.1.3")
	os.reboot()
end
if fkernel.getVersion() == "0.1.2" then
	Update0_1_3()
	UpdateVersion("0.1.3")
	os.reboot()
end
if fkernel.getVersion() == "0.1.3" then
	Update0_1_4()
	UpdateVersion("0.1.4")
	os.reboot()
end
