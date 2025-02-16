# Use Miniconda as the base image
FROM continuumio/miniconda3

# Set the working directory
WORKDIR /quants-lab

# Copy the pre-built Conda environment
COPY quants-lab.tar.gz /opt/

# Extract and activate it
RUN mkdir /opt/conda/envs/quants-lab && \
    tar -xzf /opt/quants-lab.tar.gz -C /opt/conda/envs/quants-lab --strip-components=1 && \
    rm /opt/quants-lab.tar.gz

# Set Conda path
ENV PATH="/opt/conda/envs/quants-lab/bin:$PATH"

# Copy project files
COPY core/ core/
COPY research_notebooks/ research_notebooks/
COPY controllers/ controllers/
COPY tasks/ tasks/
COPY config/tasks.yml /quants-lab/config/tasks.yml

# Default command
CMD ["python", "run_tasks.py"]
