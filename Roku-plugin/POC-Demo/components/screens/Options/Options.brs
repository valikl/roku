Function Init()
    ? "[Options] Init"

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.txtScreen=m.top.findNode("txtScreen")
    
    m.buttons           =   m.top.findNode("Buttons")
    ' create buttons
   onButtonsSet()
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
            if m.txtScreen.visible then
                m.txtScreen.visible=false
                 m.buttons.setFocus(true)
                result=true
            end if

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
    if m.top.isInFocusChain() and not m.buttons.hasFocus() and not m.txtScreen.visible then
        m.buttons.setFocus(true)
    end if
End Sub
Sub onButtonsSet()
if m.top.items<> invalid and m.top.items<>"" then
    m.opt=CreateObject("roSGNode", "SimpleTask")
    m.opt.sourceUrl=LCase(m.top.items)
    m.opt.ObserveField("result", "onOptionsSet")
    m.opt.control="RUN"
end if
   ' m.btnLst=["About", "Second"]
   ' result = []
  '  for each button in m.btnLst
   '     result.push({title : button, id:"test"})
  '  end for
  '  m.buttons.content = ContentList2SimpleNode(result)
End Sub

function onOptionsSet()
 responseJson = ParseJson(m.opt.result)
    result = []
    for each category_item in responseJson
        result.Push({title:category_item.Title,id:category_item.uri})
    end for
     m.buttons.content = ContentList2SimpleNode(result)
end function
Sub onItemSelected()
    m.temp=CreateObject("roSGNode", "SimpleTask")
    m.temp.sourceUrl=LCase(m.buttons.content.getChild(m.top.itemSelected).id)
    m.temp.ObserveField("result", "onDataChanged")
    m.temp.control="RUN"
End Sub
function onDataChanged()
  res=GetPlayListJson() 
  m.buttons.setFocus(false)
  m.txtScreen.Text=res.description
  m.txtScreen.setFocus(true)
  m.txtScreen.visible=true
  m.txtScreen.BackgroundImg=res.hdBackgroundImageUrl
  m.txtScreen.Title=res.Title  
End function

function GetPlayListJson()    
    responseJson = ParseJson(m.temp.result)
        for each category_item in responseJson
            item = {}
            item.title=category_item.title
            item.description=category_item.text
            item.hdBackgroundImageUrl=category_item.background_image_url
            return item
        end for 
end function