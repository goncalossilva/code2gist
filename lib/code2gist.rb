require "net/http"
require "uri"
require "json"

module Code2Gist
  extend self

  module Config
    def self.github_login
      @@github_login ||= nil
    end
    def self.github_login=(github_login)
      @@github_login = github_login
    end
    def self.github_token
      @@github_token ||= nil
    end
    def self.github_token=(github_token)
      @@github_token = github_token
    end
  end

  def upload(text, description = nil, opts = {})
    options = {:embed => false, :html => false}.merge(opts)

    code_regex = /```(\w+\.\w+)?[^\n]*\n(.*?)```/m
    new_text = name_nameless_code_blocks(text)

    gist_url = get_gist(Hash[*new_text.scan(code_regex).flatten], description)

    if options[:embed]
      if options[:html]
        new_text.gsub(code_regex, "<script src=\"#{gist_url}.js?file=\\1\"></script>")
      else
        new_text.gsub(code_regex, "#{gist_url}?file=\\1")
      end
    else
      gist_url
    end
  end

  private

  def name_nameless_code_blocks(text)
    nameless_blocks = 0
    new_text = text.gsub(/```(\w+\.\w+)?/).with_index do |match, index|
      if index%2 == 0 && match.size == 3
        nameless_blocks += 1;
        "```untitled_#{nameless_blocks}.txt"
      else
        match
      end
    end

    new_text
  end

  def get_gist(data, description)
    post_data = {}
    data.each_with_index do |(filename, content), index|
      post_data.merge!("files[#{filename}]" => content)
    end

    post_data.merge!(
      "login" => Code2Gist::Config.github_login,
      "token" => Code2Gist::Config.github_token
    ) unless Code2Gist::Config.github_login.nil? || Code2Gist::Config.github_token.nil?

    post_data.merge!("description" => description)

    result = Net::HTTP.post_form(URI.parse("http://gist.github.com/api/v1/json/new"), post_data)
    parsed_json = JSON(result.body)
    repo = nil
    parsed_json['gists'].each do |key, val|
      key.each do |k, v|
        if "#{k}" == 'repo'
          repo = "#{v}"
        end
      end
    end
    return "https://gist.github.com/#{repo}"
  end
end
