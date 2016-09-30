Function Init()
    ? "[DetailsScreen] init"

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")

    m.buttons           =   m.top.findNode("Buttons")
    m.poster            =   m.top.findNode("Poster")



    ' create buttons
    result = []
    for each button in ["Play", "Second"]
        result.push({title : button})
    end for
    m.buttons.content = ContentList2SimpleNode(result)
End Function