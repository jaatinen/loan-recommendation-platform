import joblib
import os

def load_model():
    # Define the relative path to the model
    model_path = os.path.join(os.path.dirname(__file__), "..", "model", "model.pkl")
    model_path = os.path.abspath(model_path)

    try:
        model = joblib.load(model_path)
        print(f"✅ Model loaded successfully from: {model_path}")
        return model
    except Exception as e:
        print(f"❌ Failed to load model from: {model_path}")
        raise e