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
    
    'Playlist node
    m.playlistScreen=m.top.findNode("PlaylistScreen")
    
    ' Search Screen with keyboard and RowList
    m.Search = m.top.findNode("Search")
    
    m.Options=m.top.findNode("Options")

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
    if m.gridScreen.focusedContent.contentType=3
        m.gridScreen.visible = "false"
        m.playlistScreen.content = m.gridScreen.focusedContent
        m.playlistScreen.setFocus(true)
        m.playlistScreen.visible = "true"
        m.screenStack.push(m.playlistScreen)
    else
        m.gridScreen.visible = "false"
        m.detailsScreen.content = m.gridScreen.focusedContent
        m.detailsScreen.setFocus(true)
        m.detailsScreen.visible = "true"
        m.screenStack.push(m.detailsScreen)
    end if
End Function

' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    result = false

    if press then
        if key = "options"
            ' option key handler

            ' hide last opened screen (m.screenStack.peek() gridScreen or detailsScreen)
            'm.screenStack.peek().visible = false

            ' add Search screen to Screen stack
            m.screenStack.push(m.Options)

            ' show and focus Search
            m.Options.visible = "true"
            m.Options.setFocus(true)

            'm.top.SearchString = ""

        else if key = "back" 
            ' if Details opened
            if m.gridScreen.visible = false and m.detailsScreen.visible=true and m.detailsScreen.videoPlayerVisible = false and m.Options.visible = false then

                ' if detailsScreen is open and video is stopped, details is lastScreen
                details = m.screenStack.pop()
                details.visible = false
                m.screenStack.peek().visible = true
                m.screenStack.peek().setFocus(true)
                result = true
            else if m.gridScreen.visible = false and m.playlistScreen.visible=true and m.playlistScreen.videoPlayerVisible = false and m.Options.visible = false then
                details = m.screenStack.pop()
                details.visible = false
                m.screenStack.peek().visible = true
                m.screenStack.peek().setFocus(true)
                result = true
            else if  m.playlistScreen.videoPlayerVisible = true  then
                  m.playlistScreen.videoPlayerVisible = false
                result = true
            ' if video player opened
            else if m.detailsScreen.videoPlayerVisible = true then
                m.detailsScreen.videoPlayerVisible = false
                result = true

            ' if search opened from Home
            else if m.Options.visible = true then
                ' if Search is visible - it must be last element
                options = m.screenStack.pop()
                options.visible = false

                ' after search pop m.screenStack.peek() == last opened screen (gridScreen or detailScreen),
                ' open last screen before search and focus it
                m.screenStack.peek().visible = false
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
