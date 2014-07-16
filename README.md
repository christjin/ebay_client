EbayClient
==========

Simple, lightweight eBay Trading API Client.

Installation
------------

### Rails

`Gemfile`:

    gem 'ebay_client', git: 'git://github.com/christjin/ebay_client.git'

`config/ebay_client.yml`:

    development: &default
      api_keys:
        - sandbox_devid: '<YOUR SANDBOX DEV ID>'
          sandbox_appid: '<YOUR SANDBOX APP ID>'
          sandbox_certid: '<YOUR SANDBOX CERT ID>'
          live_devid: '<YOUR LIVE DEV ID>'
          live_appid: '<YOUR LIVE APP ID>'
          live_certid: '<YOUR LIVE CERT ID>'

    test:
      <<: *default

    production:
      api_keys:
        - sandbox_devid: '<YOUR SANDBOX DEV ID>'
          sandbox_appid: '<YOUR SANDBOX APP ID>'
          sandbox_certid: '<YOUR SANDBOX CERT ID>'
          live_devid: '<YOUR LIVE DEV ID>'
          live_appid: '<YOUR LIVE APP ID>'
          live_certid: '<YOUR LIVE CERT ID>'

Fire up your console!

Usage
-----

### Rails

e.g. `rails console`:

    EbayClient.api.config(use_sandbox: true, token: '<token>', siteid: 0)
    EbayClient.api.get_ebay_official_time!
    # => {:timestamp=>Fri, 22 Nov 2013 12:31:02 +0000}

Notes
-----
* An overview of possible API calls can be found at the
  [eBay Trading API docs](http://developer.ebay.com/DevZone/XML/docs/Reference/eBay/)
* Names (Methods, Types, Members) are mapped from `CamelCase` \<=\> `snake_case`
* `eBay` is mapped to `ebay`, i.e. `GeteBayOfficialTime` \<=\>
  `get_ebay_official_time`
* For each call, there are 2 methods, with and without a bang (`!`), i.e.  
    * `get_ebay_official_time` returns an `EbayClient::Response`
      instance, which contains the `ack` value, the `payload` and possibly
      `errors`
    * `get_ebay_official_time!` returns the payload as a `Hash` and raises
      an `EbayClient::Response::Exception` if the API returned an error.
* You can specify an arbitrary amount of API key/tokens in your
  `ebay_client.yml`. On initialization, the EbayClient will randomly
  choose one of them. If you run out of API calls, it will automatically
  switch to another key.
* Pull requests and bug reports are welcome!
