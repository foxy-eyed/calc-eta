# frozen_string_literal: true

class LocationValidator < Hanami::Validator
  COORDINATES_RANGE = {
    lat: -90.0..90.0,
    lng: -180.0..180.0
  }.freeze

  params do
    required(:lat).filled(:float)
    required(:lng).filled(:float)
  end

  %i[lat lng].each do |param|
    rule(param) do
      key.failure("must be in range #{COORDINATES_RANGE[param]}") unless COORDINATES_RANGE[param].include?(value)
    end
  end
end
