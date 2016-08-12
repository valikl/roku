' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ' listen on port 8089
    ? "[HomeScene] Init"

    ' GridScreen node with RowList
    m.gridScreen = m.top.findNode("GridScreen")

    ' DetailsScreen Node with description, Video Player
    m.detailsScreen = m.top.findNode("DetailsScreen")
    
    ' Search Screen with keyboard and RowList
    m.Search = m.top.findNode("Search")

    ' Observer to handle Item selection on RowList inside GridScreen (alias="GridScreen.rowItemSelected")
    m.top.observeField("rowItemSelected", "OnRowItemSelected")

    ' array with nodes (screens) to proper handling of Search screen Open/Close
    m.screenStack = []

    ' gridScreen is a Main Screen
    m.screenStack.push(m.gridScreen)
      ' loading indicator starts at initializatio of channel
    m.loadingIndicator = m.top.findNode("loadingIndicator")
End Function 

' if content set, focus on GridScreen and remove loading indicator
Function OnChangeContent()
    m.gridScreen.setFocus(true)
    m.loadingIndicator.control = "stop"
End Function

' Row item selected handler
Function OnRowItemSelected()
    ' On select any item on home scene, show Details node and hide Grid
    m.gridScreen.visible = "false"
    m.detailsScreen.content = m.gridScreen.focusedContent
    m.detailsScreen.setFocus(true)
    m.detailsScreen.visible = "true"
    m.screenStack.push(m.detailsScreen)
End Function

' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    result = false

    if press then
        if key = "options"
            ' option key handler

            ' hide last opened screen (m.screenStack.peek() gridScreen or detailsScreen)
            m.screenStack.peek().visible = false

            ' add Search screen to Screen stack
            m.screenStack.push(m.Search)

            ' show and focus Search
            m.Search.visible = "true"
            m.Search.setFocus(true)

            m.top.SearchString = ""

        else if key = "back" 
        
            ' if Details opened
            if m.gridScreen.visible = false and m.detailsScreen.videoPlayerVisible = false and m.Search.visible = false then

                ' if detailsScreen is open and video is stopped, details is lastScreen
                details = m.screenStack.pop()
                details.visible = false
                m.screenStack.peek().visible = true
                m.screenStack.peek().setFocus(true)
                result = true

            ' if video player opened
            else if m.detailsScreen.videoPlayerVisible = true then
                m.detailsScreen.videoPlayerVisible = false
                result = true

            ' if search opened from Home
            else if m.Search.visible = true and m.Search.isChildrensVisible = false then
                ' if Search is visible - it must be last element
                search = m.screenStack.pop()
                search.visible = false

                ' after search pop m.screenStack.peek() == last opened screen (gridScreen or detailScreen),
                ' open last screen before search and focus it
                m.screenStack.peek().visible = true
                m.screenStack.peek().setFocus(true)
                result = true        
        end if
    end if
    end if
    return result
End Function

Sub onItemSelected()
    ' first button is Play
   
End Sub
