## DeepSeek-OCR
## https://github.com/deepseek-ai/DeepSeek-OCR
## git clone --depth=1 https://github.com/deepseek-ai/DeepSeek-OCR
## cd DeepSeek-OCR
## uv python install 3.12.9
## uv venv --python 3.12.9
## .venv\Scripts\activate
## uv pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124
## uv pip install -r requirements.txt
## uv pip install wheel psutil
## uv pip install flash-attn==2.7.3 --no-build-isolation
## uv pip install hf_transfer
## set HF_HUB_ENABLE_HF_TRANSFER=0

# Authors: DeepSeek🧙‍♂️, scillidan🤡
# Usage: python file.py <input_image> [<output_path>]

import sys
from transformers import AutoModel, AutoTokenizer
import torch
import os

output_path = "./output"

model_name = 'deepseek-ai/DeepSeek-OCR'

image_file = sys.argv[1]
output_dir = sys.argv[2] if len(sys.argv) > 2 else output_path

os.makedirs(output_dir, exist_ok=True)

tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
model = AutoModel.from_pretrained(model_name, trust_remote_code=True, torch_dtype=torch.bfloat16)
model = model.eval().cuda()

prompt = "<image>\n<|grounding|>Convert the document to markdown."
res = model.infer(
    tokenizer,
    prompt=prompt,
    image_file=image_file,
    output_path=output_dir,
    base_size=1024,
    image_size=640,
    crop_mode=True,
    save_results=True,
    test_compress=True
)

print(f"OCR Result:\n{res}")