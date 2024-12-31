module Keywords
  class Show
    def initialize(user, keyword_id)
      @user = user
      @keyword_id = keyword_id
    end

    def call
      keyword = @user.keywords.find(@keyword_id)
      search_result = keyword.search_results&.last
      [keyword, search_result]
    end
  end
end
