# Build Stage
# Use an official Python runtime as the base image for building
FROM python:3.11.4-slim AS builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY ./requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app/

# Final Stage
# Use the official Python runtime as the final base image
FROM python:3.11.4-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Copy only the built application code and dependencies from the previous stage
COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=builder /app /app

# Set the working directory in the container
WORKDIR /app

# Expose the port the application runs on
EXPOSE 8000

# Run the Django application using the built-in development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
