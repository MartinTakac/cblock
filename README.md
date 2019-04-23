# cblock

A git project to keep upto date with Martin cblock. Cblock is a current Soul Machine's solution for sequencing and planning. Because of that, there will probably be multiple copies of cblock of different sizes in the avatar code, or in different runtimes. In order to minimise the risk of incosistencies, there will be one ultimate repo where the up-to-date cblock template will maintained - and it is here. All the development will be carried out on the template (with symbolic names), from which actual runtimes will be generated as needed by the runtime_generator.py resize python script.

## Folder structure
The cblock proper is embedded in cblock letters example (letters_template), which serves as its testbed and also for inspiration how to connect/use the cblock. For usage outside the letters example, you will need just the folder cblock. If you also want viewers, it comes with two sets of display shaders, one in the folder debug_displays, the other in displays. You can use both of them at the same time, or just one of them. 

- to use (blue-brown) fancy displays, copy (along with cblock) the folder displays and the connector display_cblock.blc. Default visibility of all these displays is controlled by the constant displayConstants/is_visible.
- to use (white-yellow-grey) debug displays, copy (along with cblock) the folder debug_displays and the connector debug_display.blc (debug displays are a bit more detailed, show the buffer and oscillator window for cooperation related timers).

## How to resize cblock

1. Change values of independent variables (see below) in cblock_config.json
2.  Run **python runtime_generator.py** with following arguments:
 **-r** [path\to\model_runtime_folder] **-c** [path\to\config_file.json]  **-o** [path\to\output_folder], e.g.
**python runtime_generator.py -r letters_template -c cblock_config.json -o output**

If the cblock takes input in the form of a vector/matrix/bitmap, set its dimensions in "#INPUT_BITMAP_DIM_X#","#INPUT_BITMAP_DIM_Y#". The bitmaps (or xy inputs) are internally individuated/converted to a sparse/localist representation by the individuation SOM of dimensions #INDIV_SOM_DIM_X#", #INDIV_SOM_DIM_Y#". Their product determines maximum number of elements that can be stored as tokens/individuals.
System state/result/goal is a vector/matrix of dimensions #STATE_DIM_X#", #STATE_DIM_Y#". 
The buffer can store maximum #BUF_DIM_X#" x #BUF_DIM_Y#" elements (represented as a matrix just for occupancy display) - this determines the maximum length of a chunk.
Sequencing SOM has dimensions "#SEQ_SOM_DIM_X#","#SEQ_SOM_DIM_Y#". Their product determines the maximum number of contextual transitions (combinations of tonic - context - recent - next - eos) that can be individually stored in the SOM.
Planning SOM has dimensions "#PLAN_SOM_DIM_X#","#PLAN_SOM_DIM_Y#". Their product determines the maximum number of plans that can be individually stored in the SOM.

