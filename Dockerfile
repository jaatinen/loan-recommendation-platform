# Use official Python 3.9 image as base
FROM python:3.9

# Set working directory inside the container
WORKDIR /app

# Copy API code and model file into the container
COPY api/ ./api/
COPY model/model.pkl ./model/model.pkl
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 80 for the API service
EXPOSE 80

# Start the FastAPI server using Uvicorn
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "80"]

CMD ["python", "-m", "api.main"]
