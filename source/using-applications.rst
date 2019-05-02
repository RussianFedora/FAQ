.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _using-applications:

*************************************************
Вопросы, связанные со сторонними приложениями
*************************************************

.. index:: firefox, hardware acceleration
.. _firefox-hwaccel:

Как активировать аппаратное ускорение в браузере Firefox?
=============================================================

Для активации аппаратного ускорения рендеринга страниц в Mozilla Firefox на поддерживаемых драйверах необходимо открыть модуль конфигурации ``about:config`` и исправить значения следующих переменных (при отсутствии создать):

.. code-block:: text

    layers.acceleration.force-enabled = true
    layers.offmainthreadcomposition.enabled = true
    webgl.force-enabled = true
    gfx.xrender.enabled = true

Изменения вступят в силу при следующем запуске браузера.

Внимание! Это не затрагивает :ref:`аппаратное декодирование мультимедиа <browser-hwaccel>` средствами видеоускорителя.

.. index:: firefox, chromium, chrome, hardware acceleration, vaapi
.. _browser-hwaccel:

Как активировать аппаратное ускорение декодирования мультимедиа в браузерах?
===============================================================================

В настоящее время аппаратное ускорение декодирования мультимедиа "из коробки" в GNU/Linux не поддерживается ни в одном браузере.

В Mozilla Firefox оно вообще не реализовано: `MZBZ#563206 <https://bugzilla.mozilla.org/show_bug.cgi?id=563206>`__ и `MZBZ#1210727 <https://bugzilla.mozilla.org/show_bug.cgi?id=1210727>`__.

В Google Chrome и Chromium частично реализовано, но отключено на этапе компиляции и без особых VA-API патчей недоступно. Репозиторий :ref:`RPM Fusion <rpmfusion>` предоставляет такую сборку Chromium. Для её установки необходимо подключить его и установить пакет **chromium-vaapi**:

.. code-block:: text

    sudo dnf install chromium-vaapi

Далее необходимо запустить его, зайти в ``chrome://flags`` и установить пункт **Hardware decoding** в значение **Enabled**, после чего перезапустить браузер.

.. index:: mpv, video player, hardware acceleration, vaapi, vdpau
.. _video-hwaccel:

В каких проигрывателях реализовано аппаратное ускорение декодирования мультимедиа?
=====================================================================================

Полная поддержка аппаратного декодирования мультимедиа средствами VA-API (Intel, AMD) или VPDAU (NVIDIA) реализована в проигрывателях VLC и mpv.

Для активации данной функции необходимо в качестве графического бэкэнда вывода изображения указать **vaapi** или **vdpau**, после чего перезапустить плеер.

.. index:: telegram, im
.. _telegram-fedora:

Как лучше установить Telegram Desktop в Fedora?
===================================================

Мы настоятельно рекомендуем устанавливать данный мессенджер исключительно из :ref:`RPM Fusion <rpmfusion>`:

.. code-block:: text

    sudo dnf install telegram-desktop

Данная версия собрана и динамически слинкована с использованием исключительно штатных системных библиотек, доступных в репозиториях Fedora, а не давно устаревших и уязвимых версий из комплекта Ubuntu 14.04, как официальная.

Сборка Fedora поддерживает системные настройки тем, правильное сглаживание шрифтов (за счёт использование общесистемных настроек) и не имеет проблем со скоростью запуска.

.. index:: telegram, cleanup, im
.. _telegram-cleanup:

Ранее я устанавливал официальную версию Telegram Desktop. Как мне очистить её остатки?
=========================================================================================

Официальная версия с сайта создаёт ярлыки запуска и копирует ряд загруженных бинарных файлов в пользовательский домашний каталог. Избавимся от этого:

 1. удалим старый бинарник и модуль обновления официального клиента, а также их копии из ``~/.local/share/TelegramDesktop`` и ``~/.local/share/TelegramDesktop/tdata``;
 2. удалим ярлыки из ``~/.local/share/applications``.

Теперь можно установить :ref:`версию <telegram-fedora>` из :ref:`RPM Fusion <rpmfusion>`.

.. index:: repository, codecs, multimedia, chromium, third-party
.. _chromium-codecs:

Я установил браузер Chromium из репозиториев, но он отказывается воспроизводить видео с большинства сайтов. Как исправить?
==============================================================================================================================

Из-за патентных ограничений браузер Chromium в репозиториях Fedora сильно кастрирован. Для восстановления полной функциональности необходимо подключить :ref:`RPM Fusion <rpmfusion>` и установить пакет с кодеками для данного браузера:

