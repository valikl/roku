Function Init()
    ? "[TextScreen] Init"
  m.top.observeField("visible", "onVisibleChange")
  m.text=m.top.findNode("text")
End Function

Sub onVisibleChange()
    ? "[TextScreen] onVisibleChange"
    if m.top.visible = true then
      m.text.setFocus(true)
    end if
End Sub

