import QtQuick 2.2

Rectangle {
    id: container
    property real dot_position_x: (drag_dot.x)/(drag_dot.drag_max_x)*(x_max-x_min)+x_min
    property real dot_position_y: (drag_dot.y)/(drag_dot.drag_max_y)*(y_max-y_min)+y_min

    property real x_min: 0.0
    property real x_max: 1.0
    property real y_min: 0.0
    property real y_max: 1.0

    property color dot_colour: "red"
    property color background_colour: "transparent"
    property color border_colour: "black"
    property int border_width: 2
    property int dot_radius: 5

    signal dotPositionChanged(real x,real y)

    color: background_colour
    border.color: border_colour
    border.width: border_width

    function set_position(x,y)
    {
        drag_dot.x=((x-x_min)/(x_max-x_min))*(drag_dot.drag_max_x);
        drag_dot.y=((y-y_min)/(y_max-y_min))*(drag_dot.drag_max_y);
    }

    function scale_preserve_reset_position()
    {
        set_position(drag_dot.internal_scaled_x,drag_dot.internal_scaled_y);
    }

    onDot_position_xChanged:
    {
        container.dotPositionChanged(dot_position_x,dot_position_y);
    }

    onDot_position_yChanged:
    {
        container.dotPositionChanged(dot_position_x,dot_position_y);
    }

    onWidthChanged:
    {
        scale_preserve_reset_position();
    }

    onHeightChanged:
    {
        scale_preserve_reset_position();
    }

    Component.onCompleted:
    {
        set_position((x_min+x_max)/2,(y_min+y_max)/2);
        drag_dot.internal_scaled_x=container.dot_position_x;
        drag_dot.internal_scaled_y=container.dot_position_y;
    }

    Rectangle
    {
        id: vertical_line
        width: 1
        anchors.top:parent.top
        anchors.bottom: parent.bottom
        color: container.dot_colour
        x: drag_dot.x + drag_dot.width/2
    }
    Rectangle
    {
        id: horizontal_line
        height: 1
        anchors.left:parent.left
        anchors.right: parent.right
        color: container.dot_colour
        y: drag_dot.y + drag_dot.height/2
    }

    Rectangle
    {
        id: drag_dot
        width: 2*container.dot_radius
        height: 2*container.dot_radius
        radius: container.dot_radius
        color: container.dot_colour

        property int drag_max_x: container.width - drag_dot.width
        property int drag_max_y: container.height - drag_dot.height

        property real internal_scaled_x
        property real internal_scaled_y

        MouseArea
        {
            anchors.fill:parent
            drag.axis: Drag.XAndYAxis
            drag.target: drag_dot
            drag.minimumX: 0//drag_dot.width
            drag.maximumX: drag_dot.drag_max_x
            drag.minimumY: 0//drag_dot.height
            drag.maximumY: drag_dot.drag_max_y
            drag.threshold: 0

            onPositionChanged:
            {
                drag_dot.internal_scaled_x=container.dot_position_x;
                drag_dot.internal_scaled_y=container.dot_position_y;
            }
        }
    }
}
