function init()
    m.top.functionName = "getcontent"
end function

' Step 2
sub getcontent()
    httpRequest = CreateObject("roUrlTransfer")
    ' uncomment for HTTPS
    ' httpRequest.SetCertificatesFile("common:/certs/ca-bundle.crt")
    ' httpRequest.AddHeader("X-Roku-Reserved-Dev-Id", "")
    ' httpRequest.InitClientCertificates()
    httpRequest.AddHeader("secret-key", "") ' you must set the secret key
    httpRequest.SetUrl(m.top.contenturi)

    res = httpRequest.GetToString()
    ' For a real world scenario you would need to handle errors
    json = parseJSON(res)

    ' Step 6
    ' Using the `data` entry from the JSON object retrieved
    ' from Step 2, sort that list from high to low.
    '
    ' I did this in this file to make passing the data
    ' around easier by putting things in one ArrayList
    ' Ideally something like this could be refactored
    sorted = json.data
    sorted.Sort("r") ' r flag will sort from high to low

    ' Step 6.a
    ' Present the LAST FIVE results
    ' to the screen below the Spectrum image on “Screen A” from Step 3.
    '
    ' assume this means last 5 in the array, keeping same order high -> low
    c = sorted.Count()
    last5 = [
        StrI(sorted[c - 5], 10), ' convert our values to strings for later
        StrI(sorted[c - 4], 10),
        StrI(sorted[c - 3], 10),
        StrI(sorted[c - 2], 10),
        StrI(sorted[c - 1], 10)
    ]

    ' Step 7
    ' Create a function to find all the even numbers.
    ' a) Present the FIRST FIVE results above the Spectrum image on “Screen B”.
    '
    ' working off the same sorted list
    evens = evenNumbers(sorted)
    firstEven5 = [
        StrI(evens[0], 10),
        StrI(evens[1], 10),
        StrI(evens[2], 10),
        StrI(evens[3], 10),
        StrI(evens[4], 10)
    ]

    ' I put our data into ContentNodes
    ' this seems to be the preferred way according to the reference docs.
    '
    ' Having some sort of simple Manager Class or Observer pattern
    ' might better way to manage passing objects and state,
    ' if that is possible...
    '
    ' We have to manually set these values
    ' because the JSON is returning an object and not an arrayList

    containerNode = createObject("roSGNode", "ContentNode")

    a = createObject("roSGNode", "ContentNode")
    a.title = json.screens.a.title
    a.SDPosterUrl = json.screens.a.logo
    a.actors = last5 ' actors support an ArrayList
    containerNode.appendChild(a)

    b = createObject("roSGNode", "ContentNode")
    b.title = json.screens.b.title
    b.SDPosterUrl = json.screens.b.logo
    b.actors = firstEven5 ' actors support an ArrayList
    containerNode.appendChild(b)

    m.top.content = containerNode
end sub

' Step 7.1a
' Create a function to find all the even numbers.
function evenNumbers(nums as object) as object
    temp = []
    for each n in nums
        if n MOD 2 = 0
            temp.push(n)
        end if
    end for

    ' In the real world you might want to guard against
    ' edge cases, such as an empty array
    return temp
end function