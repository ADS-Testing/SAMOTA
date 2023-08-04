# SAMOTA replication docs
Based on [original readme](/README.md)
## Requirements
### Hardware
* NVIDIA GPU (>= 1080, RTX 2070+ is recommended)
* 16+ GB Memory
* 150+ GB Storage (SSD is recommended)

### Software
* Ubuntu 18.04
* python 3.6+
* nvidia-docker2 (see [pylot](https://github.com/erdos-project/pylot/tree/master/scripts) for more details)
* docker

## Directory Structure
- `implementation`: source code of search algorithms (SAMOTA and its alternatives), Pylot and automated evaluation scripts
- `data-analysis`: scripts to automatically process evaluation results data to generate figures
- `supporting-material`: supporting materials for safety requirements, constraints and possible values of test input attributes

## Setup
### Install Python Libraries
Initialize pipenv and install the required packages:
```shell script
pipenv install
```
### Setup docker Pylot
Use the scripts from original website (https://github.com/erdos-project/pylot) or following the commands below

```bash
docker pull erdosproject/pylot:v0.3.2
nvidia-docker run -itd --name pylot -p 20022:22 erdosproject/pylot:v0.3.2 /bin/bash
```
Create ssh-keys using following command and press enter twice when prompted
```bash
ssh-keygen
```

Setup keys with Pylot by using the following commands
```bash
nvidia-docker cp ~/.ssh/id_rsa.pub pylot:/home/erdos/.ssh/authorized_keys
nvidia-docker exec -i -t pylot sudo chown erdos /home/erdos/.ssh/authorized_keys
nvidia-docker exec -i -t pylot sudo service ssh start
```
### Setup CARLA
*Download* the simulators from the following command and *extract* them to a folder name `Carla_Versions` (due to the figshare upload limit, the compressed file is divided into three)
```shell-script
    wget https://figshare.com/ndownloader/files/30458664
    wget https://figshare.com/ndownloader/files/30458646
    wget https://figshare.com/ndownloader/files/30457506
```
```shell-script
    unzip 30458664
    unzip 30458646
    unzip 30457506
```

### Integrate CARLA and Pylot
Run the following commands to setup Pylot with our changes
```bash
docker cp Carla_Versions pylot:/home/erdos/workspace/
ssh -p 20022 -X erdos@localhost
cd /home/erdos/workspace
mkdir results
cd pylot
rm -d -rf pylot
rm -d -rf scripts
```
```bash
logout
docker cp implementation/pylot pylot:/home/erdos/workspace/pylot/
docker cp implementation/scripts pylot:/home/erdos/workspace/pylot/
```
Note: in case error while running the simulator, log in to docker and change the permissions of scripts by using following commands
```bash
ssh -p 20022 -X erdos@localhost
cd /home/erdos/workspace/pylot/scripts
chmod +x run_simulator.sh
chmod +x run_simulator_without_b.sh
chmod +x run_simulator_without_t.sh
chmod +x run_simulator_without_t_b.sh
```

## How to run 
run the search algorithm using the following code
```bash
cd implementation/runner
python3 run_{search_algorithm}.py
```
Note: Ignore `No such container:path: pylot:/home/erdos/workspace/results/finished.txt`.

log files will be generated in output folder

