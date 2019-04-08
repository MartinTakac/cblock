import re
import sys
import argparse
from os import path

class buttonParameters:
	def __init__(self):
		self.name = "Button"
		self.path = ""
		self.onValue = 1.0
		self.offValue = 0.0
		self.checkable = False
		
class sliderParameters:
	def __init__(self):
		self.name = "Slider"
		self.path = ""
		self.startValue = 0.0
		self.minValue = 0.0
		self.maxValue = 1.0
		self.stepSize = 0.0
		
class tabSection:
	def __init__(self):
		self.name = "Section"
		self.buttonList = []
		self.sliderList = []
		self.sliderColumnWidth = 200
		self.nameColumnWidth = 100
		self.valueTextColumnWidth = 40

class tabInfo:
	def __init__(self):
		self.name = "VARIABLE TUNING"
		self.sectionList = []
		
def writeBrainChildControlsQMLFile(tabsList):
	with open("brain_child_controls.qml", "w") as bcControlsFile:
		print("Writing brain_child_controls.qml")
			
		bcControlsFile.write("""
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
""")

		for tabInfo in tabsList:
			bcControlsFile.write("""
	Tab
	{{
		title: "{0}"
		{1}
		{{
		}}
	}}""".format(tabInfo.name, (str(tabInfo.name).replace(" ", ""))))
	
		bcControlsFile.write("""
}""")
		
def writeDoubleGridViewQMLFile():
	with open("DoubleGridView.qml", "w") as doubleGridViewFile:
		print("Writing DoubleGridView.qml")
		
		doubleGridViewFile.write("""import QtQuick 2.3
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
							buttonDelegateInternalVariable.set_BL_variable_value(model.onValue)
						}
						else
						{
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
							buttonDelegateInternalVariable.set_BL_variable_value(model.onValue)
						}
						else
						{
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
							console.log("QML_WARNING. Variable: " + buttonDelegateInternalVariable.variable_name + ". Non-checkable buttons always start \\"off\\". The \\"off\\" value must to match initial value in BL.");
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
				border.color: "#8820B0FF"
				radius: 8
				objectName: "sliderDelegateName"
				
				function resetSliderToStartValue()
				{
					sliderDelegateInternalSlider.value = model.startValue
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
					Label
					{
						text: {
							Math.abs(Math.log(Math.abs(
								sliderDelegateInternalSlider.maximumValue-
								sliderDelegateInternalSlider.minimumValue
							))/Math.log(10)) > 4 ?
								sliderDelegateInternalSlider.value.toExponential(2) :
								sliderDelegateInternalSlider.value.toPrecision(3)
						}

						color: (sliderDelegateInternalSlider.hovered || sliderDelegateInternalSlider.pressed) ? "#FFBBBBBB" : "#FF888888"
						height: 30
						width: doubleGridViewRoot.textScale*doubleGridViewRoot.valueWidth
						elide: Text.ElideRight
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						anchors.verticalCenter: parent.verticalCenter
						font.pointSize: doubleGridViewRoot.textScale*7
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
							handle:
							Rectangle
							{
								anchors.centerIn: parent
								gradient: Gradient {
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
	}""")

