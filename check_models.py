from dotenv import load_dotenv

load_dotenv()

import google.generativeai as genai


for model in genai.list_models():

    if "generateContent" in model.supported_generation_methods:

        print(model.name)