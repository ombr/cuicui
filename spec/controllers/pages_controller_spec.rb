require 'spec_helper'

describe PagesController do
  describe '#show' do
    render_views
    PAGES = %w(home legal)

    it 'redirect to home when page not found' do
      get :show, id: 'super_non_existent_page'
      expect(response.code).to redirect_to root_path
    end

    PAGES.each do |page|
      context "on GET to /pages/#{page}" do
        before do
          get :show, id: page
        end

        it 'responds 200' do
          expect(response.code).to eq '200'
        end
      end
    end

    PAGES.each do |page|
      I18n.available_locales.each do |locale|
        context "on GET to /#{locale}/pages/#{page}" do
          before do
            get :show, id: page, locale: locale
          end
          it 'responds 200' do
            expect(response.code).to eq '200'
          end
        end
      end
    end
  end
end
