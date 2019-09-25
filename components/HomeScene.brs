sub init()
    m.title = m.top.findNode("title")
    m.dataDisplay = m.top.findNode("data")
    m.poster = m.top.findNode("poster")
    m.button = m.top.findNode("screenButton")
    m.button.setFocus(true)
    m.button.observeField("buttonSelected", "onButtonSelect")

    m.top.backgroundURI = "" ' this is needed so we can overwrite the background color
    m.top.backgroundColor = "0x777777FF"

    m.apiRequest = createObject("roSGNode", "ContentReader")
    m.apiRequest.observeField("content", "setupHomeScreen")

    ' You will need to set the URLs for the api request
    ' I did not want to accidentally include sensitive info
    '
    ' I didn't research this far but ideally
    ' these would be set through environment variables
    m.apiRequest.contenturi = ""
    m.apiRequest.control = "RUN"
end sub

sub setupHomeScreen()
    element = m.apiRequest.content.getChild(0)
    m.title.text = element.title
    m.poster.uri = element.SDPosterUrl
    m.dataDisplay.text = combineStrings(element.actors)
end sub

function onButtonSelect()
    if m.button.text = "Go to Screen B" then
        m.button.text = "Go to Screen A"
        m.top.backgroundColor = "0xEB1010FF"
        element = m.apiRequest.content.getChild(1)
        m.title.text = element.title
        m.poster.uri = element.SDPosterUrl
        m.dataDisplay.text = combineStrings(element.actors) ' actors holds our numbers
        m.dataDisplay.vertAlign = "top"
        m.dataDisplay.translation = "[0,60]"
    else
        m.button.text = "Go to Screen B"
        m.top.backgroundColor = "0x777777FF"
        element = m.apiRequest.content.getChild(0)
        m.title.text = element.title
        m.poster.uri = element.SDPosterUrl
        m.dataDisplay.text = combineStrings(element.actors) ' actors holds our numbers
        m.dataDisplay.vertAlign = "bottom"
        m.dataDisplay.translation = "[0,-80]"
    end if
end function

' ideally check for edge cases such as
' non-string arrays
function combineStrings(strArray as object) as string
    temp = ""
    for each s in strArray
        temp += " " + s
    end for

    return temp
end function