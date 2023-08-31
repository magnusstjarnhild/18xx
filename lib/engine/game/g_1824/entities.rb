# frozen_string_literal: true

module Engine
  module Game
    module G1824
      module Entities
        COMPANIES = [
          {
            sym: 'EPP',
            name: 'C1 Eisenbahn Pilsen - Priesen',
            value: 200,
            interval: [120, 140, 160, 180, 200],
            revenue: 0,
            desc: "Buyer take control of minor Coal Railway EPP (C1), which can be exchanged for the Director's "\
                  'certificate of Regional Railway BK during SRs in phase 3 or 4, or automatically when phase 5 starts. '\
                  'BK floats after exchange as soon as 50% or more are owned by players. This private cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'EOD',
            name: 'C2 Eisenbahn Oderberg - Dombran',
            value: 200,
            interval: [120, 140, 160, 180, 200],
            revenue: 0,
            desc: "Buyer take control of minor Coal Railway EOD (C2), which can be exchanged for the Director's "\
                  'certificate of Regional Railway MS during SRs in phase 3 or 4, or automatically when phase 5 starts. '\
                  'MS floats after exchange as soon as 50% or more are owned by players. This private cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'MLB',
            name: 'C3 Mosty - Lemberg Bahn',
            value: 200,
            interval: [120, 140, 160, 180, 200],
            revenue: 0,
            desc: "Buyer take control of minor Coal Railway MLB (C3), which can be exchanged for the Director's "\
                  'certificate of Regional Railway CL during SRs in phase 3 or 4, or automatically when phase 5 starts. '\
                  'CL floats after exchange as soon as 50% or more are owned by players. This private cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'SPB',
            name: 'C4 Simeria-Petrosani Bahn',
            value: 200,
            interval: [120, 140, 160, 180, 200],
            revenue: 0,
            desc: "Buyer take control of minor Coal Railway SPB (C4), which can be exchanged for the Director's "\
                  'certificate of Regional Railway SB during SRs in phase 3 or 4, or automatically when phase 5 starts. '\
                  'SB floats after exchange as soon as 50% or more are owned by players. This private cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'S1',
            name: 'S1 Wien-Gloggnitzer Eisenbahngesellschaft',
            value: 240,
            revenue: 0,
            desc: "Buyer take control of pre-staatsbahn S1, which will be exchanged for the Director's certificate "\
                  'of SD when the first 4 train is sold. Pre-Staatsbahnen starts in Wien (E12). Cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'S2',
            name: 'S2 Kärntner Bahn',
            value: 120,
            revenue: 0,
            desc: 'Buyer take control of pre-staatsbahn S2, which will be exchanged for a 10% share of SD when the '\
                  'first 4 train is sold. Pre-Staatsbahnen starts in Graz (G10). Cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'S3',
            name: 'S3 Nordtiroler Staatsbahn',
            value: 120,
            revenue: 0,
            desc: 'Buyer take control of pre-staatsbahn S3, which will be exchanged for a 10% share of SD when the '\
                  'first 4 train is sold. Pre-Staatsbahnen starts in Innsbruck (G4). Cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'U1',
            name: 'U1 Eisenbahn Pest - Waitzen',
            value: 240,
            revenue: 0,
            desc: "Buyer take control of pre-staatsbahn U1, which will be exchanged for the Director's certificate "\
                  'of UG when the first 5 train is sold. Pre-Staatsbahnen starts in Pest (F17) in base 1824 and in '\
                  'Budapest (G12) for 3 players on the Cislethania map. Cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'U2',
            name: 'U2 Mohacs-Fünfkirchner Bahn',
            value: 120,
            revenue: 0,
            desc: 'Buyer take control of pre-staatsbahn U2, which will be exchanged for a 10% share of UG when the '\
                  'first 5 train is sold. Pre-Staatsbahnen starts in Fünfkirchen (H15). Cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'K1',
            name: 'K1 Kaiserin Elisabeth-Bahn',
            value: 240,
            revenue: 0,
            desc: "Buyer take control of pre-staatsbahn K1, which will be exchanged for the Director's certificate "\
                  'of KK when the first 6 train is sold. Pre-Staatsbahnen starts in Wien (E12). Cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
          {
            sym: 'K2',
            name: 'K2 Kaiser Franz Joseph-Bahn',
            value: 120,
            revenue: 0,
            desc: 'Buyer take control of pre-staatsbahn K2, which will be exchanged for a 10% share of KK when the '\
                  'first 6 train is sold. Pre-Staatsbahnen starts in Wien (E12). Cannot be sold.',
            abilities: [{ type: 'no_buy', owner_type: 'player' }],
            color: nil,
          },
        ].freeze

        CORPORATIONS = [
          {
            float_percent: 50,
            name: 'Böhmische Kommerzbahn',
            sym: 'BK',
            type: 'Regional',
            tokens: [0, 40, 60, 80],
            logo: '1824/BK',
            simple_logo: '1824/BK.alt',
            color: :blue,
            coordinates: 'B9',
          },
          {
            name: 'Mährisch-Schlesische Eisenbahn',
            sym: 'MS',
            type: 'Regional',
            float_percent: 50,
            tokens: [0, 40, 60, 80],
            logo: '1824/MS',
            simple_logo: '1824/MS.alt',
            color: :yellow,
            text_color: 'black',
            coordinates: 'C12',
          },
          {
            name: 'Carl Ludwigs-Bahn',
            sym: 'CL',
            type: 'Regional',
            float_percent: 50,
            tokens: [0, 40, 60, 80],
            color: '#B3B3B3',
            logo: '1824/CL',
            simple_logo: '1824/CL.alt',
            coordinates: 'B23',
          },
          {
            name: 'Siebenbürgische Bahn',
            sym: 'SB',
            type: 'Regional',
            float_percent: 50,
            tokens: [0, 40, 60, 80],
            logo: '1824/SB',
            simple_logo: '1824/SB.alt',
            color: :green,
            text_color: 'black',
            coordinates: 'G26',
          },
          {
            name: 'Bosnisch-Herzegowinische Landesbahn',
            sym: 'BH',
            type: 'Regional',
            float_percent: 50,
            tokens: [0, 40, 100],
            logo: '1824/BH',
            simple_logo: '1824/BH.alt',
            color: :red,
            coordinates: 'J13',
          },
          {
            name: 'Südbahn',
            sym: 'SD',
            type: 'Staatsbahn',
            float_percent: 10,
            tokens: [100, 100],
            abilities: [
              {
                type: 'no_buy',
                description: 'Unavailable in SR before phase 4',
              },
            ],
            logo: '1824/SD',
            simple_logo: '1824/SD.alt',
            color: :orange,
            text_color: 'black',
          },
          {
            name: 'Ungarische Staatsbahn',
            sym: 'UG',
            type: 'Staatsbahn',
            float_percent: 10,
            tokens: [100, 100, 100],
            abilities: [
              {
                type: 'no_buy',
                description: 'Unavailable in SR before phase 5',
              },
            ],
            logo: '1824/UG',
            simple_logo: '1824/UG.alt',
            color: :purple,
          },
          {
            name: 'k&k Staatsbahn',
            sym: 'KK',
            type: 'Staatsbahn',
            float_percent: 10,
            tokens: [40, 100, 100, 100],
            abilities: [
              {
                type: 'no_buy',
                description: 'Unavailable in SR before phase 6',
              },
            ],
            logo: '1824/KK',
            simple_logo: '1824/KK.alt',
            color: :brown,
          },
        ].freeze

        MINORS = [
          {
            sym: 'EPP',
            name: 'C1 Eisenbahn Pilsen - Priesen',
            type: 'Coal',
            tokens: [0],
            logo: '1824/C1',
            coordinates: 'C6',
            city: 0,
            color: '#7F7F7F',
          },
          {
            sym: 'EOD',
            name: 'C2 Eisenbahn Oderberg - Dombran',
            type: 'Coal',
            tokens: [0],
            logo: '1824/C2',
            coordinates: 'A12',
            city: 0,
            color: '#7F7F7F',
          },
          {
            float_percent: 100,
            sym: 'MLB',
            name: 'C3 Mosty - Lemberg Bahn',
            type: 'Coal',
            tokens: [0],
            logo: '1824/C3',
            coordinates: 'A22',
            city: 0,
            color: '#7F7F7F',
          },
          {
            sym: 'SPB',
            name: 'C4 Simeria-Petrosani Bahn',
            type: 'Coal',
            tokens: [0],
            logo: '1824/C4',
            coordinates: 'H25',
            city: 0,
            color: '#7F7F7F',
          },
          {
            sym: 'S1',
            name: 'S1 Wien-Gloggnitzer Eisenbahngesellschaft',
            type: 'PreStaatsbahn',
            tokens: [0],
            logo: '1824/S1',
            coordinates: 'E12',
            city: 0,
            color: :orange,
          },
          {
            sym: 'S2',
            name: 'S2 Kärntner Bahn',
            type: 'PreStaatsbahn',
            tokens: [0],
            logo: '1824/S2',
            coordinates: 'G10',
            city: 0,
            color: :orange,
          },
          {
            sym: 'S3',
            name: 'S3 Nordtiroler Staatsbahn',
            type: 'PreStaatsbahn',
            tokens: [0],
            logo: '1824/S3',
            coordinates: 'G4',
            city: 0,
            color: :orange,
          },
          {
            sym: 'U1',
            name: 'U1 Eisenbahn Pest - Waitzen',
            type: 'PreStaatsbahn',
            tokens: [0],
            logo: '1824/U1',
            coordinates: 'F17',
            city: 1,
            color: :purple,
          },
          {
            sym: 'U2',
            name: 'U2 Mohacs-Fünfkirchner Bahn',
            type: 'PreStaatsbahn',
            tokens: [0],
            logo: '1824/U2',
            coordinates: 'H15',
            city: 0,
            color: :purple,
          },
          {
            sym: 'K1',
            name: 'K1 Kaiserin Elisabeth-Bahn',
            type: 'PreStaatsbahn',
            tokens: [0],
            coordinates: 'E12',
            city: 1,
            color: :brown,
            logo: '1824/K1',
          },
          {
            sym: 'K2',
            name: 'K2 Kaiser Franz Joseph-Bahn',
            type: 'PreStaatsbahn',
            tokens: [0],
            logo: '1824/K2',
            coordinates: 'E12',
            city: 2,
            color: :brown,
          },
        ].freeze
      end
    end
  end
end
