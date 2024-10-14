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

if fkernel.getVersion() == "0.1" then
	--Update Code
	--UpdateVersion("0.2")
	--os.reboot()
end
