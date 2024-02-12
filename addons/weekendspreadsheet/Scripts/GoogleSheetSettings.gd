@tool
class_name GoogleSheetSettings
extends Resource

@export var spreadsheetId : String = "0"
@export var resourceFolder : String = "Data"

@export var pages = {}
var lastUpdated : Time

func add_page(gid : String, fileName : String):
	pages[gid] = fileName

func remove_page(id : String):
	pages.erase(id)
	
