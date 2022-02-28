# frozen_string_literal: true

describe WheelyApi do
  describe ".cars" do
    subject(:cars) { described_class.cars(**params) }

    let(:endpoint) { "#{ENV['WHEELY_API_URL']}/cars" }
    let(:params) { { lat: 53.21590, lng: 50.132277, limit: 5 } }

    it "returns body of successful response" do
      cars_response = { status: 200, body: load_fixture("cars_response.json", parse: false) }
      stub_request(:get, endpoint).with(query: params).to_return(cars_response)

      expect(cars).to eq(cars_response[:body])
    end

    it "raises instance of WheelyApi::Error if api responds with error" do
      cars_response = { status: 500, body: "Internal error!" }
      stub_request(:get, endpoint).with(query: params).to_return(cars_response)

      expect { cars }.to(raise_exception(WheelyApi::Error, "[WheelyApi]: 500 — Internal error!"))
    end

    it "wraps faraday error with WheelyApi::Error" do
      stub_request(:get, endpoint).with(query: params).to_timeout

      expect { cars }.to(raise_exception(WheelyApi::Error, "[WheelyApi]: execution expired"))
    end

    context "when WHEELY_API_URL is missed" do
      it "raises error" do
        stub_const("ENV", { "WHEELY_API_URL" => nil })

        expect { cars }.to(raise_exception(WheelyApi::Error, "[WheelyApi]: not configured!"))
      end
    end
  end

  describe ".predict" do
    subject(:predict) { described_class.predict(**params) }

    let(:endpoint) { "#{ENV['WHEELY_API_URL']}/predict" }
    let(:params) do
      { target: { lat: 53.21590, lng: 50.132277 }, source: load_fixture("cars_response.json") }
    end

    it "returns body of successful response" do
      predict_response = { status: 200, body: "[1, 1, 3, 2, 2]" }
      stub_request(:post, endpoint).with(body: params).to_return(predict_response)

      expect(predict).to eq(predict_response[:body])
    end

    it "raises instance of WheelyApi::Error if api responds with error" do
      predict_response = { status: 500, body: "Internal error!" }
      stub_request(:post, endpoint).with(body: params).to_return(predict_response)

      expect { predict }.to(raise_exception(WheelyApi::Error, "[WheelyApi]: 500 — Internal error!"))
    end

    it "wraps faraday error with WheelyApi::Error" do
      stub_request(:post, endpoint).with(body: params).to_timeout

      expect { predict }.to(raise_exception(WheelyApi::Error, "[WheelyApi]: execution expired"))
    end

    context "when WHEELY_API_URL is missed" do
      it "raises error" do
        stub_const("ENV", { "WHEELY_API_URL" => nil })

        expect { predict }.to(raise_exception(WheelyApi::Error, "[WheelyApi]: not configured!"))
      end
    end
  end
end
