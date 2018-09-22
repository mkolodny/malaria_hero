FROM continuumio/miniconda3:latest

EXPOSE 5000

#Install extra packages if required
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Add the user that will run the app (no need to run as root)
#RUN groupadd -r myuser && useradd -r -g myuser myuser

#Setting the working directory to /insight
WORKDIR /insight

#Copy the requirements for setting up the evironment
ADD $INSIGHT/requirements_conda.txt /insight/
ADD $INSIGHT/requirements_pip.txt /insight/

#Installing python3.5.4 and required libraries
RUN conda update conda
RUN conda config --add channels conda-forge
RUN conda config --append channels menpo
RUN conda config --append channels defaults
RUN conda install --yes --file requirements_conda.txt
#RUN conda install python=3.5.4
#RUN while read requirement; do conda install --yes $requirement; done < requirements_conda.txt
#RUN rm -rf /opt/conda/pkgs/

#Install the libraries using pip install
#Creating the environemnt with conda env did not work in docker
RUN pip install -r requirements_pip.txt

#Copy the $INSIGHT contents into the container at /insight
ADD $INSIGHT /insight/

# Install myapp
#RUN chown -R atico:atico /insight/*

ENV NAME insight

WORKDIR /insight/src/

CMD python flask_app.py
