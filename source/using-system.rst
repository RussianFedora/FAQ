..
    SPDX-FileCopyrightText: 2018-2022 EasyCoding Team and contributors

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _using-system:

******************
Работа в системе
******************

.. index:: autocompletion, bash
.. _autocompletion:

У меня в системе не работает автодополнение команд. Как исправить?
=====================================================================

Необходимо установить пакет sqlite:

.. code-block:: text

    sudo dnf install sqlite

При определённых условиях он может не быть установлен и из-за этого система автоматического дополнения команд может перестать функционировать.

.. index:: autocompletion, bash, dnf
.. _dnf-completion:

Не работает автодополнение имён пакетов. Как исправить?
==========================================================

Существует `баг <https://bugzilla.redhat.com/show_bug.cgi?id=1625674>`__, который блокирует возможность использования автоматического дополнения имён пакетов в dnf при наличии в системе подключённых сторонних репозиториев.

В качестве временного решения можно прекратить их использование.

.. index:: backup
.. _backup-system:

Можно ли делать резервную копию корневого раздела работающей системы?
=========================================================================

Настоятельно не рекомендуется из-за множества работающих виртуальных файловых систем и псевдофайлов в ``/sys``, ``/dev``, ``/proc`` и т.д.

.. index:: backup
.. _backup-home:

Как сделать копию домашнего каталога?
=========================================

См. `здесь <https://www.easycoding.org/2017/09/03/avtomatiziruem-rezervnoe-kopirovanie-v-fedora.html>`__.

.. index:: backup
.. _backup-create:

Как лучше всего делать резервную копию корневого раздела?
=============================================================

Обязательно загрузимся с :ref:`Fedora LiveUSB <usb-flash>`, откроем эмулятор терминала запустим создание :ref:`посекторного образа <dd-mount>`:

.. code-block:: text

    sudo dd if=/dev/sda1 of=/path/to/image.raw bs=32M status=progress

Воспользуемся утилитой **xz** для эффективного сжатия полученного образа диска:

.. code-block:: text

    sudo xz -9 -T$(nproc) /path/to/image.raw

Здесь **/dev/sda1** -- раздел диска, резервную копию которого требуется создать, а **/path/to/image.raw** -- полный путь к файлу образа (должен находиться на другом разделе диска).

.. index:: initrd, rebuild initrd
.. _initrd-rebuild:

Как мне пересобрать образ initrd?
====================================

Выполним пересборку образа initrd загруженного ядра:

.. code-block:: text

    sudo dracut -f

Выполним пересборку образов initrd всех установленных в системе ядер:

.. code-block:: text

    sudo dracut --regenerate-all --force

.. index:: boot, grub
.. _grub-reinstall:

Как мне переустановить Grub 2?
====================================

См. `здесь <https://fedoraproject.org/wiki/GRUB_2>`__.

.. index:: boot, grub, bls, loader
.. _grub-rebuild:

Как пересобрать конфиг Grub 2?
====================================

Начиная с Fedora 30, по умолчанию вместо `устаревшего способа <https://fedoraproject.org/wiki/Changes/BootLoaderSpecByDefault>`__ с добавлением ядер через grubby, применяется :ref:`BLS <grub-bls-info>`, поэтому пересборка конфига больше не требуется.

Пересборка конфига Grub 2 для `всех конфигураций <https://fedoraproject.org/wiki/Changes/UnifyGrubConfig>`__ Fedora:

.. code-block:: text

    sudo grub2-mkconfig -o /boot/grub2/grub.cfg

.. index:: boot, grub, bls, loader
.. _grub-bls-info:

Что такое BLS и почему он используется по умолчанию?
=======================================================

`BLS <https://systemd.io/BOOT_LOADER_SPECIFICATION>`__ -- это универсальный формат параметров загрузки, который будет поддерживаться большинством современных загрузчиков.

Все параметры генерируются на этапе компиляции ядра и сохраняются в специальном conf-файле, который устанавливается в каталог ``/boot/loader/entries``.

Т.к. это статические файлы, :ref:`нестандартные параметры ядра <kernelpm-perm>` теперь устанавливаются при помощи ``grubenv``.

.. index:: boot, grub, bls, loader
.. _grub-to-bls:

Как перейти с классического Grub 2 на BLS?
==============================================

Переход с классического Grub 2 на BLS полностью автоматизирован. Выполним специальный скрипт, входящий в поставку Fedora 30+:

.. code-block:: text

    sudo grub2-switch-to-blscfg

