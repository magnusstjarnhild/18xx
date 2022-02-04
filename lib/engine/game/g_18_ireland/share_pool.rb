# frozen_string_literal: true

require_relative '../../share_pool'

module Engine
  module Game
    module G18Ireland
      class SharePool < Engine::SharePool
        def fit_in_bank?(bundle)
          return super unless bundle.corporation.type == :minor

          (bundle.percent + percent_of(bundle.corporation)) <= @game.class::MINOR_MARKET_SHARE_LIMIT
        end

        def bank_at_limit?(corporation)
          return super unless corporation.type == :minor

          percent_of(corporation) >= @game.class::MINOR_MARKET_SHARE_LIMIT
        end
      end
    end
  end
end
