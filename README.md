# code2gist

This library parses text and looks for this pattern:
    ```filename.extension
    some code
    ```

It uploads all matches to http://gist.github.com and returns the link to it. The filename and extension are optional — it'll assume it's an untitled plain text file if you don't specify what it is.

## Usage

It's very simple:

    require 'code2gist'
    Code2Gist.upload(your_text, "example description")

### Options
It supports a couple of boolean options:
- `:embed` (default: `false`)
- `:html` (default: `false`)

    Code2Gist.upload(your_markdown_text, "another description", :embed
=> true, :html => true)

If you pass `:embed => true`to it, it will replace all code blocks with
links to the appropriate file at http://gist.github.com. If you also
pass `:html => true`, it will replace all code blocks with embeded
gists.

This is specially useful if your using markdown/textile and would like
to have all your code blocks in a gist and embeded in your HTML. For
example:

    html = Markdown.new(Code2Gist.upload(text, "Article code snippets",
:embed => true, :html => true)).to_html

### I want to be the owner of the gist!

It's okay, just specify your username and API token before uploading any
gists:
    Code2Gist::Config.github_login = "your_login"
    Code2Gist::Config.github_token = "your_token"

## Real example

    code = <<-eoc
      This is just a regular `document`

      It can have code!

      ```description.rb
      def what
        puts "This is ruby code!"
        `ls`
      end
      ```

      And small snippets *also* work:
      ```
      Not sure what this is
      ```

      The end
    eoc

    Code2Gist.upload(code, "my description) # => https://gist.github.com/1157214

    Code2Gist.upload(code, "another description", :embed => true) # =>
    #  This is just a regular `document`
    #
    #  It can have code!
    #
    #  https://gist.github.com/1157215?file=description.rb
    #
    #  And small snippets *also* work:
    #  https://gist.github.com/1157215?file=untitled_1.txt
    #
    #  The end

    Code2Gist.upload(code, "yet another description", :embed => true, :html => true) # =>
    #  This is just a regular `document`
    #
    #  It can have code!
    #
    #  <script src="https://gist.github.com/1157216.js?file=description.rb"></script>
    #
    #  And small snippets *also* work:
    #  <script src="https://gist.github.com/1157216.js?file=untitled_1.txt"></script>
    #
    #  The end

