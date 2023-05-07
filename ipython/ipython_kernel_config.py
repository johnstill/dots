# Configuration file for ipython-kernel.  Place it here:
#       ~/.ipython/profile_default/ipython_kernel_config.py
c = get_config()

# This will stop ipython, when run as a kernel by jupyter notebook, from trying
# to keep a history, which constantly fails when our home dir is over NFS
c.HistoryManager.enabled = False