parser = argparse.ArgumentParser(
formatter_class=argparse.RawDescriptionHelpFormatter,
description = """Parse a config file to generate a QML interface containing 
sliders for adjusting BL variables""",
epilog = """
The input config file is a plain ASCII text file.
The output is two a QML files specifying a tabbed interface.
The first output file is named "brain_child_controls.qml" by default.
Its name is user-specifiable.
The second output file is named "DoubleGridView.qml". Its name must
not be altered and it must be placed in the same directory as the
first output file in order for the interface to work correctly.
This script should automatically place it in the same directory as the
first output file.

Within the interface, each tab contains a number of sliders and buttons
linked to BL variables. These are arranged in sections.
Buttons appear at the top of a section, followed by the sliders.

Lines contain a line specifier and a number of parameters,
each separated by a comma.
Lines beginning with a # are treated as comments and ignored.

A new tab is declared using the tab line:
  tab,<tab name>
    tab name		this text appears as the title/heading of the slider group within the tab
	
Each tab contains one or more sections.
A new section is declared using the section line.
Properties governing the overall layout of a section are
specified in this line. Each time a section line appears,
a new section is added to the current tab.
  section,<section name>,<slider width>,<slider name width>,<value text width>

    section name	this text appears as the title/heading of the section
    slider width	the width of the sliders
    slider name width	the width of the sliders' names
    value text width	the width of the sliders' value displays

The general format for a button line is:
  button,<variable path>,<label text>,[on value],[off value],[-checkable]

    variable path 	the path to the variable of interest
    label text		the text appearing on the button
    on value		the value sent when the button is being pressed  (default 1.0)
    off value		the value sent when the button is not being pressed  (default 0.0)
	-checkable		add the tag "-checkable" to make this a checkable button
			
The general format for a slider line is:
  slider,<variable path>,<label text>,<starting value>,<minimum value>,<maximum value>,<step size>

    variable path 	the path to the variable of interest
    label text		the text which appears next to the slider
    minimum value	the minimum value of the slider
    maximum value	the maximum value of the slider
    step size		the size of the steps used by the slider



--- EXAMPLE CONFIG FILE ---
# First tab
tab,Breathing

# Section
section,Firing rates etc.,180,90,50
button,breathing_network/perform_time_step,Pause breathing,0.0,1.0,-checkable
slider,breathing_network/pneumo/tonic_firing_rate,pneumo TFR to Pons,-1.0,1.0,0.05
slider,breathing_network/apneu/tonic_firing_rate,apneu TFR to Pons,-1.0,1.0,0.05

# Section
section,Frequency Constants,180,90,50
slider,breathing_network/frequency_constants/self_ifc_ex,Self IFC,0,100,1.0
slider,breathing_network/frequency_constants/pre_ifc_ex,Pre I IFC,0,100,1.0

# Second tab
tab,Breathing 2

# Section
section,Special,180,90,50
slider,breathing_network/frequency_constants/ext_mfc_ex,External Int MFC,0,100,1.0


--- EXAMPLE USAGE ---
python sliderTabQmlGenerator.py config.txt
python sliderTabQmlGenerator.py config.txt -sf
"""
)
parser.add_argument("inputfile", help = "input file to parse")
parser.add_argument("--scenefiles", "-sf", action = "store_true", help = "(switch) write complete scene QML files")

args = parser.parse_args()

inputFilename = str(args.inputfile)

