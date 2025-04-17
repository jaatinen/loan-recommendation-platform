from fastapi import FastAPI
from pydantic import BaseModel
from .model_loader import load_model
import numpy as np

app = FastAPI()
model = load_model()

# 🔹 Tämä määrittelee mitä JSON:ista odotetaan
class InputData(BaseModel):
    income: float
    current_loan: float

# 🔹 Tämä vastaanottaa InputData-tyyppisen POST-pyynnön
@app.post("/predict")
def predict(data: InputData):
    input_data = np.array([[data.income, data.current_loan]])
    prediction = model.predict(input_data)
    return {"recommendation": str(prediction[0])}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("api.main:app", host="0.0.0.0", port=8000)