.. code-block:: text

    sudo dnf install chromium-libs-media-freeworld

.. index:: repository, codecs, multimedia, third-party, ffmpeg
.. _firefox-codecs:

Как активировать все доступные кодеки в браузере Firefox?
==============================================================

Браузер Mozilla Firefox использует ffmpeg для работы с мультимедийным контентом, поэтому необходимо его установить из репозитория :ref:`RPM Fusion <rpmfusion>`:

.. code-block:: text

    sudo dnf install ffmpeg-libs

.. index:: latex, editor
.. _latex-editor:

В репозиториях есть полнофункциональные редакторы LaTeX?
===========================================================

Да. Для работы с документами в формате LaTeX рекомендуется использовать **texmaker**:

.. code-block:: text

    sudo dnf install texmaker

.. index:: latex, texlive, cyrillic, fonts
.. _latex-cyrillic:

Как установить поддержку кириллических шрифтов для LaTeX?
=============================================================

Наборы кириллических шрифтов доступны в виде коллекции:

.. code-block:: text

    sudo dnf install texlive-collection-langcyrillic texlive-cyrillic texlive-russ texlive-babel-russian

.. index:: video, youtube, download
.. _youtube-download:

Как скачать видео с Youtube?
=================================

Скачать любое интересующее видео с Youtube, а также ряда других хостингов, можно посредством утилиты **youtube-dl**, доступной в основном репозитории Fedora:

.. code-block:: text

    sudo dnf install youtube-dl

Скачивание видео с настройками по умолчанию в наилучшем качестве:

.. code-block:: text

    youtube-dl -f bestvideo https://www.youtube.com/watch?v=XXXXXXXXXX

Иногда при скачивании видео в разрешении 4K с ключом ``-f bestvideo`` может не работать аппаратное ускорение при воспроизведении из-за того, что кодек vp9.2 не поддерживается аппаратными кодировщиками. В таких случаях необходимо явно указывать кодек (``-f bestvideo[vcodec=vp9]``).

Чтобы гарантировано скачать видео с указанным кодеком со звуком требуется дополнительно установить пакет **ffmpeg** из репозиториев :ref:`RPM Fusion <rpmfusion>`:

.. code-block:: text

    sudo dnf install ffmpeg

В качестве примера скачаем видео в наилучшем качестве, сжатое кодеком VP9 (с возможностью аппаратного ускорения) и звуком:

.. code-block:: text

    youtube-dl -f bestvideo[vcodec=vp9]+bestaudio https://www.youtube.com/watch?v=XXXXXXXXXX

Данная утилита имеет множество параметров командной строки, справку по которым можно найти в её странице man:

.. code-block:: text

    man youtube-dl

Для выхода из окна просмотра справки достаточно нажать **Q**.

.. index:: iso, write iso, image
.. _fedora-winiso:

Как из Fedora записать образ с MS Windows на флешку?
========================================================

К сожалению, :ref:`штатный способ <usb-flash>` записи посредством использования утилиты dd не сработает в случае ISO образов MS Windows, поэтому для этого следует применять утилиту WoeUSB:

.. code-block:: text

    sudo dnf install WoeUSB

.. index:: text file, encoding, converting, iconv
.. _iconv-convert:

Как конвертировать текстовый файл из одной кодировки в другую?
==================================================================

Для быстрой перекодировки текстовых файлов из одной кодировки в другую можно использовать утилиту iconv.

Пример перекодировки файла из cp1251 (Windows-1251) в юникод (UTF-8):

.. code-block:: text

    iconv -f cp1251 -t utf8 test.txt > result.txt

Здесь **test.txt** - исходный файл с неправильной кодировкой, а **result.txt** используется для записи результата преобразования.

.. index:: fuse, file system, mtp, android, phone
.. _fuse-mtp:

Как подключить смартфон на Android посредством протокола MTP?
================================================================

Для простой и удобной работы с файловой системой смартфона вне зависимости от используемых приложений, рабочей среды и файлового менеджера, мы рекомендуем использовать основанную на FUSE реализацию.

Установим пакет **jmtpfs**:

.. code-block:: text

    sudo dnf install jmtpfs fuse

Создадим каталог, в который будет смонтирована ФС смартфона:

.. code-block:: text

    mkdir -p ~/myphone

