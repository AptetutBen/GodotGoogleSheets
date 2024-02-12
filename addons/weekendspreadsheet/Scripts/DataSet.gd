class_name DataSet

var dataValues = []
var headerLookup = []

func _init(headers,values):
	dataValues = values
	headerLookup = headers

func get_value(id: String):
	var dataIndex = headerLookup.find(id)
	if dataIndex == -1:
		print("Key does not exsist in Data: " + id);
		return
	return dataValues[dataIndex]
	
func get_value_array(id: String, seperator : String = ","):
	var dataIndex = headerLookup.find(id)
	if dataIndex == -1:
		print("Key does not exsist in Data: " + id);
		return
	return dataValues[dataIndex].split(seperator)
