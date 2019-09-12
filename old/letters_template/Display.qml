import QtQuick 2.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import BL_qml 1.0

ScrollView
{
	verticalScrollBarPolicy: Qt.ScrollBarAlwaysOn
	horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    Column{
        Row
        {
            spacing: 15
            
              Rectangle
            {
                id: root_item
                color: "#00000000"
                width: 350
                height: 350
                
                Slider_2D_xyza
                {
                    id: slider_2d
                    anchors.fill: parent
                    anchors.margins: 20
                    dot_radius: 4
                    dot_colour: "grey"
                    border_colour: "grey"
                    x_min: -10
                    x_max: 10
                    y_min: -10
                    y_max: 10
                    
                    BL_variable_qml
                    {
                        id: translate_x
                        variable_name: "displays/transformation.translate_x"
                    }
                    
                    BL_variable_qml
                    {
                        id: translate_y
                        variable_name: "displays/transformation.translate_y"
                    }
                    
                    // This signal should be used to set variables.
                    // The x and y positions are the "x" and "y" variables
                    // and should be in the ranges [x_min,x_max] and [y_min,y_max]
                    onDotPositionChanged:
                    {
                        translate_x.set_BL_variable_value(x);
                        translate_y.set_BL_variable_value(-y);
                    }
                    
                    Component.onCompleted:
                    {
                        set_position(0.0,0.0);
                    }
                }
                Text
                {
                    id: title_text
                    text: ""
                    color: "white"
                    anchors.bottom: slider_2d.top
                    anchors.horizontalCenter: slider_2d.horizontalCenter
                    font.pointSize: 10
                    font.bold: true
                }

            }
        }
            spacing: 15
            
        ListModel
        {
			id: slider_model_0_0
            ListElement
            {
                name: "TRANSLATE X"
                path: "displays/transformation.translate_x"
                startValue: 0.0
                minValue: -10.0
                maxValue: 10.0
                stepSize: 0.01
            }
            ListElement
            {
                name: "TRANSLATE Y"
                path: "displays/transformation.translate_y"
                startValue: 0.0
                minValue: -10.0
                maxValue: 10.0
                stepSize: 0.01
            }
            ListElement
            {
                name: "SCALE"
                path: "displays/transformation.scale"
                startValue: 0.0
                minValue: 0.0
                maxValue: 10.0
                stepSize: 0.01
            }
        }
    ListModel
        {
            id: button_model_0_0
            ListElement
            {
                name: "Visible"
                path: "displayConstants/is_visible"
                onValue: 1.0
                offValue: 0.0
                isCheckable: true
                isChecked: true
            }
			ListElement
            {
                name: "Debug Visible"
                path: "displayConstants/debug_is_visible"
                onValue: 1.0
                offValue: 0.0
                isCheckable: true
                isChecked: true
            }
			ListElement
            {
                name: "Secondary monitor"
                path: "displayConstants/display_secondary_monitor"
                onValue: 1.0
                offValue: 0.0
                isCheckable: true
                isChecked: false
            }
    }
        DoubleGridView
        {
            id: grid_0_0
            width: rootItem.width
            sliderModel: slider_model_0_0
            buttonModel: button_model_0_0
            headerText:"value controls"
            sliderWidth: 200
            nameWidth: 100
            valueWidth: 80
            textScale: rootItem.textScale*1.0
        }
    }
}
