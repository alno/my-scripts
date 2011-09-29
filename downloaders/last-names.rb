# Downloading last names from http://www.genway.ru

require 'rubygems'
require 'nokogiri'
require 'open-uri'

def doc(href)
  Nokogiri::HTML(open('http://www.genway.ru' + URI.escape(href)))
end

root = doc '/lib/allfam/'
root.css('.ui_alphabet_block a').each do |letterlink|
  next unless letterlink[:href] =~ /keyfam=..$/

  prev_href = nil
  next_href = letterlink[:href]
  while next_href && next_href != prev_href
    letter_doc = doc next_href
    letter_doc.css('.famviz a').each do |link|
      puts link.text
    end
    prev_href = next_href
    next_href = letter_doc.css('.top5 .pages a').last
    next_href = next_href[:href] if next_href
  end
end
