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

    if ( event.isError ) then
        print( "Error, no ad received", msg )
    end
end


ads.init( adProvider, appID, adListener )

ads.show( "banner", { x=0, y=1000000, appID} )


local titleText = display.newText("THUMB RACER", display.contentWidth/2, -22, "Arial", 35 )
titleText:setFillColor( 0,0,1 )


local centerLine = display.newLine( display.contentWidth/2, 0, display.contentWidth/2, display.contentHeight+50 )
centerLine:setStrokeColor( 0, 0, 1, 1 )
centerLine.strokeWidth = 8

local topLine = display.newLine(0,0, display.contentWidth, 0)
topLine:setStrokeColor( 0, 0, 1, 1 )
topLine.strokeWidth = 8


local footPlacement = display.newRect( 70, display.contentHeight, 170, 200 )
footPlacement.strokeWidth = 1
footPlacement:setFillColor( 0,1,0 )

--[[UI Background Code]] --
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
---------------------------

local highScoreInfo = display.newText( "High Score: ", display.contentWidth/2, display.contentHeight/2 - 60, "Arial", 27 )
highScoreInfo:setFillColor( 0,0,1 )
highScoreInfo.isVisible = false

local currentScoreInfo = display.newText( "Your Score:", display.contentWidth/2, display.contentHeight/2 - 100, "Arial", 27 )
currentScoreInfo:setFillColor( 0,0,1 )
currentScoreInfo.isVisible = false

local instructionsOptions = {
	text = "INSTRUCTIONS\nTap the green square\n as many times as you can\n before the time runs out!",
	x = display.contentWidth/2,
	y = display.contentHeight/2 +25,
	font = "Arial",
	fontSize = 21,
	align = "center"
}
local instructions = display.newText(instructionsOptions)
instructions:setFillColor( 0,0,1 )
instructions.isVisible = true

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


function playButtonPressed( event )
    if ( "ended" == event.phase ) then
    	hideUIBG()
        timeLimit = 6
        distScore = 0
        buttonPlay.isVisible = false
        instructions.isVisible = false
        buttonPlay:setEnabled( false )
        timer.performWithDelay( 500, startGame )
        highScoreInfo.isVisible = false
        currentScoreInfo.isVisible = false
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
buttonPlay.y = display.contentCenterY-70


function replayButtonPressed( event )
    if ( "ended" == event.phase ) then
    	hideUIBG()
        timeLimit = 6
        timeLeft.text = "6"
        distScore = 0
        buttonReplay.isVisible = false
        instructions.isVisible = false
        buttonReplay:setEnabled( false )
        timer.performWithDelay( 500, startGame )
        highScoreInfo.isVisible = false
        currentScoreInfo.isVisible = false
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

local distOptions = {
	text = "Distance",
	x = display.contentWidth/4,
	y = 40,
	font = "Arial",
	fontSize = 25,
	align = "center"
}

local distText = display.newText( distOptions )
distText:setFillColor(0,0,1)

local distValueOptions = {
	text = distScore,
	x = display.contentWidth/4,
	y = 83,
	font = "Arial",
	fontSize = 60,
	align = "center"
}

local distValueText = display.newText( distValueOptions )
distValueText:setFillColor(0,1,0)

--[[Time Limit]]--
local timerTextOptions = {
	text = "Time Left",
	x = (display.contentWidth/4) * 3,
	y = 40,
	font = "Arial",
	fontSize = 25,
	align = "center"
}
local timerText = display.newText( timerTextOptions)
timerText:setTextColor(0,0,1)


local timeLeftOptions = {
	text = "6",
	x = (display.contentWidth/4) * 3,
	y = 83,
	font = "Arial",
	fontSize = 60,
	align = "center"
}
timeLeft = display.newText( timeLeftOptions )
timeLeft:setTextColor(1,0,0)


local lastSideTapped = nil



--[[Screen Tap Event]]--
function screenTap(event)
	if (inGame == true) then
		if (event.x < display.contentWidth/2) then
			if(lastSideTapped == nil or lastSideTapped == "Right") then
				lastSideTapped = "Left"
				distScore = distScore + 1
				timer.resume(gameTimer)
				distValueText.text = distScore
				footPlacement.x = display.contentWidth/2 + 90
			end
		else
			if(lastSideTapped == nil or lastSideTapped == "Left") then
				lastSideTapped = "Right"
				distScore = distScore + 1
				timer.resume(gameTimer)
				distValueText.text = distScore
				footPlacement.x = 70
			end
		end
	end
end




--[[Timer Function]]--
local function timerDown()
   timeLimit = timeLimit-1
   timeLeft.text = timeLimit
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
				io.close( file )
				file = nil
			else
				currentScoreInfo.isVisible = true
				currentScoreInfo.text = "Your Score: " .. distScore
				highScoreInfo.text = "High Score: " .. highScore
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
display.currentStage:addEventListener( "touch", screenTap )