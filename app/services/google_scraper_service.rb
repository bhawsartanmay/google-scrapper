# app/services/google_scraper_service.rb
require 'httparty'
require 'nokogiri'
require 'cgi'

class GoogleScraperService
  def initialize(keyword_id)
    @keyword = Keyword.find(keyword_id)
    @name = @keyword.name
    @url = "https://www.google.com/search?q=#{CGI.escape(@name)}"
  end

  def scrape
    response = HTTParty.get(@url, headers: user_agent_header)

    if response.code == 200
      parse_page(response.body)
    else
      nil
    end
  end

  private

  def user_agent_header
    { "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" }
  end

  def parse_page(html)
    doc = Nokogiri::HTML(html)

    total_ads = doc.css('div[data-text-ad="1"]').size
    total_links = doc.css('a').size
    total_results = doc.at_css('#result-stats')&.text.strip

    html_cache = doc.to_html

    {
      total_ads: total_ads,
      total_links: total_links,
      total_results: total_results,
      html_cache: html_cache
    }
  end
end
