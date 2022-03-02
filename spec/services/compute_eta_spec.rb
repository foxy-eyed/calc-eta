# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe ComputeEta do
  include Dry::Monads[:result]

  subject(:compute_eta) do
    described_class.new(validator: validator, car_locator: car_locator, arrival_predictor: arrival_predictor)
                   .call(location)
  end

  let(:validator) { instance_double(LocationValidator) }
  let(:car_locator) { instance_double(LocateNearbyCars) }
  let(:arrival_predictor) { instance_double(PredictArrival) }

  let(:validator_result) { Success(location) }
  let(:locator_result) { Success(load_fixture("cars_response.json")) }
  let(:predictor_result) { Success([9, 10, 8, 5, 6]) }

  let(:location) { { lat: 53.21590, lng: 50.132277 } }

  before do
    allow(validator).to receive(:call).and_return(validator_result)
    allow(car_locator).to receive(:call).and_return(locator_result)
    allow(arrival_predictor).to receive(:call).and_return(predictor_result)
  end

  it "returns success when everything is fine" do
    expect(compute_eta).to be_success
    expect(compute_eta.value!).to eq(5)
  end

  it "returns value from cache if present" do
    CalcEta.cache.set(ComputeEta::Location.new(**location).cache_key, 3)

    expect(compute_eta.value!).to eq(3)
  end

  context "when validation fails" do
    let(:validator_result) { Failure("Invalid contract") }

    it "returns failure" do
      expect(compute_eta).to be_failure
      expect(compute_eta.failure).to eq("Invalid contract")
    end
  end

  context "when car locator fails" do
    let(:locator_result) { Failure("No available cars nearby") }

    it "returns failure" do
      expect(compute_eta).to be_failure
      expect(compute_eta.failure).to eq("No available cars nearby")
    end
  end

  context "when predictor fails" do
    let(:predictor_result) { Failure("[WheelyApi]: execution expired") }

    it "returns failure" do
      expect(compute_eta).to be_failure
      expect(compute_eta.failure).to eq("[WheelyApi]: execution expired")
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
