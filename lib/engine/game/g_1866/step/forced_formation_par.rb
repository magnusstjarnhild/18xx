# frozen_string_literal: true

require_relative '../../../step/base'

module Engine
  module Game
    module G1866
      module Step
        class ForcedFormationPar < Engine::Step::Base
          ACTIONS = %w[par].freeze

          def actions(entity)
            return [] unless entity == current_entity

            ACTIONS
          end

          def active?
            !corporation_pending_par.nil?
          end

          def active_entities
            [corporation_pending_par&.par_via_exchange&.owner].compact
          end

          def corporation_pending_par
            @game.pending_forced_formation
          end

          def description
            "Choose #{corporation_pending_par.name} par value"
          end

          def get_par_prices(_entity, corporation)
            @game.forced_formation_par_prices(corporation)
          end

          def par_price_only(_corporation, _share_price)
            true
          end

          def process_par(action)
            corporation = action.corporation
            share_price = action.share_price
            raise GameError, "#{corporation.name} is not forming" unless corporation == corporation_pending_par
            unless get_par_prices(action.entity, corporation).include?(share_price)
              raise GameError, "#{corporation.name} cannot par at #{@game.format_currency(share_price.price)}"
            end

            @game.complete_forced_formation!(share_price)
          end
        end
      end
    end
  end
end
