# frozen_string_literal: true

module Engine
  module Game
    module G1849
      module Map
        TILES = {
          '3' => 4,
          '4' => 4,
          '7' => 4,
          '8' => 10,
          '9' => 6,
          '58' => 4,
          '73' => 4,
          '74' => 3,
          '77' => 4,
          '78' => 10,
          '79' => 7,
          '644' => 2,
          '645' => 2,
          '657' => 2,
          '658' => 2,
          '659' => 2,
          '679' => 2,
          '23' => 3,
          '24' => 3,
          '25' => 2,
          '26' => 1,
          '27' => 1,
          '28' => 1,
          '29' => 1,
          '30' => 1,
          '31' => 1,
          '624' => 1,
          '650' => 1,
          '651' => 1,
          '653' => 1,
          '655' => 2,
          '660' => 1,
          '661' => 1,
          '662' => 1,
          '663' => 1,
          '664' => 1,
          '665' => 1,
          '666' => 1,
          '667' => 1,
          '668' => 1,
          '669' => 1,
          '670' => 1,
          '671' => 1,
          '675' => 1,
          '677' => 3,
          '678' => 3,
          '680' => 1,
          '681' => 1,
          '682' => 1,
          '683' => 1,
          '684' => 1,
          '685' => 1,
          '686' => 1,
          '687' => 1,
          '688' => 1,
          '689' => 1,
          '690' => 1,
          '691' => 1,
          '692' => 1,
          '693' => 1,
          '694' => 1,
          '695' => 1,
          '699' => 2,
          '700' => 1,
          '701' => 1,
          '702' => 1,
          '703' => 1,
          '704' => 1,
          '705' => 1,
          '706' => 1,
          '707' => 1,
          '708' => 1,
          '709' => 1,
          '710' => 1,
          '711' => 1,
          '712' => 1,
          '713' => 1,
          '714' => 1,
          '715' => 1,
          '39' => 1,
          '40' => 1,
          '41' => 1,
          '42' => 1,
          '646' => 1,
          '647' => 1,
          '648' => 1,
          '649' => 1,
          '652' => 1,
          '654' => 1,
          '656' => 2,
          '672' => 1,
          '673' => 2,
          '674' => 2,
          '676' => 1,
          '696' => 3,
          '697' => 2,
          '698' => 2,
        }.freeze

        LOCATION_NAMES = {
          'A13' => 'Milazzo',
          'B14' => 'Messina',
          'C1' => 'Trapani',
          'C5' => 'Palermo',
          'C9' => 'St. Stefano',
          'C15' => 'Calabria',
          'D4' => 'Partinico',
          'E1' => 'Marsala',
          'E5' => 'Corleone',
          'E7' => 'Termini Imerese',
          'E11' => 'Bronte',
          'E13' => 'Taormina',
          'F10' => 'Troina',
          'G1' => 'Mazzara',
          'G3' => 'Castelvetrano',
          'G9' => 'Castrogiovanni',
          'G13' => 'Acireale',
          'H4' => 'Sciacca',
          'H8' => 'Caltanissetta',
          'H12' => 'Catania',
          'I7' => 'Canicatti',
          'I9' => 'Piazza Armerina',
          'J6' => 'Girgenti',
          'J10' => 'Caltagirone',
          'K7' => 'Licata',
          'K13' => 'Augusta',
          'M9' => 'Terranova',
          'M11' => 'Ragusa',
          'M13' => 'Siracusa',
          'N10' => 'Vittoria',
          'F12' => 'Etna',
        }.freeze

        HEXES = {
          white: {
            %w[H2 L8 O11 B12 J12 D14] => '',
            ['C11'] => 'border=edge:0,type:impassable',
            %w[B4 C7] => 'border=edge:1,type:impassable',
            ['N12'] => 'border=edge:2,type:impassable',
            ['D6'] => 'border=edge:4,type:impassable',
            %w[D8 D10] => 'border=edge:0,type:impassable;border=edge:1,type:impassable;border=edge:5,type:impassable',
            ['F8'] => 'border=edge:3,type:impassable;upgrade=cost:160,terrain:mountain',
            ['L10'] => 'border=edge:4,type:impassable;upgrade=cost:160,terrain:mountain',
            ['E9'] =>
                   'border=edge:2,type:impassable;border=edge:4,type:impassable;upgrade=cost:160,terrain:mountain',
            %w[G1 G3 K7 N10 G13] => 'town=revenue:0',
            %w[C3 E7] => 'town=revenue:0;border=edge:4,type:impassable',
            ['B2'] => 'border=edge:1,type:impassable;upgrade=cost:40,terrain:mountain',
            ['K11'] =>
                   'border=edge:0,type:impassable;border=edge:1,type:impassable;upgrade=cost:40,terrain:mountain',
            ['F10'] =>
                   'town=revenue:0;border=edge:3,type:impassable;upgrade=cost:160,terrain:mountain',
            %w[H6 H10] => 'upgrade=cost:40,terrain:mountain',
            %w[E3 F6 I5 G7] => 'upgrade=cost:80,terrain:mountain',
            %w[D2 F2 F4 G5 J8 G11 D12 L12] =>
                   'upgrade=cost:160,terrain:mountain',
            %w[D4 I7 J10] => 'town=revenue:0;upgrade=cost:40,terrain:mountain',
            %w[H4 G9] => 'town=revenue:0;upgrade=cost:80,terrain:mountain',
            %w[E5 I9] => 'town=revenue:0;upgrade=cost:160,terrain:mountain',
            ['E11'] => 'town=revenue:0;border=edge:2,type:impassable;border=edge:3,type:impassable;'\
                       'upgrade=cost:160,terrain:mountain',
            ['H8'] => 'city=revenue:0;upgrade=cost:80,terrain:mountain',
            ['J6'] => 'city=revenue:0;upgrade=cost:40,terrain:mountain',
          },
          yellow: {
            ['K9'] => 'upgrade=cost:160,terrain:mountain;path=a:0,b:3,track:narrow',
            ['C5'] => 'label=P;city=revenue:50;path=a:5,b:_0;path=a:2,b:_0;path=a:3,b:_0',
            ['H12'] => 'label=C;city=revenue:40;path=a:1,b:_0',
            ['M13'] => 'label=S;city=revenue:10;path=a:2,b:_0,track:narrow',
            ['B14'] => 'label=M;city=revenue:30;path=a:0,b:_0',
            ['M11'] => 'city=revenue:20;upgrade=cost:40,terrain:mountain;path=a:1,b:_0;'\
                       'path=a:4,b:_0,track:narrow;border=edge:3,type:impassable;'\
                       'border=edge:5,type:impassable',
            ['I11'] => 'path=a:2,b:4',
          },
          blue: {
            ['a12'] => 'offboard=revenue:20,route:optional;path=a:5,b:_0',
            ['A5'] => 'offboard=revenue:10,route:optional;path=a:0,b:_0',
            ['N8'] => 'offboard=revenue:20,route:optional;path=a:4,b:_0,track:dual',
            ['L14'] => 'offboard=revenue:60,route:optional;path=a:2,b:_0',
          },
          gray: {
            ['F12'] => '',
            ['A15'] => 'path=a:1,b:5,track:dual',
            ['B16'] => 'path=a:1,b:2,track:dual',
            ['C15'] =>
            'offboard=revenue:white_10|gray_30|black_90;path=a:4,b:_0,track:dual',
            ['C9'] =>
            'town=revenue:10;path=a:0,b:_0,track:narrow;path=a:1,b:_0;path=a:5,b:_0',
            ['C13'] => 'path=a:1,b:4,track:narrow;path=a:2,b:3',
            ['E13'] =>
            'town=revenue:10;path=a:0,b:_0;path=a:2,b:_0,track:narrow;path=a:4,b:_0',
            %w[A13 K13] => 'town=revenue:10;path=a:0,b:_0;path=a:2,b:_0;path=a:5,b:_0',
            ['C1'] => 'border=edge:4,type:impassable;city=revenue:white_20|gray_30|black_40;'\
                      'path=a:0,b:_0,track:dual;path=a:5,b:_0,track:dual',
            ['E1'] => 'city=revenue:white_20|gray_30|black_40;path=a:0,b:_0,track:dual;'\
                      'path=a:3,b:_0,track:dual;path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual',
            ['M9'] => 'city=slots:2,revenue:white_20|gray_30|black_40;path=a:1,b:_0,track:dual;'\
                      'path=a:2,b:_0;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;'\
                      'path=a:5,b:_0',
          },
        }.freeze

        LAYOUT = :flat

        AXES = { x: :number, y: :letter }.freeze
      end
    end
  end
end
