class ScrapeKeywordsJob < ApplicationJob
  queue_as :default

  def perform(keyword_id)    
    scraper = GoogleScraperService.new(keyword_id)
    
    result_data = scraper.scrape

    if result_data
      keyword = Keyword.find keyword_id
      keyword.search_results.create!(
        total_ads: result_data[:total_ads],
        total_links: result_data[:total_links],
        total_results: result_data[:total_results],
        html_cache: result_data[:html_cache]
      )

      keyword.update(status: 'completed')
    else
      keyword.update(status: 'failed')
    end
  end
end
