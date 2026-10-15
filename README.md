# dots

Current micromamba install (use default paths, no shell init):
`"${SHELL}" <(curl -L micro.mamba.pm/install.sh)`

After install, may want to run:
```
micromamba shell init --shell zsh --root-prefix=~/.local/share/mamba
micromamba create --name tools python pip wheel setuptools
echo 'micromamba activate tools' >> ~/.zshrc
```
This will ensure a default tools environment is created and loaded on login.
```
which pip
pip install -r requirements.txt
pip install -r torch_requirements.txt
# etc
```
