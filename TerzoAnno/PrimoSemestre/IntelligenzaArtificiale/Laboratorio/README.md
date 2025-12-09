# AI_Lab
Code for the lab of Artificial Intelligence course, Bachelor's degree in Computer Science, University of Verona
## Setup 

1. Download [Anaconda](https://docs.anaconda.com/free/miniconda/) for your System.

2. Install Anaconda and Git:
   - On **Linux/Mac**: 
     - `sh Anaconda{version}.sh` to install the Anaconda version chosen.
     - Could be necessary to update your *.bashrc* file writing this line: *export PATH=~/anaconda3/bin:$PATH* then save and close the *.bashrc* file.
     -  Open a terminal and digit: `source ~/.bashrc`
     - Install Git: `sudo apt-get install git` 

   - On **Windows**:
     - Double click the installer to launch.
     - *NB: during the installation, ensure to install "Anaconda Prompt" and use it for the other steps.*
     - Install Git: download [here](https://gitforwindows.org/)

3. Setup Conda environment:
   - `git clone https://github.com/isla-lab/AI_Lab`
   - `cd AI_Lab`
   - `conda env create -f tools/ai-lab-env.yml`


## Using the Jupyter Notebook

To start the environment and work on your assignments, navigate to the downloaded folder root *(AI_Lab)* and run:

```
conda activate ai-lab
jupyter notebook
```

The last command will open your browser for you to start working. To open the tutorial navigate with your browser to the dedicated notebook (*tutorial/tutorial.ipynb*).



## Authors

*  **Celeste Veronese**
*  **Luca Marzari (Tutor)**
*  **Alessandro Farinelli** - alessandro.farinelli@univr.it



## Acknowledgments

Environments are based on OpenAI Gym: https://github.com/openai/gym
