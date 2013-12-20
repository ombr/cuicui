def it_responds_200
  context 'renders views' do
    render_views
    it { response.code.should == '200' }
  end
end
