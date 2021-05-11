# frozen_string_literal: true

module Engine
  module Game
    module G18Ireland
      module Entities
        COMPANIES = [
          {
            name: 'Dalkey Atmospheric Railway',
            value: 20,
            revenue: 5,
            desc: 'No company can build in the Wicklow hex until this company is either bought by'\
            ' any company or closed.',
            sym: 'DAR',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['J14'] }],
          },
          {
            name: 'Donegal Railway',
            value: 30,
            revenue: 7,
            desc: 'The owning Corporation can place two connected narrow gauge yellow tiles in the Donegal'\
            ' hex and on adjacent hex. This action closes the company.',
            sym: 'DR',
            abilities: [
              {
                type: 'tile_lay',
                hexes: %w[F4 F2 E3 E5 G3 G5],
                tiles: %w[IR5 77 78 79],
                when: 'track',
                owner_type: 'corporation',
                count: 2,
                must_lay_together: true,
                must_lay_all: true,
                closed_when_used_up: true,
              },
            ],
          },
          {
            name: 'Board of Works',
            value: 40,
            revenue: 9,
            desc: 'The owning Corporation can place a yellow tile without payment of terrain costs.'\
            ' The company closes once this ability has been used twice.',
            sym: 'BoW',
            abilities: [
              {
                type: 'tile_lay',
                hexes: [],
                tiles: [],
                when: 'track',
                owner_type: 'corporation',
                consume_tile_lay: true,
                free: true,
                count: 2,
                closed_when_used_up: true,
              },
            ],
          },
          {
            name: 'City of Dublin Steam Packet Company',
            value: 45,
            revenue: 10,
            desc: 'The owning Corporation can place the +£10 token on any port (Belfast, Londonderry or Rosslare).'\
            ' This action closes the company, but the Corporation adds £10 to the' \
            " port's revenue until the end of the game.",
            sym: 'CDSPC',
            abilities: [
              {
                type: 'assign_hexes',
                when: 'owning_corp_or_turn',
                hexes: %w[J4 G1 I19],
                count: 1,
                owner_type: 'corporation',
              },
              {
                type: 'assign_corporation',
                when: 'any',
                count: 1,
                owner_type: 'corporation',
              },
            ],
          },
          {
            name: 'Tralee & Dingle Railway',
            value: 50,
            revenue: 10,
            desc: 'The owning Corporation can place two connected narrow gauge yellow tiles in the'\
            ' Tralee and Dingle hexes. This action closes the company.',
            sym: 'TDR',
            abilities: [
              {
                type: 'tile_lay',
                hexes: %w[A19 B18],
                tiles: ['IR5'],
                when: 'track',
                owner_type: 'corporation',
                count: 2,
                must_lay_together: true,
                must_lay_all: true,
                closed_when_used_up: true,
              },
            ],
          },
          {
            name: 'Drumglass Colliery Railway',
            value: 60,
            revenue: 12,
            desc: 'No Corporation can build in the DCR hex (H4) until this company is bought by any Corporation'\
            ' or closed. The owning Corporation may place a yellow tile'\
            ' on that hex (H4) without using a tile action or paying terrain costs.',
            sym: 'DCR',
            abilities: [
              {
                type: 'blocks_hexes',
                owner_type: 'player',
                hexes: ['H4'],
              },
              {
                type: 'tile_lay',
                hexes: ['H4'],
                tiles: [],
                when: 'owning_corp_or_turn',
                owner_type: 'corporation',
                free: true,
                count: 1,
              },
            ],
          },
          {
            name: 'Trans-Atlantic Steam Packet Station',
            value: 75,
            revenue: 15,
            desc: 'The owning Corporation can place the +£20 token on Galway. This action closes the company,'\
            " but the Corporation adds £20 to the city's revenue until the end of the game.",
            sym: 'TASPS',
            abilities: [
              {
                type: 'assign_hexes',
                when: 'owning_corp_or_turn',
                hexes: %w[C13],
                count: 1,
                owner_type: 'corporation',
              },
              {
                type: 'assign_corporation',
                when: 'any',
                count: 1,
                owner_type: 'corporation',
              },
            ],
          },
          {
            name: 'River Shannon Shipping Co',
            value: 80,
            revenue: 10,
            desc: 'The owning Corporation controls a river link between Dromod and Limerick and adds the value of the'\
          ' other city to one train ending at either Dromod or Limerick.',
            sym: 'RSSC',
          },
          {
            name: 'William Dargan Esq.',
            value: 90,
            revenue: 10,
            desc: 'The owning Corporation can upgrade a second track tile during each'\
            " OR at a cost of £30 from the Corporation's Treasury.",
            sym: 'WDE',
          },
          {
            name: 'The Irish Mail',
            value: 110,
            revenue: 20,
            desc: 'The owning Corporation can place an off-board location tile adjacent'\
            ' to one of: Londonderry, Kingstown, or Waterford. This action closes the company,'\
            ' but any Corporation may run to the tile for the rest of the game.',
            sym: 'TIM',
            abilities: [
              {
                type: 'tile_lay',
                hexes: %w[F0 H0 G-1 J12 G21 H20],
                tiles: ['IM'],
                when: 'track',
                owner_type: 'corporation',
                count: 1,
                closed_when_used_up: true,
              },
            ],
          },
          {
            name: 'Dublin & Kingstown Railway',
            value: 120,
            revenue: 0,
            desc: 'The owner of this company: Takes the DKR directorship; sets the share'\
            ' price at half bid; places a 2H-Train on the charter; places the winning bid'\
            ' in the DKR treasury less the cost of the train and discards this card.',
            sym: 'DK',
            abilities: [
            { type: 'close', when: 'bought_train', corporation: 'DKR' },
            { type: 'no_buy' },
            { type: 'shares', shares: 'DKR_0' },
            ],
          },
      ].freeze

        CORPORATIONS = [
          {
            float_percent: 20,
            sym: 'GSWR',
            name: 'Great Southern & Western Railway',
            logo: '18_ireland/GSWR',
            tokens: [0, 20, 50],
            shares: [20, 10, 10, 10, 10, 10, 10, 10, 10],
            always_market_price: true,
            color: 'red',
            reservation_color: nil,
            type: 'major',
            max_ownership_percent: 70,
          },
          {
            float_percent: 20,
            sym: 'GNRI',
            name: 'Great Northern Railway (Ireland)',
            logo: '18_ireland/GNRI',
            tokens: [0, 20, 50],
            shares: [20, 10, 10, 10, 10, 10, 10, 10, 10],
            always_market_price: true,
            color: '#3DAAD6',
            reservation_color: nil,
            type: 'major',
            max_ownership_percent: 70,
          },
          {
            float_percent: 20,
            sym: 'DSER',
            name: 'Dublin & South Eastern Railway',
            logo: '18_ireland/DSER',
            tokens: [0, 20, 50],
            shares: [20, 10, 10, 10, 10, 10, 10, 10, 10],
            always_market_price: true,
            color: 'black',
            reservation_color: nil,
            type: 'major',
            max_ownership_percent: 70,
          },
          {
            float_percent: 20,
            sym: 'MGWR',
            name: 'Midland Great Western Railway',
            logo: '18_ireland/MGWR',
            tokens: [0, 20, 50],
            shares: [20, 10, 10, 10, 10, 10, 10, 10, 10],
            always_market_price: true,
            color: 'green',
            reservation_color: nil,
            type: 'major',
            max_ownership_percent: 70,
          },
          {
            float_percent: 20,
            sym: 'MRNCC',
            name: 'Midland Railway North Counties Committee',
            logo: '18_ireland/MRNCC',
            tokens: [0, 20, 50],
            shares: [20, 10, 10, 10, 10, 10, 10, 10, 10],
            always_market_price: true,
            color: '#DB7093',
            reservation_color: nil,
            type: 'major',
            max_ownership_percent: 70,
          },
          {
            float_percent: 20,
            sym: 'WLWR',
            name: 'Waterford, Limerick & Western Railway',
            logo: '18_ireland/WLWR',
            tokens: [0, 20, 50],
            shares: [20, 10, 10, 10, 10, 10, 10, 10, 10],
            always_market_price: true,
            color: 'yellow',
            text_color: 'black',
            reservation_color: nil,
            type: 'major',
            max_ownership_percent: 70,
          },
          {
            float_percent: 20,
            sym: 'CBSCR',
            name: 'Cork, Bandon & South Coast Railway',
            logo: '18_ireland/CBSCR',
            tokens: [0, 20, 50],
            shares: [20, 10, 10, 10, 10, 10, 10, 10, 10],
            always_market_price: true,
            color: 'brown',
            reservation_color: nil,
            type: 'major',
            max_ownership_percent: 70,
          },
          # minors
          {
            float_percent: 40,
            sym: 'LER',
            name: 'Londonderry & Enniskillen',
            logo: '18_ireland/LER',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: '#8B4513',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'G1',
          },
          {
            float_percent: 40,
            sym: 'CBPR',
            name: 'Cork, Blackrock & Passage Railway',
            logo: '18_ireland/CBPR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'E21',
          },
          {
            float_percent: 40,
            sym: 'EBSR',
            name: 'Enniskillen, Bundoran & Sligo Railway',
            logo: '18_ireland/EBSR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: '#F5DEB3',
            text_color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'F6',
          },
          {
            float_percent: 40,
            sym: 'SLNCR',
            name: 'Sligo, Leitrim & Northern Counties Railway',
            logo: '18_ireland/SLNCR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'gray',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'F6',
          },
          {
            float_percent: 40,
            sym: 'DDR',
            name: 'Dublin & Drogheda Railway',
            logo: '18_ireland/DDR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: '#98FB98',
            text_color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'I11',
            city: 1,
          },
          {
            float_percent: 40,
            sym: 'DKR',
            name: 'Dublin & Kingstown Railway',
            logo: '18_ireland/DKR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'purple',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'I11',
            city: 0,
          },
          {
            float_percent: 40,
            sym: 'GJR',
            name: 'Grand Junction Railway',
            logo: '18_ireland/GJR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'white',
            text_color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'D6',
          },
          {
            float_percent: 40,
            sym: 'UR',
            name: 'Ulster Railway',
            logo: '18_ireland/UR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'coral',
            text_color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'J4',
          },
          {
            float_percent: 40,
            sym: 'DER',
            name: 'Dundalk & Enniskillen Railway',
            logo: '18_ireland/DER',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'pink',
            text_color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'I9',
          },
          {
            float_percent: 40,
            sym: 'GNWR',
            name: 'Great Northern & Western Railway',
            logo: '18_ireland/GNWR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: '#9370DB',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'F10',
          },
          {
            float_percent: 40,
            sym: 'WKR',
            name: 'Waterford & Kilkenny Railway',
            logo: '18_ireland/WKR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'lightblue',
            text_color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'G19',
          },
          {
            float_percent: 40,
            sym: 'CIR',
            name: 'Central Ireland Railway',
            logo: '18_ireland/CIR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: '#556B2F',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'G13',
          },
          {
            float_percent: 40,
            sym: 'KJR',
            name: 'Kilkenny Junction Railway',
            logo: '18_ireland/KJR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: '#DDA0DD',
            text_color: 'black',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'G13',
          },
          {
            float_percent: 40,
            sym: 'WLR',
            name: 'Waterford & Limerick Railway',
            logo: '18_ireland/WLR',
            tokens: [0],
            shares: [40, 20, 20, 20],
            always_market_price: true,
            color: 'red',
            reservation_color: nil,
            type: 'minor',
            coordinates: 'D16',
          },
        ].freeze
      end
    end
  end
end
