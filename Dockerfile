FROM continuumio/miniconda3

# Install system dependencies
RUN apt-get update && \
    apt-get install -y sudo libusb-1.0 python3-dev gcc g++ make && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /quants-lab

# Copy the Conda environment file
COPY environment.lock.yml .

# Create Conda environment at build time
RUN conda env create -f environment.lock.yml

# Set Conda as default shell
SHELL ["conda", "run", "-n", "quants-lab", "/bin/bash", "-c"]

# Copy project files
COPY core/ core/
COPY research_notebooks/ research_notebooks/
COPY controllers/ controllers/
COPY tasks/ tasks/
COPY config/tasks.yml /quants-lab/config/tasks.yml

# Default command
CMD ["conda", "run", "--no-capture-output", "-n", "quants-lab", "python3", "run_tasks.py"]
