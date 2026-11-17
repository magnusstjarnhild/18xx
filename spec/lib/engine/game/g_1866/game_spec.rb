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

  describe 'Great Britain (§8.1.2)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:player) { game.players.first }
    let(:corporation) { game.corporations.find { |c| game.corporation?(c) } }
    let(:dover) { game.hex_by_id('G5') }

    before { corporation.owner = player }

    it 'is only off-board areas reached by ferry' do
      expect(%w[E7 G3 G5].map { |h| game.hex_by_id(h).tile.offboards.size }).to eq([1, 1, 1])
      expect(game.hex_by_id('F6')).to be_nil
    end

    it 'needs a GB share to run there' do
      expect(game.hex_operating_rights?(corporation, dover)).to be(false)

      game.share_pool.transfer_shares(game.corporation_by_id('GB').shares[1].to_bundle, player)
      expect(game.hex_operating_rights?(corporation, dover)).to be(true)
    end
  end

  describe 'Spain (§8.1.2)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }

    it 'is a single off-board area on the French border' do
      spain = game.hex_by_id('P4')
      expect(spain.tile.offboards.size).to eq(1)
      expect(spain.tile.exits.map { |e| spain.neighbors[e].name }).to eq(%w[O3 O5 P6])
      expect(game.hex_by_id('R0')).to be_nil
    end
  end
end
