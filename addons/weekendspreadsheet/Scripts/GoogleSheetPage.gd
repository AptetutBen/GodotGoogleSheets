@tool
class_name GoogleSheetPage
extends Control

const MAX_ROWS : int = 3
var gid: String = "0"
var resourceName = "Sheet"

var isFetching : bool = false

@onready var sheetManager : GoogleSheetManager = get_parent().get_parent()
@onready var fetchButton : Button = $"MarginContainer/VBoxContainer/HBoxContainer/Fetch Button"
@onready var errorMessage : Label = $"MarginContainer/VBoxContainer/HFlowContainer/Error Text"
@onready var processMessage : Label = $"MarginContainer/VBoxContainer/HFlowContainer/Success Text"
@onready var gidLabel :  Label = $"MarginContainer/VBoxContainer/HBoxDetails/Sheet GID/GID Label"
@onready var nameLabel : Label = $"MarginContainer/VBoxContainer/HBoxDetails/Data Name/Data Name Label"
@onready var outputGridContainer : GridContainer = $MarginContainer/VBoxContainer/GridContainer

func set_up(id : String,rName : String ):
	gid = id
	resourceName = rName
	gidLabel.text = id
	nameLabel.text = rName

func _ready():
	processMessage.text = ""
	errorMessage.text = ""
	
	for i in outputGridContainer.get_children():
		i.queue_free()
	
func _on_fetch_button_pressed():
	sheetManager.fetch_data(gid,resourceName,self)
	fetchButton.disabled = true
	isFetching = true
	processMessage.text = ""
	errorMessage.text = ""
	processMessage.text = "Fetching..."

func _restore_button():
	fetchButton.disabled = false
	isFetching = false
	fetchButton.text = "Fetch"

func http_request_failed(message : String):
	_restore_button()
	errorMessage.text = message

func http_request_completed(result, response_code, headers, body):
	_restore_button()
	var resourceFolder : String = sheetManager.resourceFolder
	processMessage.text = "Fetched"
	var stringResult : String = body.get_string_from_utf8()
	var newDataResources : SpreadSheetData = SpreadSheetData.new()
	newDataResources.setup(stringResult)
	if !FileAccess.file_exists("res://" + resourceFolder):
		var dir = DirAccess.open("res://")
		dir.make_dir(resourceFolder)
	ResourceSaver.save(newDataResources, "res://" + resourceFolder + "/" + resourceName + ".tres")
	
	for i in outputGridContainer.get_children():
		i.queue_free()
	
	outputGridContainer.columns = len(newDataResources.headers)
	for heading in newDataResources.headers:
		var newLabel = Label.new()
		newLabel.text = heading
		outputGridContainer.add_child(newLabel)
	
	for key in newDataResources.rowsLookup.keys().slice(0,MAX_ROWS):
		for value in newDataResources.rowsLookup[key]:
			var newLabel = Label.new()
			newLabel.text = value
			outputGridContainer.add_child(newLabel)
	
	if len(newDataResources.rowsLookup.keys()) > MAX_ROWS:
		for i in min(3,len(newDataResources.headers)):
			var newLabel = Label.new()
			newLabel.text = "..."
			outputGridContainer.add_child(newLabel)
	

func _on_open_sheet_button_pressed():
	OS.shell_open(sheetManager._get_sheet_url(gid))


func _on_delete_button_pressed():
	sheetManager.delete_page(gid)
