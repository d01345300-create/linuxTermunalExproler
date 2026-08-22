    echo --
    ls
    echo ""
    echo "0 - доп опции"
    echo "1- назад 2- перейти к пути 3- обновить 4- вернуться обратно 5  - прочитать/ изменить  файл 6 - удалить файл"
    read -p "Введи цифру: " a

    case $a in
	1)
            prev_dir=$(pwd) # Запоминаем текущую папку перед уходом
            cd ..
            ;;
	2)
            prev_dir=$(pwd) # Запоминаем текущую папку перед уходом
             echo " введите путь как папку( например вы видите папку 123 для ее открытия введите 123)" 
             read -p "Введи путь: " path

            cd "$path"
            ;;
	3)
            ;;
	4)
            # Проверяем, есть ли запомненная папка (не пустая ли)
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
                rm "$filename"
                else
                echo файл не найден
                sleep 1
                fi
                ;;


                0)
            echo "Дополнительные опции:"
            echo "1 - Установить команду exproler для текущего пользователя"
            echo "2 - Выход"
            read -p "Выбери опцию: " sub
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
                    echo "Возвращаемся..."
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










