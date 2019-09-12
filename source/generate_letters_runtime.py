from bl_runtime_generator import RuntimeGenerator
from pathlib import Path

runtime_generator = RuntimeGenerator()
runtime_generator.generate_runtime(Path("./model_template"),
                                   Path("./cblock_tests/letters/runtime_data/scene/cblock"),
                                   Path("./cblock_tests/letters/cblock_letters_config.json"))
