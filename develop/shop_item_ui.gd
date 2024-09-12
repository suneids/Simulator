extends PanelContainer 
class_name ShopItemUI

@export var item_data : ShopItemData
@onready var item_name : Label = $VBoxContainer/ItemName
@onready var item_icon  : TextureRect = $VBoxContainer/ItemIcon
@onready var item_price : Label= $VBoxContainer/ItemPrice
@onready var item_add_to_cart : Button= $VBoxContainer/ItemAddToCart

func _ready():
	item_name.text = item_data.name
	item_icon.texture = item_data.icon
	item_icon.size
	item_price.text = str(item_data.price)
	