.. index:: boot, grub, bls, loader
.. _grub-from-bls:

Как вернуться с BLS на классический Grub 2?
==============================================

Установим пакет **grubby**, т.к. он используется при добавлении ядер:

.. code-block:: text

    sudo dnf install grubby

Откроем файл конфигурации Grub 2 в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/default/grub

Внесём правки, запретив использование BLS:

.. code-block:: text

    GRUB_ENABLE_BLSCFG=false

:ref:`Пересоберём конфиг Grub 2 <grub-rebuild>` и перезагрузим систему.

.. index:: slow shutdown, shutdown
.. _slow-shutdown:

Система медленно завершает работу. Можно ли это ускорить?
============================================================

См. `здесь <https://www.easycoding.org/2016/08/08/uskoryaem-zavershenie-raboty-fedora-24.html>`__.

.. index:: files, remove, find
.. _remove-old-files:

Как удалить любые файлы, старше 2 суток из указанного каталога?
==================================================================

Ресурсивно удаляем файлы старше 2 суток в указанном каталоге:

.. code-block:: text

    find ~/foo-bar -type f -mtime +2 -delete

Удаляем файлы старше 2 суток в указанном каталоге с ограничением рекурсии:

.. code-block:: text

    find ~/foo-bar -maxdepth 1 -type f -mtime +2 -delete

Здесь **~/foo-bar** -- начальный каталог, в котором производится удаление.

.. index:: kde, gtk, double-click
.. _double-click-speed:

Я использую KDE. Как мне настроить скорость двойного клика в GTK приложениях?
==================================================================================

Для настройки GTK 2 приложений необходимо открыть файл ``~/.gtkrc-2.0`` в любом текстовом редакторе (если он отсутствует — создать), затем прописать в самом конце:

.. code-block:: text

    gtk-double-click-time=1000

Для GTK 3 нужно редактировать ``~/.config/gtk-3.0/settings.ini``. В нём следует прописать то же самое:

.. code-block:: text

    gtk-double-click-time=1000

Здесь **1000** — время в миллисекундах до активации двойного клика. Документация с подробным описанием всех переменных данных файлов конфигурации `здесь <https://developer.gnome.org/gtk3/stable/GtkSettings.html>`__.

.. index:: console, lock screen, lock session
.. _block-screen:

Возможно ли заблокировать экран из командной строки?
=======================================================

Да:

.. code-block:: text

    loginctl lock-session

.. index:: bash
.. _bash-shell:

Можно ли изменить приветствие Bash по умолчанию?
===================================================

Да, необходимо в пользовательский файл ``~/.bashrc`` добавить строку вида:

.. code-block:: text

    export PS1="\[\e[33m\][\[\e[36m\]\u\[\e[0m\]@\[\e[31m\]\h\[\e[0m\] \[\e[32m\]\W\[\e[33m\]]\[\e[35m\]\$\[\e[0m\] "

Существует удобный онлайн генератор таких строк `здесь <http://bashrcgenerator.com/>`__.

.. index:: bash, title, console
.. _bash-title:

Можно ли из shell скрипта менять название терминала?
=======================================================

Да, при помощи `управляющих последовательностей <https://ru.wikipedia.org/wiki/%D0%A3%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D1%8F%D1%8E%D1%89%D0%B8%D0%B5_%D0%BF%D0%BE%D1%81%D0%BB%D0%B5%D0%B4%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE%D1%81%D1%82%D0%B8_ANSI>`__. Ими же можно менять цвет текста вывода и многое другое.

.. index:: time, synchronization, ntp, network
.. _configure-ntp:

Как настроить синхронизацию времени?
=======================================

В Fedora для этой цели используется chronyd, который установлен и запущен по умолчанию.

Чтобы узнать включена ли синхронизация времени с NTP серверами, можно использовать утилиту **timedatectl**.

Если синхронизация отключена, нужно убедиться, что сервис chronyd активирован:

.. code-block:: text

    sudo systemctl enable chronyd.service

Получить список NTP серверов, с которыми осуществляется синхронизация, можно так:

.. code-block:: text

    chronyc sources

.. index:: systemd, boot, speed
.. _systemd-analyze:

Как узнать какой сервис замедляет загрузку системы?
======================================================

Вывод информации в виде текста:

.. code-block:: text

    systemd-analyze blame

Вывод информации в виде SVG изображения:

.. code-block:: text

    systemd-analyze plot > systemd-plot.svg
    xdg-open systemd-plot.svg

.. index:: window, gnome, scaling, scaling factor, hidpi, qt
.. _window-hidpi-qt:

