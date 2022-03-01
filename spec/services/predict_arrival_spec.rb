# frozen_string_literal: true

describe PredictArrival do
  subject(:predict_arrivals) { described_class.new.call(**args) }

  let(:api) { class_double(WheelyApi).as_stubbed_const(transfer_nested_constants: true) }
  let(:args) do
    {
      target: { lat: 53.21590, lng: 50.132277 },
      source: load_fixture("cars_response.json")
    }
  end

  context "when api returns success response" do
    it "returns success" do
      api_response = [9, 10, 8, 5, 6]
      allow(api).to receive(:predict).with(**args).and_return(api_response)

      expect(predict_arrivals).to be_success
      expect(predict_arrivals.value!).to eq(api_response)
    end
  end

  context "when api call fails" do
    it "fails with correct error message" do
      allow(api).to receive(:predict).with(**args).and_raise(WheelyApi::Error, "Broken!")

      expect(predict_arrivals).to be_failure
      expect(predict_arrivals.failure).to eq("Broken!")
    end
  end
end
