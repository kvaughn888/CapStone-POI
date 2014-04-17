json.array!(@pois) do |poi|
  json.extract poi, :id, :latitude, :longitude, :address, :description, :title
  json.url poi_url(poi, format: :json)
end
