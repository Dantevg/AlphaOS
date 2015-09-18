--[[
      wApp shop for Alpha OS
      by DvgCraft
]]--

-- Variables
local version = "1.0"
local selected = 0
local selectedLev = 1
local inMain = true
local connedtion = nil

-- Menu Functions
function Exit()
  term.setBackgroundColor(colors.black)
  term.clear()
  term.setCursorPos(1,1)
  inMain = false
  return nil
end

-- Defining Menu
local mainMenu = {
  [0] = {txt = "  X ", func = Exit, icon = nil, desc = {}},
  
  [1] = {txt = "Dvg Mail", func = nil, icon = "DvgMail/icon", loc = "DvgMail", desc = {
                "Latest version      1.0 ",
                "Updated       10 4 2015 ",
                "Size              5.6kb ",
    "Dvg Mail is a program to send and   ",
    "receive mails between advanced      ",
    "computers just with their ID.       ",
    "To install, just set one computer as",
    "server before using Dvg Mail client "}
  },
  [2] = {txt = "Dvg Chat", func = nil, icon = "DvgChat/icon", loc = "DvgChat", desc = {
                "Latest version      1.0 ",
                "Updated          1 2015 ",
                "Size              2.3kb ",
    "Dvg Chat is a simple program with a ",
    "beautifully designed UI to chat     ",
    "with eachother.                     "}
  },
  [3] = {txt = "Maze game", func = nil, icon = "maze/icon", loc = "maze", desc = {
                "Latest version      1.0 ",
                "Updated          2 2015 ",
                "Size*             5.1kb ",
    "In the Maze game you have to find   ",
    "the end of the maze. You can import ",
    "your own levels or use one of the   ",
    "standard levels.                    ",
    "* Levels not included in size.      "}
  },
  [4] = {txt = "Tic Tac Toe", func = nil, icon = "TicTacToe/icon", loc = "TicTacToe", desc = {
                "Latest version      1.0 ",
                "Updated          2 2015 ",
                "Size              6.6kb ",
    "The Tic Tac Toe game is just what   ",
    "it says it is. You can just play    ",
    "Tic Tac Toe.                        "}
  },
}

-- Functions
function checkUpdate()
  local response = http.get("http://dantevg.nl/files/Latest/wAppShop.txt")
  if response == nil then
    connection = false
    return true
  else
    connection = true
  end
  
  local latest = response.readAll()
  if latest == version then
    return true
  else
    return false
  end
end
function update()
  local response = http.get("http://dantevg.nl/files/Latest/wAppshop.txt")
  if response == nil then
    return false
  else
    connection = true
  end
  
  local file = {}
  local line = response.readLine()
  while line ~= nil do
    table.insert(file, line)
    local line = response.readLine()
  end
