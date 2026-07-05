1.Install Dependencies: You'll need some essential packages before you can use Buildozer. From your virtual environment, run:

sudo apt update
sudo apt install -y python3-pip python3-setuptools python3-dev build-essential ccache git libncurses5 libstdc++6 libssl-dev libffi-dev libsqlite3-dev libbz2-dev libreadline-dev zlib1g-dev

2. Install Buildozer: After the dependencies are set, install Buildozer in your virtual environment:

pip install buildozer


3. Install Android SDK/NDK (for Android app building):

Buildozer will automatically download and set up the Android SDK/NDK when you first build your app, but you need to have Java and CMake installed as well.

Install Java Development Kit (JDK) via:

sudo apt install openjdk-8-jdk


4. Initialize Buildozer: In your project directory (where main.py (pythong project)is located), run:



5. The buildozer.spec file contains settings like the app name, version, permis5. sions, and dependencies. Open the buildozer.spec file and modify it according to your app's requirements.

Set app name and version: Open the buildozer.spec file and find these lines:

# (name of your application)
title = Lottery Predictor
# (package name for your application)
package.name = lottery_predictor
# (your application version)
version = 1.0


6. Add required dependencies: If your app requires extra libraries, such as numpy or pandas, add them to the requirements section:

requirements = kivy,numpy,pandas

7.Add permissions (if required): If your app needs special permissions (like internet access or accessing storage), you can specify them in the buildozer.spec file:

android.permissions = INTERNET, ACCESS_FINE_LOCATION
