extends Node


func generate_unique_name(BaseStringList: Array = []) -> String:
	var random_number: String = str(randi())
	var new_name: String = ""
	
	if random_number.length() < 10:
		var new_number: String = ""
		var zero_number = 10 - random_number.length()
		for counter in range(zero_number):
			new_number += "0"
		
		new_number += random_number
		random_number = new_number
	
	if 0 < BaseStringList.size():
		for item in BaseStringList:
			new_name += item + "_"
			
	new_name += random_number
	return new_name
