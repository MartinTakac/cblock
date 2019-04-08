import QtQuick 2.4
	import QtQuick.Controls 1.2
	import QtQuick.Controls.Styles 1.2
	import QtQuick.Layouts 1.1
	import BL_qml 1.0

	Item
	{
		id: doubleGridViewRoot
		property QtObject buttonModel
		property string headerText
		property QtObject sliderModel

		property int sliderWidth: 170
		property int valueWidth: 40
		property int nameWidth: 90
		
		property real textScale: 1.0

		height: childrenRect.height
		
		function updateFilter()
		{
			var text = filterField.text
			var filter = ""
			for(var i = 0; i<text.length; i++)
				filter+= text[i]
			slidergridview.currentIndex = -1
			for (var i = 0; i < slidergridview.count; ++i)
			{
				slidergridview.currentIndex = i
				var gridViewChild = slidergridview.currentItem
				if (gridViewChild.objectName === "sliderDelegateName")
				{
					gridViewChild.searchSliders(filter)
				}
			}
			slidergridview.currentIndex = 0
		}
		
		function resetAllSliders()
		{
			// This feels a bit hacky but I haven't found a more elegant way
			slidergridview.currentIndex = -1
			for (var i = 0; i < slidergridview.count; ++i)
			{
				slidergridview.currentIndex = i
				var gridViewChild = slidergridview.currentItem
				
				if (gridViewChild.objectName === "sliderDelegateName")
				{
					gridViewChild.resetSliderToStartValue()
				}
			}
			slidergridview.currentIndex = 0
		}
		
		function updateAllSliders()
		{
			// This feels a bit hacky but I haven't found a more elegant way
			slidergridview.currentIndex = -1
			for (var i = 0; i < slidergridview.count; ++i)
			{
				slidergridview.currentIndex = i
				var gridViewChild = slidergridview.currentItem
				
				if (gridViewChild.objectName === "sliderDelegateName")
				{
					gridViewChild.setSliderToCurrentVariableValue()
				}
			}
			slidergridview.currentIndex = 0
		}

		Component
		{
			id: sectionHeaderDelegate
			Item
			{
				id: sectionHeaderContainer
				width: parent.width
				height: sectionTitleText.height+30

				Rectangle
				{
					id: sectionTitleLeftBracket
					color: "#FF888888"
					width: 2
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					anchors.right: sectionTitleText.left
					anchors.rightMargin: 30
					Rectangle
					{
						color: "#FF888888"
						height: 2
						anchors.top: parent.top
						anchors.left: parent.right
						width: 10
					}
					Rectangle
					{
						color: "#FF888888"
						height: 2
						anchors.bottom: parent.bottom
						anchors.left: parent.right
						width: 10
					}
				}
				Rectangle
				{
					id: sectionTitleRightBracket
					color: "#FF888888"
					width: 2
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					anchors.left: sectionTitleText.right
					anchors.leftMargin: 30
					Rectangle
					{
						color: "#FF888888"
						height: 2
						anchors.top: parent.top
						anchors.right: parent.left
						width: 10
					}
					Rectangle
					{
						color: "#FF888888"
						height: 2
						anchors.bottom: parent.bottom
						anchors.right: parent.left
						width: 10
					}
				}
				Rectangle
				{
					color: "#FF888888"
					height: 2
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.right: sectionTitleLeftBracket.left
				}
				Rectangle
				{
					color: "#FF888888"
					height: 2
					anchors.verticalCenter: parent.verticalCenter
					anchors.right: parent.right
					anchors.left: sectionTitleRightBracket.right
				}
				Label
				{
					id: sectionTitleTextPhantom
					anchors.centerIn: parent
					text: doubleGridViewRoot.headerText
					font.bold: true
					color: "transparent"
					horizontalAlignment: Text.AlignHCenter
					font.pointSize: doubleGridViewRoot.textScale*12
				}
				Label
				{
					id: sectionTitleText
					anchors.centerIn: parent
					text: doubleGridViewRoot.headerText
					font.bold: true
					color: "white"
					width: Math.min(parent.width/2, sectionTitleTextPhantom.contentWidth)
					wrapMode: Text.WordWrap
					horizontalAlignment: Text.AlignHCenter
					font.pointSize: doubleGridViewRoot.textScale*12
				}
			}
		}

		Component
		{
			id: buttonDelegate
			Button
			{
				id: buttonDelegateInternalButton
				text: model.name
				width: Math.max(doubleGridViewRoot.textScale*80, GridView.view.width/(GridView.view.count) - 10)
				height: 35
				checkable: model.isCheckable
				onPressedChanged:
				{
					if (!this.checkable)
					{
						if (this.pressed)
						{
							console.log(model.path, model.onValue)
							buttonDelegateInternalVariable.set_BL_variable_value(model.onValue)
						}
						else
						{
							console.log(model.path, model.offValue)
							buttonDelegateInternalVariable.set_BL_variable_value(model.offValue)
						}
					}
				}
				onCheckedChanged:
				{
					if (this.checkable)
					{
						if (this.checked)
						{
							console.log(model.path, model.onValue)
							buttonDelegateInternalVariable.set_BL_variable_value(model.onValue)
						}
						else
						{
							console.log(model.path, model.offValue)
							buttonDelegateInternalVariable.set_BL_variable_value(model.offValue)
						}
					}
				}
				style: ButtonStyle
				{
					background: Rectangle
					{
						implicitWidth: 100
						implicitHeight: 25
						border.width: control.pressed ? 2 : 1
						border.color: control.hovered ? "#FFEEEEEE" : "#FF989898"
						color: control.enabled ? ((control.checked || control.pressed) ? "#40DFDFDF" : "transparent") : "#80FF3030"
						radius: 3
					}
					label: Label
					{
						text: control.text
						color: "white"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						width: control.width
						height: control.height
						font.pointSize: doubleGridViewRoot.textScale*7
					}
				}
				
				BL_variable_qml
				{
					id: buttonDelegateInternalVariable
					variable_name: model.path
				}
				
				Component.onCompleted:
				{
					var variableValue = buttonDelegateInternalVariable.get_BL_variable_value();
					var onValueDiff = Math.abs(model.onValue - variableValue);
					var offValueDiff = Math.abs(model.offValue - variableValue);
					
					if (this.checkable === true)
					{
						if (onValueDiff < offValueDiff)
						{
							this.checked = true;
						}
						else
						{
							this.checked = false;
						}
						
						if ((onValueDiff > 0.0001) && (offValueDiff > 0.0001))
						{
							console.log("QML_ERROR. Variable: " + buttonDelegateInternalVariable.variable_name + ". Initial value from BL doesn't match on or off values specified for button (tol = 10e-4).");
							this.text = "ERROR: VALUE MISMATCH. BUTTON DISABLED."
							this.enabled = false;
						}
					}
					else
					{
						if (offValueDiff > 0.0001)
						{
							console.log("QML_ERROR. Variable: " + buttonDelegateInternalVariable.variable_name + ". Initial value from BL doesn't match off value specified for button (tol = 10e-4).");
							console.log("QML_ERROR. Variable: " + buttonDelegateInternalVariable.variable_name + ". Non-checkable buttons always start \"off\". The \"off\" value must to match initial value in BL.");
							this.text = "ERROR: OFF VALUE MISMATCH. BUTTON DISABLED."
							this.enabled = false;
						}
					}
				}
			}
		}

		Component
		{
			id: sliderDelegate

			Rectangle
			{
				height: doubleGridViewRoot.textScale*60
				width: doubleGridViewRoot.textScale*(doubleGridViewRoot.sliderWidth+doubleGridViewRoot.nameWidth+doubleGridViewRoot.valueWidth+2*sliderRow.spacing+25)
				color: "transparent"
				border.width: 1
				visible:
				{
					if (model.visible == undefined)
					{
						visible: true
					}
					else
					{
						visible: model.visible
					}
				}
				border.color: "#115D88"
				radius: 8
				objectName: "sliderDelegateName"
				function setSliderToCurrentVariableValue()
				{
					sliderDelegateInternalSlider.value = sliderDelegateInternalVariable.get_BL_variable_value()
				}
				function resetSliderToStartValue()
				{
					sliderDelegateInternalSlider.value = model.startValue
					console.log(model.path, model.startValue)
				}
				function searchSliders(searchTerm)
				{	
					var searchStr = searchTerm.toString()
					var sliderStr = (model.name).toString()
					var searchVal = sliderStr.search(searchStr)
					if (searchVal == -1)
					{
						model.visible = false
					}
					else
					{
						model.visible = true
					}
				}

				Row
				{
					id : sliderRow
					anchors.centerIn: parent
					spacing : 10
					
					BL_variable_qml
					{
						id: sliderDelegateInternalVariable
						variable_name: model.path
						Component.onCompleted:
						{
							var variableValue = sliderDelegateInternalVariable.get_BL_variable_value()

							if (variableValue < model.minValue)
							{
								console.log("QML_ERROR. Variable: " + sliderDelegateInternalVariable.variable_name + ". Initial variable value in BL is less than slider minimum. Slider minimum has been changed to match the initial BL value.");
								sliderDelegateInternalSlider.enabled = false;
								delegateText.text = "ERROR: INITIALISED OUTSIDE RANGE."
							}
							if (variableValue > model.maxValue)
							{
								console.log("QML_ERROR. Variable: " + sliderDelegateInternalVariable.variable_name + ". Initial variable value in BL is greater than slider maximum. Slider maximum has been changed to match the initial BL value.");
								sliderDelegateInternalSlider.enabled = false;
								delegateText.text = "ERROR: INITIALISED OUTSIDE RANGE."
							}
							sliderDelegateInternalSlider.value = variableValue;
							model.startValue = variableValue;
						}
					}
					
					Label
					{
						id: delegateText
						text: model.name
						font.capitalization: Font.AllUppercase
						font.bold: true
						font.pointSize: doubleGridViewRoot.textScale*7
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						elide: Text.ElideRight
						color: (sliderDelegateInternalSlider.hovered || sliderDelegateInternalSlider.pressed) ? "#FFBBBBBB" : "#FF888888"
						width: doubleGridViewRoot.textScale*doubleGridViewRoot.nameWidth
						wrapMode: Text.Wrap
						anchors.verticalCenter: parent.verticalCenter
					}
					TextField
					{	
						id: delegateEdit
						text:
						{
							Math.abs(Math.log(Math.abs(
								sliderDelegateInternalSlider.maximumValue-
								sliderDelegateInternalSlider.minimumValue
							))/Math.log(10)) > 4 ?
								sliderDelegateInternalSlider.value.toExponential(2) :
								sliderDelegateInternalSlider.value.toPrecision(3)
						}
						height: 30
						width: doubleGridViewRoot.textScale*doubleGridViewRoot.valueWidth
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						anchors.verticalCenter: parent.verticalCenter
						font.pointSize: doubleGridViewRoot.textScale*7
						onEditingFinished:
						{
							console.log(model.path, delegateEdit.text)
							sliderDelegateInternalVariable.set_BL_variable_value(parseFloat(delegateEdit.text))
							sliderDelegateInternalSlider.value = parseFloat(delegateEdit.text)
						}
						style: TextFieldStyle
						{
							textColor: "white"
							background: Rectangle {
								color: "black"
								radius: 2
								implicitWidth: 100
								implicitHeight: 24
								border.color: "#115D88"
								border.width: 1
							}
						}
					}
					Slider
					{
						id: sliderDelegateInternalSlider
						width: doubleGridViewRoot.textScale*doubleGridViewRoot.sliderWidth
						anchors.verticalCenter: parent.verticalCenter
						enabled: true
						style: SliderStyle
						{
							groove: Rectangle
							{
								implicitWidth: doubleGridViewRoot.textScale*doubleGridViewRoot.sliderWidth
								implicitHeight: doubleGridViewRoot.textScale*4
								color: control.enabled ? "#FF707070" : "#FFCC2020"
								radius: doubleGridViewRoot.textScale*4
								Rectangle
								{
									implicitWidth: styleData.handlePosition
									implicitHeight: doubleGridViewRoot.textScale*4
									color: "#FF20B0FF"
									radius: doubleGridViewRoot.textScale*4
								}
							}
							handle: Rectangle
							{
								anchors.centerIn: parent
								gradient: Gradient
								{
									GradientStop { position: 0.0; color: "white" }
									GradientStop { position: 0.38; color: control.enabled ? (control.pressed ? "white" : "#FF25B5FF") : "#FFFFB525" }
									GradientStop { position: 1.0; color: control.enabled ? (control.pressed ? "white" : "#FF1BABFF") : "#FFFFAB1B" }
								}
								implicitWidth: doubleGridViewRoot.textScale*12
								implicitHeight: doubleGridViewRoot.textScale*12
								radius: doubleGridViewRoot.textScale*6

								Rectangle
								{
									anchors.centerIn: parent
									color: control.pressed ? "#7622C9FF" : "#6020C7FF"
									border.color: "#FF29C0FF"
									border.width: control.hovered ? 1 : 0
									implicitWidth: doubleGridViewRoot.textScale*18
									implicitHeight: doubleGridViewRoot.textScale*18
									radius: doubleGridViewRoot.textScale*9
								}
							}
						}
						minimumValue: model.minValue
						maximumValue: model.maxValue
						value: sliderDelegateInternalVariable.get_BL_variable_value()
						stepSize: model.stepSize
						orientation: Qt.Horizontal
						onValueChanged:
						{
							sliderDelegateInternalVariable.set_BL_variable_value(value)
						}
						onPressedChanged:
						{
							if (! pressed)
							{
								console.log(model.path, value)
							}
						}
						MouseArea
						{
                            anchors.fill: parent
                            onWheel:
							{
                                //pass
                            }
                            onPressed:
							{
                                // forward mouse event
                                mouse.accepted = false
                            }
                            onReleased:
							{
                                // forward mouse event
                                mouse.accepted = false
                            }
						}
					}
				}
			}
		}

		GridView
		{
			id: buttongridview
			anchors.horizontalCenter: parent.horizontalCenter
			width: parent.width
			height: this.contentHeight
			interactive: false

			cellHeight: 50
			cellWidth: Math.max(doubleGridViewRoot.textScale*90, this.width/this.count)

			model: buttonModel
			delegate: buttonDelegate
			header: sectionHeaderDelegate
		}

		GridView
		{
			id: slidergridview
			width: parent.width
			height: this.cellHeight*Math.ceil(this.count/Math.max(1,(Math.floor(this.width/this.cellWidth))))
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: buttongridview.bottom
			interactive: false

			cellHeight: doubleGridViewRoot.textScale*64
			cellWidth: doubleGridViewRoot.textScale*(doubleGridViewRoot.sliderWidth+doubleGridViewRoot.nameWidth+doubleGridViewRoot.valueWidth+50)

			model: sliderModel
			delegate: sliderDelegate
		}
	}