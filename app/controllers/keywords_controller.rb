class KeywordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @keywords = current_user.keywords
  end

  def new
    @keyword = Keyword.new
  end

  def create
    unless params[:keyword]
      flash[:alert] = "Please select file"
      redirect_to new_keyword_path
    else
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
  end

  def show
    service = Keywords::Show.new(current_user, params[:id])
    @keyword, @search_result = service.call
  end

  def destroy
    service = Keywords::Destroy.new(current_user, params[:id])
    result = service.destroy
  
    flash[result.success? ? :notice : :alert] = result.message
    redirect_to keywords_path
  end
  
  def delete_all
    service = Keywords::Destroy.new(current_user)
    result = service.destroy_all
  
    flash[result.success? ? :notice : :alert] = result.message
    redirect_to keywords_path
  end

  private

  def keyword_params
    params.require(:keyword).permit(:file)
  end
end
