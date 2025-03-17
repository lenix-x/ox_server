return {
	-- nightvision
	['nightvision'] = {
		label = 'Night Vision',
		weight = 500,
		client = {
			export = 'nightvision.toggle'
		}
	},
	-- laptop
	['laptop'] = {
		label = 'Facade Laptop',
		description = 'A high-tech gadget that is always up to something',
		stack = false,
		close = false,
		consume = 0,
		client = {
			image = 'fd_laptop.png',
		},
		server = {
			export = 'fd_laptop.useLaptop'
		},
		buttons = {
			{
				label = 'Open storage',
				action = function(slot)
					TriggerServerEvent('fd_laptop:server:openLaptopStorage', slot)
				end
			}
		}
	},
	-- bombs
	['bomb'] = {
		label = 'C4',
		weight = 1500,
		client = {
			export = 'bombs.plantbomb'
		}
	},
	-- stoic dart
	['dart_device'] = {
        label = 'D.A.R.T',
        weight = 1000,  -- Adjust weight as needed
        stack = false,  -- Assuming one dart_device cannot be stacked
        close = true,   -- Close inventory after use
        consume = 1,    -- Consumes 1 dart_device per use
        description = 'DART_Device',
        client = {
            export = 'Stoic-DART.FireDart'  -- Calls the 'FireDart' export from client.lua
        }
    },
    ['angle_grinder'] = {
        label = 'Angle Grinder',
        weight = 1000,  -- Adjust weight as needed
        stack = false,  -- Assuming one dart_device cannot be stacked
        close = true,   -- Close inventory after use
        consume = 1,    -- Consumes 1 dart_device per use
        description = 'Used to saw off all sorts of stuff including a GPS tracker!',
        client = {
            usetime = 900,
            export = 'Stoic-DART.PlayerRemoveDart'  -- Calls the 'FireDart' export from client.lua
        }
    },
	-- renewedd-dutyblips
	['gps_tracker'] = {
		label = 'Police Tracker',
		weight = 1000,
		stack = false,
		consume = 0,
		server = {
			export = 'Renewed-Dutyblips.toggleItem'
		}
	},
	-- forgery
	['forged_id'] = {
		label = 'ID Card',
		weight = 0,
		stack = false,
		close = true,
		description = 'A card containing citizen info',
		client = {
			image = 'id_card.png',
		}
	},

	['forged_driverslicense'] = {
		label = 'Drivers License',
		weight = 0,
		stack = false,
		close = true,
		description = 'A license allowing a citizen to operate a vehicle.',
		client = {
			image = 'driver_license.png',
		}
	},

	['forged_weaponslicense'] = {
		label = 'Weapons License',
		weight = 0,
		stack = false,
		close = true,
		description = 'A license allowing a citizen to carry firearms',
		client = {
			image = 'weapon_license.png',
		}
	},
	-- mdt
	['mdt'] = {
		label = 'MDT',
		weight = 250,
		client = {
			export = 'ox_mdt.openMDT'
		}
	},
	-- vehiclekeys
	['vehiclekey'] = {
		label = 'Vehicle Key'
	},
	-- farming
	['pitchfork'] = {
		label = 'Pitch Fork',
		weight = 1000,
		client = {
			export = 'Renewed-Farming.harvestPlants'
		},
	},
	
	['wateringcan'] = {
		label = 'Watering Can',
		weight = 0,
	},
	
	['beetroot'] = {
		label = 'Beetroot',
		description = 'Freshly harvested beetroot, perfect for cooking or adding to salads.',
		weight = 100
	},
	['beetrootseed'] = {
		label = 'Beetroot Seed',
		description = 'Small seeds used to grow beetroot plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		},
	},
	
	['carrot'] = {
		label = 'Carrot',
		description = 'Crisp and nutritious carrots, a staple ingredient in many recipes. Can be enjoyed raw or cooked.',
		weight = 100
	},
	['carrotseed'] = {
		label = 'Carrot Seed',
		description = 'Tiny seeds used to grow carrot plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['corn'] = {
		label = 'Corn',
		description = 'Freshly harvested corn, sweet and juicy. Great for grilling or boiling.',
		weight = 100
	},
	['cornseed'] = {
		label = 'Corn Seed',
		description = 'Small seeds used to grow corn plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['cucumber'] = {
		label = 'Cucumber',
		description = 'Crisp and refreshing cucumbers, perfect for salads or pickling.',
		weight = 100
	},
	['cucumberseed'] = {
		label = 'Cucumber Seed',
		description = 'Tiny seeds used to grow cucumber plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['garlic'] = {
		label = 'Garlic',
		description = 'Aromatic garlic bulbs, known for their strong flavor and various culinary uses.',
		weight = 100
	},
	['garlicseed'] = {
		label = 'Garlic Seed',
		description = 'Small cloves used to grow garlic plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['potato'] = {
		label = 'Potato',
		description = 'Versatile and starchy potatoes, ideal for mashing, baking, or frying.',
		weight = 100,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['pumpkin'] = {
		label = 'Pumpkin',
		description = 'Large and festive pumpkins, perfect for carving or using in autumn recipes.',
		weight = 100,
	},
	['pumpkinseed'] = {
		label = 'Pumpkin Seed',
		description = 'Seeds used to grow pumpkin plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['radish'] = {
		label = 'Radish',
		description = 'Crunchy and peppery radishes, great for adding a kick to salads or pickling.',
		weight = 100
	},
	['radishseed'] = {
		label = 'Radish Seed',
		description = 'Small seeds used to grow radish plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['sunflower'] = {
		label = 'Sunflower',
		description = 'Bright and cheerful sunflowers, known for their tall stalks and vibrant yellow petals.',
		weight = 100
	},
	['sunflowerseed'] = {
		label = 'Sunflower Seed',
		description = 'Seeds used to grow sunflower plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['tomato'] = {
		label = 'Tomato',
		description = 'Juicy and flavorful tomatoes, perfect for salads, sauces, or sandwiches.',
		weight = 100
	},
	['tomatoseed'] = {
		label = 'Tomato Seed',
		description = 'Small seeds used to grow tomato plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['watermelon'] = {
		label = 'Watermelon',
		description = 'Large and refreshing watermelons, perfect for summertime enjoyment.',
		weight = 100
	},
	['watermelonseed'] = {
		label = 'Watermelon Seed',
		description = 'Seeds used to grow watermelon plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['cabbage'] = {
		label = 'Cabbage',
		description = 'Fresh and crisp cabbage, perfect for salads and cooking.',
		weight = 100
	},
	['cabbageseed'] = {
		label = 'Cabbage Seed',
		description = 'Seeds used to grow cabbage plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['onion'] = {
		label = 'Onion',
		description = 'Pungent and flavorful onions, a kitchen essential.',
		weight = 100
	},
	['onionseed'] = {
		label = 'Onion Seed',
		description = 'Seeds used to grow onion plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	
	['wheat'] = {
		label = 'Wheat',
		description = 'Golden wheat grains, a staple crop used for making flour and various food products.',
		weight = 100
	},
	['wheatseed'] = {
		label = 'Wheat Seed',
		description = 'Small seeds used to grow wheat plants.',
		weight = 10,
		client = {
			export = 'Renewed-Farming.placeSeed'
		}
	},
	--#
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			image = 'burger_chicken.png',
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			},
			{
				label = 'What do you call a vegan burger?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('A misteak.')
				end
			},
			{
				label = 'What do frogs like to eat with their hamburgers?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('French flies.')
				end
			},
			{
				label = 'Why were the burger and fries running?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('Because they\'re fast food.')
				end
			}
		},
		consume = 0.3
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['sprunk'] = {
		label = 'Sprunk',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with a sprunk'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
		client = {
			image = 'card_id.png'
		}
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		client = {
			event = 'lockpick:use'
		}
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},
}
