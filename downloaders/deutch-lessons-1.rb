#!/usr/bin/env ruby
# Downloading deutch lessons from http://www.dw-world.de/dw/0,,2548,00.html

require 'rubygems'
require 'mechanize'
require 'fileutils'

@agent = Mechanize.new

index = 0
page = @agent.get "http://www.dw-world.de/dw/0,,2548,00.html"
page.forms.each do |form|
  select = form.fields.first
  if select.is_a? Mechanize::Form::SelectList
    select.options.each do |option|
      dir = "deutch-lessons-1/#{index}/#{option.text}"

      FileUtils.mkdir_p(dir)

      opt_url = "http://www.dw-world.de/dw/content/0,,#{option.value},00.html"
      opt_page = @agent.get opt_url rescue (puts "Not found page for '#{option.text}' - '#{opt_url}'"; nil)

      if opt_page
        opt_page.parser.css(".symAudio a").each do |popup_link|
          audio_page = @agent.get "http://www.dw-world.de/#{popup_link[:href]}"
          audio_page.parser.css(".formatlink").each do |link|
            `cd "#{dir}" && wget "#{link[:href]}"`
          end
        end

        opt_page.parser.css(".symDownload a").each do |link|
          url = "http://www.dw-world.de/#{link[:href]}"
          `cd "#{dir}" && wget "#{url}"`
        end
      end
    end unless index == 0

    index += 1
  end
end
