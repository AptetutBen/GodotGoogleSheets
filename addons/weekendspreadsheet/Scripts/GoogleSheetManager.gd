@tool
class_name GoogleSheetManager
extends Control

var id: String = "0"
var csvUrl = "https://docs.google.com/spreadsheets/d/{id}/gviz/tq?tqx=out:csv&gid={gid}"
var googleSheetPrefab = load("res://addons/weekendspreadsheet/Scenes/page.tscn") as PackedScene
var resourceFolder = "Data"
var settingsLocation : String = "res://addons/weekendspreadsheet/settings.tres"
var settingsFile = load(settingsLocation) as GoogleSheetSettings
var fetched_resourceName : String
var pageLookup = {}
var pageIdToDelete : String

@onready var pageParent : TabContainer = $TabContainer
@onready var confirmDialogue : ConfirmationDialog = $ConfirmationDialog
@onready var idLineEdit : LineEdit = $"TabContainer/Settings/MarginContainer/VBoxContainer/Sheet ID/ID LineEdit"
@onready var folderLineEdit : LineEdit = $"TabContainer/Settings/MarginContainer/VBoxContainer/Folder Name/Folder LineEdit"
@onready var addButton : Button = $"TabContainer/Settings/MarginContainer/VBoxContainer/Add New Sheet Button"
@onready var newSheetDetails : Control = $"TabContainer/Settings/MarginContainer/VBoxContainer/New Sheet Settings"
@onready var successText : Label = $"TabContainer/Settings/MarginContainer/VBoxContainer/HFlowContainer/Success Text"
@onready var errorText : Label =$"TabContainer/Settings/MarginContainer/VBoxContainer/HFlowContainer/Error Text"
@onready var addDataNameLineEdit : LineEdit = $"TabContainer/Settings/MarginContainer/VBoxContainer/New Sheet Settings/VBoxContainer/Data Name/Data LineEdit"
@onready var addGidLineEdit : LineEdit = $"TabContainer/Settings/MarginContainer/VBoxContainer/New Sheet Settings/VBoxContainer/Sheet GID/GID LineEdit"

# Called when the node enters the scene tree for the first time.
func _ready():
	id = settingsFile.spreadsheetId
	resourceFolder = settingsFile.resourceFolder
	idLineEdit.text = id
	folderLineEdit.text = resourceFolder
	
	successText.text = ""
	errorText.text = ""
	confirmDialogue.visible = false
	newSheetDetails.visible = false
	for pageKey in settingsFile.pages.keys():
		_add_page(pageKey,settingsFile.pages[pageKey])
	if pageParent.get_child_count() > 1:
		pageParent.get_child(1).visible = true

func _add_page(gid: String, page: String):
	var newPage = googleSheetPrefab.instantiate() as Control
	pageParent.add_child(newPage)
	newPage.name = page
	pageParent.current_tab = 0
	newPage.set_up(gid,page)
	pageLookup[gid] = newPage

func on_remove_page(page : Control):
	pass

func fetch_data(gui : String, resourceName: String, page : Node):
	fetched_resourceName = resourceName
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(page.http_request_completed)

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(_get_csv_url(gui))
	if error != OK:
		print("An error occurred in the HTTP request.")
		page.http_request_failed("hello")

func _get_csv_url(gid: String) -> String:
	return csvUrl.replace("{id}", id).replace("{gid}", gid)

func delete_page(pageId : String):
	confirmDialogue.visible = true
	pageIdToDelete = pageId

func _on_confirmation_dialog_canceled():
	pass


func _on_confirmation_dialog_confirmed():
	pageParent.remove_child(pageLookup[pageIdToDelete])
	pageParent.current_tab = 0;
	settingsFile.remove_page(pageIdToDelete)
	ResourceSaver.save(settingsFile,settingsLocation)
	

func _on_folder_line_edit_text_changed(new_text):
	settingsFile.resourceFolder = new_text
	ResourceSaver.save(settingsFile,settingsLocation)


func _on_id_line_edit_text_changed(new_text):
	settingsFile.spreadsheetId = new_text
	ResourceSaver.save(settingsFile,settingsLocation)


func _on_add_sheet_button_pressed():
	var gid : String = addGidLineEdit.text
	var dataName : String = addDataNameLineEdit.text
	errorText.text = "Please fill in all values"
	if(gid.is_empty() || dataName.is_empty()):
		errorText.text = "Please fill in all values"
		return
	
	errorText.text = ""
	print(settingsFile.spreadsheetId)
	settingsFile.pages[gid] = dataName
	ResourceSaver.save(settingsFile,settingsLocation)
	_add_page(gid,dataName)
	newSheetDetails.visible = false
	addButton.visible = true
	addGidLineEdit.text = ""
	addDataNameLineEdit.text = ""
	pageParent.current_tab = pageParent.get_tab_count()-1
	
func _on_add_new_sheet_button_pressed():
	newSheetDetails.visible = true
	addButton.visible = false
	
