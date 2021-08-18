resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

files {
	'dlctext.meta',
	'handling.meta',
	'vehicles.meta',
	'carcols.meta',
	'vehiclelayouts.meta',
	'shop_vehicle.meta',
	'ambulance.xml',
	'ambulance2.xml',
	'ambulance3.xml',
	'ambulance4.xml',
	'ambulance5.xml',
	'mug.xml',
	'mug2.xml',
	'ambulanceb.xml',
	'carvariations.meta',
}

data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'DLCTEXT_FILE' 'dlctext.meta'
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts.meta'
data_file 'VEHICLE_SHOP_FILE' 'shop_vehicle.meta'

client_scripts 'vehicle_names.lua'
is_els 'true'