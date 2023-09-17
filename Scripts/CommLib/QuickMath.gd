extends Node


func get_jump_velocity(JumpInTiles: float, JumpTimeToPeak: float) -> float:
	if JumpInTiles == 0 or JumpTimeToPeak == 0:
		print_debug("Warning: Missing values or 0.0 provided for actor jump height and time to peak on JumpVelocity")
		print_debug("Warning: get_jump_velocity() cannot be performed successfully. Returning 0.0 instead")
		return 0.0
	else:
		# The +1 comes from the single pixel that is eaten by the floor before jump
		return -((2.0 * JumpInTiles + 1) / JumpTimeToPeak)


func get_jump_gravity(JumpInTiles:float, JumpTimeToPeak:float) -> float:
	if JumpInTiles == 0 or JumpTimeToPeak == 0:
		print_debug("Missing values for actor jump height and time to peak on JumpGravity")
		print_debug("Warning: get_jump_gravity() cannot be performed successfully. Returning 0.0 instead")
		return 0.0
	else:
		return -((-2.0 * JumpInTiles) / pow(JumpTimeToPeak, 2))


func get_normal_gravity(JumpInTiles:float, JumpTimeToFloor:float) -> float:
	if JumpInTiles == 0 or JumpTimeToFloor == 0:
		print_debug("Missing values for actor jump height and time to floor on NormalGravity")
		print_debug("Warning: get_normal_gravity() cannot be performed successfully. Returning 0.0 instead")
		return 0.0
	else:
		return -((-2.0 * JumpInTiles) / pow(JumpTimeToFloor, 2))

## Checks if the first value is between the two values given. If it is returns true else returns false
func is_between(Value : float, From : float, To : float) -> bool:
	var high_number : float
	var low_number : float

	if From < To:
		high_number = To
		low_number = From
	else:
		high_number = From
		low_number = To

	if low_number <= Value and Value <= high_number:
		return true
	else:
		return false


## Unlike the array method of erase() which will reindex all elements to the rigth of the removed element
## to (elementIndex -1) this will move the last element of the array to the removed element place and 
## reduce the array size by 1. This is a lot faster but will not preserve the array order. 
## If you want to keep the array's order use Array.erase() instead.
func erase_array_element(ElementToErase, TargetArray: Array):
	if not TargetArray.has(ElementToErase):
		return
	
	if TargetArray.back() != ElementToErase:
		TargetArray[TargetArray.find(ElementToErase)] = TargetArray.back()
	
	TargetArray.resize(maxi(TargetArray.size() - 1, 0))
		
	
## Unlike the array method of insert() which will reindex all elements to the right of the inseted element
## to (PreviousIndex + 1), this function will move the element in the insert position to the back and
## then replace that element with the new one. The position to be inserted at must be a valid one.
## This is a lot faster but will not preserve the array order. If you want to keep the array's order 
## use Array.insert() instead.
func insert_in_array(PositionToInsertAt: int, ElementToInsert, TargetArray: Array):
	var _array_size: int = TargetArray.size()
	
	if _array_size < PositionToInsertAt:
		return
	
	if _array_size <= 1 or PositionToInsertAt == _array_size:
		TargetArray.append(ElementToInsert)
	else:
		TargetArray.append(TargetArray[PositionToInsertAt])
		TargetArray[PositionToInsertAt] = ElementToInsert


## Switches the place between the given element and the first element of the array. Will do nothing
## if the element doesn't exist
func array_bring_to_front(MoveToFront, ArrayToChange: Array) -> void:
	if MoveToFront not in ArrayToChange or ArrayToChange.size() <= 1 or MoveToFront == ArrayToChange.front():
		return
	
	var _element_index = ArrayToChange.find(MoveToFront)
	var _element_memory = ArrayToChange.front()
	
	ArrayToChange[0] = MoveToFront
	ArrayToChange[_element_index] = _element_memory


func array_get_lowest_numberi(ArrayToCheck: Array) -> int:
	if ArrayToCheck.is_empty():
		return 0
	
	var lowest_number: int = int(ArrayToCheck.front())
	
	for number in ArrayToCheck:
		if int(number) < lowest_number:
			lowest_number = int(number)
	
	return lowest_number


func are_numbers_same_poles(NumberA: float, NumberB: float) -> bool:
	if NumberA == 0.0 or NumberB == 0:
		return true

	return (0 < NumberA) == (0 < NumberB)


func get_acceleration(TimeToAccel: float, MaxSpeed: float) -> float:
	if TimeToAccel == 0:
		return MaxSpeed * Engine.max_fps
	
	return MaxSpeed / TimeToAccel
