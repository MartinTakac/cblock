# CBlock

Cblock is the current solution for sequencing and planning at Soul Machines.
The model is expected to exist in multiple locations in the avatar, so it makes use of the BL Runtime Generator Python package.
This project also includes the C++ tests for the model and the corresponding BLRG configurations for those tests.
Tests render the template every time they are run, so any changes to the template will be immediately reflected in the tests.
For information on the Docker-based testing infrastructure, please [see here](https://soulmachines.atlassian.net/wiki/spaces/COGARCH/pages/310542359/BL+Model+Testing).

The cblock model was developed before we solidified our templating system so there are a few concessions we had to make.
The cblock model template itself is located in `source/model_template`.
This template has been updated to use the [BL Runtime Generator package](https://soulmachines.atlassian.net/wiki/spaces/COGARCH/pages/365723734/BL+Runtime+Generator).
It has also been updated to include model parameters in the configuration.
Since BLRG supports nested config variables, it is able to neatly separate them into a hierarchy.
You can see a sample config in `source/misc/cblock_sample_config.json`.

Note that this no longer matches Martin's cblock documentation, which originally asked the user to write a connector external to the model to set the parameters.
There's nothing wrong with that approach, but the goal of BLRG is to declaratively define an entire working model, so including the parameters in the configuration file fits a bit better.

Another change we had to make in order to fit the newer templating approach is to only include the model itself in the template directory.
With this approach, you can (hopefully) render the template directly into an existing BL model and only have to write the input connectors.
Unfortunately this means the displays and debug displays are not actually part of the template and must be manually added and connected.
I don't know if that is a big problem or not.
If it is let me know and we can update the template to include the displays, but I'm under the impression that they aren't necessary in the mother avatar.
Regardless, the displays and their connectors are in `source/misc/display_code`.

Any other useful bits of BL code that are required by cblock but are external to the model itself can be taken from the test folders directly.
These folders, e.g. `source/cblock_tests/letters/runtime_data/scene`, contain the scaffolding required to feed cblock with test data.
(They also include the displays in case the ones in `misc` are messed up).
The tests themselves render the template into the `runtime_data/scene/cblock` folder (erasing it each time it's run), everything else remains static and, hopefully, are specific to the tests being run.
Again, if my assumptions are wrong let me know and I can tweak the template to include the code that the cblock needs to operate.

There are two sets of displays, `displays` and `debug_displays`.

- To use any of these displays, you need to copy `displayConstants.blm` and `visibility.blc`. Default visibility of all these displays is controlled by the constant `displayConstants/is_visible`.
- to use (blue-brown) fancy displays, copy the folder `displays` and the connector `display_cblock.blc`
- to use (white-yellow-grey) debug displays, copy the folder `debug_displays` and the connector `debug_display.blc`. Debug displays are a bit more detailed, show the buffer and oscillator window for cooperation related timers.

