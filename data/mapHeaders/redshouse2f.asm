RedsHouse2F_h: ; 5c0a4 (17:40a4)
	db REDS_HOUSE_2 ; tileset
	db REDS_HOUSE_2F_HEIGHT, REDS_HOUSE_2F_WIDTH ; dimensions
	dw RedsHouse2FBlocks, RedsHouse2FTextPointers, RedsHouse2FScript
	db $00 ; no connections
	dw RedsHouse2FObject
