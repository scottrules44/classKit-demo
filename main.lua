local classKit = require "plugin.classKit"
local widget = require "widget"
local json = require "json"
local bg = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)

local title = display.newText( "Class Kit Plugin", display.contentCenterX, 50, native.systemFontBold, 20 )
title:setFillColor( 0 )

local content = {
	{ ["type"]= "quiz",["title"] = "Math Quiz", ["id"] = "com.scotth.mathQuiz", ["universalLinkURL"]="testApp://mathQuiz" },
}
local mathScore = 0
--Not coded the best way but only for demo purposes
function mathQ1(  )
	native.showAlert( "Math Quiz","12+5=", { "17", "19","21","32" }, function ( event )
		if ( event.action == "clicked" ) then
	        local i = event.index
	        if ( i == 1 ) then
	            mathScore = mathScore+50
	        end

	        mathQ2(  )
	    end
	end )
end
function mathQ2(  )
	native.showAlert("Math Quiz", "12-5=", { "4", "8","7","3" }, function ( event )
		if ( event.action == "clicked" ) then
	        local i = event.index
	        if ( i == 3 ) then
	            mathScore = mathScore+50
	        end
	        classKit.addItemActivity("score", {title="math quiz", score = mathScore, maxScore = 100, id = "com.scotth.mathQuiz"})
	        
	        classKit.setProgressActivity(1)
	        classKit.stopActivity()
	        classKit.saveData()
	        classKit.removeContext("com.scotth.mathQuiz", function()
            end)


	        
	        native.showAlert("Math Score", mathScore.."%", {"Ok" }, function (  )
	        	
	        end )
	        mathScore = 0
	    end
	end )
end
--
local mathQuiz= widget.newButton({
label = "Load math quiz",
x = display.contentCenterX,
y = display.contentCenterY-100,
id = "Math Quiz",
labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
onRelease =  function ()
	classKit.startContext("com.scotth.mathQuiz", function(e)
        if e.isError == false then
            classKit.createActivity("com.scotth.mathQuiz", function(e)
                classKit.startActivity()
                mathQ1()
            end)
        end
    end)
end

})

classKit.addContent(content)

-- Open via url scheme
local launchArgs = ...

if ( launchArgs ) then
    if launchArgs.url == "testApp://mathQuiz" then
        classKit.startActivity()
        mathQ1()
    end
end
local function onSystemEvent( event )
    if event.url == "testApp://mathQuiz" then
        classKit.startActivity()
        mathQ1()
    end
end

Runtime:addEventListener( "system", onSystemEvent )
