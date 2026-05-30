extends Node

var selected_tool : DataTypes.Tools = DataTypes.Tools.None #Selected tool variable

signal tool_selected(tool:DataTypes.Tools) #Tool selection signal
signal enable_tool(tool:DataTypes.Tools)

func select_tool(tool:DataTypes.Tools) -> void: #选择工具的函数，Pass the tool as a parameter
	tool_selected.emit(tool)
	selected_tool = tool

func enable_tool_button(tool:DataTypes.Tools) -> void:
	enable_tool.emit(tool)
