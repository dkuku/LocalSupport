# extracted from 'gmaps4rails' gem
# link = https://github.com/apneadiving/Google-Maps-for-Rails/blob/master/spec/lib/markers_builder_spec.rb
require 'rails_helper'

describe Gmaps::MarkersBuilder do

  describe 'call' do
    let(:lat) { 40 }
    let(:lng) { 5  }
    let(:id)  { 'id' }
    let(:infowindow) { 'some infowindow content' }
    let(:name)       { 'name' }
    let(:picture)    do 
      {
      url: 'http://www.blankdots.com/img/github-32x32.png',
      width: '32',
      height: '32'
    }
    end    
    let(:shadow) do 
      {
      url: 'shadow',
      width: '30',
      height: '30'
    }
    end    
    let(:expected_hash) do 
      {
      lat: lat,
      lng: lng,
      marker_title: name,
      some_id: id,
      infowindow: infowindow,
      picture: picture,
      shadow: shadow
    }
    end    
    let(:object) do 
      OpenStruct.new(
      latitude: lat,
      longitude: lng,
      name: name,
      some_id: id
    )
    end    

    let(:action) do 
      Gmaps::MarkersBuilder.new(object).call do |user, marker|
        marker.lat        user.latitude
        marker.lng        user.longitude
        marker.infowindow infowindow
        marker.picture    picture
        marker.shadow     shadow
        marker.title      user.name
        marker.json(some_id: user.some_id)
      end
    end

    it 'creates expected hash' do
      expect(action).to eq [expected_hash]
    end

  end


end
