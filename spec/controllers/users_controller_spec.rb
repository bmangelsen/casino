require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  @request.env['devise.mapping'] = Devise.mappings[:user]
  fixtures :users
  binding.pry
end