У меня в Gnome не работает масштабирование окон Qt приложений. Что делать?
=============================================================================

Для активации автоматического масштабирования достаточно прописать в файле ``~/.bashrc`` следующие строки:

.. code-block:: text

    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_SCALE_FACTOR=2

Переменная ``QT_AUTO_SCREEN_SCALE_FACTOR`` имеет тип boolean (значения **1** (включено) или **0** (выключено)) и управляет автоматическим масштабированием в зависимости от разрешения экрана.

Переменная ``QT_SCALE_FACTOR`` задаёт коэффициент масштабирования:

  * **1.5** -- 150%;
  * **1.75** -- 175%;
  * **2** -- 200%;
  * **2.5** -- 250%;
  * **3** -- 300%.

Более подробную информацию можно найти в `документации Qt <https://doc.qt.io/qt-5/highdpi.html>`__.

.. index:: sddm, dm, disable virtual keyboard, keyboard
.. _sddm-disable-vkb:

Как отключить виртуальную клавиатуру в SDDM?
=================================================

Чтобы отключить поддержку ввода с виртуальной экранной клавиатуры в менеджере входа в систему SDDM, откроем в текстовом редакторе файл ``/etc/sddm.conf``, а затем найдём и удалим следующую строку:

.. code-block:: text

    InputMethod=qtvirtualkeyboard

Если она отсутствует, создадим в блоке ``[General]``:

.. code-block:: text

    InputMethod=

Изменения вступят в силу при следующей загрузке системы.

.. index:: systemd, failed to start modules, kernel, virtualbox
.. _failed-to-start:

При загрузке системы появляется ошибка Failed to start Load Kernel Modules. Как исправить?
==============================================================================================

Это известная проблема системы виртуализации :ref:`VirtualBox <virtualbox>`, использующей out-of-tree модули ядра, но может также проявляться и у пользователей проприетарных :ref:`драйверов Broadcom <broadcom-drivers>`.

Для исправления необходимо **после каждого обновления ядра** выполнять пересборку initrd:

.. code-block:: text

    sudo dracut -f

Для вступления изменений в силу требуется перезагрузка:

.. code-block:: text

    sudo systemctl reboot

.. index:: keyring, kwallet, wallet
.. _kwallet-pam:

Как настроить автоматическую разблокировку связки ключей KWallet при входе в систему?
=========================================================================================

KDE предоставляет особый PAM модуль для автоматической разблокировки связки паролей KDE Wallet при входе в систему. Установим его:

.. code-block:: text

    sudo dnf install pam-kwallet

Запустим менеджер KWallet (**Параметры системы** -- группа **Предпочтения пользователя** -- **Учётная запись** -- страница **Бумажник** -- кнопка **Запустить управление бумажниками**), нажмём кнопку **Сменить пароль** и укажем тот же самый пароль, который используется для текущей учётной записи.

Сохраняем изменения и повторно входим в систему.

.. index:: xdg, directories
.. _xdg-reallocate:

Как переместить стандартные каталоги для документов, загрузок и т.д.?
==========================================================================

Откроем файл ``~/.config/user-dirs.dirs`` в любом текстовом редакторе и внесём свои правки.

Стандартные настройки:

.. code-block:: ini

    XDG_DESKTOP_DIR="$HOME/Рабочий стол"
    XDG_DOCUMENTS_DIR="$HOME/Документы"
    XDG_DOWNLOAD_DIR="$HOME/Загрузки"
    XDG_MUSIC_DIR="$HOME/Музыка"
    XDG_PICTURES_DIR="$HOME/Изображения"
    XDG_PUBLICSHARE_DIR="$HOME/Общедоступные"
    XDG_TEMPLATES_DIR="$HOME/Шаблоны"
    XDG_VIDEOS_DIR="$HOME/Видео"

Применим изменения:

.. code-block:: text

    xdg-user-dirs-update

Убедитесь, что перед применением изменений данные каталоги существуют, иначе будет выполнен сброс на стандартное значение.

.. index:: sddm, hidpi, scaling
.. _sddm-hidpi:

У меня HiDPI дисплей и в SDDM всё отображается очень мелко. Как настроить?
==============================================================================

Откроем файл ``/etc/sddm.conf``:

.. code-block:: text

    sudoedit /etc/sddm.conf

Добавим в самый конец следующие строки:

.. code-block:: ini

    [Wayland]
    EnableHiDPI=true

    [X11]
    EnableHiDPI=true

Сохраним изменения и перезапустим систему.

