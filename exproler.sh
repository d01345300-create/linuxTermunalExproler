clear
echo "====================exproler+============"
prev_dir="" # Инициализируем переменную для памяти (пустую)

while true; do
    clear
    echo "====================exproler+============"   
    echo вы в
    pwd
    echo --
    ls
    echo ""
    echo "1- назад 2- перейти к пути 3- обновить 4- вернуться обратно 5  - прочитать/ изменить  файл 6 - удалить файл"
    read -p "Введи цифру: " a

    case $a in
        1)
            prev_dir=$(pwd) # Запоминаем текущую папку перед уходом
            cd ..
            ;;
        2)
            prev_dir=$(pwd) # Запоминаем текущую папку перед уходом
            read -p "Введи путь: " path
	    echo введите  в формате  папку которую вы видите на экране 
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


        *)
            echo "Неверная команда"
            sleep 1
            ;;
    esac
done
