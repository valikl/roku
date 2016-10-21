' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid Screen
 ' creates all children
 ' sets all observers 
Function Init()
    ? "[GridScreen] Init"

    m.rowList       =   m.top.findNode("RowList")
    m.description   =   m.top.findNode("Description")
    m.background    =   m.top.findNode("Background")
    m.videoPlayer       =   m.top.findNode("VideoPlayer")
    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.buttons =  m.top.findNode("Buttons")
    

     ' create buttons
    result = []
    for each button in ["Watch Livestream"]
        result.push({title : button, hdBackgroundImageUrl:"http://www.laitman.ru/wp-content/gallery/vstrechi-poezdki/laitman-in-japanese_w.jpg"})
    end for
    'm.buttons.content = ContentList2SimpleNode(result)

End Function

Sub onItemSelected()
    ' first button is Play
   ' if m.top.itemSelected = 0
     print "Jopa1"
   ' end if
End Sub

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
Sub onVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        m.buttons.setFocus(true)
        m.videoPlayer.control = "stop"
    end if
End Sub
function onKeyEvent(key as String, press as Boolean) as Boolean
 ? ">>> GridScreen >> OnkeyEvent"
 print key
result = false
  if press then
        if key="up" then
        if m.top.liveStreamEnabled then
           m.rowList.setFocus(false)
           m.buttons.setFocus(true)
            ''Take images from somewhere
           m.buttons.uri=m.top.liveStreamSelectedImage
           m.background.uri=m.top.liveStreamSelectedBackground
           result = true
         end if
         else if key="down"
          if m.top.liveStreamEnabled then
             m.buttons.uri=m.top.liveStreamUnselectedImage
             m.rowList.setFocus(true)
          end if
         else if key="OK"
             if m.top.liveStreamEnabled and m.background.uri=m.top.liveStreamSelectedBackground then
               videoContent = createObject("RoSGNode", "ContentNode")
               videoContent.url = m.top.liveStreamURL
               videoContent.title = "Live Stream"
               m.videoPlayer.content=videoContent
               m.videoPlayer.visible = true
               m.videoPlayer.setFocus(true)
               m.videoPlayer.control = "play"
               m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
               result = true
             end if
         else if key="right"
           itemFocused = m.top.itemFocused
        ' item focused should be an intarray with row and col of focused element in RowList
            If itemFocused.Count() = 2 then
                focusedContent          = m.top.content.getChild(itemFocused[0]).getChild(0)
                
                if focusedContent <> invalid then
                m.top.focusedContent    = focusedContent
               
              end if
             end if    
         end if    
  end if
   return result
End Function
' handler of focused item in RowList
Sub OnItemFocused()
    itemFocused = m.top.itemFocused
    ' item focused should be an intarray with row and col of focused element in RowList
    If itemFocused.Count() = 2 then
        focusedContent          = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])
        if focusedContent <> invalid then
            m.top.focusedContent    = focusedContent
            m.description.content   = focusedContent
            m.background.uri        = focusedContent.hdBackgroundImageUrl
        end if
    end if
     'm.buttons.setFocus(true)
End Sub

' set proper focus to RowList in case if return from Details Screen
Sub onVisibleChange()
    if m.top.visible = true then
        m.rowList.setFocus(true)
    end if
End Sub

' set proper focus to RowList in case if return from Details Screen
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.rowList.hasFocus() then
       'm.rowList.setFocus(true)
    end if
End Sub
