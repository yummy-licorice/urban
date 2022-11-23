import puppy, os, jsony, terminal

type
  Def = object
    definition: string
    author: string
  Res = object
    list: seq[Def]

if getEnv("URBAN_API_KEY", "") == "":
  stderr.writeLine("No API key found, please set the URBAN_API_KEY environment variable")
  quit 1

if paramCount() < 1:
  stderr.writeLine("Please provide atleast one word to define")
  quit 1

let key = getEnv("URBAN_API_KEY", "")
let query = paramStr(1)
let req = Request(
  url: parseUrl("https://mashape-community-urban-dictionary.p.rapidapi.com/define?term=" & query),
  verb: "get",
  headers: @[
    Header(key: "X-RapidAPI-Key", value: key),
    Header(key: "X-RapidAPI-Host", value: "mashape-community-urban-dictionary.p.rapidapi.com")
  ]
)
let res = fetch(req)
let json = res.body.fromJson(Res)
for item in json.list:
  stdout.styledWriteLine(fgBlue, "Definition from " & item.author)
  echo item.definition & "\n"
