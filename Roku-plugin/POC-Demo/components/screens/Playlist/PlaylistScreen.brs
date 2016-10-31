' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits details Screen
 ' sets all observers 
 ' configures buttons for Details screen
Function Init()
    ? "[PlaylistScreen] init"

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")

    m.buttons           =   m.top.findNode("Buttons")
    m.videoPlayer       =   m.top.findNode("VideoPlayer")
   ' m.poster            =   m.top.findNode("Poster")
    m.description       =   m.top.findNode("Description")
    m.background        =   m.top.findNode("Background")
    m.playListItems       =   m.top.findNode("PlaylistItems")
    m.about=m.top.findNode("about")
    ' create buttons
    result = []
    for each button in ["Play"]
        result.push({title : button})
    end for
    m.buttons.content = ContentList2SimpleNode(result)
End Function

function onKeyEvent(key as String, press as Boolean) as Boolean
 ? ">>> PlayList >> OnkeyEvent"
result = false
print key
 if key="up" then
     m.playListItems.setFocus(false)
     m.buttons.setFocus(true)
     result=true
 else if key="down" then
    m.buttons.setFocus(false)
    m.playListItems.setFocus(true)
    result= true
 else if m.top.visible=true and key="OK" and  m.description.content<>invalid and  m.stopEvent<>true then
        m.videoPlayer.visible = true
        m.videoPlayer.setFocus(true)
        m.videoPlayer.control = "play"
        m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
        result =true
 end if
 m.stopEvent=false
 return result
End Function

' set proper focus to buttons if Details opened and stops Video if Details closed
Sub onVisibleChange()
    ? "[PlaylistScreen] onVisibleChange"
    if m.top.visible = true then
        m.stopEvent=true
        'm.buttons.jumpToItem = 0
        m.playListItems.setFocus(true) 
    else
        m.videoPlayer.visible = false
        m.videoPlayer.control = "stop"
    end if
End Sub

' set proper focus to Buttons in case if return from Video PLayer
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.buttons.hasFocus() and not m.videoPlayer.hasFocus() and not m.playListItems.hasFocus() then
        m.buttons.setFocus(true)
    end if
End Sub
Sub OnItemFocused()
    itemFocused = m.top.itemFocused
    If itemFocused.Count() = 2 then
        focusedContent          = m.top.PLcontent.getChild(itemFocused[0]).getChild(itemFocused[1])
        if focusedContent <> invalid then
        '    m.top.focusedContent    = focusedContent
            m.description.content   = focusedContent
            m.background.uri        = focusedContent.hdBackgroundImageUrl
            m.videoPlayer.content =focusedContent
        end if
    end if
     'm.buttons.setFocus(true)
End Sub
' set proper focus on buttons and stops video if return from Playback to details
Sub onVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        m.buttons.setFocus(true)
        m.videoPlayer.control = "stop"
    end if
End Sub

' event handler of Video player msg
Sub OnVideoPlayerStateChange()
    if m.videoPlayer.state = "error"
        ' error handling
        m.videoPlayer.visible = false
    else if m.videoPlayer.state = "playing"
        ' playback handling
    else if m.videoPlayer.state = "finished"
        m.videoPlayer.visible = false
    end if
End Sub

' on Button press handler
Sub onItemSelected()
    ' first button is Play
    if m.top.itemSelected = 0
        m.videoPlayer.visible = true
        m.videoPlayer.setFocus(true)
        m.videoPlayer.control = "play"
        m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
    end if
End Sub

' Content change handler
Sub OnContentChange()
    if m.top.content<>invalid then
        m.description.content   = m.top.content
        m.description.Description.width = "770"
       ' m.videoPlayer.content   = m.top.content
        m.top.streamUrl         = m.top.content.url
       ' m.poster.uri            = m.top.content.HDPosterUrl
        m.background.uri        = m.top.content.hdBackgroundImageUrl
        m.temp=CreateObject("roSGNode", "SimpleTask")
        m.temp.sourceUrl=LCase(m.top.content.id)
        m.temp.ObserveField("result", "onDataChanged")
        m.temp.control="RUN"
    end if
End Sub

function onDataChanged()
  res=GetPlayListJson() 
  items=ParseXMLContent(res)
  m.playListItems.content = items
  m.playListItems.setFocus(true)
     
End function
Function ParseXMLContent(list As Object)
        row = createObject("RoSGNode","ContentNode")
        row.Title =""      
        for each itemAA in list
            item = createObject("RoSGNode","ContentNode")
            item.SetFields(itemAA)
            row.appendChild(item)
        end for
     RowItems = createObject("RoSGNode","ContentNode")
     RowItems.appendChild(row)
    return RowItems
End Function
function GetPlayListJson()    
    responseJson = ParseJson(m.temp.result)
    list = []
        for each category_item in responseJson
            item = {}
            item.contentType="movie"
            item.stream = category_item.video_url
            item.url = category_item.video_url
            item.streamFormat = "mp4"
            item.HDPosterUrl = category_item.side_image_url
            item.hdBackgroundImageUrl = category_item.background_image_url
            item.title=category_item.title
            item.description=category_item.description
            list.push(item)
        end for 
    return list
end function

'///////////////////////////////////////////'
' Helper function convert AA to Node
Function ContentList2SimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = createObject("roSGNode",nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = createObject("roSGNode", nodeType)
            item.setFields(itemAA)
            result.appendChild(item)
        end for
    end if
    return result
End Function
