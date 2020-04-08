# FastAPI Docker



## Installation

To install you must have Docker installed

With docker installed run the following commands from the command line:

```bash
# can change the name to whatever you want
$ docker build -t fast-api .

# First -p is for port binding - binds the local port to the container port.
# Container port must be 8000, but the local port can be whatever.
$ docker run -p 8000:8000 fast-api
```



------



## Create a Python Docker Container with a Virtual Environment

To create a python app that runs anywhere there is the need to create a Docker container, which contains all of the dependencies needed to run the application. To do this we will create a Docker container that contains a virtual environment, a requirements file and a Dockerfile that calls the pip installs.


#### How this was created

1. First create a new directory, which will contain the python environment.

2. cd to the new directory and create a directory inside that called `app`

3. Create a file called `Dockerfile` (with no extension)

4. In a new terminal (pointing to this directory) enter the following commands

   ```bash
   # Create a new virtual environment inside the new directory
   $ python -m venv env
   
   # (Linux/OS X) Activate the new environment
   $ source env/bin/activate
   
   # (WINDOWS) Activate the new environment
   $ env/Scripts/activate
   ```

5. Install any dependencies into the virtual environment using `pip install <dependecy_name>` 

6. Create a requirements.txt file by entering the following command

   ```bash
   $ pip freeze > requirements.txt
   ```

7. Create a `.dockerignore` file 

8. Add the following directories to the ignore file (you can add more if required)

   ```
   env/
   __pycache__/
   ```

9. The next step is to populate the Dockerfile

   ```dockerfile
   # Use latest version of Pythong for specific version use python:<tag_of_version>
   FROM python:latest 
   
   # Set the working directory to /app
   WORKDIR /app
   
   # Copy the current directory contents into the container at /app
   ADD . /app
   
   # Install the dependencies
   RUN pip install -r requirements.txt
   
   # Run the commands to start the application (in this case we are using FastAPI, 
   # which uses Uvicorn). Since the code for the app is contained in the app directory
   # this namespace needs to be added to the module arg.
   # NOTE: multiple args can be added (as seen below)
   # NOTE2: THIS WILL NOT WORK FOR UVICORN - See Below
   CMD ["uvicorn", "app.main:app", "--reload"]
   ```
   

With these steps complete you will now have an environment ready to build in - **Unless you are serving a web service and in this instance we are**. 



----



### Serving a web service

If serving a web service from inside docker container there is a further consideration.  The following example was discovered when creating the FastAPI application. In the `__main__` declaration the python code looks like this:

```python
if __name__ == '__main__':
    uvicorn.run(app,host="127.0.0.1",port="8000")
```

This will work if running the code from the command line. However, when running the web service from inside a container the external localhost cannot access the internal localhost even with exposed ports. 

**Solution**

You must change all internal IP declarations to `0.0.0.0` as seen below:

```python
if __name__ == '__main__':
    uvicorn.run(app,host="0.0.0.0",port="8000")
```

In this way when localhost:8000 on the Docker client machine, this will successfully point to our web service on the container.

