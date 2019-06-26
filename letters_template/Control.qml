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
		spacing: 15

		ListModel
		{
			id: slider_model_0_0
					
			ListElement
			{
				name: "train steps"
				path: "training_control/do_autotrain_steps"
				startValue: 2500.0
				minValue: 0.0
				maxValue: 5000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "myelinate only"
				path: "training_control/myelination"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "step delay"
				path: "output_ready_off_delayed/number_of_time_steps_delay"
				startValue: 2500.5
				minValue: 1.0
				maxValue: 5000.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_0_0
				
			ListElement
			{
				name: "trigger train"
				path: "training_control/trigger_automatic_training_qml"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
		}
		ListModel
		{
			id: slider_model_0_1
					
			ListElement
			{
				name: "allow playback"
				path: "control/allow_playback"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "inspect buf index"
				path: "cblock/cblockParams/inspect_buf_index"
				startValue: 49.0
				minValue: -1.0
				maxValue: 99.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_0_1
				
			ListElement
			{
				name: "save weights"
				path: "cblock/cblockParams/save_all_weights"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
			ListElement
			{
				name: "load weights"
				path: "cblock/cblockParams/load_all_weights"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
			ListElement
			{
				name: "reset weights"
				path: "cblock/cblockParams/reset_all_weights"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
			ListElement
			{
				name: "reset seq"
				path: "cblock/cblockParams/resetSeq_qml"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
			ListElement
			{
				name: "finalize seq"
				path: "cblock/cblockParams/finalizeSeq_qml"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
			ListElement
			{
				name: "refresh goal"
				path: "cblock/cblockInputs/refresh_goal_plan"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
			ListElement
			{
				name: "test dump"
				path: "cblock/faked_stack/dump_qml"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
			ListElement
			{
				name: "test load"
				path: "cblock/faked_stack/load_qml"
				onValue: 1.0
				offValue: 0.0
				isCheckable: false
			}
					
		}
		ListModel
		{
			id: slider_model_0_2
					
			ListElement
			{
				name: "result index"
				path: "control/manual_result_index"
				startValue: 10.0
				minValue: 0.0
				maxValue: 20.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "reward"
				path: "control/manual_reward"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
		}
		ListModel
		{
			id: button_model_0_2
				
		}
		ListModel
		{
			id: slider_model_0_3
					
			ListElement
			{
				name: "play at intervals"
				path: "control/playback_at_intervals"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "playback speed correction"
				path: "control/playback_speed_correction"
				startValue: 10.0
				minValue: 0.0
				maxValue: 20.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "playback entropy thr"
				path: "cblock/cblockParams/entropy_thr"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "prediction smoothing"
				path: "cblock/cblockParams/smoothing"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1e-16
			}
					
			ListElement
			{
				name: "kick start gain"
				path: "cblock/cblockParams/kick_start_gain"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "interval speed"
				path: "cblock/cblockParams/interval_LIF_speed"
				startValue: 100.0
				minValue: 0.0
				maxValue: 200.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "reset at interval timeout"
				path: "cblock/cblockParams/reset_at_interval_timeout"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "reset if no first"
				path: "cblock/cblockParams/reset_if_no_first_timeout"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "sparse input coding"
				path: "cblock/cblockParams/sparse_coded_input"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_0_3
				
		}
		ListModel
		{
			id: slider_model_0_4
					
			ListElement
			{
				name: "winner surprise"
				path: "cblock/cblockParams/winner_match_surprise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "avg mult thr"
				path: "cblock/cblockParams/surprise_avg_mult"
				startValue: 2.5
				minValue: 0.0
				maxValue: 5.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "prev avg mix"
				path: "cblock/cblockParams/prev_avg_err_mix"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "trunc surp at"
				path: "cblock/cblockParams/surp_trunc_value"
				startValue: 252.5
				minValue: 5.0
				maxValue: 500.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_0_4
				
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
			
				dgv_0_0.resetAllSliders()
				dgv_0_1.resetAllSliders()
				dgv_0_2.resetAllSliders()
				dgv_0_3.resetAllSliders()
				dgv_0_4.resetAllSliders()
			}
		}
		DoubleGridView
		{
			id: dgv_0_0
			width: rootItem.width
			sliderModel: slider_model_0_0
			buttonModel: button_model_0_0
			headerText: "Train from file"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_0_1
			width: rootItem.width
			sliderModel: slider_model_0_1
			buttonModel: button_model_0_1
			headerText: "Control"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_0_2
			width: rootItem.width
			sliderModel: slider_model_0_2
			buttonModel: button_model_0_2
			headerText: "Manual input"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_0_3
			width: rootItem.width
			sliderModel: slider_model_0_3
			buttonModel: button_model_0_3
			headerText: "Parameters"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_0_4
			width: rootItem.width
			sliderModel: slider_model_0_4
			buttonModel: button_model_0_4
			headerText: "Surprise"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
	}
}