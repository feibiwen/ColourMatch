class Photo::GetHistogramData
  def self.call(path, colours, colormap=nil)
    colormap  ||= 'lib/assets/images/colormap.png'
    histogram   = make_histogram(path, colours, colormap)
    rgb_data    = parse_histogram(histogram)
    get_all_colorspaces(rgb_data)
  end

  private

  def self.make_histogram(path, colours, colormap)
    `convert #{path}   \
    -format %c         \
    -resize 250x250    \
    -colors #{colours} \
    -remap #{colormap} \
    histogram:info:- | sort -n -r`
  end

  def self.parse_histogram(histogram)
    hex_colour_regex = /(?<occurances>[\d]{1,8}):\s\(\s*(?<c1>[\d]{1,3}),\s*(?<c2>[\d]{1,3}),\s*(?<c3>[\d]{1,3})/
    histogram.scan(hex_colour_regex)
  end


  def self.get_all_colorspaces(rgb_data)
    rgb_data.map! do |color_array|
      # First, we need to get this in the right format.
      # From  ['255','255','255'] 
      # to    { r: 255, g: 255, b: 255 }
      rgb = {
        r: color_array[1].to_i,
        g: color_array[2].to_i,
        b: color_array[3].to_i
      }

      # Next, we do the conversion
      hsb = Colour::Convert.call(rgb, :hsb)

      lab = Colour::Convert.call(rgb, :lab)

      {
        occurances: color_array[0].to_i,
        rgb:        rgb,
        hsb:        hsb,
        lab:        lab
      }
    end
  end

end