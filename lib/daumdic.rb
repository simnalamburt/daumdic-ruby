# 다음사전에 단어를 검색한 후, 한줄짜리 결과를 출력한다.
def search(input)
  return if input.nil?
  return if (input = input.strip).empty?

  tempfile = open(URI.escape("http://dic.daum.net/search.do?q=#{input}"))

  Nokogiri::HTML(tempfile)
    .css('#mArticle .clean_word ul.list_mean > li')
    .map { |n| n.xpath("node()[not(@class='num_g1')]").text }
    .join(', ')
end
