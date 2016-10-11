Function Init()
    ? "[Options] init"

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    
    m.buttons           =   m.top.findNode("Buttons")
    ' create buttons
    result = []
    for each button in ["Play", "Second"]
        result.push({title : button})
    end for
    m.buttons.content = ContentList2SimpleNode(result)
End Function

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
    ? ">>> Options >> onKeyEvent"
    result = false
    if press then
        ? "key == ";  key
        if key = "back"
            ' if Details opened

        end if
    end if
    return result
end function

Sub onVisibleChange()
    ? "[Options] onVisibleChange"
    if m.top.visible = true then
        m.buttons.jumpToItem = 0
        m.buttons.setFocus(true)
    end if
End Sub

Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.buttons.hasFocus() then
        m.buttons.setFocus(true)
    end if
End Sub

Sub onItemSelected()
    ' first button is Play
  '  if m.top.itemSelected = 0
   ' end if
End Sub