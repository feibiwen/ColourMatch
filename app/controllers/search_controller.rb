class SearchController < ApplicationController

  # POST /search/upload
  # Used when searching by photo.
  # Param: photo -> HttpUpload object
  def upload
    return render json: {error: "Missing necessary parameter 'photo'"}, status: 422 unless params[:photo]
    
    name = sanitize_name(params[:photo].original_filename)

    return render json: {error: "Couldn't save photo to disk."}, status: 415 unless path = Photo::SaveToDisk.call(params[:photo], name)

    # Let's get 6-bit (64-colour) data
    colour_data_64_bit      = Photo::GetHistogramData.call(path, 64)
    hsb_channel_data_64_bit = Photo::GetHSBChannelStats.call(colour_data_64_bit)

    colour_data_16_bit      = Photo::GetHistogramData.call(path, 16)
    # hsb_channel_data_16_bit = Photo::GetHSBChannelStats.call(colour_data_16_bit)

    # Current strategy: Combine the 3-5 most popular 16-bit colors, as well as 0-2 outliers
    results = Photo::ExtractDominantColours.call(colour_data_16_bit, hsb_channel_data_64_bit)


    # Create a png palette for testing
    Photo::CreatePaletteImage.call(results, name) unless Rails.env.production?

    # Find the database objects that match the colors.
    # Because we've used our database as the 'colormap', we really just need to do a simple DB lookup
    lab_results = match_colours_to_db(results)

    render json: lab_results

  end

  # GET /search
  # Used when searching by colour.
  # Param: colour -> string hex code eg. '#123456'
  def show
    return render json: {error: "Missing necessary parameter 'colour'"}, status: 422 unless params[:colour]

    # Convert hex to RGB
    rgb_color = Colour::Convert.call(params[:colour], :rgb)


    nearest_neighbor = Colour::FindClosest.call(rgb_color)


    render json: { original_colour: params[:colour], closest_colour: nearest_neighbor}

  end



  private

  def match_colours_to_db(results)
    results.map { |c| Colour.lookup(c[:rgb]) }
  end


  def sanitize_name(name)
    name.gsub(/[^\w\.]/, '')
  end

end
