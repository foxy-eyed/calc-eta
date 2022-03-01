# frozen_string_literal: true

describe LocateNearbyCars do
  subject(:locate_cars) { described_class.new.call(**location) }

  let(:location) { { lat: 53.21590, lng: 50.132277 } }
  let(:api) { class_double(WheelyApi).as_stubbed_const(transfer_nested_constants: true) }

  context "when api returns not empty cars array" do
    it "returns success" do
      api_response = load_fixture("cars_response.json")
      allow(api).to receive(:cars).with(limit: kind_of(Integer), **location)
                                  .and_return(api_response)

      expect(locate_cars).to be_success
      expect(locate_cars.value!).to eq(api_response)
    end
  end

  context "when api returns empty response" do
    it "fails with correct error message" do
      allow(api).to receive(:cars).with(limit: kind_of(Integer), **location)
                                  .and_return([])

      expect(locate_cars).to be_failure
      expect(locate_cars.failure).to eq("No available cars nearby")
    end
  end

  context "when api call fails" do
    it "fails with correct error message" do
      allow(api).to receive(:cars).with(limit: kind_of(Integer), **location)
                                  .and_raise(WheelyApi::Error, "Ouch!")

      expect(locate_cars).to be_failure
      expect(locate_cars.failure).to eq("Ouch!")
    end
  end
end