end
function printMenu(menu)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  term.setCursorPos(47,1)
  if selected == 0 then
    write(">")
  else
    write(" ")
  end
  term.setBackgroundColor(colors.red)
  print(menu[0].txt)
  
  term.setCursorPos(1,3)
  term.setBackgroundColor(colors.white)
  for i = 1, #menu do
    if i == selected then
      term.setTextColor(colors.black)
      if selectedLev == 1 then
        term.setTextColor(colors.black)
      else
        term.setTextColor(colors.lightGray)
      end
      print(">"..menu[i].txt)
    else
      term.setTextColor(colors.lightGray)
      print(" "..menu[i].txt)
    end
  end
  
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.black)
  term.setCursorPos(16,3)
  if selected ~= 0 then
    if menu[selected].icon ~= nil then
      local icon = paintutils.loadImage("/.DvgFiles/data/"..menu[selected].icon)
      paintutils.drawImage(icon, 16, 3)
    else
      local noicon = paintutils.loadImage("/.DvgFiles/Alpha/icons/noicon")
      paintutils.drawImage(noicon, 16, 3)
    end
    
    term.setBackgroundColor(colors.white)
    term.setCursorPos(28, 3)
    write(menu[selected].txt)
    if #menu[selected].desc > 3 then
      for i = 1, 3 do
        term.setCursorPos(28,4+i)
        write(menu[selected].desc[i])
      end
      for i = 4, #menu[selected].desc do
        term.setCursorPos(16,7+i)
        write(menu[selected].desc[i])
      end
    end
    
    if selectedLev == 2 then
      term.setBackgroundColor(colors.red)
    else
      term.setBackgroundColor(colors.lightGray)
    end
    term.setTextColor(colors.white)
    term.setCursorPos(28,16)
    write("          ")
    term.setCursorPos(28,17)
    write("  DELETE  ")
    term.setCursorPos(28,18)
    write("          ")
    if selectedLev == 3 then
      term.setBackgroundColor(colors.green)
    else
      term.setBackgroundColor(colors.lightGray)
    end
    term.setTextColor(colors.white)
    term.setCursorPos(39,16)
    write("            ")
    term.setCursorPos(39,17)
    write("  DOWNLOAD  ")
    term.setCursorPos(39,18)
    write("            ")
  else
    term.setCursorPos(16, 3)
    write("Select an app to view details.")
    term.setCursorPos(16, 5)
    write("Color codes")
    term.setCursorPos(16, 6)
    term.setTextColor(colors.blue)
    write("Blue: business (Dvg Mail...)")
    term.setCursorPos(16, 7)
    term.setTextColor(colors.red)
    write("Red: Fun (Dvg Chat...)")
    term.setCursorPos(16, 8)
    term.setTextColor(colors.lime)
    write("Lime: game (Maze, Tic Tac Toe...)")
  end
end
function keyPressed(key, menu)
  if key == keys.enter then
    if selectedLev == 1 then
      if menu[selected].func ~= nil then
        menu[selected].func()
      end
    elseif selectedLev == 2 then
      delete("/.DvgFiles/data/"..menu[selected].loc)
    elseif selectedLev == 3 then
      download(menu[selected].download)
    end
  elseif key == keys.up and selected > 0 and selectedLev == 1 then
    selected = selected - 1
  elseif key == keys.down and selected < #menu and selectedLev == 1 then
    selected = selected + 1
  elseif key == keys.left and selectedLev > 1 and selected ~= 0 then
    selectedLev = selectedLev - 1
  elseif key == keys.right and selectedLev < 3 and selected ~= 0 then
    selectedLev = selectedLev + 1
  end
end
function header(...)
  term.setCursorPos(1,1)
  term.setBackgroundColor(colors.blue)
  term.setTextColor(colors.white)
  write(" Alpha OS - wApp Shop                          ")
  if #arg == 1 and arg[1] == true then
    term.setBackgroundColor(colors.red)
    write("  X ")
  else
    write("    ")
  end
  term.setBackgroundColor(colors.white)
end

function main()
  inMain = true
  while inMain do
    term.setBackgroundColor(colors.white)
    term.clear()
    header()
    term.setCursorPos(1,19)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.lightGray)
    write("by DvgCraft")
    if not connection then
      term.setTextColor(colors.red)
      write("  No internet connection*")
    end
    printMenu(mainMenu)
    event, param1, param2, param3 = os.pullEvent()
    if event == "key" then
      keyPressed(param1, mainMenu)
    elseif event == "mouse_click" and param1 == 1 then
      if param2 >= 39 and param2 <= 50 and param3 >= 16 and param3 <= 18 then
        mouseClicked("download", mainMenu)
      end
    end
  end
end

-- Run
local updated = checkUpdate()
if not updated then
  if not connection then return end
  term.setBackgroundColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  term.setBackgroundColor(colors.lightBlue)
  term.setTextColor(colors.white)
  write(" Alpha OS - wApp Shop                          ")
  term.setBackgroundColor(colors.pink)
  print("  X ")
  term.setBackgroundColor(colors.white)
  term.setTextColor(colors.black)
  dvg.center("Updating...", 10)
  update()
end
main()
