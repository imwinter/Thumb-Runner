display.setDefault("background", 255, 255, 255, 1)

function doesFileExist( fname, path )

    local results = false

    local filePath = system.pathForFile( fname, path )

    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "r" )
    end

    if ( filePath ) then
        print( "File found: " .. fname )
        filePath:close()
        results = true
    else
        print( "File does not exist: " .. fname )
    end

    return results
end

local ads = require( "ads" )
local appID=  "ca-app-pub-7134633350641035/6740295304"
local adProvider = "admob"

local function adListener( event )
    -- The 'event' table includes:
    -- event.name: string value of "adsRequest"
    -- event.response: message from the ad provider about the status of this request
    -- event.phase: string value of "loaded", "shown", or "refresh"
    -- event.type: string value of "banner" or "interstitial"
    -- event.isError: boolean true or false

    local msg = event.response
    -- Quick debug message regarding the response from the library
    print( "Message from the ads library: ", msg )

    if ( event.isError ) then
        print( "Error, no ad received", msg )
    else
        print( "Ah ha! Got one!" )
    end
end


ads.init( adProvider, appID, adListener )

ads.show( "banner", { x=0, y=1000000, appID} )


local centerLine = display.newLine( display.contentWidth/2, -40, display.contentWidth/2, display.contentHeight+40 )
centerLine:setStrokeColor( 1, 0, 0, 1 )
centerLine.strokeWidth = 8


local footPlacement = display.newRect( 70, display.contentHeight, 170, 200 )
footPlacement.strokeWidth = 1
footPlacement:setFillColor( 0,1,0 )

local uiBGBG = display.newRect(display.contentCenterX, display.contentCenterY, 260,260)
uiBGBG.strokeWidth = 1
uiBGBG:setFillColor(0,0,1)

local uiBG = display.newRect(display.contentCenterX, display.contentCenterY, 250,250)
uiBG.strokeWidth = 1
uiBG:setFillColor(1,1,1)

function hideUIBG()
	uiBG.isVisible = false
	uiBGBG.isVisible = false
end

function showUIBG()
	uiBG.isVisible = true
	uiBGBG.isVisible = true
end

local highScoreInfo = display.newText( "High Score: ", display.contentWidth/2, display.contentHeight/2 - 80, "Arial", 27 )
highScoreInfo:setFillColor( 0,0,1 )
highScoreInfo.isVisible = false

local widget = require( "widget" )
local inGame = false
print("IG False")
local buttonReplay
local buttonPlay 

local distScore = 0





timeLimit = 5

function startGame()
	inGame = true
	ads.hide( )
end

--[[
function quitButtonPressed( event )
    if ( "ended" == event.phase ) then

    end
end

-- Create the widget
buttonQuit = widget.newButton
{
    label = "QUIT",
    onEvent = quitButtonPressed,
    emboss = false,
    --properties for a rounded rectangle button...
    shape="roundedRect",
    width = 200,
    height = 40,
    cornerRadius = 2,
    fillColor = { default={ 0, 0, 1, 1 }, over={ 0, 1, 0, 0.4 } },
    strokeWidth = 4
  
}

buttonQuit.x = display.contentCenterX
buttonQuit.y = display.contentCenterY
]]--

function playButtonPressed( event )
    if ( "ended" == event.phase ) then
    	hideUIBG()
        timeLimit = 6
        distScore = 0
        buttonPlay.isVisible = false
        buttonPlay:setEnabled( false )
        timer.performWithDelay( 500, startGame )
        highScoreInfo.isVisible = false
    end
end

-- Create the widget
buttonPlay = widget.newButton
{
    label = "PLAY",
    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    fontSize = 20,
    onEvent = playButtonPressed,
    emboss = false,
    --properties for a rounded rectangle button...
    shape="roundedRect",
    width = 200,
    height = 60,
    cornerRadius = 2,
    fillColor = { default={ 0, 0, 1, 1 }, over={ 0, 1, 0, 0.4 } },
    strokeWidth = 4
  
}

