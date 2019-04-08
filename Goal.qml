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
			id: slider_model_1_0
					
			ListElement
			{
				name: "goal-driven"
				path: "cblock/cblockInputs/goal_driven"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "plan inspection"
				path: "cblock/cblockInputs/goal_plan_inspection"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_1_0
				
		}
		ListModel
		{
			id: slider_model_1_1
					
			ListElement
			{
				name: "result index"
				path: "control/manual_goal_index"
				startValue: 10.0
				minValue: 0.0
				maxValue: 20.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "reward"
				path: "cblock/planning/goal/reward"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "alpha result"
				path: "cblock/planning/goal/alpha_goal_state_bulk"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "alpha reward"
				path: "cblock/planning/goal/alpha_reward"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
		}
		ListModel
		{
			id: button_model_1_1
				
		}
		ListModel
		{
			id: slider_model_1_2
					
			ListElement
			{
				name: "goal timeout speed"
				path: "cblock/planning/control/plan_timeout_speed"
				startValue: 1.0
				minValue: 0.0
				maxValue: 2.0
				stepSize: 0.0001
			}
					
			ListElement
			{
				name: "plan goodness thr"
				path: "cblock/cblockParams/plan_goodness_thr"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "goal reached thr"
				path: "cblock/cblockParams/goal_reached_thr"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "plan ior decay"
				path: "cblock/planning/control/ior_decay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.0001
			}
					
			ListElement
			{
				name: "ior surround"
				path: "cblock/planning/control/ior_surrounding"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "inv sur size"
				path: "cblock/planning/xy_to_loc_som/activation_sensitivity"
				startValue: 400.0
				minValue: 0.0
				maxValue: 800.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "TD plan gain in goal"
				path: "cblock/cblockParams/plan_top_down_on_seq_gain"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "plan noise"
				path: "cblock/planning/control/noise_level"
				startValue: 0.005
				minValue: 0.0
				maxValue: 0.01
				stepSize: 0.0001
			}
					
			ListElement
			{
				name: "delta plans"
				path: "cblock/cblockParams/use_delta_based_plans"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_1_2
				
		}
		ListModel
		{
			id: slider_model_1_3
					
			ListElement
			{
				name: "upper half"
				path: "goal_state_comp_gains_qml/bulk_upper_half"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "bottom half"
				path: "goal_state_comp_gains_qml/bulk_bottom_half"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c0"
				path: "goal_state_comp_gains_qml/c0"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c1"
				path: "goal_state_comp_gains_qml/c1"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c2"
				path: "goal_state_comp_gains_qml/c2"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c3"
				path: "goal_state_comp_gains_qml/c3"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c4"
				path: "goal_state_comp_gains_qml/c4"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c5"
				path: "goal_state_comp_gains_qml/c5"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c6"
				path: "goal_state_comp_gains_qml/c6"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c7"
				path: "goal_state_comp_gains_qml/c7"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c8"
				path: "goal_state_comp_gains_qml/c8"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c9"
				path: "goal_state_comp_gains_qml/c9"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c10"
				path: "goal_state_comp_gains_qml/c10"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c11"
				path: "goal_state_comp_gains_qml/c11"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c12"
				path: "goal_state_comp_gains_qml/c12"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c13"
				path: "goal_state_comp_gains_qml/c13"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c14"
				path: "goal_state_comp_gains_qml/c14"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c15"
				path: "goal_state_comp_gains_qml/c15"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c16"
				path: "goal_state_comp_gains_qml/c16"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c17"
				path: "goal_state_comp_gains_qml/c17"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c18"
				path: "goal_state_comp_gains_qml/c18"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c19"
				path: "goal_state_comp_gains_qml/c19"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c20"
				path: "goal_state_comp_gains_qml/c20"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c21"
				path: "goal_state_comp_gains_qml/c21"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c22"
				path: "goal_state_comp_gains_qml/c22"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c23"
				path: "goal_state_comp_gains_qml/c23"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c24"
				path: "goal_state_comp_gains_qml/c24"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c25"
				path: "goal_state_comp_gains_qml/c25"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c26"
				path: "goal_state_comp_gains_qml/c26"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c27"
				path: "goal_state_comp_gains_qml/c27"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c28"
				path: "goal_state_comp_gains_qml/c28"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c29"
				path: "goal_state_comp_gains_qml/c29"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c30"
				path: "goal_state_comp_gains_qml/c30"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c31"
				path: "goal_state_comp_gains_qml/c31"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c32"
				path: "goal_state_comp_gains_qml/c32"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c33"
				path: "goal_state_comp_gains_qml/c33"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c34"
				path: "goal_state_comp_gains_qml/c34"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c35"
				path: "goal_state_comp_gains_qml/c35"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c36"
				path: "goal_state_comp_gains_qml/c36"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c37"
				path: "goal_state_comp_gains_qml/c37"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c38"
				path: "goal_state_comp_gains_qml/c38"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c39"
				path: "goal_state_comp_gains_qml/c39"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c40"
				path: "goal_state_comp_gains_qml/c40"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c41"
				path: "goal_state_comp_gains_qml/c41"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c42"
				path: "goal_state_comp_gains_qml/c42"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c43"
				path: "goal_state_comp_gains_qml/c43"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c44"
				path: "goal_state_comp_gains_qml/c44"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c45"
				path: "goal_state_comp_gains_qml/c45"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c46"
				path: "goal_state_comp_gains_qml/c46"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c47"
				path: "goal_state_comp_gains_qml/c47"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c48"
				path: "goal_state_comp_gains_qml/c48"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c49"
				path: "goal_state_comp_gains_qml/c49"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c50"
				path: "goal_state_comp_gains_qml/c50"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c51"
				path: "goal_state_comp_gains_qml/c51"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c52"
				path: "goal_state_comp_gains_qml/c52"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c53"
				path: "goal_state_comp_gains_qml/c53"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c54"
				path: "goal_state_comp_gains_qml/c54"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c55"
				path: "goal_state_comp_gains_qml/c55"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c56"
				path: "goal_state_comp_gains_qml/c56"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c57"
				path: "goal_state_comp_gains_qml/c57"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c58"
				path: "goal_state_comp_gains_qml/c58"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c59"
				path: "goal_state_comp_gains_qml/c59"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c60"
				path: "goal_state_comp_gains_qml/c60"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c61"
				path: "goal_state_comp_gains_qml/c61"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c62"
				path: "goal_state_comp_gains_qml/c62"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c63"
				path: "goal_state_comp_gains_qml/c63"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c64"
				path: "goal_state_comp_gains_qml/c64"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c65"
				path: "goal_state_comp_gains_qml/c65"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c66"
				path: "goal_state_comp_gains_qml/c66"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c67"
				path: "goal_state_comp_gains_qml/c67"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c68"
				path: "goal_state_comp_gains_qml/c68"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c69"
				path: "goal_state_comp_gains_qml/c69"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c70"
				path: "goal_state_comp_gains_qml/c70"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c71"
				path: "goal_state_comp_gains_qml/c71"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c72"
				path: "goal_state_comp_gains_qml/c72"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c73"
				path: "goal_state_comp_gains_qml/c73"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c74"
				path: "goal_state_comp_gains_qml/c74"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c75"
				path: "goal_state_comp_gains_qml/c75"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c76"
				path: "goal_state_comp_gains_qml/c76"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c77"
				path: "goal_state_comp_gains_qml/c77"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c78"
				path: "goal_state_comp_gains_qml/c78"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c79"
				path: "goal_state_comp_gains_qml/c79"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c80"
				path: "goal_state_comp_gains_qml/c80"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c81"
				path: "goal_state_comp_gains_qml/c81"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c82"
				path: "goal_state_comp_gains_qml/c82"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c83"
				path: "goal_state_comp_gains_qml/c83"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c84"
				path: "goal_state_comp_gains_qml/c84"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c85"
				path: "goal_state_comp_gains_qml/c85"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c86"
				path: "goal_state_comp_gains_qml/c86"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c87"
				path: "goal_state_comp_gains_qml/c87"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c88"
				path: "goal_state_comp_gains_qml/c88"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c89"
				path: "goal_state_comp_gains_qml/c89"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c90"
				path: "goal_state_comp_gains_qml/c90"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c91"
				path: "goal_state_comp_gains_qml/c91"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c92"
				path: "goal_state_comp_gains_qml/c92"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c93"
				path: "goal_state_comp_gains_qml/c93"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c94"
				path: "goal_state_comp_gains_qml/c94"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c95"
				path: "goal_state_comp_gains_qml/c95"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c96"
				path: "goal_state_comp_gains_qml/c96"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c97"
				path: "goal_state_comp_gains_qml/c97"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c98"
				path: "goal_state_comp_gains_qml/c98"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "c99"
				path: "goal_state_comp_gains_qml/c99"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_1_3
				
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
			
				dgv_1_0.resetAllSliders()
				dgv_1_1.resetAllSliders()
				dgv_1_2.resetAllSliders()
				dgv_1_3.resetAllSliders()
			}
		}
		DoubleGridView
		{
			id: dgv_1_0
			width: rootItem.width
			sliderModel: slider_model_1_0
			buttonModel: button_model_1_0
			headerText: "Control"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_1_1
			width: rootItem.width
			sliderModel: slider_model_1_1
			buttonModel: button_model_1_1
			headerText: "Manual goal"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_1_2
			width: rootItem.width
			sliderModel: slider_model_1_2
			buttonModel: button_model_1_2
			headerText: "Parameters"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_1_3
			width: rootItem.width
			sliderModel: slider_model_1_3
			buttonModel: button_model_1_3
			headerText: "Result component gains"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 90
			textScale: rootItem.textScale
		}
	}
}