.. index:: sddm, avatar
.. _sddm-avatars:

Как отключить отображение пользовательских аватаров в SDDM?
===============================================================

Пользовательские аватары представляют собой файл ``~/.face.icon``. При запуске SDDM пытается прочитать его для каждого существующего пользователя.

Для отключения данной функции откроем файл ``/etc/sddm.conf``:

.. code-block:: text

    sudoedit /etc/sddm.conf

Добавим в самый конец следующие строки:

.. code-block:: ini

    [Theme]
    EnableAvatars=false

Сохраним изменения и перезапустим систему.

.. index:: powertop, top, power
.. _power-usage:

Как узнать какие процессы больше всего разряжают аккумулятор ноутбука?
===========================================================================

Установим утилиту **powertop**:

.. code-block:: text

    sudo dnf install powertop

Запустим её с правами суперпользователя:

.. code-block:: text

    sudo powertop

Процессы, которые больше всех влияют на скорость разряда аккумуляторных батарей, будут отображаться в верхней части.

.. index:: system information, info
.. _system-info:

Как собрать информацию о системе?
=====================================

Установим утилиту **inxi**:

.. code-block:: text

    sudo dnf install inxi

Соберём информацию о системе и выгрузим на fpaste:

.. code-block:: text

    inxi -F | fpaste

На выходе будет сгенерирована уникальная ссылка, которую можно передать на :ref:`форум, в чат <get-help>` и т.д.

.. index:: networking, vpn, l2tp, ipsec
.. _nm-l2tp:

Мой провайдер использует L2TP. Как мне добавить его поддержку?
==================================================================

Плагин L2TP для Network Manager должен присутствовать в Workstation и всех spin live образах по умолчанию, но если его по какой-то причине нет (например, была выборана минимальная установка netinstall), то добавить его можно самостоятельно.

Для Gnome/XFCE и других, основанных на GTK:

.. code-block:: text

    sudo dnf install NetworkManager-l2tp-gnome

Для KDE:

.. code-block:: text

    sudo dnf install plasma-nm-l2tp

После установки необходимо запустить модуль настройки Network Manager (графический или консольный), добавить новое VPN подключение с типом L2TP и указать настройки, выданные провайдером.

Однако следует помнить, что у некоторых провайдеров используется L2TP со специальными патчами Microsoft (т.н. win реализация), что может вызывать нестабильность и сбои при подключении. В таком случае рекомендуется приобрести любой недорогой роутер с поддержкой L2TP (можно б/у) и использовать его в качестве клиента для подключения к сети провайдера.

.. index:: networking, network manager, nmcli, console, wi-fi
.. _nm-wificon:

Как подключиться к Wi-Fi из консоли?
========================================

Если ранее уже были созданы Wi-Fi подключения, то выведем их список:

.. code-block:: text

    nmcli connection | grep wifi

Теперь запустим выбранное соединение:

.. code-block:: text

    nmcli connection up Connection_Name

.. index:: networking, network manager, nmcli, console, wi-fi
.. _nm-wificli:

Как подключиться к Wi-Fi из консоли при отсутствии соединений?
==================================================================

Если :ref:`готовых соединений <nm-wificon>` для Wi-Fi нет, но известны SSID и пароль, то можно осуществить подключение напрямую:

.. code-block:: text

    nmcli device wifi connect MY_NETWORK password XXXXXXXXXX

Здесь **MY_NETWORK** -- название SSID точки доступа, к которой мы планируем подключиться, а **XXXXXXXXXX** -- её пароль.

.. index:: text, editor, text editor, console
.. _editor-selection:

Как выбрать предпочитаемый текстовый редактор в консольном режиме?
=======================================================================

Для выбора предпочитаемого текстового редактора следует применять :ref:`переменные окружения <env-set>`, прописав их в личном файле ``~/.bashrc``:

.. code-block:: text

    export VISUAL=vim
    export EDITOR=vim
    export SUDO_EDITOR=vim

**VISUAL** -- предпочитаемый текстовый редактор с графическим интерфейсом пользователя, **EDITOR** -- текстовый, а **SUDO_EDITOR** используется в :ref:`sudoedit <sudo-edit-config>`.

.. index:: text, editor, git, text editor
.. _editor-git:

Как выбрать предпочитаемый текстовый редактор для Git?
===========================================================

Хотя Git подчиняется настройкам :ref:`редактора по умолчанию <editor-selection>`, допустимо его указать явно в файле конфигурации:

.. code-block:: text

    git config --global core.editor vim

