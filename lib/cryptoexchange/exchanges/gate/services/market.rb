module Cryptoexchange::Exchanges
  module Gate
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            false
          end
        end

        def fetch
          output = super ticker_url
          adapt_all output
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Gate::Market::API_URL}/tickers"
        end

        def adapt_all(output)
          output.map do |market_pair_key, ticker|
            base, target = market_pair_key.split('_')
            market_pair = Cryptoexchange::Models::MarketPair.new(
                base: base,
                target: target,
                market: Gate::Market::NAME
              )
            adapt(ticker, market_pair)
          end
        end

        def adapt(output, market_pair)
          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = Gate::Market::NAME
          ticker.ask       = NumericHelper.to_d(output['lowestAsk'])
          ticker.bid       = NumericHelper.to_d(output['highestBid'])
          ticker.last      = NumericHelper.to_d(output['last'])
          ticker.high      = NumericHelper.to_d(output['high24hr'])
          ticker.low       = NumericHelper.to_d(output['low24hr'])
          ticker.volume    = NumericHelper.to_d(output['quoteVolume'])
          ticker.timestamp = nil
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end
