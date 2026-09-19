class CitiesController < ApplicationController
  def update
    city = City.find params[:code]
    if city
      cookies[:city] = { value: city.code, expires: 1.year.from_now, same_site: :lax }
    end
    redirect_back fallback_location: root_path
  end
end
