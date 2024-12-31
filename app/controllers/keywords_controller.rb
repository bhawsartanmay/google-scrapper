class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @keywords = current_user.keywords
  end

  def new
    @keyword = Keyword.new
  end

  def create
    service = Keywords::Create.new(current_user, keyword_params)
    result = service.call

    if result.success?
      flash[:notice] = "Scrapping is progress, please wait for sometime."
      redirect_to keywords_path, notice: result.message
    else
      @keyword = service.keyword
      flash.now[:alert] = result.message
      render :new
    end
  end

  def show
    service = Keywords::Show.new(current_user, params[:id])
    @keyword, @search_result = service.call
  end

  def destroy
    @keyword = Keyword.find_by(id: params[:id])
    if @keyword&.destroy
      flash[:notice] = "Keyword was successfully deleted."
    else
      flash[:alert] = "There was an issue deleting the keyword."
    end
    redirect_to keywords_path
  end

  def delete_all
    if current_user.keywords.destroy_all
      flash[:notice] = "All keywords were successfully deleted."
    else
      flash[:alert] = "There was an issue deleting all keywords."
    end
    redirect_to keywords_path
  end

  private

  def keyword_params
    params.require(:keyword).permit(:file)
  end
end
