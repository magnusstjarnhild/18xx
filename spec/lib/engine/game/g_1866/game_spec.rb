# frozen_string_literal: true

require 'spec_helper'

describe Engine::Game::G1866::Game do
  describe 'national routes (§8.3)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }

    it 'does not let a national run through a hex outside its region' do
      hexes = %w[F22 F20 F18].map { |h| game.hex_by_id(h) }
      route = instance_double(Engine::Route, corporation: game.corporation_by_id('PRU'), all_hexes: hexes)

      expect { game.check_distance(route, []) }.to raise_error(Engine::GameError, 'Nationals can only run within its region')
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

  describe 'setup (§3.1)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:in_play) { game.corporations.select { |c| game.corporation?(c) } }

    it 'puts 11 public companies in play' do
      expect(in_play.size).to eq(11)
    end

    it 'includes a public company from each of France, A-H, Germany and Italy' do
      expect(described_class::REGION_CORPORATIONS.values.map { |ids| in_play.any? { |c| ids.include?(c.id) } })
        .to all(be(true))
    end
  end

  describe 'C tiles (§3.4)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }

    def tile(name)
      game.tiles.find { |t| t.name == name }
    end

    it 'gives each C hex a different one of the seven configurations' do
      labels = described_class::C_TILE_HEX.map { |h| game.hex_by_id(h).tile.label.to_s }
      expect(labels.uniq.size).to eq(6)
      expect(labels - described_class::C_TILE_LABEL).to be_empty
    end

    it 'keeps the seventh configuration when upgrading (§8.2.3)' do
      expect(game.upgrades_to?(tile('C25'), tile('C26'))).to be(true)
      expect(game.upgrades_to?(tile('C25'), tile('C10'))).to be(false)
      expect(game.upgrades_to?(tile('C27'), tile('C28'))).to be(true)
    end
  end

  describe 'major national dividends (§8.1.2, §8.2.7)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:step) { Engine::Game::G1866::Step::Dividend.new(game, game.round) }

    def payout(national_id)
      national = game.corporation_by_id(national_id)
      allow(step).to receive(:current_entity).and_return(national)
      step.dividend_options(national)[:payout]
    end

    it 'pays the fixed dividend per share from table 15' do
      expect(payout('DE')[:per_share]).to eq(50)
      expect(payout('CH')[:per_share]).to eq(10)
    end

    it 'moves the share price one space right' do
      expect(payout('GB')).to include(share_direction: :right, share_times: 1)
    end

    it 'does not buy trains' do
      buy_train = Engine::Game::G1866::Step::BuyTrain.new(game, game.round)
      allow(buy_train).to receive(:current_entity).and_return(game.corporation_by_id('DE'))
      expect(buy_train.actions(game.corporation_by_id('DE'))).to be_empty
    end
  end

  describe 'forced formation (§10.2.3)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:player) { game.players.first }
    let(:step) { Engine::Game::G1866::Step::ForcedFormationPar.new(game, game.round) }
    let(:ch) { game.corporation_by_id('CH') }
    let(:esp) { game.corporation_by_id('ESP') }
    let(:bnl) { game.corporation_by_id('BNL') }

    def par!(corporation, share_price)
      step.process_par(Engine::Action::Par.new(player, corporation: corporation, share_price: share_price))
    end

    before do
      %w[C6 C4].each { |id| game.company_by_id(id).owner = player }
      allow(game).to receive(:phase_par_type).and_return(:par_2)
      allow(game.round).to receive(:check_operating_order!)
      game.event_formation!
    end

    it 'waits for the concession holder to choose a price' do
      expect(game.pending_forced_formation).to eq(ch)
      expect(step.active_entities).to eq([player])
    end

    it 'lets the holder choose any legal price' do
      highest = step.get_par_prices(player, ch).first
      cash = player.cash
      par!(ch, highest)

      expect(ch.share_price).to eq(highest)
      expect(player.cash).to eq(cash - highest.price)
      expect(game.pending_forced_formation).to eq(bnl)
    end

    it 'forms a concession nobody bought at the lowest legal price' do
      lowest = step.get_par_prices(player, esp).last
      par!(ch, step.get_par_prices(player, ch).first)

      expect(esp.share_price).to eq(lowest)
    end

    it 'rejects a price outside the brown zone' do
      yellow = game.stock_market.par_prices.find { |p| p.types.include?(:par) }
      expect { par!(ch, yellow) }.to raise_error(Engine::GameError)
    end
  end

  describe 'major national track lays (§8.2.3.2)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:a) { game.players[0] }
    let(:b) { game.players[1] }
    let(:ch) { game.corporation_by_id('CH') }
    let(:round) do
      game.instance_variable_set(:@round, game.operating_round(1))
      game.round
    end

    before do
      game.company_by_id('C6').owner = b
      game.forced_formation_national(ch, game.forced_formation_par_prices(ch).last)
      game.share_pool.transfer_shares(game.share_pool.shares_of(ch).first.to_bundle, a)
      round
    end

    it 'gives the director the first tile, then each shareholder in seating order' do
      expect(game.active_players).to eq([b])
      round.process_action(Engine::Action::Pass.new(ch))
      expect(game.active_players).to eq([a])
    end

    it 'gives each shareholder one tile' do
      tile = game.tiles.find { |t| t.name == '57' }
      round.process_action(Engine::Action::LayTile.new(ch, tile: tile, hex: game.hex_by_id('L14'), rotation: 0))

      expect(game.hex_by_id('L14').tile).to eq(tile)
      expect(game.active_players).to eq([a])
    end

    it 'offers the next shareholder to skip, not to finish' do
      round.process_action(Engine::Action::Pass.new(ch))
      expect(round.active_step.pass_description).to eq('Skip (Track)')
    end

    it 'only lets the shareholder whose turn it is lay track' do
      expect(game.valid_actors(Engine::Action::Pass.new(ch))).to eq([b])
    end

    it 'shows the shareholder whose turn it is as acting for the national' do
      round.process_action(Engine::Action::Pass.new(ch))

      expect(game.acting_for_entity(ch)).to eq(a)
      expect(game.valid_actors(Engine::Action::Pass.new(ch))).to eq([a])
    end

    it 'does not log a shareholder laying track as master mode' do
      round.process_action(Engine::Action::Pass.new(ch))
      pass = Engine::Action::Pass.new(ch)
      pass.user = a.id
      game.process_action(pass)

      expect(game.log.map(&:message).grep(/Master Mode/)).to be_empty
    end

    it 'gives no tiles to Great Britain and Spain, which are only off-board areas' do
      %w[GB ESP].zip(%w[C1 C5]).each do |national_id, concession_id|
        national = game.corporation_by_id(national_id)
        game.company_by_id(concession_id).owner = a
        game.forced_formation_national(national, game.forced_formation_par_prices(national).last)

        expect(national.owner).to eq(a)
        expect(game.major_national_track_layers(national)).to be_empty
      end
    end

    it 'ends the track step after the last shareholder' do
      2.times { round.process_action(Engine::Action::Pass.new(ch)) }
      expect(round.active_step).not_to be_a(Engine::Game::G1866::Step::Track)
    end
  end

  describe 'emergency share issuing (§11.1)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:corporation) { game.corporations.find { |c| game.corporation?(c) } }

    before do
      par_price = game.stock_market.par_prices.find { |p| p.types.include?(:par) && p.price > game.depot.min_depot_price }
      game.par_corporation(corporation, par_price)
      allow(game).to receive(:bundles_for_corporation).and_return(corporation.ipo_shares.map(&:to_bundle))
    end

    it 'offers a share when one share covers the cheapest train' do
      expect(game.emergency_issuable_bundles(corporation).map(&:num_shares).uniq).to eq([1])
    end

    it 'offers nothing at a share price of £0' do
      corporation.share_price = game.stock_market.share_price([0, 0])
      expect(game.emergency_issuable_bundles(corporation)).to be_empty
    end
  end

  describe 'minor nationals (§8.1.3)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }

    it 'keeps the bank half out of reach' do
      minors = game.corporations.select { |c| game.minor_national_corporation?(c) }
      expect(minors.flat_map(&:shares).reject(&:president).map(&:buyable)).to all(be(false))
    end
  end

  describe 'losing operating rights (§7.3)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:corporation) { game.corporations.find { |c| game.corporation?(c) } }
    let(:routes) { game.graph.instance_variable_get(:@routes) }

    before do
      corporation.owner = game.players.first
      allow(corporation).to receive(:floated?).and_return(true)
      routes[corporation] = { route_available: true, route_train_purchase: true }
    end

    it 'forgets the routes the company could run before' do
      game.corporation_token_rights!(corporation)
      expect(routes).not_to include(corporation)
    end
  end

  describe 'closing at a share price of £0 (§8.2.13)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:corporation) { game.corporations.find { |c| game.corporation?(c) } }
    let(:train) { game.depot.upcoming.first }

    before do
      game.par_corporation(corporation, game.stock_market.par_prices.find { |p| p.types.include?(:par) })
      game.buy_train(corporation, train, :free)
    end

    it 'removes its trains from the game' do
      game.corporation_closes(corporation)
      expect(train.buyable).to be(false)
    end
  end

  describe 'major national formed without a concession holder (§10.2.3)' do
    let(:game) { described_class.new(%w[a b c], seed: 1) }
    let(:ch) { game.corporation_by_id('CH') }

    before do
      allow(game).to receive(:phase_par_type).and_return(:par_2)
      allow(game.round).to receive(:check_operating_order!)
      game.event_formation!
    end

    it 'has no shareholders and no track' do
      expect(ch.num_player_shares).to eq(0)
      expect(game.major_national_track_layers(ch)).to be_empty
    end

    it 'rises one space every operating round' do
      par = ch.share_price
      game.instance_variable_set(:@round, game.operating_round(1))
      game.round.setup

      expect(ch.share_price).to eq(game.stock_market.share_price(par.coordinates.then { |r, c| [r, c + 1] }))
      expect(game.log.map(&:message)).to include('CH operates without any president')
    end
  end
end