Подключим устройство к компьютеру или ноутбуку по USB, разблокируем его и выберем режим MTP, после чего выполним:

.. code-block:: text

    jmtpfs ~/myphone

По окончании работы обязательно завершим MTP сессию:

.. code-block:: text

    fusermount -u ~/myphone

.. index:: kde connect, smartphone, kde
.. _kde-connect:

Как лучше работать со смартфоном посредством компьютера или ноутбука?
==========================================================================

Для простой и эффективной работы со смартфоном на базе ОС Android пользователи рабочей среды KDE Plasma 5 могут использовать KDE Connect:

.. code-block:: text

    sudo dnf install kde-connect

Сначала установим клиент KDE Connect на смартфон:

 * `Google Play <https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp>`__;
 * `F-Droid <https://f-droid.org/packages/org.kde.kdeconnect_tp/>`__;

Запустим плазмоид KDE Connect и выполним сопряжение.

.. index:: kde connect, firewalld
.. _kde-connect-firewalld:

KDE Connect не видит мой смартфон. Как исправить?
======================================================

Добавим правило, разрешающее входящие соединения к сервису kdeconnectd посредством :ref:`Firewalld <firewalld-about>`:

.. code-block:: text

    sudo firewall-cmd --add-service=kde-connect --permanent

Применим новые правила:

.. code-block:: text

    sudo firewall-cmd --reload

.. index:: kde, plasma, new file, dolphin, templates
.. _dolphin-templates:

Как добавить новый тип файлов в меню Создать в Dolphin?
==========================================================

Сначала получим пути, в которых KDE пытается обнаружить *ярлыки* шаблонов новых файлов:

.. code-block:: text

    kf5-config --path templates

По умолчанию это ``~/.local/share/templates`` и он не существует, поэтому создадим его:

.. code-block:: text

    mkdir -p ~/.local/share/templates

В качестве примера сохраним в любом каталоге новый шаблон ``xml-document.xml`` примерно следующего содержания:

.. code-block:: xml

    <?xml version="1.0" encoding="utf-8" ?>
    <root>
    </root>

В каталоге шаблонов KDE добавим ярлык ``xml-document.desktop`` на созданный ранее файл:

.. code-block:: ini

    [Desktop Entry]
    Icon=application-xml
    Name[ru_RU]=Документ XML
    Name=XML document
    Type=Link
    URL[$e]=file:$HOME/Templates/xml-document.xml

Здесь **Icon** - значок для новой строки, **Name** - название новой строки с поддержкой локализации, а **URL** - полный путь к файлу шаблона.

Изменения вступят в силу немедленно и через несколько секунд в меню *Создать* файлового менеджера Dolphin появится новый пункт.

.. index:: gnome, nautilus, new file, templates
.. _nautilus-templates:

Как добавить новый тип файлов в меню Создать в Nautilus?
============================================================

В отличие от :ref:`Dolphin в KDE <dolphin-templates>`, Nautilus в Gnome ищет файлы шаблонов в стандартном каталоге :ref:`$XDG_TEMPLATES_DIR <xdg-reallocate>`. Получим путь к нему:

.. code-block:: text

    xdg-user-dir TEMPLATES

Создадим новый файл ``XML document.xml`` следующего содержания:

.. code-block:: xml

    <?xml version="1.0" encoding="utf-8" ?>
    <root>
    </root>

Изменения вступят в силу немедленно и через несколько секунд в меню *Создать* файлового менеджера Nautilus появится новый пункт.

.. index:: chromium, chrome, browser, command line, web
.. _chromium-commandline:

Как постоянно запускать браузер Chromium с определёнными параметрами?
=========================================================================

Для того, чтобы постоянно запускать браузер Chromium с определёнными `параметрами запуска <https://peter.sh/experiments/chromium-command-line-switches/>`__, необходимо создать файл ``~/.config/chromium-flags.conf`` и прописать их в нём.