.. index:: iso, image, mount
.. _iso-mount:

Как смонтировать ISO образ в Fedora?
========================================

Создадим точку монтирования:

.. code-block:: text

    sudo mkdir /mnt/iso

Смонтируем файл образа:

.. code-block:: text

    sudo mount -o loop /path/to/image.iso /mnt/iso

По окончании произведём размонтирование:

.. code-block:: text

    sudo umount /mnt/iso

.. index:: iso, image
.. _iso-create:

Как считать содержимое CD/DVD диска в файл ISO образа?
==========================================================

Для этого можно воспользоваться утилитой **dd**:

.. code-block:: text

    sudo dd if=/dev/sr0 of=/path/to/image.iso bs=4M status=progress

Здесь **/dev/sr0** имя устройства привода для чтения оптических дисков, а **/path/to/image.iso** -- файл образа, в котором будет сохранён результат.

.. index:: dd, disk, drive, image
.. _dd-mount:

Как смонтировать посекторный образ раздела?
================================================

Монтирование raw образа раздела, созданного посредством утилиты **dd**:

.. code-block:: text

    sudo mount -o ro,loop /path/to/image.raw /mnt/dd-image

Размонтирование:

.. code-block:: text

    sudo umount /mnt/dd-image

Здесь **/path/to/image.iso** -- файл образа на диске.

.. index:: dd, disk, drive, image
.. _dd-fullraw:

Как смонтировать посекторный образ диска целиком?
======================================================

Смонтировать образ диска целиком напрямую не получится, поэтому сначала придётся определить смещения разделов относительно его начала.

Запустим утилиту **fdisk** и попытаемся найти внутри образа разделы:

.. code-block:: text

    sudo fdisk -l /path/to/image.raw

Из вывода нам необходимо узнать значение **Sector size**, а также **Start** всех необходимых разделов.

Вычислим смещение относительно начала образа для каждого раздела по формуле **Start * Sector size**. К примеру если у первого Start равно 2048, а Sector size диска 512, то получим 2048 * 512 == 1048576.

Произведём монтирование раздела по смещению 1048576:

.. code-block:: text

    sudo mount -o ro,loop,offset=1048576 /path/to/image.raw /mnt/dd-image

Повторим операции для всех остальных разделов, обнаруженных внутри образа. По окончании работы выполним размонтирование:

.. code-block:: text

    sudo umount /mnt/dd-image

Здесь **/path/to/image.iso** -- файл образа на диске.

.. index:: timezone
.. _set-timezone:

Как изменить часовой пояс?
==============================

Изменить часовой пояс можно посредством утилиты **timedatectl**:

.. code-block:: text

    sudo timedatectl set-timezone Europe/Moscow

.. index:: keyboard, layout, gui
.. _set-keyboard-gui:

Как изменить список доступных раскладок клавиатуры и настроить их переключение в графическом режиме?
========================================================================================================

Настройка переключения по **Alt + Shift**, раскладки EN и RU:

.. code-block:: text

    sudo localectl set-x11-keymap us,ru pc105 "" grp:alt_shift_toggle

Настройка переключения по **Ctrl + Shift**, раскладки EN и RU:

.. code-block:: text

    sudo localectl set-x11-keymap us,ru pc105 "" grp:ctrl_shift_toggle

.. index:: keyboard, layout, console, text mode
.. _set-keyboard-console:

Как изменить список доступных раскладок клавиатуры и настроить их переключение в текстовом режиме?
======================================================================================================

Установка русской раскладки и режимов переключения по умолчанию (**Alt + Shift**):

.. code-block:: text

    sudo localectl set-keymap ru

Установка русской раскладки и режима переключения **Alt + Shift**:

.. code-block:: text

    sudo localectl set-keymap ruwin_alt_sh-UTF-8

Установка русской раскладки и режима переключения **Ctrl + Shift**:

.. code-block:: text

    sudo localectl set-keymap ruwin_ct_sh-UTF-8

.. index:: kde, plasma, gtk, styles
.. _gtk-plasma-style:

Можно ли заставить GTK приложения выглядеть нативно в KDE?
==============================================================

Установим пакет с темой Breeze для GTK2 и GTK3:

.. code-block:: text

    sudo dnf install breeze-gtk

Зайдём в **Параметры системы** -- **Внешний вид** -- **Оформление приложений** -- **Стиль программ GNOME (GTK+)**.

Выберем **Breeze** (при использовании тёмной темы в KDE -- **Breeze Dark**) в качестве темы GTK2 и GTK3, а также укажем шрифт, который будет использовать при отображении диалоговых окон.

