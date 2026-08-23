#!/bin/bash

blue()   { printf '\033[1;34m'; }
yellow() { printf '\033[1;33m'; }
reset()  { printf '\033[0m'; }

prev_dir=""

interactive_select() {
    local selected=0
    local key=""
    local key2=""
    local key3=""
    local chosen=""
    local item=""
    local display=""
    local entries=()

    while true; do
        shopt -s nullglob
        entries=(*)
        shopt -u nullglob

        if (( ${#entries[@]} == 0 )); then
            selected=0
        elif (( selected >= ${#entries[@]} )); then
            selected=$((${#entries[@]} - 1))
        fi

        clear
        echo "====================exproler+============"

        yellow
        echo "вы в"
        pwd
        echo "--"
        reset

        if (( ${#entries[@]} == 0 )); then
            echo "(папка пустая)"
        else
            for i in "${!entries[@]}"; do
                item="${entries[$i]}"

                if [ -d "$item" ]; then
                    display="$item/"
                else
                    display="$item"
                fi

                if (( i == selected )); then
                    printf '\033[7m> %s\033[0m\n' "$display"
                else
                    printf '  %s\n' "$display"
                fi
            done
        fi

        echo
        blue
        echo "↑ ↓ - выбрать | Enter - открыть | Backspace - назад | q - выйти"
        reset

        IFS= read -rsn1 key

        case "$key" in
            $'\x1b')
                key2=""
                key3=""

                IFS= read -rsn1 -t 0.1 key2
                IFS= read -rsn1 -t 0.1 key3

                case "$key2$key3" in
                    "[A")
                        if (( selected > 0 )); then
                            ((selected--))
                        fi
                        ;;
                    "[B")
                        if (( selected < ${#entries[@]} - 1 )); then
                            ((selected++))
                        fi
                        ;;
                esac
                ;;

            "")
                if (( ${#entries[@]} > 0 )); then
                    chosen="${entries[$selected]}"

                    if [ -d "$chosen" ]; then
                        old_dir=$(pwd)

                        if cd -- "$chosen"; then
                            prev_dir="$old_dir"
                            selected=0
                        else
                            echo "Не удалось открыть папку"
                            sleep 1
                        fi

                    elif [ -f "$chosen" ]; then
                        if [ -x "$chosen" ] && [[ "$chosen" != *.* ]]; then
                            clear
                            echo "Запуск: $(pwd)/$chosen"
                            echo
                            "./$chosen"
                            echo
                            read -r -p "Нажмите Enter чтобы вернуться..." _

                        elif [ -x "$chosen" ] && [[ "$chosen" == *.sh ]]; then
                            clear
                            echo "Запуск: $(pwd)/$chosen"
                            echo
                            "./$chosen"
                            echo
                            read -r -p "Нажмите Enter чтобы вернуться..." _

                        else
                            clear
                            echo "Открытие:"
                            echo "$(pwd)/$chosen"
                            echo

                            if command -v xdg-open >/dev/null 2>&1; then
                                xdg-open "$chosen" >/dev/null 2>&1 &
                            else
                                echo "xdg-open не найден"
                                sleep 1
                            fi
                        fi
                    fi
                fi
                ;;

            $'\x7f'|$'\x08')
                old_dir=$(pwd)

                if cd ..; then
                    prev_dir="$old_dir"
                    selected=0
                else
                    echo "Не удалось перейти назад"
                    sleep 1
                fi
                ;;

            q|Q)
                return
                ;;
        esac
    done
}


while true; do
    reset
    clear

    echo "====================exproler+============"

    yellow
    echo "вы в"
    pwd
    echo "--"
    reset

    ls

    echo
    echo
    echo
    echo "===============инструменты============="

    blue
    echo "0 - доп опции"
    echo "7 - открыть файл 8- создать папку 9- создать файл 10- удалить папку 11- открыть файл с правами админа"
    echo "12 - выбор файлов стрелочками"
    echo "1- назад 2- перейти к пути 3- обновить 4- вернуться обратно 5- прочитать/изменить файл 6- удалить файл"
    reset

    read -r -p "Введи цифру: " a

    case "$a" in
        1)
            old_dir=$(pwd)

            if cd ..; then
                prev_dir="$old_dir"
            else
                echo "Не удалось перейти назад"
                sleep 1
            fi
            ;;

        2)
            echo "Введите путь как папку (например вы видите папку 123, для её открытия введите 123)"
            read -r -p "Введи путь: " path

            old_dir=$(pwd)

            if cd -- "$path"; then
                prev_dir="$old_dir"
            else
                echo "Папка не найдена"
                sleep 1
            fi
            ;;

        3)
            ;;

        4)
            if [ -n "$prev_dir" ]; then
                current_dir=$(pwd)

                if cd -- "$prev_dir"; then
                    prev_dir="$current_dir"
                else
                    echo "Не удалось открыть предыдущий путь"
                    sleep 1
                fi
            else
                echo "Предыдущий путь не запомнен!"
                sleep 1
            fi
            ;;

        5)
            read -r -p "имя файла: " filename

            if [ -f "$filename" ]; then
                nano -- "$filename"
            else
                echo "файл не найден"
                sleep 1
            fi
            ;;

        6)
            read -r -p "имя файла: " filename

            if [ -f "$filename" ]; then
                read -r -p "подтвердите удаление (y/n): " ch

                if [ "$ch" = "y" ]; then
                    rm -- "$filename"
                else
                    echo "отмена"
                    sleep 1
                fi
            else
                echo "файл не найден"
                sleep 1
            fi
            ;;

        7)
            read -r -p "имя файла: " filename

            if [ -f "$filename" ]; then
                if command -v xdg-open >/dev/null 2>&1; then
                    echo "$(pwd)/$filename"
                    xdg-open "$filename" >/dev/null 2>&1 &
                else
                    echo "xdg-open не найден"
                    sleep 1
                fi
            else
                echo "файл не найден"
                sleep 1
            fi
            ;;

        8)
            read -r -p "имя папки: " filename

            if [ -e "$filename" ]; then
                echo "файл или папка уже существует"
                sleep 1
            else
                mkdir -- "$filename"
            fi
            ;;

        9)
            read -r -p "имя файла: " filename

            if [ -e "$filename" ]; then
                echo "файл уже существует"
                sleep 1
            else
                if touch -- "$filename"; then
                    nano -- "$filename"
                else
                    echo "не удалось создать файл"
                    sleep 1
                fi
            fi
            ;;

        10)
            read -r -p "имя папки: " filename

            if [ -d "$filename" ]; then
                read -r -p "подтвердите удаление (y/n): " ch

                if [ "$ch" = "y" ]; then
                    rm -r -- "$filename"
                else
                    echo "отмена"
                    sleep 1
                fi
            else
                echo "папка не найдена"
                sleep 1
            fi
            ;;

        11)
            read -r -p "имя файла: " filename

            if [ -f "$filename" ]; then
                if command -v sudoedit >/dev/null 2>&1; then
                    sudoedit "$filename"
                else
                    sudo nano -- "$filename"
                fi
            else
                echo "файл не найден"
                sleep 1
            fi
            ;;

        12)
            interactive_select
            ;;

        0)
            echo "Дополнительные опции:"
            echo "1 - Установить команду exproler для текущего пользователя"
            echo "2 - Выход"

            read -r -p "Выберете опцию: " sub

            case "$sub" in
                1)
                    mkdir -p "$HOME/bin"
                    cp -- "$0" "$HOME/bin/exproler"
                    chmod +x "$HOME/bin/exproler"

                    if [ ! -f "$HOME/.bashrc" ]; then
                        touch "$HOME/.bashrc"
                    fi

                    if ! grep -Fq 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc"; then
                        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
                    fi

                    echo "Готово! Теперь команда exproler доступна из любой папки."
                    echo "Перезапусти терминал или выполни: source ~/.bashrc"
                    sleep 2
                    ;;

                2)
                    exit 0
                    ;;

                *)
                    echo "Неверная опция"
                    sleep 1
                    ;;
            esac
            ;;

        *)
            echo "Неверная команда"
            sleep 1
            ;;
    esac
done
