#!/bin/bash

# Путь к папке proc (можно изменить)
PROC_DIR="../proc"

# Имя файла для поиска
TARGET_FILE="memory_strings.txt"

# Имя выходного файла
OUTPUT_FILE="response.txt"

# Шаблоны для поиска
PATTERNS=("wg://*" "mtls://*" "https://*" "http://*" "dns://*" "tcppivot://*" "namedpipe://*")

# Очищаем выходной файл, если он существует
> "$OUTPUT_FILE"

# Перебираем все подпапки в proc
for dir in "$PROC_DIR"/*/; do
    # Проверяем наличие файла strings.txt
    if [[ -f "${dir}${TARGET_FILE}" ]]; then
        found=0
        matches=""
        
        # Ищем каждое из выражений в файле
        for pattern in "${PATTERNS[@]}"; do
            while IFS= read -r line; do
                if [[ "$line" == $pattern ]]; then
                    if [[ $found -eq 0 ]]; then
                        echo "${dir}${TARGET_FILE} найдено:" >> "$OUTPUT_FILE"
                        found=1
                    fi
                    echo "$line" >> "$OUTPUT_FILE"
                    matches+="$line"$'\n'
                fi
            done < "${dir}${TARGET_FILE}"
        done
        
        # Добавляем пустую строку между разными файлами, если были найдены совпадения
        if [[ $found -eq 1 ]]; then
            echo "" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "Поиск завершен. Результаты сохранены в $OUTPUT_FILE"
