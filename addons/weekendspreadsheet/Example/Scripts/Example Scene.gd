extends Control

# Path to the saved data that you wish to load
var hockeyDataSavedData = "res://addons/weekendspreadsheet/Example/Data/Hockey Data.tres"
var workOrdersSavedData = "res://addons/weekendspreadsheet/Example/Data/Work Orders.tres"
func _ready():
	
	# Converts the saved data back into a object that you can reference
	var hockySpreadsheetData : SpreadSheetData = ResourceLoader.load(hockeyDataSavedData)
	var workOrdersSpreadsheetData : SpreadSheetData = ResourceLoader.load(workOrdersSavedData)

	## Checks the data was loaded in correctly 
	if hockySpreadsheetData:
		# Get one line of data from the spreadsheet using the id (first column)
		var hockyDataSet : DataSet = hockySpreadsheetData.get_data_set("17")
		# Extract and data from the dataset using it's column id 
		print(
			hockyDataSet.get_value("NameF") + " " +
			hockyDataSet.get_value("NameL")
		)
	else:
		print("Failed to load the resource")

	# Checks the data was loaded in correctly 
	if workOrdersSpreadsheetData:
		# Get one line of data from the spreadsheet using the id (first column)
		var woDataSet : DataSet = workOrdersSpreadsheetData.get_data_set("A00103")
		# Extract and data from the dataset using it's column id 
		print(
			woDataSet.get_value("LeadTech") + " " + woDataSet.get_value("LbrHrs")
		)
	else:
		print("Failed to load the resource")
