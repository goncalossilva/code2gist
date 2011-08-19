$:.unshift "#{File.dirname(__FILE__)}/../lib/"
require "test/unit"
require "code2gist"

class Code2GistTest < Test::Unit::TestCase
  def test_empty_gist
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

    puts Code2Gist.upload(code, "test description")# =~ /https:\/\/gist\.github\.com\/\d+/

    puts Code2Gist.upload(code, "another description", :embed => true)# =~ /https:\/\/gist.github.com\/\d+\?file=\w+\.\w+/

    puts Code2Gist.upload(code, "yet another description", :embed => true, :html => true)# =~ /<script src="https:\/\/gist.github.com\/\d+\.js\?file=\w+\.\w+"><\/script>/
  end
end
