# frozen_string_literal: true

# Copyright 2015-2017 Hyeon Kim
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
# <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
# option. This file may not be copied, modified, or distributed
# except according to those terms.

require 'uri'
require 'nokogiri'
require 'open-uri'

class Daumdic
  # 다음사전에 단어를 검색한 후, 한줄짜리 결과를 출력한다.
  def self.one_liner(input)
    return if input.nil?
    return if (input = input.strip).empty?

    uri = "https://dic.daum.net/search.do?#{URI.encode_www_form(q: input)}"
    doc = Nokogiri::HTML(URI.open(uri))

    # Look for alternatives
    rel = doc.css('.link_speller').map(&:text).join(', ')
    return rel unless rel.empty?

    # Got some results
    box = doc.css('.search_box')[0]
    return if box.nil?

    word = box.css('.txt_cleansch').text
    word = box.css('.txt_searchword')[0]&.text if word.empty?
    meaning = box.css('.txt_search').map(&:text).join(', ')
    pronounce = box.css('.txt_pronounce').first&.text
    lang = box.parent.css('.tit_word').text
    if /^(.*)어사전$/.match(lang); lang = $1 end

    # Failed to parse daumdic
    return if meaning.empty?

    # Make a result message
    result = ''
    unless ['한국', '영', '일본', '한자사전'].include? lang
      result += "(#{lang})  "
    end
    if input != word
      result += "#{word}  "
    end
    unless pronounce.nil?
      result += "#{pronounce}  "
    end
    result += meaning
  end
end
