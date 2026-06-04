// this expects to be passed --format html --input "content=$(tree -J content/)"

#let dir-listing(path, nodes) = for n in nodes {
    if n.type == "file" and n.name.ends-with(".pdf") [
        #html.li[
            #link(path + n.name)[#n.name.slice(0, -4)]
        ]
    ] else if n.type == "directory" and not n.name.starts-with("_") [
        #html.elem("li")[
            #n.name \
            #html.elem("ul", attrs: (style: "padding-left: 1cm;"),
                dir-listing(path + n.name + "/", n.contents)
            )
        ]
    ]
}

#html.html[
    #html.head[
        #html.meta(charset: "utf-8")
        #html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
        #html.title[Document Collection]
        #html.link(rel: "stylesheet", href: "https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css")
    ]

    #html.body[
        #html.elem("section", attrs: (class: "section"))[
            #html.elem("div", attrs: (class: "container"))[
                #html.elem("div", attrs: (class: "block"))[
                    *Hi!* I'm Lukas Buchli, and this is my collection of various documents.
                ]
                #html.elem("div", attrs: (class: "block"))[
                    #html.elem("aside", attrs: (class: "menu"))[
                        #html.elem("p", attrs: (class: "menu-label"))[Documents]
                        #html.ul[
                            #box(dir-listing("/content/", json(bytes(sys.inputs.content)).at(0).contents))
                        ]
                    ]
                ]
                #html.hr()
                #html.elem("div", attrs: (class: "block content"))[
                    This website is multi-licensed:
                    - Documents & Content: All summaries, cheatsheets, presentations,
                      and other website content are licensed under the
                      #link("/LICENSE-CC-BY-SA-4.txt")[Creative Commons
                      Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) license].
                    - Code & Templates: All Typst source code, templates, scripts, and build
                      configurations (available in the
                      #link("https://github.com/lbuchli/Docs")[repository]) are licensed under the
                      #link("/LICENSE-GPLv3.txt")[GNU General Public License v3.0].
                ]
            ]
        ]
    ]
]
