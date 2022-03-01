# frozen_string_literal: true

describe LocationValidator do
  subject(:validator) { described_class.new }

  it "requires latitude & longitude presence" do
    result = validator.call({})

    expect(result).to be_failure
    expect(result.errors.to_h).to eq(lat: ["is missing"], lng: ["is missing"])
  end

  it "requires lat & lng to be a float numbers" do
    result = validator.call("lat" => "NAN", "lng" => "NAN")

    expect(result).to be_failure
    expect(result.errors.to_h).to eq(lat: ["must be a float"], lng: ["must be a float"])
  end

  it "requires lat & lng to be less than or equal to max values" do
    result = validator.call("lat" => 90.000001, "lng" => 180.000001)

    expect(result).to be_failure
    expect(result.errors.to_h).to eq(lat: ["must be in range -90.0..90.0"],
                                     lng: ["must be in range -180.0..180.0"])
  end

  it "requires lat & lng to be larger than or equal to min values" do
    result = validator.call("lat" => -90.000001, "lng" => -180.000001)

    expect(result).to be_failure
    expect(result.errors.to_h).to eq(lat: ["must be in range -90.0..90.0"],
                                     lng: ["must be in range -180.0..180.0"])
  end

  context "with valid params" do
    let(:params) do
      { "lat" => 53.21590, "lng" => 50.132277 }
    end

    it "returns success result" do
      expect(validator.call(params)).to be_success
    end

    it "contains validated params" do
      expect(validator.call(params).to_h).to eq(params.transform_keys(&:to_sym))
    end
  end
end