buttonPlay.x = display.contentCenterX
buttonPlay.y = display.contentCenterY


function replayButtonPressed( event )
    if ( "ended" == event.phase ) then
    	hideUIBG()
        timeLimit = 6
        distScore = 0
        buttonReplay.isVisible = false
        buttonReplay:setEnabled( false )
        timer.performWithDelay( 500, startGame )
        highScoreInfo.isVisible = false
    end
end

-- Create the widget
buttonReplay = widget.newButton
{
    label = "REPLAY",
    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    fontSize = 20,
    onEvent = replayButtonPressed,
    emboss = false,
    --properties for a rounded rectangle button...
    shape="roundedRect",
    width = 200,
    height = 60,
    cornerRadius = 2,
    fillColor = { default={ 0, 0, 1, 1 }, over={ 0, 1, 0, 0.4 } },
    strokeWidth = 4
  
}

buttonReplay.x = display.contentCenterX
buttonReplay.y = display.contentCenterY

buttonReplay:setEnabled( false )
buttonReplay.isVisible = false


--local distTextTitle = display.newText( "Distance: ", display.contentWidth/4, -30, "Arial", 20)
--distTextTitle:setFillColor(0,0,0)

local distText = display.newText( "Distance: " .. distScore, display.contentWidth/4, -20, "Arial", 25)
distText:setFillColor(1,0,0)


--[[Time Limit]]--
timeLeft = display.newText("Time Left: " .. timeLimit, (display.contentWidth-display.contentWidth/4), -20, "Arial", 25)
timeLeft:setTextColor(255,0,0)


local lastSideTapped = nil



--[[Screen Tap Event]]--
function screenTap(event)
	if (inGame == true) then
		if (event.x < display.contentWidth/2) then
			if(lastSideTapped == nil or lastSideTapped == "Right") then
				lastSideTapped = "Left"
				distScore = distScore + 1
				timer.resume(gameTimer)
				distText.text = "Distance: " .. distScore
				footPlacement.x = display.contentWidth/2 + 90
			end
		else
			if(lastSideTapped == nil or lastSideTapped == "Left") then
				lastSideTapped = "Right"
				distScore = distScore + 1
				timer.resume(gameTimer)
				distText.text = "Distance: " .. distScore
				footPlacement.x = 70
			end
		end
	end
end




--[[Timer Function]]--
local function timerDown()
   timeLimit = timeLimit-1
   timeLeft.text = "Time Left: " .. timeLimit
     if(timeLimit==0)then
     	timer.pause( gameTimer)
  		highScoreInfo.isVisible = true
        inGame = false
        showUIBG()
		ads.show( "banner", { x=0, y=1000000, appID} )
        buttonReplay.isVisible = true
        buttonReplay:setEnabled(true)
        if(doesFileExist("highScore.txt",system.DocumentsDirectory)) then
        	local path = system.pathForFile( "highScore.txt", system.DocumentsDirectory )
			local file = io.open( path, "r" )
			local highScore = file:read( "*a" )
			local highScoreNum = tonumber( highScore)
			io.close( file )
			file = nil
			if(distScore > highScoreNum) then
				local newHighScore = distScore
				local path = system.pathForFile( "highScore.txt", system.DocumentsDirectory )
				local file = io.open( path, "w" )
				file:write( newHighScore )
				highScoreInfo.text = "New High Score: " .. distScore
				print("New High Score: " .. distScore)
				io.close( file )
				file = nil
			else
				highScoreInfo.text = "High Score: " .. highScore
				print("Not as high as: " .. highScore)
			end
		else
			local newHighScore = distScore
			local path = system.pathForFile( "highScore.txt", system.DocumentsDirectory )
			local file = io.open( path, "w" )
			file:write( newHighScore )
			highScoreInfo.text = "New High Score: " .. distScore
			print("New High Score: " .. distScore)
			io.close( file )
			file = nil
		end
     end
 end


gameTimer = timer.performWithDelay(1000, timerDown,-1)
timer.pause(gameTimer)
print("Paused")
display.currentStage:addEventListener( "tap", screenTap )