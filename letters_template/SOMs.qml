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
			id: slider_model_2_0
					
			ListElement
			{
				name: "inspect SOM"
				path: "cblock/seq_som/TD_inspection/control/inspect"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "display realtime"
				path: "cblock/cblockParams/display_seq_som_real_time"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "learn in non goal-driven"
				path: "cblock/cblockParams/seq_learn_non_goal_driven"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "learn in goal-driven"
				path: "cblock/cblockParams/seq_learn_goal_driven"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sensitivity train"
				path: "cblock/seq_som/asomConsts/qmlSensitivityTrain"
				startValue: 20.0
				minValue: 0.0
				maxValue: 40.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Sensitivity predict"
				path: "cblock/seq_som/asomConsts/qmlSensitivityPredict"
				startValue: 20.0
				minValue: 0.0
				maxValue: 40.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "use TR prior"
				path: "cblock/seq_som/asomConsts/qmlUseTrPrior"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Soft output"
				path: "cblock/seq_som/asomConsts/qmlSoftOutput"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "LFC"
				path: "cblock/seq_som/asomConsts/qmlLfc"
				startValue: 750.0
				minValue: 0.0
				maxValue: 1500.0
				stepSize: 100.0
			}
					
			ListElement
			{
				name: "Sigma"
				path: "cblock/seq_som/asomConsts/qmlSigma"
				startValue: 1.0
				minValue: 0.0
				maxValue: 2.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Compare noise"
				path: "cblock/seq_som/asomConsts/qmlCompareNoise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.05
			}
					
			ListElement
			{
				name: "Best match threshold"
				path: "cblock/seq_som/asomConsts/qmlBestMatchThreshold"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Best match LR multiplier"
				path: "cblock/seq_som/asomConsts/qmlBestMatchLfcMult"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Training record decay"
				path: "cblock/seq_som/asomConsts/qmlTrainingRecordDecay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "context decay"
				path: "cblock/cblockParams/prev_context_mix"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "tonic decay"
				path: "cblock/cblockParams/tonic_decay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
		}
		ListModel
		{
			id: button_model_2_0
				
		}
		ListModel
		{
			id: slider_model_2_1
					
			ListElement
			{
				name: "tonic"
				path: "cblock/seq_som/alpha_gains/tonic_train"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "context"
				path: "cblock/seq_som/alpha_gains/context_train"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "current"
				path: "cblock/seq_som/alpha_gains/current_train"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "next"
				path: "cblock/seq_som/alpha_gains/next_train"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "eos"
				path: "cblock/seq_som/alpha_gains/eos_train"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
		}
		ListModel
		{
			id: button_model_2_1
				
		}
		ListModel
		{
			id: slider_model_2_2
					
			ListElement
			{
				name: "tonic"
				path: "cblock/seq_som/alpha_gains/tonic"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "context"
				path: "cblock/seq_som/alpha_gains/context"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "current"
				path: "cblock/seq_som/alpha_gains/current"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
		}
		ListModel
		{
			id: button_model_2_2
				
		}
		ListModel
		{
			id: slider_model_2_3
					
			ListElement
			{
				name: "tonic"
				path: "cblock/seq_som/alpha_gains/tonic_gd"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "context"
				path: "cblock/seq_som/alpha_gains/context_gd"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "current"
				path: "cblock/seq_som/alpha_gains/current_gd"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
		}
		ListModel
		{
			id: button_model_2_3
				
		}
		ListModel
		{
			id: slider_model_2_4
					
			ListElement
			{
				name: "tonic"
				path: "cblock/seq_som/alpha_gains/tonic_surprise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "context"
				path: "cblock/seq_som/alpha_gains/context_surprise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "current"
				path: "cblock/seq_som/alpha_gains/current_surprise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.01
			}
					
			ListElement
			{
				name: "keep till eos gd"
				path: "cblock/cblockParams/surprise_alphas_till_eos_gd"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "keep till eos ngd"
				path: "cblock/cblockParams/surprise_alphas_till_eos_ngd"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
		}
		ListModel
		{
			id: button_model_2_4
				
		}
		ListModel
		{
			id: slider_model_2_5
					
			ListElement
			{
				name: "inspect SOM"
				path: "cblock/plan_som/TD_inspection/control/inspect"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "TD influence"
				path: "cblock/cblockInputs/plan_TD_influence"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "display realtime"
				path: "cblock/cblockParams/display_plan_som_real_time"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "learn in non goal-driven"
				path: "cblock/cblockParams/plan_learn_non_goal_driven"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "learn in goal-driven"
				path: "cblock/cblockParams/plan_learn_goal_driven"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sens from plan"
				path: "cblock/plan_som/asomConsts/qmlSensitivityJustPlan"
				startValue: 20.0
				minValue: 0.0
				maxValue: 40.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Sens from rew"
				path: "cblock/plan_som/asomConsts/qmlSensitivityJustReward"
				startValue: 75.0
				minValue: 0.0
				maxValue: 150.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Sens from res"
				path: "cblock/plan_som/asomConsts/qmlSensitivityResult"
				startValue: 50.0
				minValue: 0.0
				maxValue: 100.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "use TR prior"
				path: "cblock/plan_som/asomConsts/qmlUseTrPrior"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Soft output"
				path: "cblock/plan_som/asomConsts/qmlSoftOutput"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "LFC"
				path: "cblock/plan_som/asomConsts/qmlLfc"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sigma"
				path: "cblock/plan_som/asomConsts/qmlSigma"
				startValue: 1.0
				minValue: 0.0
				maxValue: 2.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Compare noise"
				path: "cblock/plan_som/asomConsts/qmlCompareNoise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.05
			}
					
			ListElement
			{
				name: "Best match threshold"
				path: "cblock/plan_som/asomConsts/qmlBestMatchThreshold"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Best match LR multiplier"
				path: "cblock/plan_som/asomConsts/qmlBestMatchLfcMult"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Training record decay"
				path: "cblock/plan_som/asomConsts/qmlTrainingRecordDecay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
		}
		ListModel
		{
			id: button_model_2_5
				
		}
		ListModel
		{
			id: slider_model_2_6
					
			ListElement
			{
				name: "display realtime"
				path: "cblock/IO/xy_som_consts/display_real_time"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "allow training"
				path: "cblock/cblockParams/allow_indiv_som_training"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sensitivity"
				path: "cblock/IO/xy_som_consts/qmlSensitivity"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Compare noise"
				path: "cblock/IO/xy_som_consts/qmlCompareNoise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.05
			}
					
			ListElement
			{
				name: "Best match threshold"
				path: "cblock/IO/xy_som_consts/qmlBestMatchThreshold"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Best match LR multiplier"
				path: "cblock/IO/xy_som_consts/qmlBestMatchLfcMult"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Learning rate"
				path: "cblock/IO/xy_som_consts/qmlLearningFrequency"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Learning rate when full"
				path: "cblock/IO/xy_som_consts/qmlLearningFrequencyFullMap"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sigma"
				path: "cblock/IO/xy_som_consts/qmlSigma"
				startValue: 1.0
				minValue: 0.0
				maxValue: 2.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Training record decay"
				path: "cblock/IO/xy_som_consts/qmlTrainingRecordDecay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
		}
		ListModel
		{
			id: button_model_2_6
				
		}
		ListModel
		{
			id: slider_model_2_7
					
			ListElement
			{
				name: "display realtime"
				path: "cblock/IO/xy_som_consts/display_real_time"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "allow training"
				path: "cblock/cblockParams/allow_indiv_som_training"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "sparse bump inv size"
				path: "cblock/IO/winner_pos_to_sparse_som/activation_sensitivity"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Sensitivity"
				path: "cblock/IO/xy_som_consts_sparse/qmlSensitivity"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Compare noise"
				path: "cblock/IO/xy_som_consts_sparse/qmlCompareNoise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.05
			}
					
			ListElement
			{
				name: "Best match threshold"
				path: "cblock/IO/xy_som_consts_sparse/qmlBestMatchThreshold"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Best match LR multiplier"
				path: "cblock/IO/xy_som_consts_sparse/qmlBestMatchLfcMult"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Learning rate"
				path: "cblock/IO/xy_som_consts_sparse/qmlLearningFrequency"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Learning rate when full"
				path: "cblock/IO/xy_som_consts_sparse/qmlLearningFrequencyFullMap"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sigma"
				path: "cblock/IO/xy_som_consts_sparse/qmlSigma"
				startValue: 1.0
				minValue: 0.0
				maxValue: 2.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Training record decay"
				path: "cblock/IO/xy_som_consts_sparse/qmlTrainingRecordDecay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
		}
		ListModel
		{
			id: button_model_2_7
				
		}
		ListModel
		{
			id: slider_model_2_8
					
			ListElement
			{
				name: "inspect SOM"
				path: "cblock/IO/TD_inspection/control/inspect"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "display realtime"
				path: "cblock/IO/bitmap_som_consts/display_real_time"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "allow training"
				path: "cblock/cblockParams/allow_indiv_som_training"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sensitivity"
				path: "cblock/IO/bitmap_som_consts/qmlSensitivity"
				startValue: 50.0
				minValue: 0.0
				maxValue: 100.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Compare noise"
				path: "cblock/IO/bitmap_som_consts/qmlCompareNoise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.05
			}
					
			ListElement
			{
				name: "Best match threshold"
				path: "cblock/IO/bitmap_som_consts/qmlBestMatchThreshold"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Best match LR multiplier"
				path: "cblock/IO/bitmap_som_consts/qmlBestMatchLfcMult"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Learning rate"
				path: "cblock/IO/bitmap_som_consts/qmlLearningFrequency"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Learning rate when full"
				path: "cblock/IO/bitmap_som_consts/qmlLearningFrequencyFullMap"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sigma"
				path: "cblock/IO/bitmap_som_consts/qmlSigma"
				startValue: 1.0
				minValue: 0.0
				maxValue: 2.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Training record decay"
				path: "cblock/IO/bitmap_som_consts/qmlTrainingRecordDecay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
		}
		ListModel
		{
			id: button_model_2_8
				
		}
		ListModel
		{
			id: slider_model_2_9
					
			ListElement
			{
				name: "inspect SOM"
				path: "cblock/IO/TD_inspection/control/inspect"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "display realtime"
				path: "cblock/IO/bitmap_som_consts/display_real_time"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "allow training"
				path: "cblock/cblockParams/allow_indiv_som_training"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "sparse bump inv size"
				path: "cblock/IO/winner_pos_to_sparse_som/activation_sensitivity"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Sensitivity"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlSensitivity"
				startValue: 50.0
				minValue: 0.0
				maxValue: 100.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Compare noise"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlCompareNoise"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.05
			}
					
			ListElement
			{
				name: "Best match threshold"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlBestMatchThreshold"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Best match LR multiplier"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlBestMatchLfcMult"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
			ListElement
			{
				name: "Learning rate"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlLearningFrequency"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Learning rate when full"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlLearningFrequencyFullMap"
				startValue: 500.0
				minValue: 0.0
				maxValue: 1000.0
				stepSize: 1.0
			}
					
			ListElement
			{
				name: "Sigma"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlSigma"
				startValue: 1.0
				minValue: 0.0
				maxValue: 2.0
				stepSize: 0.1
			}
					
			ListElement
			{
				name: "Training record decay"
				path: "cblock/IO/bitmap_som_consts_sparse/qmlTrainingRecordDecay"
				startValue: 0.5
				minValue: 0.0
				maxValue: 1.0
				stepSize: 0.001
			}
					
		}
		ListModel
		{
			id: button_model_2_9
				
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
			
				dgv_2_0.resetAllSliders()
				dgv_2_1.resetAllSliders()
				dgv_2_2.resetAllSliders()
				dgv_2_3.resetAllSliders()
				dgv_2_4.resetAllSliders()
				dgv_2_5.resetAllSliders()
				dgv_2_6.resetAllSliders()
				dgv_2_7.resetAllSliders()
				dgv_2_8.resetAllSliders()
				dgv_2_9.resetAllSliders()
			}
		}
		DoubleGridView
		{
			id: dgv_2_0
			width: rootItem.width
			sliderModel: slider_model_2_0
			buttonModel: button_model_2_0
			headerText: "seq SOM"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_1
			width: rootItem.width
			sliderModel: slider_model_2_1
			buttonModel: button_model_2_1
			headerText: "alphas train"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 100
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_2
			width: rootItem.width
			sliderModel: slider_model_2_2
			buttonModel: button_model_2_2
			headerText: "alphas predict"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 100
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_3
			width: rootItem.width
			sliderModel: slider_model_2_3
			buttonModel: button_model_2_3
			headerText: "alphas goal-driven predict"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 100
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_4
			width: rootItem.width
			sliderModel: slider_model_2_4
			buttonModel: button_model_2_4
			headerText: "alphas surprise predict"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 100
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_5
			width: rootItem.width
			sliderModel: slider_model_2_5
			buttonModel: button_model_2_5
			headerText: "plan-SOM"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_6
			width: rootItem.width
			sliderModel: slider_model_2_6
			buttonModel: button_model_2_6
			headerText: "xy input SOM"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_7
			width: rootItem.width
			sliderModel: slider_model_2_7
			buttonModel: button_model_2_7
			headerText: "xy input SOM sparse"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_8
			width: rootItem.width
			sliderModel: slider_model_2_8
			buttonModel: button_model_2_8
			headerText: "bitmap input SOM"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
		DoubleGridView
		{
			id: dgv_2_9
			width: rootItem.width
			sliderModel: slider_model_2_9
			buttonModel: button_model_2_9
			headerText: "bitmap input SOM sparse"
			sliderWidth: 200
			nameWidth: 300
			valueWidth: 80
			textScale: rootItem.textScale
		}
	}
}