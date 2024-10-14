function downloadClone()
    local url = "https://gist.githubusercontent.com/SquidDev/e0f82765bfdefd48b0b15a5c06c0603b/raw/06be706a772fa0a64195be1146bff6360c04d27c/clone.lua"
    local filePath = "clone.lua"
    
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

while true do
	shell.run("clear")
	print("CC-CFW-Fr0styOS Installer 0.1")
	print("OS and Installer Written by Jacob Hodgkins")
	io.write("\nInstall(Y/N):")
	input = io.read()
	if input == "Y" then
		break
	elseif input == "y" then
		break
	elseif input == "N" then
		return 0
	elseif input == "n" then
		return 0
	end
end

print("\nDownloading Git Cloner Credits:SquidDev")
downloadClone()
print("\nCloning Fr0styOS")
shell.run("clone.lua https://github.com/HodgkinsDev/CC-CFW-Fr0styOS.git")
print("\nMoving OS Files")
shell.run("move CC-CFW-Fr0styOS/* /")
print("\nCleaning up")
shell.run("rm CC-CFW-Fr0styOS/")
os.reboot()