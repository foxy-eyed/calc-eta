# frozen_string_literal: true

describe RedisCache do
  subject(:cache) { described_class.new }

  describe "#read" do
    it "returns value when key present" do
      cache.write("key", "value")
      expect(cache.read("key")).to eq("value")
    end

    it "returns nil with nonexistent key" do
      expect(cache.read("key")).to be_nil
    end
  end

  describe "#exists?" do
    it "is truthy when key present" do
      cache.write("key", "value")
      expect(cache).to be_exists("key")
    end

    it "is false with nonexistent key" do
      expect(cache).not_to be_exists("key")
    end
  end

  describe "#fetch" do
    # rubocop:disable Style/RedundantFetchBlock
    it "returns stored value if key present" do
      cache.write("key", "value")
      value = cache.fetch("key") { "block-return-value" }
      expect(value).to eq("value")
    end

    it "returns block result with nonexistent key" do
      value = cache.fetch("key") { "block-return-value" }
      expect(value).to eq("block-return-value")
    end

    it "persists block result with nonexistent key" do
      cache.fetch("key") { "block-return-value" }
      expect(cache.read("key")).to eq("block-return-value")
    end
    # rubocop:enable Style/RedundantFetchBlock
  end

  describe "#delete" do
    it "deletes key" do
      cache.write("key", "value")
      cache.delete("key")

      expect(cache).not_to be_exists("key")
    end
  end
end
