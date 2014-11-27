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

    describe 'legal' do
      context 'not on a site' do
        it 'render admin layout' do
          get :show, id: 'legal'
          expect(response).to render_template 'admin'
        end
      end

      context 'on a site' do
        let(:site) { create :site }
        it 'render application layout' do
          @request.host = "#{site.slug}.#{ENV['DOMAIN']}"
          get :show, id: 'legal'
          expect(response).to render_template 'application'
        end

        it 'render print site title' do
          @request.host = "#{site.slug}.#{ENV['DOMAIN']}"
          get :show, id: 'legal'
          expect(response.body).to include site.host
        end
      end
    end
  end
end