Также установим **Breeze** для курсоров мыши и темы значков. Применим изменения и перезапустим все GTK приложения.

.. index:: bash, command-line, hotkeys
.. _bash-hotkeys:

Какие полезные комбинации клавиш существуют при наборе команд в терминале?
=============================================================================

Существуют следующие комбинации:

  * **Ctrl + A** -- перемещает текстовый курсор на начало строки (аналогична **Home**);
  * **Ctrl + E** -- перемещает текстовый курсор в конец строки (аналогична **End**);
  * **Ctrl + B** -- перемещает текстовый курсор на один символ влево (аналогична стрелке влево);
  * **Ctrl + F** -- перемещает текстовый курсор на один символ вправо (аналогична стрелке вправо);
  * **Alt + B** -- перемещает текстовый курсор на одно слово влево;
  * **Alt + F** -- перемещает текстовый курсор на одно слово вправо;
  * **Ctrl + W** -- удаляет последнее слово в строке;
  * **Ctrl + U** -- удаляет всё из строки ввода;
  * **Ctrl + K** -- удаляет всё, что находится правее текущей позиции текстового курсора;
  * **Ctrl + Y** -- отменяет последнюю операцию удаления;
  * **Ctrl + _** -- отменяет любую последнюю операцию.

.. index:: kde, plasma, url, mime type, link
.. _kde-link-mime:

При нажатии по любой гиперссылке она открывается не в браузере, а соответствующем приложении. Как исправить?
===============================================================================================================

Согласно настроек по умолчанию, при нажатии на любую ссылку вне браузера (например, в мессенджере) компонент KDE KIO попытается определить mime-тип файла, загружаемого по ней, и открыть её в ассоциированном с приложении. Например, если это изображение JPEG, то оно будет загружено в Gwenview.

Отключить данную функцию можно в **Параметры системы** -- **Предпочтения пользователя** -- **Приложения** -- **Приложения по умолчанию** -- раздел **Браузер** -- пункт **Открывать адреса http и https** -- **В следующем приложении** -- **Firefox**.

.. index:: mime type, file type
.. _file-types:

Как файловые менеджеры определяют типы файлов?
=================================================

Если в ОС Microsoft Windows тип файлов определяется исключительно по их расширению, то в GNU/Linux для этого используется `mime-типы <https://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_MIME-%D1%82%D0%B8%D0%BF%D0%BE%D0%B2>`__.

В системе ведётся база соответствия mime-типов установленным приложениям, соответствующая `стандарту XDG Free Desktop <https://specifications.freedesktop.org/mime-apps-spec/mime-apps-spec-latest.html>`__.

Для получения mime-типа конкретного файла можно использовать утилиту **file**:

.. code-block:: text

    file foo-bar.txt

Для открытия файла в ассоциированном с его mime-типом приложении применяется утилита **xdg-open**:

.. code-block:: text

    xdg-open foo-bar.txt

.. index:: locale, localization, language
.. _system-locale:

Как изменить язык (локализацию) системы?
============================================

Получим список доступных локалей:

.. code-block:: text

    localectl list-locales

Установим английскую локаль для системы:

.. code-block:: text

    sudo localectl set-locale LANG=en_US.UTF-8

Установим русскую локаль для системы:

.. code-block:: text

    sudo localectl set-locale LANG=ru_RU.UTF-8

.. index:: locale, localization, language
.. _application-locale:

Как запустить приложение с другой локалью?
==============================================

Для запуска приложения с другой локалью необходимо передать ему новое значение в :ref:`переменной окружения <env-set>` **LANG**:

.. code-block:: text

    LANG=en_US.UTF-8 foo-bar

.. index:: timezone, time
.. _application-timezone:

Как запустить приложение с другим часовым поясом?
====================================================

Для запуска приложения с другим часовым поясом необходимо передать ему новое значение в :ref:`переменной окружения <env-set>` **TZ**:

.. code-block:: text

    TZ=CET foo-bar

Здесь вместо **CET** следует указать название часового пояса.

.. index:: x11, wayland, session
.. _session-type:

Как определить какой тип сессии используется: X11 или Wayland?
=================================================================

Для определения типа текущей сессии, необходимо получить значение глобальной :ref:`переменной окружения <env-set>` **XDG_SESSION_TYPE**:

.. code-block:: text

    echo $XDG_SESSION_TYPE

.. index:: neofetch, screenfetch, system info, console
.. _neofetch:

