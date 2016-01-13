require 'uri'
require 'nokogiri'
require 'open-uri'

class Daumdic
  # 다음사전에 단어를 검색한 후, 한줄짜리 결과를 출력한다.
  def self.search(input)
    return if input.nil?
    return if (input = input.strip).empty?

    doc = Nokogiri::HTML(open(URI.escape("http://dic.daum.net/search.do?q=#{input}")))
    if doc.css('.search_result1').any?
      # Exact match

      language = doc
        .css('.search_fst .tit_searchfd')
        .text.strip
      if /^(.*)어 사전$/.match language
        language = $1
      end

      word = doc
        .css('.search_fst .clean_word .tit_word > a:first')
        .text.strip

      pronounce = doc
        .css('.search_fst .clean_word span.pronounce_word')
        .map { |n| n.text.strip }
        .first

      meaning = doc
        .css('.search_fst .clean_word ul.list_mean > li')
        .map { |n| n.xpath("node()[not(@class='num_g1')]").text.strip }
        .join(', ')

      # Failed to parse daumdic
      return if meaning.empty?

      # Make a result message
      result = ''
      unless ['한국', '영', '일본', '한자 사전'].include? language
        result += "(#{language})  "
      end
      unless pronounce.nil?
        result += "#{pronounce}  "
      end
      if input != word
        result += "#{word}  "
      end
      result += meaning
    elsif doc.css('.speller_search').any?
      # Not found, but there're some alternatives
      alternatives = doc
        .css('.speller_search > a')
        .map(&:text)
        .join(', ')

      alternatives
    else
      # No idea
      nil
    end
  end
end
