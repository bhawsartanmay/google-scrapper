require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:search_results).dependent(:destroy) }
  end

  describe 'enums' do
    it do
      should define_enum_for(:status).
        with_values(pending: 0, completed: 1, failed: 2).
        backed_by_column_of_type(:integer)
    end
  end

  describe 'file uploader' do
    it 'mounts the KeywordFileUploader' do
      expect(Keyword.new.file).to be_an_instance_of(KeywordFileUploader)
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated search_results when deleted' do
      keyword = create(:keyword)
      search_result = create(:search_result, keyword: keyword)

      expect { keyword.destroy }.to change { SearchResult.count }.by(-1)
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:keyword)).to be_valid
    end
  end
end