with open(inputFilename, "r") as scriptFile:

	tabsList = []
	currentTabInfo = None
	currentSectionInfo = None
	lineNumber = 1
	numberOfRowsInLayoutDefault = 15
	sliderColumnWidthDefault = 200
	nameColumnWidthDefault = 70
	valueTextColumnWidthDefault = 30
	panelNameDefault = "VARIABLE TUNING"
	firstTab = True
	firstSectionInTab = True
	
	for lineIter in scriptFile:
		line = lineIter.strip()
		if (len(line) == 0) or (line[0] == '#'):
			continue
		
		tokens = line.split(",")
		if (tokens[0] == "tab"):
			if (len(tokens) < 2):
				print("Error parsing tab at line " + str(lineNumber) + ": Not enough parameters.")
			elif (len(tokens) > 2):
				print("Error parsing tab at line " + str(lineNumber) + ": Too many parameters.")
			else:
				if currentTabInfo is not None:
					if currentSectionInfo is not None:
						currentTabInfo.sectionList.append(currentSectionInfo)
						currentSectionInfo = None
					tabsList.append(currentTabInfo)
					
				print("Tab added: " + str(tokens[1]))
				currentTabInfo = tabInfo()	
				currentTabInfo.name = str(tokens[1])
				
		elif (tokens[0] == "section"):
			if currentTabInfo is None:
				print("Error parsing section at line " + str(lineNumber) + ": Must declare a tab first.")
			else:
				if (len(tokens) < 5):
					print("Error parsing section at line " + str(lineNumber) + ": Not enough parameters.")
				elif (len(tokens) > 5):
					print("Error parsing section at line " + str(lineNumber) + ": Too many parameters.")
				else:
					if currentSectionInfo is not None:
						currentTabInfo.sectionList.append(currentSectionInfo)
					
					print("Section added: " + str(tokens[1]))
					currentSectionInfo = tabSection()
					currentSectionInfo.name = str(tokens[1])
					currentSectionInfo.sliderColumnWidth = int(tokens[2])
					currentSectionInfo.nameColumnWidth = int(tokens[3])
					currentSectionInfo.valueTextColumnWidth = int(tokens[4])
				
		elif (tokens[0] == "button"):
			if currentSectionInfo is None and currentTabInfo is None:
				print("Error parsing button at line " + str(lineNumber) + ": Must declare a tab and a section first.")
			elif currentSectionInfo is None and currentTabInfo is not None:
				print("Error parsing button at line " + str(lineNumber) + ": Must declare a section first.")
			else:
				if (len(tokens) < 3):
					print("Error parsing button at line " + str(lineNumber) + ": Not enough parameters.")
				elif (len(tokens) > 6):
					print("Error parsing button at line " + str(lineNumber) + ": Too many parameters.")
				else:
					print("Button added for: " + str(tokens[1]))
					
					tempButtonParam = buttonParameters()
					
					tempButtonParam.path = str(tokens[1])
					tempButtonParam.name = str(tokens[2])
					
					if (len(tokens) > 3):
						tempButtonParam.onValue = float(tokens[3])
					if (len(tokens) > 4):
						tempButtonParam.offValue = float(tokens[4])
					if (len(tokens) > 5) and (str(tokens[5]) == "-checkable"):
						tempButtonParam.checkable = True
					
					currentSectionInfo.buttonList.append(tempButtonParam)
				
		elif (tokens[0] == "slider"):
			if currentSectionInfo is None and currentTabInfo is None:
				print("Error parsing slider at line " + str(lineNumber) + ": Must declare a tab and a section first.")
			elif currentSectionInfo is None and currentTabInfo is not None:
				print("Error parsing slider at line " + str(lineNumber) + ": Must declare a section first.")
			else:
				if (len(tokens) < 6):
					print("Error parsing slider at line " + str(lineNumber) + ": Not enough parameters.")
				elif (len(tokens) > 7):
					print("Error parsing slider at line " + str(lineNumber) + ": Too many parameters.")
				elif (len(tokens) == 7):
					print("Error parsing slider at line " + str(lineNumber) + ": Too many parameters.")
					print("\tOlder versions of this script needed an extra parameter - startValue - which is no longer used.")
					print("\tTry removing the 3rd parameter (the first number after the path and name) for any affected lines.")
				else:
					print("Slider added for: " + str(tokens[1]))
					
					tempSliderParam = sliderParameters()
					
					tempSliderParam.path = str(tokens[1])
					tempSliderParam.name = str(tokens[2])
					tempSliderParam.minValue = float(tokens[3])
					tempSliderParam.maxValue = float(tokens[4])
					tempSliderParam.startValue = (tempSliderParam.minValue + tempSliderParam.maxValue) / 2.0
					tempSliderParam.stepSize = float(tokens[5])
					
#					# OLD CODE
#					
#					if (len(tokens) < 7):
#						stepSize = (float(tokens[5]) - float(tokens[4])) / currentSectionInfo.sliderColumnWidth
#						
#						# Seems nasty but is probably still OK and isn't called frequently
#						nearestPowerOfTen = math.pow(10, math.floor(math.log10(stepSize)))
#						stepSizeLogMultiplier = math.floor(stepSize / nearestPowerOfTen)
#						
#						stepSizeIntegerIncrement = 1
#						
#						if (stepSizeLogMultiplier < 5) and (stepSizeLogMultiplier >= 2):
#							stepSizeIntegerIncrement = 2						
#						elif (stepSizeLogMultiplier >= 5):
#							stepSizeIntegerIncrement = 5
#						
#						stepSize = stepSizeIntegerIncrement * nearestPowerOfTen
#						
#						tempSliderParam.stepSize = stepSize
#					else:
#						tempSliderParam.stepSize = float(tokens[6])
#
					currentSectionInfo.sliderList.append(tempSliderParam)
			
		lineNumber += 1
	
	if currentTabInfo is not None and currentSectionInfo is not None:
		currentTabInfo.sectionList.append(currentSectionInfo)
		tabsList.append(currentTabInfo)
		

