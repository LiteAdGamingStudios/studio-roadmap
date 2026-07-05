# STEP 1: Install WSL (Run this in PowerShell, not Ubuntu)
wsl --install

# Then go to Microsoft Store, search "Ubuntu 20.04" or "Ubuntu 22.04", and install it.
# Launch Ubuntu from the Start menu.
# Set your username and password when prompted.

# ----- FROM HERE ON, RUN ALL COMMANDS INSIDE THE UBUNTU TERMINAL -----

# STEP 2: Update Ubuntu
sudo apt update && sudo apt upgrade -y

# STEP 3: Install Python and pip
sudo apt install python3 python3-pip -y

# STEP 4: Install venv for creating virtual environments
sudo apt install python3-venv -y

# STEP 5: Create and activate a virtual environment
python3 -m venv kivy-env
source kivy-env/bin/activate

# STEP 6: Install dependencies required by Kivy
sudo apt install \
    libgl1-mesa-dev \
    libgles2-mesa-dev \
    zlib1g-dev \
    libgstreamer1.0-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    libmtdev-dev \
    python3-setuptools \
    -y

# STEP 7: Install Kivy in your virtual environment
pip install "kivy[base]" --extra-index-url https://kivy.org/downloads/simple/

# OPTIONAL: If you want media/audio features too
# pip install "kivy[full]" --extra-index-url https://kivy.org/downloads/simple/

# STEP 8: Set up GUI support for WSL

# ▶️ If you're using Windows 11, GUI works out of the box (WSLg support)

# ▶️ If you're using Windows 10:
# - Download and install VcXsrv (https://sourceforge.net/projects/vcxsrv/)
# - Then run this in Ubuntu to connect GUI to Windows display:
export DISPLAY=:0

# (Optional) Add this line to ~/.bashrc so it works every time:
echo 'export DISPLAY=:0' >> ~/.bashrc
source ~/.bashrc

#Step 9: Install cython in your virtual environment
sudo pip install cython

#step 10: provide permissions
sudo /home/riyas/kivy-env/bin/python3 -m pip install appdirs colorama jinja2 sh build toml packaging setuptools

Step 11: Additional permissions
# cd /home/riyas
sudo chown -R $USER:$USER /home/riyas/kivy-env/
pip install wheel


Step 12: Reinstall dependencies
pip install kivy buildozer cython pyjnius

step13 For unzip (system-wide utility):
Install it globally on your system (in WSL, not just the virtual environment) so Buildozer can use it during the build process:
sudo apt update
sudo apt install unzip


Step 14 Run this to list all files in the SDK directory:
ls ~/.buildozer/android/platform/android-sdk
We're looking for:

A .zip file like commandlinetools-linux-*.zip

A folder named something like cmdline-tools, tools, or cmdline-tools-linux



step15 Unzip the SDK tools:(name provided in step 14)
cd ~/.buildozer/android/platform/android-sdk
unzip commandlinetools-linux-6514223_latest.zip


step 16 
Depending on what you get after unzipping (you can check using ls), run the correct rename commands. For example, if it creates a folder called tools, do:
mkdir -p cmdline-tools
mv tools cmdline-tools/latest
If it creates cmdline-tools, then do:
mkdir -p cmdline-tools
mv cmdline-tools cmdline-tools/latest


Step 17 
Fix the sdk manager link
mkdir -p ~/.buildozer/android/platform/android-sdk/tools/bin
ln -s ~/.buildozer/android/platform/android-sdk/cmdline-tools/latest/bin/sdkmanager ~/.buildozer/android/platform/android-sdk/tools/bin/sdkmanager

Step 18 You just need to install the zip utility. Run this command inside your WSL terminal:
sudo apt update && sudo apt install zip -y


step 19 run this in your project folder
cd .buildozer/android/platform
rm -rf build-* dists/
cd ../../..
