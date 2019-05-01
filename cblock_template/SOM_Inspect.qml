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
					width: 300
					height: 300

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

		
	}
}