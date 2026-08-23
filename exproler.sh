#!/bin/bash


clear
echo "====================exproler+============"

blue()   { echo -e "\033[1;34m"; }   
yellow() { echo -e "\033[1;33m"; }   
reset()  { echo -e "\033[0m"; } 


                      
prev_dir="" 

while true; do
    reset
    clear
    echo "====================exproler+============"   
    yellow
    echo вы в
    pwd
    echo --
    reset
     ls
    echo ""
    echo ""
    echo ""
    echo "===============инструменты============="
    blue
    echo "0 - доп опции 12- все комманды 13- доп инструменты "
    echo "7 - открыть файл 8- создать папку 9- создать файл 10- удалить папку 11- открыть файл с правами админа"
    echo "1- назад 2- перейти к пути 3- обновить 4- вернуться обратно 5  - прочитать/ изменить  файл 6 - удалить файл"
    reset
    read -p "Введи цифру: " a


    case $a in
        1)
            prev_dir=$(pwd) 
            cd ..
            ;;
        2)
            prev_dir=$(pwd) 
             echo " введите путь как папку( например вы видите папку 123 для ее открытия введите 123)" 
             read -p "Введи путь: " path
             
            cd "$path"
            sleep 0.5 
            ;;
        3)
            ;;
        4)
            
            if [ -n "$prev_dir" ]; then
                cd "$prev_dir"
            else
                echo "Предыдущий путь не запомнен!"
                sleep 1
            fi
            ;;

        5) 
                read -p "имя файла:" filename
                if [ -f "$filename" ]; then
                nano "$filename"
                else
                echo файл не найден
                sleep 1
                fi
                ;;
                
        6)
                read -p "имя файла:" filename;
                if [ -f "$filename" ]; then
                read -p "подвердите удаление (y/n):" ch;
                if [ "$ch" = "y" ] ; then
                rm "$filename"
                else
                echo "отмена"
                fi
                else
                echo файл не найден
                sleep 1
                fi
                ;;

        7)
                read -p "имя файла:" filename;
                if [ -f "$filename" ]; then
                xdg-open "$filename"
                else
                echo файл не найден
                sleep 1
                fi
                ;;




        8)
                read -p "имя папки:" filename;
                if [ -d "$filename" ]; then
                echo " папка уже сущесвутет"
                sleep 1
                else
                mkdir "$filename"
                fi
                ;;
        

        9)
                read -p"имя файла:" filename;
                touch  "$filename"
                nano "$filename"
                ;;
        
        10)
                read -p"имя папки:" filename;
                if [ -d "$filename"  ]; then
                read -p"подвердите удаление  (y/n):" ch;
                if [ "$ch" = "y" ]; then
                rm -r "$filename"
                else
                echo отмена
                sleep 1
                fi
                else
                echo файл не найден
                sleep 1
                fi
                ;;
                

        11)
                read -p"имя  файла " filename;
                if [ -f "$filename" ]; then
                sudo  xdg-open "$filename"
                else
                echo "файл не найден" 
                sleep 1
                fi
                ;;



        12)
                echo " 0 - дополнителные средства 1 - назад 2- выбрать папку ( зайти ) 3- обновить 4- назад 5- прочитать / изменить файл 6- удалить файл"
                echo " 7- открыть файл 8-создать папку 9- создать файл 10 - удалить папку 11- открыть файл с правами админа 12- это окно"
                yellow
                echo " ===========навигация========"
                reset
                echo " 1 - назад 4 - назад( отменить 1 или 2 )  9-создать файл 6- удалить файл  10- удалить папку   8- создать папку"
                read -p"нажмите enter для продолжения"
                ;;


        13)
                blue
                echo "1 - перейти по полному пути"
                reset
                read -p "выбор:" ch
                if [ "$ch" = "1" ]; then
                read -p "путь:" pyti
                cd "$pyti"
                fi
                ;;


                0)
            echo "Дополнительные опции:"
            echo "Дополнительные опции:"
            echo "Дополнительные опции:"
            echo "1 - Установить команду exproler для текущего пользователя"
            echo "2 - Выход"
            read -p "Выберете опцию: " sub
            case $sub in
                1)
                    # Создаём папку bin, если её нет
                    mkdir -p ~/bin
                    # Копируем скрипт
                    cp "$0" ~/bin/exproler
                    chmod +x ~/bin/exproler
                    # Добавляем путь в .bashrc, если его там нет
                    if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
                        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
                    fi
                    echo "Готово! Теперь команда exproler доступна из любой папки."
                    echo "Перезапусти терминал или выполни: source ~/.bashrc"
                    sleep 2
                    ;;
                2)
                        exit 0
                        retrun
                    ;;
                *)
                    echo "Неверная опция"
                    ;;
            esac
            ;;

        *)
            echo "Неверная команда"
            sleep 1
            ;;
    esac
done
