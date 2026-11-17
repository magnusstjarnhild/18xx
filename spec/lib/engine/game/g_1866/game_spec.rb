# frozen_string_literal: true

require 'spec_helper'

describe Engine::Game::G1866::Game do
  describe 268_711 do
    it 'does not let a national run through a hex outside its region' do
      game = fixture_at_action(917)
      de = game.corporation_by_id('DE')
      route = Engine::Route.new(
        game,
        game.phase,
        de.trains.first,
        routes: [],
        connection_hexes: [%w[E17 E15], %w[E15 F14 G15], %w[G15 H16 H18 G19]],
      )

      expect { route.revenue }.to raise_error(Engine::GameError, 'Nationals can only run within its region')
    end
  end

  describe 'trains' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }

    def event_types(train_name)
      game.depot.trains.find { |t| t.name == train_name }.events.map { |e| e['type'] }
    end

    it 'makes the mail contract available with the first 5 train' do
      expect(event_types('4')).not_to include('infrastructure_m')
      expect(event_types('5')).to include('infrastructure_m')
    end

    it 'has four 5 trains' do
      expect(game.depot.trains.count { |t| t.name == '5' }).to eq(4)
    end
  end
end