В качестве разделителя применяется пробел, либо символ разрыва строки. Строки, которые начинаются с символа решётки (**#**) считаются комментариями и игнорируются.

Пример:

.. code-block:: text

    # Переопределим каталог хранения дискового кэша.
    --disk-cache-dir /tmp/chromium
    # Установим предельный размер дискового кэша.
    --disk-cache-size 268435456

.. index:: thunderbird, mail client, email, extension, translation, lightning, langpack
.. _thunderbird-symlinks:

В установленном Thunderbird не обновляется расширение Lightning и языковые пакеты. Как исправить?
====================================================================================================

Проблема заключается в том, что системные расширения и пакеты с переводами должны копироваться в профиль пользователя при каждом обновлении клиента, но RPM пакетам `запрещено <https://docs.fedoraproject.org/en-US/packaging-guidelines/>`__ вносить любые изменения в домашние каталоги пользователей, поэтому они автоматически не обновляются.

Чтобы исправить проблему необходимо и достаточно создать символические ссылки на XPI файлы, обновляемые пакетом.

Удалим старые файлы из профилей Thunderbird:

.. code-block:: text

    rm -f ~/.thunderbird/*/extensions/langpack-ru@thunderbird.mozilla.org.xpi
    rm -f ~/.thunderbird/*/extensions/{e2fda1a4-762b-4020-b5ad-a41df1933103}.xpi
    rm -f ~/.thunderbird/*/extensions/langpack-cal-ru@lightning.mozilla.org.xpi

Создадим символические ссылки на месте удалённых XPI файлов:

.. code-block:: text

    ln -s /usr/lib64/thunderbird/distribution/extensions/langpack-ru@thunderbird.mozilla.org.xpi ~/.thunderbird/*/extensions/langpack-ru@thunderbird.mozilla.org.xpi
    ln -s /usr/lib64/thunderbird/distribution/extensions/{e2fda1a4-762b-4020-b5ad-a41df1933103}.xpi ~/.thunderbird/*/extensions/{e2fda1a4-762b-4020-b5ad-a41df1933103}.xpi
    ln -s /usr/lib64/thunderbird/distribution/extensions/langpack-cal-ru@lightning.mozilla.org.xpi ~/.thunderbird/*/extensions/langpack-cal-ru@lightning.mozilla.org.xpi

Перезапустим Thunderbird для того, чтобы изменения вступили в силу.

.. index:: qr code, bar code, image
.. _qr-code:

Как распознать QR-код или штрих-код из консоли?
===================================================

Для распознавания бар-кода на изображении и получения его содержимого воспользуемся пакетом **zbar**:

.. code-block:: text

    sudo dnf install zbar

Применим утилиту **zbarimg** для получения содержимого кодов внутри файла изображения ``foo-bar.png``:

.. code-block:: text

    zbarimg --noxml foo-bar.png

Результат (или результаты (по одному на каждый обнаруженный бар-код)) будут выведены в консоль.

.. index:: scanner, pdf, ocr, text
.. _ocr-app:

Как можно распознать текст с изображения или сканера?
========================================================

Для получения текста из файлов изображений, либо PDF, можно воспользоваться системой оптического распознавания символов Tesseract, а также графической утилитой gImageReader.

Установим Tesseract и набор файлов для русского языка:

.. code-block:: text

    sudo dnf install tesseract tesseract-langpack-rus

Установим утилиту gImageReader с интерфейсом на Qt (для пользователей KDE, LXQt):

.. code-block:: text

    sudo dnf install gimagereader-qt

Установим утилиту gImageReader с интерфейсом на GTK3 (для пользователей Gnome, XFCE, LXDE, Mate, Cinnamon и т.д.):

.. code-block:: text

    sudo dnf install gimagereader-gtk

Запустим gImageReader, в левой боковой панели выберем отсканированный файл (для наилучших результатов разрешение при сканировании должно быть не меньше 300 DPI), PDF, либо :ref:`устройство сканирования <scan-drivers>`, зададим режим распознавания и используемые в документе языки, затем нажмём кнопку **Распознать всё**.

Результат может быть сохранён в файл с панели результатов распознавания.

.. index:: zip, archive, encoding, file
.. _zip-encoding:

При распаковке Zip архива появляются кракозябры вместо имён файлов. Как исправить?
=====================================================================================

Zip-архивы, созданные штатными средствами ОС Windows, сохраняют имена файлов внутри архива исключительно в однобайтовой кодировке системы по умолчанию (в русской версии это Windows-1251 (cp1251), в английской - Windows-1252 (cp1252)), поэтому при распаковке таких архивов вместо русских букв будут отображаться кракозябры.

Утилита unzip поддерживает явное указание кодировки, поэтому воспользуемся данной функцией:

.. code-block:: text

    unzip -O cp1251 foo-bar.zip -d /path/to/destination

Здесь **cp1251** - кодировка имён файлов, **foo-bar.zip** - имя архива, а **/path/to/destination** - каталог, в который он будет распакован.

.. index:: cache, browser, tmpfs
.. _browser-tmpfs:

Стоит ли переносить кэши браузеров в tmpfs?
===============================================

Да, т.к. это даёт следующие преимущества:

  1. очень быстрый доступ особенно при случайном чтении;
  2. отсутствует необходимость в ручной очистке, т.к. это будет сделано автоматически при перезагрузке системы.

.. index:: cache, browser, tmpfs, firefox
.. _firefox-cache:

Как перенести кэш браузера Firefox в tmpfs?
==============================================

В Fedora каталог **/tmp** по умолчанию монтируется в tmpfs, поэтому осуществим перенос кэшей данного браузера именно в него:

  1. запустим Firefox и откроем страницу ``about:config``;
  2. найдём в списке переменную ``browser.cache.disk.parent_directory`` (при отсутствии создадим) и присвоим ему строковое значение ``/tmp/firefox``;
  3. чтобы кэш очень сильно не разрастался, укажем в переменной ``browser.cache.disk.capacity`` максимальный размер в байтах, например ``262144`` (256 МБ);
  4. перезапустим браузер для применения новых изменений.

.. index:: wget, http, web, download
.. _wget-crawler:

Как скачать веб-страницу рекурсивно?
=======================================

Для рекурсивного скачивания статических веб-страниц можно использовать wget в специальном режиме.

Запустим скачивание ресурса **example.org**:

.. code-block:: text

    wget --random-wait -r -p -e robots=off -U "Mozilla/5.0 (X11; Linux x86_64; rv:66.0) Gecko/20100101 Firefox/66.0" https://example.org

Рекурсивное скачивание может занять много времени и места на диске. Настоятельно не рекомендуется использовать этот режим на ресурсах с динамическим контентом.

.. index:: exif, jpeg, information, metadata
.. _exif-data:

Как извлечь метаданные EXIF из файла изображения?
====================================================

Установим пакет ImageMagick:

.. code-block:: text

    sudo dnf install ImageMagick

Осуществим извлечение метаданных `EXIF <https://ru.wikipedia.org/wiki/EXIF>`__ файла **foo-bar.jpg**:

.. code-block:: text

    identify -verbose foo-bar.jpg

.. index:: wget, http, web, bookmarks, check
.. _wget-spider:

Как проверить действительность ссылок в закладках без сторонних расширений?
==============================================================================

Проверить действительность любых ссылок, указанных в файле, можно средствами **wget** в режиме *spider*.

Запустим веб-браузер и экспортируем список закладок в файл, совместимый с форматом *Netscape Bookmarks*. В Firefox это можно сделать так:

  1. **Закладки** - **Показать все закладки**;
  2. **Импорт и резервные копии** - **Экспорт закладок в HTML файл**;
  3. сохраняем файл **bookmarks.html** в любом каталоге.

Перейдём в каталог, в котором находится файл **bookmarks.html** и запустим проверку:

.. code-block:: text

    wget --spider --force-html --no-verbose --tries=1 --timeout=10 -i bookmarks.html

В зависимости от размера файла процесс проверки может занять очень много времени.

.. index:: steam, gaming
.. _steam:

Как установить Steam в Fedora?
=================================

Подключим репозитории :ref:`RPM Fusion <rpmfusion>` (как free, так и nonfree), после чего установим его:

.. code-block:: text

    sudo dnf install steam

Ярлык запуска клиента Steam появится в главном меню используемой графической среды.

.. index:: gnome, shell, extension
.. _gnome-shell-extensions:

Откуда правильно устанавливать расширения для Gnome Shell?
==============================================================

Расширения для Gnome Shell можно устанавливать как в виде пакета из репозиториев, так и напрямую из `Магазина расширений Gnome <https://extensions.gnome.org/>`__. Разница лишь в том, что расширения, установленные пакетом, будут доступны сразу для всех пользователей системы.

Рекомендуется устанавливать расширения из Магазина, т.к. многие пакеты очень редко получают обновления.

.. index:: gnome, shell, extension, firefox, chromium
.. _gnome-shell-browser:

Как разрешить установку расширений Gnome Shell из веб-браузера?
==================================================================

Для того, чтобы разрешить установку :ref:`расширений Gnome Shell <gnome-shell-extensions>` из браузеров, необходимо установить соответствующий пакет:

.. code-block:: text

    sudo dnf install gnome-shell-browser

Также данное дополнение можно установить и вручную:

 * `Firefox <https://addons.mozilla.org/ru/firefox/addon/gnome-shell-integration/>`__;
 * `Chrome/Chromium <https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=ru>`__.

.. index:: kde, plasma, extension, firefox, chromium
.. _plasma-browser:

Как разрешить установку расширений KDE Plasma из веб-браузера?
=================================================================

Для того, чтобы разрешить установку расширений оболочки KDE Plasma из браузеров, необходимо установить соответствующий пакет:

.. code-block:: text

    sudo dnf install plasma-browser-integration

Также данное дополнение можно установить и вручную:

 * `Firefox <https://addons.mozilla.org/ru/firefox/addon/plasma-integration/>`__;
 * `Chrome/Chromium <https://chrome.google.com/webstore/detail/plasma-integration/cimiefiiaegbelhefglklhhakcgmhkai?hl=ru>`__.

.. index:: gnome, shell, tray, system tray, icon
.. _gnome-shell-tray:

Как вернуть классический системный лоток (трей) в Gnome Shell?
==================================================================

Начиная с Gnome 3.26, из области уведомлений оболочки была удалена поддержка классического системного лотка, поэтому многие приложения при закрытии или сворачивании могут не завершать свою работу, а продолжать работать в фоне без отображения видимого окна.

Восстановить трей можно посредством установки одного из :ref:`расширений Gnome Shell <gnome-shell-extensions>`. Самым популярным является `TopIcons Plus <https://extensions.gnome.org/extension/1031/topicons/>`__.

Установка для всех пользователей в виде пакета из репозиториев Fedora:

.. code-block:: text

    sudo dnf install gnome-shell-extension-topicons-plus

.. index:: 7zip, archive, split, optical drive, dvd, p7zip
.. _7zip-split:

Как упаковать содержимое каталога в архив с разделением на части, пригодные для записи на диск?
==================================================================================================

Установим пакет **p7zip**:

.. code-block:: text

    sudo dnf install p7zip

Упакуем содержимое текущего каталога в 7-Zip архив с использованием алгоритма сжатия LZMA2 c разбиением на тома размером 4480 МБ (для размещения на DVD носителях):

.. code-block:: text

    7za a -m0=LZMA2 -mx9 -r -t7z -v4480m /path/to/archive.7z

.. index:: kerberos, remote, login, authorization, renewal, gnome
.. _kerberos-gnome:

Как настроить автоматическое обновление Kerberos-тикетов в Gnome?
====================================================================

Актуальные версии среды Gnome поддерживают автоматическое :ref:`обновление <kerberos-renew>` :ref:`Kerberos-тикетов <kerberos-auth>` "из коробки".

Откроем **настройки Gnome**, выберем пункт **Онлайн учётные записи**, нажмём кнопку с символом **+** для добавления нового, в конце списка выберем вариант **Другие**, а затем **Enterprise login (Kerberos)**.

В появившемся окне введём авторизационные данные и подтвердим добавление аккаунта.

.. index:: torrent, download, transmission, server
.. _transmission-server:

Как запустить фоновый клиент для загрузки торрентов?
=======================================================

Установим Transsmission в виде сервиса:

.. code-block:: text

    sudo dnf install transmission-daemon

Установим "тонкий клиент" Transsmission Remote:

.. code-block:: text

    sudo dnf install transmission-remote-gtk

Активируем и запустим сервер:

.. code-block:: text

    sudo systemctl enable --now transmission-daemon.service

В Firewalld разрешим входящие BitTorrent подключения:

.. code-block:: text

    sudo firewall-cmd --add-service=transmission-client --permanent

Запустим "тонкий клиент", подключимся к серверу **127.0.0.1:9091**, перейдём в **Опции** - **Настройки сервера** и внесём свои правки, указав например каталог для загрузок.

Изменения вступают в силу немедленно. Сервер будет запускаться автоматически при каждой загрузке системы и сразу же осуществлять загрузку, либо раздачу торрентов.

.. index:: gnome, shell, settings, reset
.. _gnome-shell-reset:

Как сбросить все настройки Gnome Shell?
==========================================

Чтобы сбросить все настройки Gnome и Gnome Shell, выполним:

.. code-block:: text

    dconf reset -f /

Это действие удалит все настройки Gnome, включая приложения, использующие dconf для хранения пользовательских настроек, аккаунтов и т.д., параметры системы, настройки среды, установленные темы и расширения и т.д. Перед использованием рекомендуется создать резеврную копию.

При следующем входе будут восстановлены значения по умолчанию.
