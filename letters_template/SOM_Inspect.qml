import QtQuick 2.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import BL_qml 1.0

ScrollView
{
	verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn
	horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
	Column
	{
		Rectangle
				{
					id: root_item
					color: "black"
					width: 800
					height: 800

					Slider_2D_xyza
					{
						id: slider_2d
						anchors.fill: parent
						anchors.margins: 50
						dot_radius: 6
						dot_colour: "cyan"
						border_colour: "cyan"
						x_min: 0.0
						x_max: 1.0
						y_min: 0.0
						y_max: 1.0

						BL_variable_qml
						{
							id: translate_x
							variable_name: "cblock/cblockParams/inspect_SOM_x"
						}

						BL_variable_qml
						{
							id: translate_y
							variable_name: "cblock/cblockParams/inspect_SOM_y"
						}

						// This signal should be used to set variables.
						// The x and y positions are the "x" and "y" variables
						// and should be in the ranges [x_min,x_max] and [y_min,y_max]
						onDotPositionChanged:
						{
							translate_x.set_BL_variable_value(x);
							translate_y.set_BL_variable_value(1.0-y);
						}

						Component.onCompleted:
						{
							set_position(0.5,0.5);
						}
					}
					Text
					{
						id: title_text
						text: "SOM Inspect"
						color: "cyan"
						anchors.bottom: slider_2d.top
						anchors.horizontalCenter: slider_2d.horizontalCenter
						font.pointSize: 10
						font.bold: true
					}
				}

		
		spacing: 15

		ListModel
		{
			id: slider_model_3_0
					
			ListElement
			{
				name: "translate x"
				path: "displayConstants/inspect_tr_translate_x"
				startValue: 0.0
				minValue: -10.0
				maxValue: 10.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "translate y"
				path: "displayConstants/inspect_tr_translate_y"
				startValue: 0.0
				minValue: -10.0
				maxValue: 10.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "scale"
				path: "displayConstants/inspect_tr_scale"
				startValue: 5.0
				minValue: 0.0
				maxValue: 10.0
				stepSize: 0.1
			}
					
		}
		ListModel
		{
			id: button_model_3_0
				
		}
		Rectangle
		{
			anchors.horizontalCenter: parent.horizontalCenter
			width: 1
			height: 10
			color: "transparent"
		}
		Row
		{
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 15
			Button
			{
				width: 0.33*rootItem.width
				text: "Larger Text"
				style: ButtonStyle
				{
					background: Rectangle
					{
						implicitWidth: 100
						implicitHeight: 25
						border.width: control.pressed ? 2 : 1
						border.color: control.pressed ? "#FFDDDDDD" : "#FF888888"
						color: control.hovered ? "#22DDDDDD" : "transparent"
						radius: 4
					}
					label: Label
					{
						text: control.text
						color: "white"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						width: control.width
						height: control.height
						font.pointSize: rootItem.textScale*11
					}
				}
				onClicked:
				{
					rootItem.textScale = rootItem.textScale*1.1;
				}
			}
			Button
			{
				width: 0.33*rootItem.width
				text: "Smaller Text"
				style: ButtonStyle
				{
					background: Rectangle
					{
						implicitWidth: 100
						implicitHeight: 25
						border.width: control.pressed ? 2 : 1
						border.color: control.pressed ? "#FFDDDDDD" : "#FF888888"
						color: control.hovered ? "#22DDDDDD" : "transparent"
						radius: 4
					}
					label: Label
					{
						text: control.text
						color: "white"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						width: control.width
						height: control.height
						font.pointSize: rootItem.textScale*7
					}
				}
				onClicked:
				{
					rootItem.textScale = rootItem.textScale/1.1;
				}
			}
		}
		Button
		{
			anchors.horizontalCenter: parent.horizontalCenter
			width: 0.66*rootItem.width
			text: "Reset Sliders"
			style: ButtonStyle
			{
				background: Rectangle
				{
					implicitWidth: 100
					implicitHeight: 25
					border.width: control.pressed ? 2 : 1
					border.color: control.pressed ? "#FFDDDDDD" : "#FF888888"
					color: control.hovered ? "#22DDDDDD" : "transparent"
					radius: 4
				}
				label: Label
				{
					text: control.text
					color: "white"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					width: control.width
					height: control.height
					font.pointSize: rootItem.textScale*9
				}
			}
			onClicked:
			{
			
				dgv_3_0.resetAllSliders()
			}
		}
		DoubleGridView
		{
			id: dgv_3_0
			width: rootItem.width
			sliderModel: slider_model_3_0
			buttonModel: button_model_3_0
			headerText: "Training record view"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
	}
}