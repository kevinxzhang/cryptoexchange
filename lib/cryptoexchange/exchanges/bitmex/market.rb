module Cryptoexchange::Exchanges
  module Bitmex
    class Market < Cryptoexchange::Models::Market
      NAME = 'bitmex'
      API_URL = 'https://www.bitmex.com/api/v1'

      def self.trade_page_url(args={})
        "https://www.bitmex.com/app/trade/#{args[:inst_id]}"
      end
    end
  end
end
