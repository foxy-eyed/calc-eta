# frozen_string_literal: true

module LoadFixture
  def load_fixture(filename, parse: true)
    format = File.extname(filename).tr(".", "")
    raw = File.read("./spec/fixtures/#{filename}")

    return JSON.parse(raw) if parse && format == "json"

    raw
  end
end
