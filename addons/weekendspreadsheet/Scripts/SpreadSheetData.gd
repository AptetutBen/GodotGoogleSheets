class_name SpreadSheetData
extends Resource

@export var headers = []
@export var rowsLookup = {}

func setup(data: String):
	var rows = data.replace("\"","").split("\n")
	var csvHeaders = rows[0].replace("\"","").split(",")
	
	for i in csvHeaders.size():
		headers.append(csvHeaders[i])
	
	for i in rows.size():
		if i == 0:
			continue
		var rowItems = rows[i].split(",")
		rowsLookup[rowItems[0]] = rowItems
		
func get_data_set(id : String) -> DataSet:
	if !rowsLookup.has(id):
		print("Key does not exsist in Data: " + id);
		return null
		
	return DataSet.new(headers,Array(rowsLookup[id]))
