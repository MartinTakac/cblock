
import QtQuick 2.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import BL_qml 1.0

TabView
{
	id: rootItem
	property real textScale: 1.0
    style: TabViewStyle
	{
        frameOverlap: 1
        tab: Rectangle 
		{
            color: styleData.selected ? "#FF20B0FF" : "#FF006096"
            border.color: "#FF20B0FF"
            implicitWidth: Math.max(text.width + 4, rootItem.textScale*80)
            implicitHeight: rootItem.textScale*30
            radius: 0
            Text 
			{
                id: text
                anchors.centerIn: parent
                text: styleData.title
                color: styleData.selected ? "#FF000000" : "#FFFFFFFF"
				font.pointSize: rootItem.textScale*8
            }
        }
		frame: Rectangle
		{
			color: "black"
			Rectangle
			{
				anchors.bottom: parent.top
				anchors.left: parent.left
				anchors.right: parent.right
				height: 1
				color: "#FF20B0FF"
			}
		}
    }
	Tab
	{
		title: "Chunking"
		TabView
		{
			id: rootItem
			property real textScale: 1.0
			style: TabViewStyle
			{
				frameOverlap: 1
				tab: Rectangle 
				{
					color: styleData.selected ? "#FF20B0FF" : "#FF006096"
					border.color: "#FF20B0FF"
					implicitWidth: Math.max(text.width + 4, rootItem.textScale*80)
					implicitHeight: rootItem.textScale*30
					radius: 0
					Text 
					{
						id: text
						anchors.centerIn: parent
						text: styleData.title
						color: styleData.selected ? "#FF000000" : "#FFFFFFFF"
						font.pointSize: rootItem.textScale*8
					}
				}
				frame: Rectangle
				{
					color: "black"
					Rectangle
					{
						anchors.bottom: parent.top
						anchors.left: parent.left
						anchors.right: parent.right
						height: 1
						color: "#FF20B0FF"
					}
				}
			}

			Tab
			{
				title: "Control"
				Control
				{
				}
			}
			Tab
			{
				title: "Goal"
				Goal
				{
				}
			}
			Tab
			{
				title: "SOMs"
				SOMs
				{
				}
			}
			Tab
			{
				title: "SOM inspect"
				SOM_Inspect
				{
				}
			}
		        Tab
			{
				title: "Display"
				Display
				{
				}
			}
		
			
			//Tab
			//{
			//		title: "Level 2"
			//		Level2
			//	{
			//	}
			//}
		}
	}	
}