Как вывести в консоль краткую информацию об установленной системе?
=====================================================================

Установим neofetch:

.. code-block:: text

    sudo dnf install neofetch

Запустим и выведем информацию о системе в консоль:

.. code-block:: text

    neofetch

.. index:: boot, plymouth, animation
.. _plymouth-disable:

Как отключить анимированную каплю при загрузке системы?
==========================================================

Для отключения анимации загрузки (plymouth boot screen) необходимо и достаточно :ref:`добавить параметры ядра <kernelpm-perm>` ``rd.plymouth=0 plymouth.enable=0``, после чего :ref:`пересобрать конфиг Grub 2 <grub-rebuild>`.

.. index:: boot, plymouth, theme
.. _plymouth-themes:

Как изменить тему экрана, отображающегося при загрузке системы?
===================================================================

Выведем список установленных тем Plymouth boot screen:

.. code-block:: text

    plymouth-set-default-theme --list

Определим текущую:

.. code-block:: text

    plymouth-set-default-theme

Установим, например, **charge**:

.. code-block:: text

    sudo plymouth-set-default-theme charge -R

Параметр ``-R`` включает автоматическую :ref:`пересборку initrd <initrd-rebuild>` ядра.

.. index:: boot, plymouth, theme, logo
.. _plymouth-nologo:

Как отключить вывод логотипа производителя устройства при загрузке системы?
==============================================================================

Начиная с Fedora 30, для Plymouth по умолчанию устанавливается тема **bgrt**, поддерживающая вывод логотипа производителя устройства, если система загружается в :ref:`UEFI режиме <uefi-boot>`.

Чтобы убрать его, :ref:`сменим тему <plymouth-themes>` загрузочного экрана, например на **charge**:

.. code-block:: text

    sudo plymouth-set-default-theme charge -R

Изменения вступят в силу при следующей загрузке системы. Логотип больше отображаться не будет.

.. index:: ntfs, partition, windows, fast boot, hybrid shutdown, powercfg
.. _ntfs-readonly:

Все NTFS тома монтируются в режиме только для чтения. Как исправить?
========================================================================

Некорректное размонтирование разделов -- это особенность работы режима гибридного завершения работы (`hybrid shutdown <https://docs.microsoft.com/en-us/windows-hardware/drivers/kernel/distinguishing-fast-startup-from-wake-from-hibernation>`__) в ОС Microsoft Windows, при котором система не завершает свою работу, а вместо этого всегда переходит в режим глубокого сна.

Данный режим несовместим с другими операционными системами, в т.ч. GNU/Linux, поэтому должен быть отключён в обязательном порядке при использовании :ref:`dual-boot <dual-boot>`.

  1. запустим командную строку с правами администратора, затем выполним ``powercfg -h off``;
  2. запретим использование режима быстрой загрузки (fast boot) в настройках UEFI BIOS.

.. index:: icon, desktop, override
.. _icon-override:

Как изменить ярлык приложения из главного меню?
====================================================

Значки приложений главного меню расположены в каталоге ``/usr/share/applications``, однако редактировать их там не следует ибо при следующем :ref:`обновлении <dnf-update>` все изменения будут потеряны.

Вместо этого создадим локальное переопределение -- скопируем desktop-файл в ``~/.local/share/applications`` и внесём необходимые правки.

Создадим каталог назначения если он отсутствует:

.. code-block:: text

    mkdir -p ~/.local/share/applications

Скопируем ярлык **foo-bar.desktop**:

.. code-block:: text

    cp /usr/share/applications/foo-bar.desktop ~/.local/share/applications/

Внесём свои правки.

Кэш :ref:`значков главного меню <kde-icons-refresh>` обновится автоматически, т.к. все популярные среды рабочего стола отслеживают изменения в данном каталоге.

.. index:: language, gnome, keyboard, switch, bindings, input, source
.. _set-keyboard-gnome:

Как изменить сочетание клавиш для переключения языка ввода в Gnome?
======================================================================

Рассмотрим два способа изменения сочетания клавиш для переключения между языками: консоль и GUI.

Консоль:
^^^^^^^^^^

Определим, какой вариант установлен:

.. code-block:: text

    gsettings get org.gnome.desktop.wm.keybindings switch-input-source

Установим новое сочетание для переключения раскладок:

.. code-block:: text

    gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"

Возможные варианты сочетаний клавиш (допустимо несколько вариантов, через запятую):

