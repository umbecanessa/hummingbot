# Start from a base image with Miniconda installed
FROM continuumio/miniconda3

# Install system dependencies
RUN apt-get update && \
    apt-get install -y sudo libusb-1.0 python3-dev gcc g++ make && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /quants-lab

# Copy the Conda environment file
COPY environment.yml .

# Create the Conda environment without running pip
RUN conda env create -f environment.yml || conda env update -f environment.yml

# Activate the environment
SHELL ["conda", "run", "-n", "quants-lab", "/bin/bash", "-c"]

# Copy the project files
COPY core/ core/
COPY research_notebooks/ research_notebooks/
COPY controllers/ controllers/
COPY tasks/ tasks/
COPY config/tasks.yml /quants-lab/config/tasks.yml

# Install problematic pip dependencies separately
RUN pip install --no-cache-dir hummingbot

# Default command to run the application
CMD ["conda", "run", "--no-capture-output", "-n", "quants-lab", "python3", "run_tasks.py"]
