import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Slider
{
    id:slider

    property color slider_groove_filled_colour: "transparent"
    property color slider_groove_colour: "black"
    property color slider_handle_colour: "black"
    property color slider_handle_pressed_colour: "black"
    property real slider_handle_size: 20
    property real slider_groove_size: 9
    property real painted_width_difference
    property real painted_height_difference
    property real display_scale

    property real neutral_value: 0.00

    property int x_start
    property int y_start

    property int x_end
    property int y_end



    Item
    {
        id: derived_values

        property real dx: slider.x_start-slider.x_end
        property real dy: slider.y_start-slider.y_end

        property real slider_x: slider.x_end
        property real slider_y: slider.y_end

        property real slider_angle: -180*(Math.atan2(dx,dy))/3.14159265358979
        property real slider_height: Math.sqrt(dx*dx+dy*dy)

        Component.onCompleted:
        {
            console.log(slider_x,slider_y,dx,dy,slider_angle,slider_height)
        }
    }

    style: SliderStyle
    {
        groove: Rectangle {
            implicitWidth: 200
            implicitHeight: slider_groove_size
            color: slider_groove_colour
            radius: slider_groove_size
            Rectangle {
                implicitWidth: styleData.handlePosition
                implicitHeight: slider_groove_size
                color: slider_groove_filled_colour
                radius: slider_groove_size
            }
        }
        handle: Rectangle {
            anchors.centerIn: parent
            color: control.pressed ? slider_handle_pressed_colour : slider_handle_colour
            border.color: "transparent"
            border.width: 10
            implicitWidth: slider_handle_size
            implicitHeight: slider_handle_size
            radius: slider_handle_size/2
        }
    }
    opacity: 1.0
    x: derived_values.slider_x*display_scale+painted_width_difference-slider.width/2
    y: derived_values.slider_y*display_scale+painted_height_difference
    height: derived_values.slider_height*display_scale
    transform: Rotation { origin.x: slider.width/2; origin.y: 0; angle: derived_values.slider_angle}
    minimumValue: 0
    maximumValue: 1
    value: neutral_value
    stepSize: 0.02
    orientation: Qt.Vertical
}
