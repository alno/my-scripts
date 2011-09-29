#!/usr/bin/env ruby
# Downloading deutch lessons from http://www.dw-world.de/dw/0,,9677,00.html

require 'rubygems'
require 'mechanize'
require 'fileutils'

@agent = Mechanize.new

page = @agent.get "http://www.dw-world.de/dw/0,,9677,00.html"
page.parser.css('.ID181 a').each do |lesson_link|
  dir = "deutch-lessons-2/#{lesson_link.text}"

  FileUtils.mkdir_p(dir)

  lesson_url = "http://www.dw-world.de/#{lesson_link[:href]}"
  lesson_page = @agent.get lesson_url rescue (puts "Not found page for '#{lesson_link.text}' - '#{lesson_url}'"; nil)

  if lesson_page
    lesson_page.parser.css(".symAudio a").each do |popup_link|
      audio_page = @agent.get "http://www.dw-world.de/#{popup_link[:href]}"
      audio_page.parser.css(".formatlink").each do |link|
        `cd "#{dir}" && wget "#{link[:href]}"`
      end
    end

    lesson_page.parser.css(".symDownload a").each do |link|
      url = "http://www.dw-world.de/#{link[:href]}"
      `cd "#{dir}" && wget "#{url}"`
    end
  end
end