.. code-block:: text

    '<Alt>Shift_L', '<Shift>Alt_L', '<Shift>Alt_R', '<Alt>Shift_R'
    '<Ctrl>Shift_L', '<Shift>Control_L', '<Shift>Control_R', '<Ctrl>Shift_R'
    'Caps_Lock'

GUI:
^^^^^^^

Установим пакет **dconf-editor**, если он не установлен:

.. code-block:: text

    sudo dnf install dconf-editor

Запустим данное приложение:

.. code-block:: text

    dconf-editor

В ветке ``org.gnome.desktop.wm.keybindings`` установим параметру ``switch-input-source`` желаемое значение.

Обязательно убедимся в наличии квадратных скобок. Конфигурация по-умолчанию -- ``['<Super>space', 'XF86Keyboard']``.

.. index:: x11, wayland, session
.. _x11-session:

Как переключить рабочую среду на использование X11?
======================================================

Настройки для различных рабочих сред:

  * :ref:`GNOME <x11-gnome>`;
  * :ref:`KDE <x11-plasma>`.

.. index:: x11, wayland, session, gnome, gdm
.. _x11-gnome:

Как переключить GNOME на использование X11?
===============================================

Откроем файл конфигурации ``/etc/gdm/custom.conf`` в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/gdm/custom.conf

Внесём изменения в секцию **daemon**:

.. code-block:: ini

    [daemon]
    WaylandEnable=false
    DefaultSession=gnome-xorg.desktop

Сохраним изменения и перезагрузим устройство:

.. code-block:: text

    systemctl reboot

.. index:: x11, wayland, session, kde, sddm
.. _x11-plasma:

Как переключить KDE на использование X11?
==============================================

Произведём замену пакета **sddm-wayland-plasma** на **sddm-x11**:

.. code-block:: text

    sudo dnf swap sddm-wayland-plasma sddm-x11 --allowerasing

Перезагрузим устройство для вступления изменений в силу:

.. code-block:: text

    systemctl reboot

При следующем входе в меню выбора доступных сеансов выберем **Plasma (X11)**.

.. index:: font, ttf, fc-match, fontconfig
.. _font-identify:

Как определить, какой шрифт будет использован для указанной гарнитуры?
=========================================================================

Воспользуемся утилитой **fc-match** из комплекта поставки FreeType для определения используемого шрифта и соответствующего ему файла на диске для запрошенной гарнитуры:

.. code-block:: text

    fc-match 'sans-serif'

.. index:: font, ttf, fontconfig, fonts.d
.. _font-replace:

Как заменить один шрифт другим на системном уровне?
======================================================

Заменим шрифты **Foo Bar** и **Foo Bar Emoji** на *Noto*.

Создадим каталог для пользовательских настроек fontconfig:

.. code-block:: text

    mkdir -p ~/.config/fontconfig/fonts.d

Добавим новый файл конфигурации и сразу же установим правильный контекст безопасности SELinux:

.. code-block:: text

    touch ~/.config/fontconfig/fonts.d/30-replace-foo.conf
    restorecon -Rv ~/.config/fontconfig

Вставим в ``~/.config/fontconfig/fonts.d/30-replace-foo.conf`` следующий код:

.. code-block:: xml

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
    <alias>
        <family>Foo Bar</family>
        <prefer>
            <family>Noto Sans</family>
        </prefer>
    </alias>
    <alias>
        <family>Foo Bar Emoji</family>
        <prefer>
            <family>Noto Color Emoji</family>
        </prefer>
    </alias>
    </fontconfig>

Очистим кэши fontconfig:

.. code-block:: text

    fc-cache -fr

Убедимся, что для шрифта **Foo Bar** теперь :ref:`используется <font-identify>` **Noto Sans Regular**.

Если всё сделано верно, перезапустим все приложения, либо выполним новый вход в систему для вступления изменений в силу.

.. index:: files, find, permissions, chown, home, whoami
.. _home-permissions:

Как исправить права доступа для объектов в домашнем каталоге?
=================================================================

При запуске приложений с правами суперпользователя в домашнем каталоге могут появляться каталоги и файлы, принадлежащие root. Они способны вызывать проблемы при работе приложений в стандартном режиме из-за отсутствия к ним прав доступа на запись.

Выявим файлы и каталоги, не принадлежащие текущему пользователю, при помощи утилиты **find**:

.. code-block:: text

    find ~ ! -user $(whoami) -print

Если таковые были найдены, автоматически исправим владельца и группу для них:

.. code-block:: text

    sudo find ~ ! -user $(whoami) -exec chown $(whoami):$(whoami) "{}" \;
