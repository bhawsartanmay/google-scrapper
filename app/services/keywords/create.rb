module Keywords
  class Create
    require 'csv'
    def initialize(user, params)
      @user = user
      @params = params
      @keyword = nil
    end

    def call
      @keyword = @user.keywords.new(@params)
      if @keyword.save
        process_csv(@keyword)
        ServiceResult.new(true, 'File uploaded and processing started.', @keyword)
      else
        ServiceResult.new(false, 'File upload failed.', @keyword)
      end
    end

    attr_reader :keyword

    private

    def process_csv(keyword)
      keywords_data = []
      CSV.foreach(keyword.file.path, headers: true) do |row|
        keywords_data << { name: row['keyword'], user_id: @user.id }
      end
      created_keywords = Keyword.upsert_all(keywords_data, unique_by: [:name, :user_id])
      created_keywords.each do |created_keyword|
        ScrapeKeywordsJob.perform_later(created_keyword["id"])
      end
    end
  end
end
