alias Points.Plan
alias Points.Report

# Steps taken from a [Chris McCord Gist](https://gist.githubusercontent.com/chrismccord/d5bc5f8e38c8f76cad33/raw/6be399a453203d275dd68ff591d2f09b73fc5b4f/upgrade.md):

(fn ->
   {:ok, project} = Report.create_project(%{title: "Pritchett's Closets & Blinds"})

   Plan.create_ticket(project, %{title: "Clone Jira Boards for Phoenix 1.1.1 to 1.1.2 upgrade instructions"})

   Plan.create_ticket(project, %{
    title: "Markdown Formatting",
    description: """
                 ---
                 __Advertisement__
                 
                 - __[pica](https://nodeca.github.io/pica/demo/)__ - high quality and fast image
                   resize in browser.
                 - __[babelfish](https://github.com/nodeca/babelfish/)__ - developer friendly
                   i18n with plurals support and easy syntax.
                 
                 You will like those projects!
                 
                 ---
                 
                 # h1 Heading

                 paragrah

                 ## h2 Heading

                 paragrah

                 ### h3 Heading

                 paragrah

                 #### h4 Heading

                 paragrah

                 ##### h5 Heading

                 paragrah

                 ###### h6 Heading
                 
                 paragrah
                 
                 ## Horizontal Rules
                 
                 ___
                 
                 ---
                 
                 ***
                 
                 
                 ## Typographic replacements
                 
                 "Smartypants, double quotes" and 'single quotes'
                 
                 
                 ## Emphasis
                 
                 **This is bold text**
                 
                 __This is bold text__
                 
                 *This is italic text*
                 
                 _This is italic text_
                 
                 ~~Strikethrough~~
                 
                 
                 ## Blockquotes
                 
                 
                 > Blockquotes can also be nested...
                 >> ...by using additional greater-than signs right next to each other...
                 > > > ...or with spaces between arrows.
                 
                 
                 ## Lists
                                  
                 + Create a list by starting a line with `+`, `-`, or `*`
                 + Sub-lists are made by indenting 2 spaces:
                   - Marker character change forces new list start:
                     * Ac tristique libero volutpat at
                     + Facilisis in pretium nisl aliquet
                     - Nulla volutpat aliquam velit
                 + Very easy!
                 
                 Ordered
                 
                 1. Lorem ipsum dolor sit amet
                 2. Consectetur adipiscing elit
                 3. Integer molestie lorem at massa
                 
                 
                 1. You can use sequential numbers...
                 1. ...or keep all the numbers as `1.`
                 
                 Start numbering with offset:
                 
                 57. foo
                 1. bar
                 
                 
                 ## Code
                 
                 Inline `code` looks like this
                 
                 Indented code
                 
                     // Some comments
                     line 1 of code
                     line 2 of code
                     line 3 of code
                 
                 
                 Block code "fences"
                 
                 ```
                 Sample text here...
                 ```

                 
                 ## Tables
                 
                 | Option | Description |
                 | ------ | ----------- |
                 | data   | path to data files to supply the data that will be passed into templates. |
                 | engine | engine to be used for processing templates. Handlebars is the default. |
                 | ext    | extension to be used for dest files. |
                 
                 Right aligned columns
                 
                 | Option | Description |
                 | ------:| -----------:|
                 | data   | path to data files to supply the data that will be passed into templates. |
                 | engine | engine to be used for processing templates. Handlebars is the default. |
                 | ext    | extension to be used for dest files. |
                 
                 
                 ## Links
                 
                 [link text](http://dev.nodeca.com)
                 
                 [link with title](http://nodeca.github.io/pica/demo/ "title text!")
                 
                 Autoconverted link https://github.com/nodeca/pica (enable linkify to see)
                 
                 
                 ## Images
                 
                 ![Minion](https://octodex.github.com/images/minion.png)
                 ![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")
                 
                 Like links, Images also have a footnote style syntax
                 
                 ![Alt text][id]
                 
                 With a reference later in the document defining the URL location:
                 
                 [id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"
                 """
   })

   Plan.create_ticket(project, %{
    title: "Update your phoenix deps",
    description: """
                 ```elixir
                 def deps do
                   [{:phoenix, "~> 1.1.2"},
                    ...]
                 end
                 ```

                 Now, update your phoenix deps to grab the latest minor releases:

                 ```console
                 $ mix deps.update phoenix phoenix_html phoenix_live_reload
                 ```
                 """,
    extra_info: "This impacts 11 of the apps in the umbrella"
   })

   Plan.create_ticket(project, %{
    title: "Update your `package.json`",
    description: """
                 > (for umbrellas the `file` prefix will need `file:../../deps/`)
                 
                 ```javascript
                 {
                   "repository": {
                   },
                   "dependencies": {
                     "babel-brunch": "^6.0.0",
                     "brunch": "^2.1.1",
                     "clean-css-brunch": ">= 1.0 < 1.8",
                     "css-brunch": ">= 1.0 < 1.8",
                     "javascript-brunch": ">= 1.0 < 1.8",
                     "uglify-js-brunch": ">= 1.0 < 1.8",
                     "phoenix": "file:deps/phoenix",
                     "phoenix_html": "file:deps/phoenix_html"
                   }
                 }
                 ```
                 
                 And run `$ npm install` to bring in the new node deps
                 """
   })

   Plan.create_ticket(project, %{
    title: "Update you brunch-config.js:",
    description: """
                 Remove phoenix and phoenix_html from your `watched` configuration
                 
                 
                 ```diff
                   paths: {
                     // Dependencies and current project directories to watch
                     watched: [
                 -     "deps/phoenix/web/static",
                 -     "deps/phoenix_html/web/static",
                       "web/static",
                       "test/static"
                     ],
                 
                     // Where to compile files to
                     public: "priv/static"
                   },
                 ```
                 
                 Add `npm.whitelist` to your `npm` config:
                 
                 ```diff
                   npm: {
                     enabled: true,
                 +   whitelist: ["phoenix", "phoenix_html"]
                   }
                 ```
                 """
   })

   Plan.create_ticket(project, %{
    title: "Update your js imports",
    extra_info: """
                ```diff
                - import "deps/phoenix_html/web/static/js/phoenix_html"
                + import "phoenix_html"
                
                - import {Socket} from "deps/phoenix/web/static/js/phoenix"
                + import {Socket} from "phoenix"
                ```
                
                ## Test it
                
                    $ mix phoeinix.server
                    07 Jan 16:16:59 - info: compiled 5 files into 2 files, copied 3 in 1.2 sec
                """
   })
 end).()