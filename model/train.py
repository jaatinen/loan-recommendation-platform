from sklearn.linear_model import LogisticRegression
import joblib
import numpy as np

# Example training data:
# Features: [income, current_loan]
X = np.array([
    [3000, 10000],
    [4000, 5000],
    [2500, 12000],
    [5000, 3000]
])

# Labels: what should be recommended based on income and current loan
y = [
    "savings_recommendation",
    "loan_offer",
    "savings_recommendation",
    "loan_offer"
]

# Train the model
model = LogisticRegression()
model.fit(X, y)

# Save the trained model to a file
joblib.dump(model, "model.pkl")

print("✅ Model trained and saved to model.pkl")