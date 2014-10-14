local composer = require( "composer" )
local scene = composer.newScene()
counter = 0

function scene:create( event )

    local sceneGroup = self.view

    background = display.newRect(0, 0, display.contentWidth*2, display.contentHeight*3 )
    background:setFillColor(1,1,1)
    sceneGroup:insert(background)

    uiBGBG = display.newRect(display.contentCenterX, display.contentCenterY, 260,260)
    uiBGBG.strokeWidth = 1
    uiBGBG:setFillColor(0,0,1)
    sceneGroup:insert(uiBGBG)

    uiBG = display.newRect(display.contentCenterX, display.contentCenterY, 250,250)
    uiBG.strokeWidth = 1
    uiBG:setFillColor(1,1,1)
    sceneGroup:insert(uiBG)

    instructionsOptions = {
        text = "Watch a short video\nto remove ads\nfor 2 hours!",
        x = display.contentWidth/2 + 7,
        y = display.contentHeight/2 +25,
        font = "Arial",
        fontSize = 25,
        align = "center"
    }
    instructions = display.newText(instructionsOptions)
    instructions:setFillColor( 0,0,1 )
    instructions.isVisible = true
    sceneGroup:insert(instructions)

    buttonWatch = widget.newButton
    {
        label = "WATCH",
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 20,
        onEvent = watchButtonPressed,
        emboss = false,
        --properties for a rounded rectangle button...
        shape="roundedRect",
        width = 200,
        height = 60,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 0, 1, 0, 0.4 } },
        strokeWidth = 4,
        isEnabled = false,
      
    }

    buttonWatch.x = display.contentCenterX
    buttonWatch.y = display.contentCenterY-70
    sceneGroup:insert(buttonWatch)  

    buttonReturn = widget.newButton
    {
        label = "Return to Game",
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 20,
        onEvent = returnButtonPressed,
        emboss = false,
        --properties for a rounded rectangle button...
        shape="roundedRect",
        width = 200,
        height = 40,
        cornerRadius = 2,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 0, 1, 0, 0.4 } },
        strokeWidth = 4
      
    }

    buttonReturn.x = display.contentCenterX
    buttonReturn.y = display.contentCenterY + 100
    sceneGroup:insert(buttonReturn)  


	

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

scene:addEventListener( "create", scene )
adInfo = display.newText( "AI: ", display.contentWidth/2, display.contentHeight/5, "Arial", 25 )
adInfo:setFillColor( 1,0,0 )

ads = require( "ads" )
local vungleID = "com.ianmwinter.games.Thumb_Racer"
local adProvider2 = "vungle"
ads:setCurrentProvider( "vungle" )
ads.init(adProvider2, vungleID, adListener)


_H = display.contentHeight
_W = display.contentWidth


function showAd()
	adInfo.text = "showAd Called"
	adRef = ads.show("interstitial")
end

function adListener( event )
	if(event) then
		adInfo.text = "Receieved Event"
		if event.type == "cachedAdAvailable" then
			watchButton.isEnabled = true
			watchButton:setFillColor( 0,1,0 )
			adInfo.text = "Ad Ready"
		elseif event.type == "isError" then
			adInfo.text = "Error"
		elseif event.type == "adEnd" then
			adInfo.text = "Hope you enjoyed the video!"
		end
	else
		adInfo.text = "No Event"
	end
end

function watchButtonPressed( event )
    if ( "ended" == event.phase ) then
    	showAd()
    	print("press")
    end
end

function returnButtonPressed( event )
    if ( "ended" == event.phase ) then
    	composer.gotoScene( "game" )
    	composer.removeScene( "removeads")
    end
end

adListener()
return scene