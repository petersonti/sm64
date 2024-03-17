#BUILD Render96ex to Raspberry
#Tested in Raspberry Pi 5

#dependencies
sudo apt -y install build-essential libglew-dev libsdl2-dev wget p7zip

#git
cd $HOME
git clone --single-branch --branch alpha https://github.com/Render96/Render96ex.git
git clone https://github.com/petersonti/sm64.git Render96ex/temp/sm64
git clone https://github.com/pokeheadroom/RENDER96-HD-TEXTURE-PACK.git -b master Render96ex/temp/hd-textures

#Obtain the latest release of the model pack. It can be found under https://github.com/Render96/ModelPack/releases (Render96_DynOs_v3.2.7z)
wget https://github.com/Render96/ModelPack/releases/download/3.2/Render96_DynOs_v3.2.7z -P Render96ex/temp/

#copy files
cd Render96ex/
cp temp/sm64/baserom.us.z64 .


#build
make RENDER_API=GL BETTERCAMERA=1 NODRAWINGDISTANCE=1 TEXTURE_FIX=1 EXTERNAL_DATA=1 RENDER_API=GL EXT_OPTIONS_MENU=1 -j4


#copy hd-texture and DynOs
echo ''
echo Copy HD-Textures
cp -r temp/hd-textures/gfx build/us_pc/res
echo Extract DynOs
7z x temp/Render96_DynOs_v3.2.7z -o./build/us_pc/dynos/packs/

#delete folder to fix
rm -r ./build/us_pc/res/gfx/textures/skyboxes
rm ./build/us_pc/res/gfx/textures/outside/castle_grounds_textures.01000.rgba16.png

#Copy folder

echo Copy build to executable
sudo cp -r ./build/us_pc /opt/render96ex

#create shortcut
echo '[Desktop Entry]
Version=3.2
Name=Super Mario 64 Render 96
GenericName=Super Mario 64 Render 96
Comment=Native Open Source Port of Super Mario 64 including Render 96 Mods
Exec=render96ex
Icon=render96ex
Terminal=false
Type=Application
Categories=Game;Retro;Emulator;' | sudo tee -a /usr/local/share/applications/render96ex.desktop

#cretate executable
echo '#!/usr/bin/env bash

cd /opt/render96ex || exit
./sm64.us.f3dex2e' | sudo tee -a /usr/local/bin/render96ex

sudo chmod +x /usr/local/bin/render96ex

#copy icon
sudo cp temp/sm64/render96ex.png /usr/share/icons/hicolor/256x256/apps/
sudo update-icon-caches /usr/share/icons/*

#create save120star
mkdir -p $HOME/.local/share/sm64ex

echo '# Super Mario 64 save file
# Comment starts with #
# True = 1, False = 0
# 2024-03-17 02:42:27

[menu]
coin_score_age = 0
sound_mode = stereo

[flags]
wing_cap = 1
metal_cap = 1
vanish_cap = 1
key_1 = 1
key_2 = 1
basement_door = 1
upstairs_door = 1
ddd_moved_back = 1
moat_drained = 1
pps_door = 1
wf_door = 1
ccm_door = 1
jrb_door = 1
bitdw_door = 1
bitfs_door = 1
50star_door = 1

[courses]
bob = "2, 1111111, 1"
wf = "150, 1111111, 0"
jrb = "150, 1111111, 0"
ccm = "150, 1111111, 0"
bbh = "150, 1111111, 0"
hmc = "150, 1111111, 0"
lll = "150, 1111111, 0"
ssl = "150, 1111111, 0"
ddd = "150, 1111111, 0"
sl = "150, 1111111, 0"
wdw = "150, 1111111, 0"
ttm = "150, 1111111, 0"
thi = "150, 1111111, 0"
ttc = "150, 1111111, 0"
rr = "150, 1111111, 0"

[bonus]
bitdw = 1
bitfs = 1
bits = 1
pss = 11
cotmc = 1
totwc = 1
vcutm = 1
wmotr = 1
sa = 1
hub = 11111

[cap]

[sgi]
keys = "1111111111"
character = "0"
coins = "000000"' > $HOME/.local/share/sm64ex/render96_save_file_0.sav
