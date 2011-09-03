# code2gist

This library looks for code blocks in your text and uploads them to
http://gist.github.com. Then, it can either give you the link to it or
replace your code blocks inline for their respective gist.github.com
links.

The code must follow this pattern:

    ```filename.extension
    some code
    ```

The filename and extension are optional — it'll assume it's an untitled plain text file if you don't specify what it is.

## Usage

It's very simple:

    require 'code2gist'
    Code2Gist.upload(your_text, "example description")

Or:

    new_text = Code2Gist.replace(your_text, "another example description")

### Options
When replacing, there are two options available: `:html` (default:
`false`) and `:anonymous` (default: `false`).

Quick example:

    Code2Gist.replace(your_markdown_text, "yay!", :html => true)

This is specially useful if you're using markdown/textile and would like
to have all your code blocks in a gist and embeded in your HTML. For
example:

    html = Markdown.new(Code2Gist.replace(text, "Code snippets from article X", :html => true)).to_html

You can use the `:anonymous` option to avoid authenticating that code
upload, even if the credentials are available (see next section):

    Code2Gist.replace(your_markdown_text, "anonymous!", :anonymous =>
true)

### I want to be the owner of the gist!

It's okay, just specify your username and API token before uploading any
gists:

    Code2Gist::Config.github_login = "your_login"
    Code2Gist::Config.github_token = "your_token"

### Command-line interface

Use `code2gist`from the command-line. Just run:

    $ code2gist upload file "optional description"

Or:

    $ code2gist replace file "optional description"

Or even:

    $ code2gist replace file "optional description" --substitute # this will change your file in place!

It supports all options. Check `code2gist --help` to see how to use them
properly.

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

    Code2Gist.replace(code, "another description") # =>
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

    Code2Gist.replace(code, "yet another description", :html => true) # =>
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

