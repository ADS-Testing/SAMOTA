# Replication of "SAMOTA"

Modified version of the [original replication package](https://doi.org/10.6084/m9.figshare.16468530) to support the followings:
- Ubuntu 20.04 LTS


## Requirements
### Hardware
* NVIDIA GPU (>= 1080, RTX 2070+ is recommended)
* 16+ GB Memory
* 150+ GB Storage (SSD is recommended)

### Software
* Ubuntu 20.04 LTS
* python 3.8
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

```bash
./setup_carla.sh
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

### Set Results/ directory
```bash
mkdir {PATH_OF_REPOSITORY}/SAMOTA/implementation/runner/Results
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

### For the details about the scenario inputs and fitness score, please refer to the [supporting matarial](/supporting-material/supporting_material.md).


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
