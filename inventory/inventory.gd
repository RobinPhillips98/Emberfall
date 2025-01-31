extends Resource

class_name Inv
signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	
	match item.type:
		"sword":
			slots[0].item = item
			slots[0].amount = 1
		"armor":
			slots[1].item = item
			slots[1].amount = 1
		"bow":
			slots[2].item = item
			slots[2].amount = 1
		"health_potion":
			if slots[3].amount == 0:
				slots[3].item = item
				slots[3].amount = 1
			else:
				slots[3].amount += 1
		"mana_potion":
			if slots[4].amount == 0:
				slots[4].item = item
				slots[4].amount = 1
			else:
				slots[4].amount += 1
		
	#var itemslots = slots.filter(func(slot): return slot.item == item)
	#if !itemslots.is_empty():
		#itemslots[0].amount += 1
	#else:
		#var emptyslots = slots.filter(func(slot): return slot.item == null)
		#if !emptyslots.is_empty():
			#emptyslots[0].item = item
			#emptyslots[0].amount = 1
	update.emit()

func remove(index: int):
	if slots[index].amount == 0:
		pass

	slots[index].amount -= 1
	if slots[index].amount == 0:
		slots[index].item = null
