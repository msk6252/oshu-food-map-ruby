require 'nokogiri'


class KmlToLatLng
  def self.convert
    kml_file = 'export.kml'
    doc = Nokogiri::XML(File.open(kml_file))
    latlng = []
    doc.css('Placemark').each do |placemark|
      lng, lat = placemark.css('Point coordinates').text.split(',')
      latlng << { lat: lat, lng: lng } if !lat.nil? && !lng.nil?
    end

    return latlng
  end
end
