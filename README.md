# Replication of "(ICSE 22) Efficient Online Testing for DNN-based Systems using Surrogate-Assisted and Many-Objective Optimization"

Modified version of the [original replication package](https://doi.org/10.6084/m9.figshare.16468530) to support the followings:
- Ubuntu 20.04 LTS


## Requirements
### Hardware
* NVIDIA GPU (>= 1080, RTX 2070+ is recommended) (with [nvidia-driver installed](https://help.ubuntu.com/community/NvidiaDriversInstallation))
* 16+ GB Memory
* 250+ GB Storage (SSD is recommended)

### Software
* Ubuntu 20.04 LTS
* python 3.8
* nvidia-docker2 (see [pylot's script](https://github.com/erdos-project/pylot/blob/master/scripts/install-nvidia-docker.sh) for more details)

## Directory Structure
- `implementation`: source code of search algorithms (SAMOTA and its alternatives), Pylot and automated evaluation scripts
- `data-analysis`: scripts to automatically process evaluation results data to generate figures
- `supporting-material`: supporting materials for safety requirements, constraints and possible values of test input attributes

## Setup
### Install Python Libraries

(Option 1: venv) Initialise venv and install the required packages:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

(Option 2: pipenv) Initialise pipenv and install the required packages:
```shell script
pipenv install
```

(Option 3: conda) Initialise a conda environment and install the required packages (Useful if multiple python versions are locally installed):
```shell script
conda create -n samota python=3.8
conda activate samota
pip install -r requirements.txt
```

### Download & Setup Pylot (docker; 30-50 mins)
(Recommandation: Run the next step, i.e., Download CARLA, whlie you are doing the pylot setup below because downloading CALRA is time-consuming)

Check the docker:
```bash
docker images
```

If there is no docker, use the [script from Pylot](https://github.com/erdos-project/pylot/blob/master/scripts/install-nvidia-docker.sh) to install it.

If docker gives you a permission error, follow below (otherwise skip):
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Download the pylot docker image:

```bash
docker pull erdosproject/pylot:v0.3.2
nvidia-docker run -itd --name pylot -p 20022:22 erdosproject/pylot:v0.3.2 /bin/bash
```

Create ssh-keys using following command and press enter twice when prompted
```bash
ssh-keygen
```

Setup ssh using the keys
```bash
nvidia-docker cp ~/.ssh/id_rsa.pub pylot:/home/erdos/.ssh/authorized_keys
nvidia-docker exec -i -t pylot sudo chown erdos /home/erdos/.ssh/authorized_keys
nvidia-docker exec -i -t pylot sudo service ssh start
```

### Download CARLA (20-40 mins)
*Download* the simulators from the following command and *extract* them to a folder name `Carla_Versions` (due to the figshare upload limit, the compressed file is divided into three)

```bash
./setup_carla.sh
```

### Integrate CARLA and Pylot

Move the customised CARLA into the Pylot container
```bash
docker cp Carla_Versions pylot:/home/erdos/workspace/
rm -rf Carla_Versions # optional, to save some storage space
```

Move customised pylot scripts into the Pylot container
```bash
ssh -p 20022 -X erdos@localhost  # answer 'yes'

# now you should be inside the container
cd /home/erdos/workspace
mkdir results  # check, Results?
cd pylot
rm -rf pylot scripts
logout

# outside the container
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

### Create an empty directory for saving results
```bash
mkdir {PATH_TO_THIS_REPO}/SAMOTA/implementation/runner/Results
mkdir {PATH_TO_THIS_REPO}/SAMOTA/implementation/runner/output
mkdir {PATH_TO_THIS_REPO}/SAMOTA/implementation/runner/output/temp
```
- According to [`run_single_scenario` function](/implementation/runner/runner.py), this will allow program to save the fitness scores.

## How to run 
run the search algorithm using the following code
```bash
cd implementation/runner
python3 run_{search_algorithm}.py
```
Note: Ignore `No such container:path: pylot:/home/erdos/workspace/results/finished.txt`.

- Minimun fitness score during the simulation will be saved in `/implementation/runner/output/temp` and trajectory information will be saved in `/implementation/runner/Results`.
- For the details about the scenario inputs and fitness score, please refer to the [supporting matarial](/supporting-material/supporting_material.md).

### (Tip) How to start/stop docker an existing container

If the `pylot` container is not properly stopped during the execution of search algorithms due to unexpected errors (or keyboard inturruptions), you can use the following docker commands to start|stop the existing container: 
```bash
nvidia-docker start|stop pylot
```

If needed, you can check the status of the container(s):
```bash
nvidia-docker ps --all
```


## Troubleshooting wiki links
 - [All of the fitness score values are displayed as 1000](https://github.com/ADS-Testing/Main/wiki/%5BSAMOTA%5D-All-of-the-fitness-score-values-are-displayed-as-1000)
 - [Prediction module was not included in the git repository](https://github.com/ADS-Testing/Main/wiki/%5BSAMOTA%5D-Prediction-module-was-not-included-in-the-git-repository)


 ## Authors
 ### Original source
 ```text
 @inproceedings{haq2022efficient,
  title={Efficient online testing for DNN-enabled systems using surrogate-assisted and many-objective optimization},
  author={Haq, Fitash Ul and Shin, Donghwan and Briand, Lionel},
  booktitle={Proceedings of the 44th international conference on software engineering},
  pages={811--822},
  year={2022}
}
 ```

### TODO
- Visualize the scenarios
- Description about program structure

 ### Replicated and modified by
- [Kyungwook Nam](https://github.com/nkwook)
- [Taehyun Ahn](https://dev.paxtaeo.com/en)
- Advised by [Donghwan Shin](https://www.dshin.info/)

## License
[MIT License](/LICENSE.txt)
