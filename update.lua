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
    
    return 0  -- Return 0 on success
end


if fkernel.getVersion() == "0.1" then
	Update0_1_1()
	UpdateVersion("0.1.1")
	os.reboot()
end

if fkernel.getVersion() == "0.1.1" then
	--UpdateCode
	--UpdateVersion("NEXTVER")
	--os.reboot()
end
