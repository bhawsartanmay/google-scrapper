module Keywords
  class Destroy
    def initialize(user, keyword_id = nil)
      @user = user
      @keyword_id = keyword_id
    end

    def destroy
      keyword = Keyword.find_by(id: @keyword_id, user: @user)
      if keyword&.destroy
        OpenStruct.new(success?: true, message: "Keyword was successfully deleted.")
      else
        OpenStruct.new(success?: false, message: "There was an issue deleting the keyword.")
      end
    end

    def destroy_all
      if @user.keywords.destroy_all
        OpenStruct.new(success?: true, message: "All keywords were successfully deleted.")
      else
        OpenStruct.new(success?: false, message: "There was an issue deleting all keywords.")
      end
    end
  end
end
