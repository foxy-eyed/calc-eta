# frozen_string_literal: true

module CalcEta
  class Documentation
    def call(env)
      spec_uri = URI::HTTP.build(host: env["SERVER_NAME"],
                                 port: env["SERVER_PORT"],
                                 path: "/docs/")
                          .merge("eta-openapi.yaml").to_s

      [200, { "Content-Type" => "text/html" }, [build_body(spec_uri)]]
    end

    private

    def build_body(doc_url)
      <<~HTML
        <!doctype html>
        <html>
        <head>
          <meta charset="utf-8">
          <script type="module" src="https://unpkg.com/rapidoc/dist/rapidoc-min.js"></script>
        </head>
        <body>
          <rapi-doc spec-url="#{doc_url}" theme="dark"></rapi-doc>
        </body>
        </html>
      HTML
    end
  end
end
