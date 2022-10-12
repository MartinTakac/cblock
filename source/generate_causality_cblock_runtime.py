from bl_runtime_generator import RuntimeGenerator
from pathlib import Path

runtime_generator = RuntimeGenerator()
#runtime_generator.generate_runtime(Path("./model_template_2"),
#                                   Path("./runtime_data/scene/cblock"),
#                                   Path("./cblock_letters_config.json"))
runtime_generator.generate_runtime(Path("./model_template"),
                                   Path("../../cblock_generated/cblock"),
                                   Path("./cblock_causality_config.json"))
