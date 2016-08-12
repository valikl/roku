' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid Screen
 ' creates all children
 ' sets all observers 
Function Init()
    ? "[GridScreen] Init"

    m.rowList       =   m.top.findNode("RowList")
    m.description   =   m.top.findNode("Description")
    m.background    =   m.top.findNode("Background")

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.buttons =  m.top.findNode("Buttons")
    
    fields = m.top.getFields()
    for each f in fields
        print f
    end for
    
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
function onKeyEvent(key as String, press as Boolean) as Boolean
 ? ">>> GridScreen >> OnkeyEvent"
 print key
result = false
  if press then
        if key="up" then
            m.rowList.setFocus(false)
            m.buttons.setFocus(true)
           m.buttons.uri="http://i.imgsafe.org/ea30b5e1ce.png"
            print "in"
            result = true
         else if key="down"
         m.buttons.uri="http://www.laitman.ru/wp-content/gallery/vstrechi-poezdki/laitman-in-japanese_w.jpg"
         m.rowList.setFocus(true)
         else if key="OK"
            print "Ok button clicked "
         else if key="right"
           itemFocused = m.top.itemFocused
        ' item focused should be an intarray with row and col of focused element in RowList
            If itemFocused.Count() = 2 then
                focusedContent          = m.top.content.getChild(itemFocused[0]).getChild(0)
                
                if focusedContent <> invalid then
                m.top.focusedContent    = focusedContent
                print focusedContent
               
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