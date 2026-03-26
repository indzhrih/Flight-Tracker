# Flight-Tracker

Simple API that provides flight information in JSON format by flight number built with **Rails 7.2.3**

# Table of contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Local setup](#local-setup)
    - [Before you start](#before-you-start)
    - [Deployment](#deployment)
    - [Tests](#tests)
    - [Code style](#code-style-check)
- [Usage](#usage)
    - [Get flight information](#get-flight-information)
    - [Flight number format](#flight-number-format)
    - [CSV filling rake task](#csv-filling-rake-task)
- [Architecture](#architecture)
    - [Models](#models) 
    - [Controllers](#controllers)
    - [Services](#services)
    - [Adapter](#adapter)
    - [Clients](#clients)
    - [Commands](#commands)
    - [Jbuilder](#jbuilder)

# Requirements

* Ruby ≥ 3.3.4 [https://www.ruby-lang.org/en/downloads/]

* PostgreSQL [https://www.postgresql.org/download/]

# Installation

* Clone using the web URL with `git clone https://github.com/indzhrih/Flight-Tracker.git`

OR

* Use a password-protected SSH key with `git clone git@github.com:indzhrih/Flight-Tracker.git`

# Local setup

### Before you start

* Install application gems with `bundle install`

### Deployment

* Create a `.env` file in the project root and set the variables as in `.env.example`

* Run `bin/rails db:prepare` to create DB, apply migrations and populate database with seeds

* Run the server with `bin/rails s`

### Tests

* Run tests using `bundle exec rspec`

Test results will be displayed in your CLI

Test coverage report can be found in `coverage`

### Code style check

* Run rubocop with `bundle exec rubocop`

This will show code style issues

# Usage

### Get flight information

Send a GET request to: `/api/v1/flight/:flight_number`

Example:
```
curl http://localhost:3000/api/v1/flight/LH1234
```
**One-leg Response:**

```
{
  "route": {
    "departure": {
      "iata": "FRA",
      "city": "Frankfurt am Main",
      "country": "Germany",
      "latitude": 50.03,
      "longitude": 8.57
    },
    "arrival": {
      "iata": "VIE",
      "city": "Vienna",
      "country": "Austria",
      "latitude": 48.11,
      "longitude": 16.57
    }
  },
  "status": "OK",
  "distance": "620",
  "error_message": null
}
```

**Multi-leg response example:**

```
{
  "route": [
    {
      "departure": {
        "iata": "HEL",
        "city": "Helsinki",
        "country": "Finland",
        "latitude": 60.32,
        "longitude": 24.96
      },
      "arrival": {
        "iata": "YHZ",
        "city": "Halifax",
        "country": "Canada",
        "latitude": 44.88,
        "longitude": -63.51
      },
      "distance": "5727"
    },
    {
      "departure": {
        "iata": "YHZ",
        "city": "Halifax",
        "country": "Canada",
        "latitude": 44.88,
        "longitude": -63.51
      },
      "arrival": {
        "iata": "PTY",
        "city": "Tocumen",
        "country": "Panama",
        "latitude": 9.07,
        "longitude": -79.38
      },
      "distance": "4264"
    }
  ],
  "status": "OK",
  "distance": "9991",
  "error_message": null
}
```

**Fail response example:**

```
{
  "route": null,
  "status": "FAIL",
  "distance": 0,
  "error_message": "Incorrect flight number"
}
```

### Flight number format

The application accepts flight numbers in IATA/ICAO-like format, for example:
```
    SU1234
    LH1234
    AFL1234
```

Input values are normalized before lookup, so values like su12 become SU0012.

### CSV filling rake task

You can fill a CSV file with flight information using the rake task:

```
  bin/rails "flights:fill_csv[path/to/flight_numbers.csv]"
```

The filled file will be created in the same directory as the input file with the name: `flights_numbers_filled.csv`

CSV file must have the next structure:

| Example flight number | Flight number used for lookup | Lookup status | Number of legs | First leg departure airport IATA | Last leg arrival airport IATA | Distance in kilometers |
|-----------------------|-------------------------------|---------------|----------------|----------------------------------|-------------------------------|------------------------|
| `ENT4766`             |                               |               |                |                                  |                               |                        |
| `FR9663`              |                               |               |                |                                  |                               |                        |
| `"LH1829, LH1624"`    |                               |               |                |                                  |                               |                        |
| `INVALID`             |                               |               |                |                                  |                               |                        |

# Architecture

### Models
- `Flight` - stores flight information
- `Leg`- describes one segment of the route
- `Airport` - contains airport data

### Controllers

The only controller is `Api::V1::FlightsController`. The show action takes the `flight_number` parameter, calls `FlightSearch::FlightFinder` and returns a JSON response.

### Services

`FlightSearch::FlightFinder` - Primary coordinator

  - Normalizes the flight number with `FlightNumberNormalizer`

  - Tries to find data in the database with `MakeDatabaseJson`

    If the data is found and fresh, returns it.

    Otherwise, accesses the external API with `MakeAdsbdbJson`

  -  If successful, saves data to the database with `SaveFlightToDatabase` and returns the result.

  - Returns a response with `MakeFailJson` when there are errors.

`FlightSearch::FlightNumberNormalizer` – The service to bring the flight number into a standard format (XXZZZZ or YYYZZZZ). Uses a regular expression and adds zeros to numeric part.

`FlightSearch::DistanceCalculator` - Calculates the distance between two airports according to a Haversines formula (based on their coordinates).

### Adapter
`FlightSearch::Adapters::AdsbdbResponseAdapter` - Adapts a raw response from the external API (ADSBdb) to a common internal format.

Implements adapter pattern

### Clients

`FlightSearch::Clients::AdsbdbClient` - wrapper for HTTP requests to ADSBdb.

Uses `Faraday` with a pre-configured connection.

### Commands

Set of classes that implement the `Command` pattern for encapsulating individual operations

- `MakeDatabaseJson` - Builds JSON from data already in the database. 
- `MakeAdsbdbJson` - Sequentially invokes the client, adapter, and save command. Returns either the result of the adapter (success) or an error string
- `SaveFlightToDatabase` - Stores data from the external API in the database
- `MakeFailJson` - Returns a unified response with an error (status: 'FAIL').

### Jbuilder
`Jbuilder` is used to generate the JSON response API.
