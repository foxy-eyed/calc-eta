# frozen_string_literal: true

describe "Fetch ETA", type: :request do
  include Dry::Monads[:result]

  subject(:get_eta) { get route }

  context "with invalid params" do
    let(:route) { "/eta?lat=10&lng=100000" }

    it "responds with 422" do
      get_eta
      expect(response_status).to eq(422)
    end

    it "renders validation errors" do
      get_eta
      expect(response_json).to eq({ "errors" => { "lng" => ["must be in range -180.0..180.0"] } })
    end
  end

  context "when success" do
    let(:route) { "/eta?lat=53.21590&lng=50.132277" }

    before do
      eta_computer = instance_double(ComputeEta)
      allow(eta_computer).to receive(:call).and_return(Success(5))
      allow(ComputeEta).to receive(:new).and_return(eta_computer)
    end

    it "responds with 200" do
      get_eta
      expect(response_status).to eq(200)
    end

    it "renders correct json body" do
      get_eta
      expect(response_json).to eq({ "eta" => 5 })
    end
  end

  context "when computation failed" do
    let(:route) { "/eta?lat=53.21590&lng=50.132277" }

    before do
      stub_const("ENV", { "WHEELY_API_URL" => nil }) # break external services integration
    end

    it "responds with 500" do
      get_eta
      expect(response_status).to eq(500)
    end

    it "renders error message" do
      get_eta
      expect(response_json).to eq({ "error" => "[WheelyApi]: not configured!" })
    end
  end
end