for tabIndex, tabIter in enumerate(tabsList):
	outputFileName = (str(tabIter.name).replace(" ", "")) + ".qml"
	with open(outputFileName, "w") as outputFile:
		print("Writing " + outputFileName)
		
		outputFile.write("""import QtQuick 2.2
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
""")
		for sectionIndex, sectionIter in enumerate(tabIter.sectionList):
			outputFile.write("""
		ListModel
		{{
			id: slider_model_{0}_{1}
					""".format(tabIndex, sectionIndex))

			for sliderParam in sectionIter.sliderList:
				outputFile.write("""
			ListElement
			{{
				name: "{0}"
				path: "{1}"
				startValue: {2}
				minValue: {3}
				maxValue: {4}
				stepSize: {5}
			}}
					""".format(
					sliderParam.name,
					sliderParam.path,
					sliderParam.startValue,
					sliderParam.minValue,
					sliderParam.maxValue,
					sliderParam.stepSize))

			outputFile.write("""
		}}
		ListModel
		{{
			id: button_model_{0}_{1}
				""".format(tabIndex, sectionIndex))
				
			for buttonIter in sectionIter.buttonList:
				outputFile.write("""
			ListElement
			{{
				name: "{0}"
				path: "{1}"
				onValue: {2}
				offValue: {3}
				isCheckable: {4}
			}}
					""".format(
					buttonIter.name,
					buttonIter.path,
					buttonIter.onValue,
					buttonIter.offValue,
					(str(buttonIter.checkable).lower())))
					
			outputFile.write("""
		}""")
					

		outputFile.write("""
		Rectangle
		{{
			anchors.horizontalCenter: parent.horizontalCenter
			width: 1
			height: 10
			color: "transparent"
		}}
		Row
		{{
			anchors.horizontalCenter: parent.horizontalCenter
			spacing: 15
			Button
			{{
				width: 0.33*rootItem.width
				text: "Larger Text"
				style: ButtonStyle
				{{
					background: Rectangle
					{{
						implicitWidth: 100
						implicitHeight: 25
						border.width: control.pressed ? 2 : 1
						border.color: control.pressed ? "#FFDDDDDD" : "#FF888888"
						color: control.hovered ? "#22DDDDDD" : "transparent"
						radius: 4
					}}
					label: Label
					{{
						text: control.text
						color: "white"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						width: control.width
						height: control.height
						font.pointSize: rootItem.textScale*11
					}}
				}}
				onClicked:
				{{
					rootItem.textScale = rootItem.textScale*1.1;
				}}
			}}
			Button
			{{
				width: 0.33*rootItem.width
				text: "Smaller Text"
				style: ButtonStyle
				{{
					background: Rectangle
					{{
						implicitWidth: 100
						implicitHeight: 25
						border.width: control.pressed ? 2 : 1
						border.color: control.pressed ? "#FFDDDDDD" : "#FF888888"
						color: control.hovered ? "#22DDDDDD" : "transparent"
						radius: 4
					}}
					label: Label
					{{
						text: control.text
						color: "white"
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						width: control.width
						height: control.height
						font.pointSize: rootItem.textScale*7
					}}
				}}
				onClicked:
				{{
					rootItem.textScale = rootItem.textScale/1.1;
				}}
			}}
		}}
		Button
		{{
			anchors.horizontalCenter: parent.horizontalCenter
			width: 0.66*rootItem.width
			text: "Reset Sliders"
			style: ButtonStyle
			{{
				background: Rectangle
				{{
					implicitWidth: 100
					implicitHeight: 25
					border.width: control.pressed ? 2 : 1
					border.color: control.pressed ? "#FFDDDDDD" : "#FF888888"
					color: control.hovered ? "#22DDDDDD" : "transparent"
					radius: 4
				}}
				label: Label
				{{
					text: control.text
					color: "white"
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					width: control.width
					height: control.height
					font.pointSize: rootItem.textScale*9
				}}
			}}
			onClicked:
			{{
			""".format(tabIter.name))
				
		for sectionIndex, sectionIter in enumerate(tabIter.sectionList):
			outputFile.write("""
				dgv_{0}_{1}.resetAllSliders()""".format(
				tabIndex, sectionIndex))
		outputFile.write("""
			}
		}""")
		for sectionIndex, sectionIter in enumerate(tabIter.sectionList):
			outputFile.write("""
		DoubleGridView
		{{
			id: dgv_{0}_{1}
			width: rootItem.width
			sliderModel: slider_model_{0}_{1}
			buttonModel: button_model_{0}_{1}
			headerText: "{2}"
			sliderWidth: {3}
			nameWidth: {4}
			valueWidth: {5}
			textScale: rootItem.textScale
		}}""".format(tabIndex,
					sectionIndex,
					sectionIter.name,
					sectionIter.sliderColumnWidth,
					sectionIter.nameColumnWidth,
					sectionIter.valueTextColumnWidth))
		
		outputFile.write("""
	}
}""")

if (args.scenefiles):
	writeDoubleGridViewQMLFile()
	writeBrainChildControlsQMLFile(tabsList)


