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


if fkernel.getVersion() == "0.1" then
	Update0_1_1()
	UpdateVersion("0.1.1")
	os.reboot()
end

if fkernel.getVersion() == "0.1.1" then
	--UpdateCode
	UpdateVersion("NEXTVER")
	os.reboot()
end
