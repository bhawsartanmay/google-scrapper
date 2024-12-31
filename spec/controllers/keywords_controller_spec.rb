require 'rails_helper'

RSpec.describe KeywordsController, type: :controller do
  let(:user) { create(:user) }
  let!(:keyword) { create(:keyword, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns all keywords to @keywords' do
      get :index
      expect(assigns(:keywords)).to eq([keyword])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new keyword to @keyword' do
      get :new
      expect(assigns(:keyword)).to be_a_new(Keyword)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_file.csv'), 'text/csv') }
    let(:valid_params) { { keyword: { file: file } } }

    context 'when the service is successful' do
      before do
        allow_any_instance_of(Keywords::Create).to receive(:call).and_return(OpenStruct.new(success?: true, message: 'File processed successfully'))
      end

      it 'redirects to keywords_path with a notice' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('File processed successfully')
        expect(response).to redirect_to(keywords_path)
      end
    end

    context 'when the service fails' do
      before do
        allow_any_instance_of(Keywords::Create).to receive(:call).and_return(OpenStruct.new(success?: false, message: 'Invalid file', keyword: Keyword.new))
      end

      it 'renders the new template with an alert' do
        post :create, params: valid_params
        expect(flash.now[:alert]).to eq('Invalid file')
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the keyword and search results' do
      service = instance_double(Keywords::Show)
      allow(Keywords::Show).to receive(:new).and_return(service)
      allow(service).to receive(:call).and_return([keyword, []])

      get :show, params: { id: keyword.id }
      expect(assigns(:keyword)).to eq(keyword)
      expect(assigns(:search_result)).to eq([])
    end
  end

  describe 'DELETE #destroy' do
    context 'when the keyword is deleted successfully' do
      it 'sets a success flash message and redirects to index' do
        delete :destroy, params: { id: keyword.id }
        expect(flash[:notice]).to eq('Keyword was successfully deleted.')
        expect(response).to redirect_to(keywords_path)
      end
    end

    context 'when the keyword deletion fails' do
      before do
        allow_any_instance_of(Keyword).to receive(:destroy).and_return(false)
      end

      it 'sets an alert flash message and redirects to index' do
        delete :destroy, params: { id: keyword.id }
        expect(flash[:alert]).to eq('There was an issue deleting the keyword.')
        expect(response).to redirect_to(keywords_path)
      end
    end
  end

  describe 'DELETE #delete_all' do
    context 'when all keywords are deleted successfully' do
      it 'sets a success flash message and redirects to index' do
        delete :delete_all
        expect(flash[:notice]).to eq('All keywords were successfully deleted.')
        expect(response).to redirect_to(keywords_path)
      end
    end

    context 'when deleting all keywords fails' do
      before do
        allow_any_instance_of(ActiveRecord::Relation).to receive(:destroy_all).and_return(false)
      end

      it 'sets an alert flash message and redirects to index' do
        delete :delete_all
        expect(response).to redirect_to(keywords_path)
      end
    end
  end
end
