## ETA calculation service

[![Lint and test](https://github.com/foxy-eyed/calc-eta/actions/workflows/lint_and_test.yml/badge.svg?branch=main&event=push)](https://github.com/foxy-eyed/calc-eta/actions/workflows/lint_and_test.yml)

### To run locally
```
docker-compose up -d --build
```
Now you have app running at http://localhost:9292 and ready to process your requests.

### API

 * To get ETA: `GET /eta`

    Example:
    ```
    curl -X GET "http://localhost:9292/eta?lat=53.2159&lng=50.132277"
    ```

You can find interactive API documentation at http://localhost:9292/documentation:

![Documentation](http://g.recordit.co/hmV3S28UUN.gif)

### To run tests
```
docker-compose run --rm test bundle exec rspec
```

Also you can check [this workflow](https://github.com/foxy-eyed/calc-eta/actions/workflows/lint_and_test.yml) runs to ensure all tests are passed.
