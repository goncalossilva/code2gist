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

    nocode = <<-eonc
      There is no code here

      But it should work normally
    eonc

    assert Code2Gist.upload(code, "test description") =~ /https:\/\/gist\.github\.com\/\d+/

    assert Code2Gist.replace(code, "another description") =~ /https:\/\/gist.github.com\/\d+\?file=\w+\.\w+/

    assert Code2Gist.replace(code, "yet another description", :html => true) =~ /<script src="https:\/\/gist.github.com\/\d+\.js\?file=\w+\.\w+"><\/script>/

    assert Code2Gist.replace(nocode, "no code!") == nocode
  end
end
