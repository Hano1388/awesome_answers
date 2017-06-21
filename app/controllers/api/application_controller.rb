class Api::ApplicationController < ApplicationController
  # this will not throw an exception if an authenticity token is not
  # passed. In other words, this will allow post requests to be made
  # from tools other than a form rendered by rails.
  skip_before_action :verify_authenticity_token

  # to make request that is authenticated, do as follows for a fetch:
  #   fetch('http://localhost:3000/api/v1/questions/300', {
  #     headers: {
  #       'Authorization' : 'Apikey d5c234ff7b9b6bb96e7a125b8f6755ae539eb7e6b0ebabfc4dffe26f021059e8'
  #     }
  #   })
  #     .then(res => res.json())
  #     .then(console.info)
  def current_user
    @user ||= User.find_by(api_key: api_key) unless api_key.nil?
  end

  private
  def api_key
    # this grabs the api_key from the `Authorization` headers
    # in the http request. It expects it to be in this format:
    # "Apikey <the-api-key>"
    match = request.headers['AUTHORIZATION']&.match(/^Apikey (.+)/)
    match&.length == 2 ? match[1] : nil
  end

  def authenticate_user!
    head :unauthorized unless current_user.present?
  end
end
