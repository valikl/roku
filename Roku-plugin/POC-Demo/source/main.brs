' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

Sub RunUserInterface()
    screen = CreateObject("roSGScreen")
    m.scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()
    print "HHHHHHHHHHHHHH"

    'try to read json
    list= getJson()
    Row1 = GetApiArray(1)
    Row2=GetApiArray(2)
    Row3=GetApiArray(3)
    Row4=GetApiArray(4)
    Row5 = GetApiArray(5)
    Row6=GetApiArray(6)
    Row7=GetApiArray(7)
    Row8=GetApiArray(8)
    searchRow=GetApiArray(1)
    searchRow.Append(Row2)
    searchRow.Append(Row3)
    searchRow.Append(Row4)
    searchRow.Append(Row5)
    searchRow.Append(Row6)
    searchRow.Append(Row7)
    searchRow.Append(Row8)
    'SET 2 TO SEE DATA FROM API
    if 1=2
    list = [
        {
            TITLE : "LESSONS - BEGINERS"
            ContentList : Row1
            ddd: "Df"
        }
        {
            TITLE : "Lessons - intermediate"
            ContentList : Row2
        }
        {
            TITLE : "Lessons - advance"
            ContentList : Row3
        }
       {
            TITLE : "Music"
            ContentList : Row4
        }
        {
            TITLE : "Conventions"
            ContentList : Row5
        }
        {
            TITLE : "Films"
            ContentList : Row6
        }
         {
           TITLE : "Short clips"
            ContentList : Row7
        }
        {
            TITLE : "Kabbalah Revealed (Tony)"
            ContentList : Row8
        }
    ]
    end if
    m.SearchList = [
        {
            TITLE : "Search results"
            ContentList : searchRow
        }
    ]
    m.scene.gridContent = ParseXMLContent(list)
    m.scene.observeField("SearchString", port)
    while(true)
        msg = wait(0, port)
        print "------------------"
        print "msg = "; msg
        if type(msg) = "roSGNodeEvent" and msg.getField() = "SearchString" then
            SearchQuery(m.scene.SearchString)
        end if
        
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
End Sub

sub SearchQuery(SearchString as String)
    m.scene.searchContent = ParseXMLContentSearch(m.SearchList, SearchString)
end sub

Function ParseXMLContentSearch(list As Object, SearchString as String) as Object
    RowItems = createObject("RoSGNode","ContentNode")
    
    for each rowAA in list
    'for index = 0 to 1
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.Title

        for each itemAA in rowAA.ContentList
            if (Instr(1, LCase(itemAA.Title), LCase(SearchString) ) > 0 or Instr(1, LCase(itemAA.Description), LCase(SearchString) ) > 0) and SearchString <>""
                item = createObject("RoSGNode","ContentNode")
                item.SetFields(itemAA)
                row.appendChild(item)
            end if
        end for
        RowItems.appendChild(row)
    end for

    return RowItems
End Function


Function ParseXMLContent(list As Object)
    RowItems = createObject("RoSGNode","ContentNode")
    
    for each rowAA in list
    'for index = 0 to 1
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.Title
        
        for each itemAA in rowAA.ContentList
            item = createObject("RoSGNode","ContentNode")
            item.SetFields(itemAA)
            row.appendChild(item)
        end for
        RowItems.appendChild(row)
    end for

    return RowItems
End Function


Function GetApiArray(row As Integer)
    ' url = CreateObject("roUrlTransfer")
    ' url.SetUrl("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss")
    ' url.SetUrl("C:\Users\valikl\workspace\POC-Demo")

    
    name="pkg:/source/media"+row.ToStr()+".xml"
    
    if row = 1 then
     rsp = ReadAsciiFile("pkg:/source/media.xml")
    else 
     rsp = ReadAsciiFile("pkg:/source/media.xml")
    end if
    ' rsp = url.GetToString()

    responseXML = ParseXML(rsp)
    responseXML = responseXML.GetChildElements()
    responseArray = responseXML.GetChildElements()

    result = []

    for each xmlItem in responseArray
        if xmlItem.getName() = "item"
            itemAA = xmlItem.GetChildElements()
            if itemAA <> invalid
                item = {}
                item.contentType="movie"
                for each xmlItem in itemAA
                    item[xmlItem.getName()] = xmlItem.getText()
                    if xmlItem.getName() = "media:content"
                        item.stream = {url : xmlItem.url}
                        item.url = xmlItem.getAttributes().url
                        item.streamFormat = "mp4"
                        
                        mediaContent = xmlItem.GetChildElements()
                        for each mediaContentItem in mediaContent
                            if mediaContentItem.getName() = "media:thumbnail"
                                item.HDPosterUrl = mediaContentItem.getattributes().url
                                item.hdBackgroundImageUrl = mediaContentItem.getattributes().urlBackGround
                            end if
                        end for
                    end if
                end for
                result.push(item)
            end if
        end if
    end for

    return result
End Function


Function ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml=CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function

function getJson()
    searchRequest = CreateObject("roUrlTransfer")
    searchRequest.SetURL("http://10.66.24.124/kirby-roku/kabbalah-channel/")
    json = searchRequest.GetToString()
    'print json

    responseJson = ParseJson(json)
    list = []
    for each category in responseJson
    
    if category.Type="category"
             cat={}
             cat.TITLE=category.title
             result = []
            for each category_item in category.children
                item = {}
                if category_item.TYPE="playlist" 
                    item.contenttype="season"
                    item.title=category_item.title
                    item.description=category_item.description
                    item.HDPosterUrl = category_item.image_url
                    item.children=category_item.children
                    item.Categories=cat.Title
                    item.hdBackgroundImageUrl = category_item.background_image_url
                else 
                    item.contentType="movie"
                    item.stream = category_item.video_url
                    item.url = category_item.video_url
                    item.streamFormat = "mp4"
                    item.HDPosterUrl = category_item.side_image_url
                    item.hdBackgroundImageUrl = category_item.background_image_url
                    item.title=category_item.title
                    item.description=category_item.description
                    
                end if
             result.push(item)
            end for 
             cat.ContentList=result
             list.push(cat)
       end if
    end for
    return list
end function
