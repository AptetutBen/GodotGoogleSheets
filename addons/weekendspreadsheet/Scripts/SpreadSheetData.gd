class_name SpreadSheetData
extends Resource

@export var headers = []
@export var rowsLookup = {}

func setup(data: String):
	var rows = data.split("\n")
	var csvHeaders = rows[0].replace("\"","").split(",")

	for i in range(csvHeaders.size()):
		headers.append(csvHeaders[i])

	for i in range(1, rows.size()):
		var row = rows[i]
		var rowItems = []
		var currentItem = ""
		var insideQuotes = false

		for j in range(row.length()):
			var char = row[j]

			if char == '"' and (j == 0 or row[j - 1] != '\\'):
				insideQuotes = not insideQuotes
			elif char == ',' and not insideQuotes:
				rowItems.append(currentItem)
				currentItem = ""
			else:
				currentItem += char

		rowItems.append(currentItem)
		rowsLookup[rowItems[0]] = rowItems
		
func get_data_set(id : String) -> DataSet:
	if !rowsLookup.has(id):
		print("Key does not exsist in Data: " + id);
		return null
		
	return DataSet.new(headers,Array(rowsLookup[id]))
