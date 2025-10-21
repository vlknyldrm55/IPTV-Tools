#!/bin/bash
echo "=== IPTV TOOLS KURULUM SİSTEMİ ==="

# Gerekli paketler
pkg update -y
pkg install -y curl wget grep sed awk findutils

# Script'leri kopyala
mkdir -p ~/iptv-tools
cp scripts/*.sh ~/iptv-tools/

# Çalıştırma izinleri
chmod +x ~/iptv-tools/*.sh

# SDCard klasörleri
mkdir -p /sdcard/IPTV_Listeleri
mkdir -p /sdcard/combo
mkdir -p /sdcard/iptv_sonuclar

# PATH ekleme
echo 'export PATH="$PATH:~/iptv-tools"' >> ~/.bashrc

echo "✅ KURULUM TAMAMLANDI!"
echo "Kullanım: ~/iptv-tools/real_combo_scanner.sh"
