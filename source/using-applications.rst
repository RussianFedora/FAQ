..
    SPDX-FileCopyrightText: 2018-2022 EasyCoding Team and contributors

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _using-applications:

**********************
Сторонние приложения
**********************

.. index:: firefox, hardware acceleration
.. _firefox-hwaccel:

Как активировать аппаратное ускорение в браузере Firefox?
=============================================================

Для активации аппаратного ускорения рендеринга страниц в Mozilla Firefox на поддерживаемых драйверах необходимо открыть модуль конфигурации ``about:config`` и исправить значения следующих переменных (при отсутствии создать):

.. code-block:: text

    layers.acceleration.force-enabled = true
    webgl.force-enabled = true
    gfx.webrender.enabled = true
    gfx.webrender.all = true
    dom.webgpu.enabled = true

Изменения вступят в силу при следующем запуске браузера.

Внимание! Это не затрагивает :ref:`аппаратное декодирование мультимедиа <browser-hwaccel>` средствами видеоускорителя.

.. index:: firefox, chromium, chrome, hardware acceleration, vaapi
.. _browser-hwaccel:

Как активировать аппаратное ускорение декодирования мультимедиа в браузерах?
===============================================================================

Поддерживаемые веб-браузеры:

  * :ref:`Mozilla Firefox <hwaccel-firefox>`;
  * :ref:`Chromium <hwaccel-chromium>`.

.. index:: firefox, chromium, chrome, hardware acceleration, vaapi
.. _hwaccel-firefox:

Как активировать аппаратное ускорение декодирования мультимедиа в Firefox?
===============================================================================

Начиная с версии `Firefox 77.0 <https://mastransky.wordpress.com/2020/06/03/firefox-on-fedora-finally-gets-va-api-on-wayland/>`__, аппаратное ускорение декодирования мультимедиа доступно для :ref:`сеанса Wayland <session-type>`, а с `Firefox 81.0 <https://mastransky.wordpress.com/2020/09/29/firefox-81-on-fedora-with-va-api-webrtc-and-x11/>`__ и для X11.

Установим полный :ref:`набор кодеков <firefox-codecs>`, а также :ref:`VA-API драйверы <hwaccel-drivers>` из репозитория :ref:`RPM Fusion <rpmfusion>`.

Откроем модуль конфигурации ``about:config`` и изменим значения следующих переменных (при отсутствии создадим):

.. code-block:: text

    widget.wayland-dmabuf-vaapi.enabled = true
    media.ffmpeg.vaapi.enabled = true
    media.ffmpeg.low-latency.enabled = true
    media.navigator.mediadatadecoder_vpx_enabled = true

В случае использования сеанса на базе :ref:`Wayland <session-type>` ввиду `известной ошибки <https://bugzilla.mozilla.org/show_bug.cgi?id=1683808>`__ отключим встроенную песочницу для декодировщика мультимедиа (это значительно снизит безопасность браузера):

.. code-block:: text

    media.ffvpx.enabled = false
    media.rdd-ffvpx.enabled = false
    media.rdd-vpx.enabled = false

Перезапустим браузер для вступления изменений в силу.

.. index:: chromium, chrome, hardware acceleration, vaapi
.. _hwaccel-chromium:

Как активировать аппаратное ускорение декодирования мультимедиа в Chromium?
===============================================================================

В Google Chrome и Chromium аппаратное ускорение декодирования мультимедиа реализовано, но отключено в официальных сборках на этапе компиляции для GNU/Linux платформы.

Репозиторий :ref:`RPM Fusion <rpmfusion>` предоставляет сборку Chromium с включённой поддержкой :ref:`VA-API <video-hwaccel>`. Для её установки активируем его, установим :ref:`VA-API драйверы <hwaccel-drivers>`, а также пакет **chromium-freeworld**:

.. code-block:: text

    sudo dnf install chromium-freeworld

Далее в Chromium Freeworld зайдём в ``chrome://flags`` и установим для пункта **Hardware decoding** значение **Enabled**, после чего перезапустим браузер для вступления изменений в силу.

.. index:: mpv, video player, hardware acceleration, vaapi, vdpau
.. _video-hwaccel:

В каких проигрывателях реализовано аппаратное ускорение декодирования мультимедиа?
=====================================================================================

Полная поддержка аппаратного декодирования мультимедиа средствами :ref:`VA-API <vaapi-info>` (:ref:`Intel <vaapi-intel>`, :ref:`NVIDIA <vaapi-nvidia>`, AMD) или VPDAU (NVIDIA) реализована в проигрывателях VLC и mpv.

Для активации данной функции необходимо в качестве графического бэкэнда вывода изображения указать **vaapi** или **vdpau**, после чего перезапустить плеер.

.. index:: hardware acceleration, vaapi, intel, nvidia, amd
.. _vaapi-info:

Как получить информацию о поддерживаемых VA-API форматах видео?
==================================================================

Установим утилиту **vainfo**:

.. code-block:: text

    sudo dnf install libva-utils

Выведем информацию о поддерживаемых форматах и профилях:

.. code-block:: text

    vainfo

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

Из-за патентных ограничений браузер Chromium в репозиториях Fedora сильно кастрирован. Для восстановления полной функциональности необходимо подключить :ref:`RPM Fusion <rpmfusion>` и установить пакет с полной версией:

.. code-block:: text

    sudo dnf install chromium-freeworld

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

.. index:: video, youtube, download, yt-dlp, ffmpeg
.. _youtube-download:

Как скачать видео с Youtube?
=================================

Скачать любое интересующее видео с Youtube, а также ряда других хостингов, можно посредством утилиты **yt-dlp**, доступной в основном репозитории Fedora:

.. code-block:: text

    sudo dnf install yt-dlp

Скачивание видео с настройками по умолчанию в наилучшем качестве:

.. code-block:: text

    yt-dlp https://www.youtube.com/watch?v=XXXXXXXXXX

Иногда при скачивании видео в разрешении 4K с ключом ``-f bestvideo`` может не работать аппаратное ускорение при воспроизведении из-за того, что кодек vp9.2 не поддерживается аппаратными кодировщиками. В таких случаях необходимо явно указывать кодек (``-f bestvideo[vcodec=vp9]``).

Чтобы гарантировано скачать видео с указанным кодеком со звуком требуется дополнительно установить пакет **ffmpeg** из репозиториев :ref:`RPM Fusion <rpmfusion>`:

.. code-block:: text

    sudo dnf install ffmpeg

В качестве примера скачаем видео в наилучшем качестве, сжатое кодеком VP9 (с возможностью аппаратного ускорения) и звуком:

.. code-block:: text

    yt-dlp -f bestvideo[vcodec=vp9]+bestaudio https://www.youtube.com/watch?v=XXXXXXXXXX

Поддерживается автоматическое удаление спонсорских интеграций из видеоряда на основе базы данных `SponsorBlock <https://sponsor.ajay.app/>`__, активируемое параметром ``--sponsorblock-remove=sponsor``:

.. code-block:: text

    yt-dlp -f bestvideo+bestaudio --sponsorblock-remove=sponsor https://www.youtube.com/watch?v=XXXXXXXXXX

Данная утилита имеет множество параметров командной строки, справку по которым можно найти в её странице man:

.. code-block:: text

    man yt-dlp

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

Здесь **test.txt** -- исходный файл с неправильной кодировкой, а **result.txt** используется для записи результата преобразования.

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
  * `F-Droid <https://f-droid.org/packages/org.kde.kdeconnect_tp/>`__.

Запустим плазмоид KDE Connect и выполним сопряжение.

.. index:: kde connect, firewalld
.. _kde-connect-firewalld:

KDE Connect не видит мой смартфон. Как исправить?
======================================================

Добавим правило, разрешающее входящие соединения к сервису kdeconnectd посредством :ref:`Firewalld <firewalld-about>`:

.. code-block:: text

    sudo firewall-cmd --add-service=kdeconnect --permanent

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

Здесь **Icon** -- значок для новой строки, **Name** -- название новой строки с поддержкой локализации, а **URL** -- полный путь к файлу шаблона.

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

.. index:: converting multiple files, convert, find, ffmpeg, mp3
.. _convert-multiple-files:

Как конвертировать множество файлов в mp3 из текущего каталога?
===================================================================

Конвертируем все файлы с маской \*.ogg в mp3 в текущем каталоге:

.. code-block:: text

    find . -maxdepth 1 -type f -name "*.ogg" -exec ffmpeg -i "{}" -acodec mp3 -ab 192k "$(basename {}).mp3" \;

.. index:: window, borders, kde plasma, kde
.. _window-borders:

Как убрать рамки внутри окон в KDE Plasma 5?
===============================================

Для этого следует открыть **Меню KDE** -- **Компьютер** -- **Параметры системы** -- **Оформление приложений** -- страница **Стиль интерфейса** -- кнопка **Настроить** -- вкладка **Рамки**, **убрать все флажки** из чекбоксов на данной странице и нажать кнопку **OK**.

.. index:: icons, cache, kde, plasma
.. _kde-icons-refresh:

Как обновить кэш значков приложений в главном меню KDE Plasma 5?
===================================================================

Обычно кэш обновляется автоматически при любых изменениях файлов внутри каталогов ``/usr/share/applications`` (глобально), а также ``~/.local/share/applications`` (пользователь), однако если по какой-то причине этого не произошло, выполним обновление кэшей вручную:

.. code-block:: text

    kbuildsycoca5 --noincremental

.. index:: thunderbird, mail client, email, extension, translation, langpack
.. _thunderbird-symlinks:

В установленном Thunderbird не обновляются языковые пакеты. Как исправить?
===============================================================================

Проблема заключается в том, что системные расширения и пакеты с переводами должны копироваться в профиль пользователя при каждом обновлении клиента, но RPM пакетам `запрещено <https://docs.fedoraproject.org/en-US/packaging-guidelines/>`__ вносить любые изменения в домашние каталоги пользователей, поэтому они автоматически не обновляются.

Чтобы исправить проблему необходимо и достаточно создать символические ссылки на XPI файлы, обновляемые пакетом.

Удалим старые файлы из профилей Thunderbird:

.. code-block:: text

    rm -f ~/.thunderbird/*/extensions/langpack-ru@thunderbird.mozilla.org.xpi

Создадим символические ссылки на месте удалённых XPI файлов:

.. code-block:: text

    ln -s /usr/lib64/thunderbird/distribution/extensions/langpack-ru@thunderbird.mozilla.org.xpi ~/.thunderbird/*/extensions/langpack-ru@thunderbird.mozilla.org.xpi

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

Zip-архивы, созданные штатными средствами ОС Windows, сохраняют имена файлов внутри архива исключительно в однобайтовой кодировке системы по умолчанию (в русской версии это Windows-1251 (cp1251), в английской -- Windows-1252 (cp1252)), поэтому при распаковке таких архивов вместо русских букв будут отображаться кракозябры.

Утилита unzip поддерживает явное указание кодировки, поэтому воспользуемся данной функцией:

.. code-block:: text

    unzip -O cp1251 foo-bar.zip -d /path/to/destination

Здесь **cp1251** -- кодировка имён файлов, **foo-bar.zip** -- имя архива, а **/path/to/destination** -- каталог, в который он будет распакован.

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
  3. чтобы кэш очень сильно не разрастался, укажем в переменной ``browser.cache.disk.capacity`` (тип *целое*) максимальный размер в килобайтах, например ``262144`` (256 МБ);
  4. перезапустим браузер для применения новых изменений.

.. index:: wget, http, web, download
.. _wget-crawler:

Как скачать веб-страницу рекурсивно?
=======================================

Для рекурсивного скачивания статических веб-страниц можно использовать wget в специальном режиме.

Запустим скачивание ресурса **example.org**:

.. code-block:: text

    wget --random-wait -r -p -e robots=off -U "Mozilla/5.0 (X11; Linux x86_64; rv:100.0) Gecko/20100101 Firefox/100.0" https://example.org

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

  1. **Закладки** -- **Показать все закладки**;
  2. **Импорт и резервные копии** -- **Экспорт закладок в HTML файл**;
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

Восстановить трей можно посредством установки одного из :ref:`расширений Gnome Shell <gnome-shell-extensions>`:

  * `AppIndicator Support <https://extensions.gnome.org/extension/615/appindicator-support/>`__ (также доступно в виде пакета ``gnome-shell-extension-appindicator`` в репозиториях);
  * `TopIcons Plus <https://extensions.gnome.org/extension/1031/topicons/>`__ (также доступно в виде пакета ``gnome-shell-extension-topicons-plus`` в репозиториях).

.. index:: gnome, shell, desktop, icon
.. _gnome-shell-desktop:

Как вернуть классический рабочий стол в Gnome Shell?
=======================================================

Начиная с Gnome 3.28, поддержка рабочего стола с возможностью размещения на нём файлов, либо ярлыков приложений, была удалена.

Восстановить классический рабочий стол можно при помощи установки :ref:`расширения Gnome Shell <gnome-shell-extensions>` `Desktop Icons <https://extensions.gnome.org/extension/1465/desktop-icons/>`__ (также доступно в виде пакета ``gnome-shell-extension-desktop-icons`` в репозиториях).

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

Запустим "тонкий клиент", подключимся к серверу **127.0.0.1:9091**, перейдём в **Опции** -- **Настройки сервера** и внесём свои правки, указав например каталог для загрузок.

Изменения вступают в силу немедленно. Сервер будет запускаться автоматически при каждой загрузке системы и сразу же осуществлять загрузку, либо раздачу торрентов.

.. index:: gnome, shell, settings, reset
.. _gnome-shell-reset:

Как сбросить все настройки Gnome Shell?
==========================================

Чтобы сбросить все настройки Gnome и Gnome Shell, выполним:

.. code-block:: text

    dconf reset -f /

Это действие удалит все настройки Gnome, включая приложения, использующие dconf для хранения пользовательских настроек, аккаунтов и т.д., параметры системы, настройки среды, установленные темы и расширения и т.д. Перед использованием рекомендуется создать резервную копию.

При следующем входе будут восстановлены значения по умолчанию.

.. index:: directory, tree
.. _directory-tree:

Как построить дерево каталогов и сохранить его в файл?
=========================================================

Для построения дерева каталогов воспользуемся утилитой **tree**, затем перенаправим вывод в файл:

.. code-block:: text

    tree /path/to/directory > ~/foo-bar.txt

Здесь **/path/to/directory** -- путь к каталогу, дерево которого нужно построить, а **~/foo-bar.txt** -- файл, в котором будет сохранён результат.

.. index:: recycle bin, delete file, trash, terminal
.. _trash-terminal:

Как из терминала удалить файл в корзину?
===========================================

Для удаления в корзину из оболочки воспользуемся утилитой **gio**:

.. code-block:: text

    gio trash /path/to/file.txt

.. index:: irc, certificate, login, hexchat, liberachat, openssl, sasl
.. _irc-nopass:

Можно ли входить в IRC сеть LiberaChat без ввода пароля?
============================================================

Да, сеть LiberaChat поддерживает вход по ключам.

Создадим каталог для хранения ключей HexChat:

.. code-block:: text

    mkdir -p ~/.config/hexchat/certs

Воспользуемся утилитой **openssl**, чтобы сгенерировать новую ключевую пару:

.. code-block:: text

    openssl req -x509 -new -newkey rsa:4096 -sha256 -days 1825 -nodes -out ~/.config/hexchat/certs/liberachat.pem -keyout ~/.config/hexchat/certs/liberachat.pem

Будут заданы стандартные вопросы. На них можно отвечать как угодно (сервер не проверяет валидность данных), за исключением **Common Name** (зарегистрированный ник в сети LiberaChat) и **Email Address** (привязанный к учётной записи адрес электронной почты).

Установим корректный chmod:

.. code-block:: text

    chmod 0400 ~/.config/hexchat/certs/liberachat.pem

Запустим HexChat, откроем список сетей и убедимся, что FreeNode называется **liberachat** (в нижнем регистре; важно, чтобы имя файла сертификата соответствовало названию сети). Если это не так, нажмём **F2** и осуществим переименование.

Зайдём в расширенные настройки сети liberachat, укажем в качестве основного сервера ``irc.liberachat.net/6697`` (остальные лучше вообще удалить), затем установим следующие параметры:

  * флажок **соединяться только с выделенным сервером** -- включено;
  * флажок **использовать SSL для всех серверов в этой сети** -- включено;
  * **метод авторизации** -- SASL external (cert).

Получим SHA1 отпечаток созданного сертификата:

.. code-block:: text

    openssl x509 -in ~/.config/hexchat/certs/freenode.pem -outform der | sha512sum -b | cut -d' ' -f1

Подключимся к серверу, затем авторизуемся в системе:

.. code-block:: text

    /ns identify PASSWORD

Добавим SHA1 отпечаток сертификата в доверенные:

.. code-block:: text

    /ns cert add XXXXXXXXXX

Здесь **PASSWORD** -- текущий пароль пользователя, а **XXXXXXXXXX** -- отпечаток сертификата.

Теперь можно отключиться и подключиться заново. Вход будет выполнен уже безопасным способом без использования паролей.

.. index:: kde, plasma, kickoff, menu, icons, reset, kactivitymanagerd
.. _kickoff-reset:

В меню KDE перестали отображаться значки приложений и документов. Как исправить?
===================================================================================

Исчезновение значков приложений, либо документов в меню KDE Plasma 5 часто происходит при повреждении баз данных компонента KDE activity manager.

Произведём удаление старых баз (при необходимости можно сделать резервную копию):

.. code-block:: text

    rm -rf ~/.local/share/kactivitymanagerd

При следующем входе в систему все настройки Kickoff будут сброшены, включая страницу *Избранное* и при этом должна восстановиться его правильная работа.

.. index:: firefox, browser, sqlite, database, vacuum, compress, find
.. _firefox-vacuum:

Как сжать базы данных sqlite браузера Firefox?
=================================================

Браузер Mozilla Firefox сохраняет данные внутри стандартных баз sqlite3, поэтому даже после очистки истории, cookies, кэшей и т.д. их размер на диске не уменьшается, т.к. данные в них лишь помечаются удалёнными, а непосредственная очистка (vacuum) производится по таймеру во время простоя несколько раз в месяц.

Сжать все базы данных можно и вручную. Для этого установим пакет sqlite:

.. code-block:: text

    sudo dnf install sqlite

Убедимся, что Firefox **не запущен**, затем выполним команду vaccuum для всех sqlite файлов внутри локальных профилей браузера:

.. code-block:: text

    find ~/.mozilla/firefox -name "*.sqlite" -exec sqlite3 "{}" VACUUM \;

Это действие абсолютно безопасно, т.к. физически удаляет лишь те данные, которые в них были помечены в качестве удалённых.

.. index:: flash, usb, check, f3
.. _f3chk-safe:

Как безопасно проверить объём накопителя?
============================================

Установим пакет **f3**:

.. code-block:: text

    sudo dnf install f3

Подключим накопитель и смонтируем его, затем начнём проверку:

.. code-block:: text

    f3write /media/foo-bar

По окончании работы осуществим проверку записанных данных:

.. code-block:: text

    f3read /media/foo-bar

Если проверки прошли успешно, накопитель имеет действительный объём.

Удалим созданные проверочные данные:

.. code-block:: text

    find /media/foo-bar -name *.h2w -delete \;

Здесь **/media/foo-bar** -- точка монтирования накопителя, объём которого требуется проверить.

.. index:: flash, usb, check, f3
.. _f3chk-deep:

Как выполнить глубокую проверку объёма накопителя?
=====================================================

Установим пакет **f3**:

.. code-block:: text

    sudo dnf install f3

Подключим накопитель, но не будем его монтировать.

Внимание! Все данные с этого устройства будет безвозвратно потеряны.

Запустим глубокую проверку:

.. code-block:: text

    sudo f3probe --destructive --time-ops /dev/sdb

Здесь **/dev/sdb** -- устройство, объём которого требуется проверить.

После завершения процесса потребуется заново создать раздел и файловую систему на проверяемом устройстве при помощи таких утилит, как GParted, Gnome Disks, KDE Disk Manager и т.д.

.. index:: latex, texlive, pdf, markdown, xelatex, xetex
.. _markdown-pdf:

Как из документа в формате Markdown создать PDF?
====================================================

Установим универсальный конвертер документов pandoc:

.. code-block:: text

    sudo dnf install pandoc

Установим движок xelatex:

.. code-block:: text

    sudo dnf install texlive-xetex

Преобразуем документ ``foo-bar.md`` из формата Markdown в PDF:

.. code-block:: text

    pandoc foo-bar.md --pdf-engine=xelatex --variable papersize=a4 --variable fontsize=12pt --variable mathfont="DejaVu Sans" --variable mainfont="DejaVu Serif" --variable sansfont="DejaVu Sans" --variable monofont="DejaVu Sans Mono" -o foo-bar.pdf

Допускается указать любые установленные в системе OpenType шрифты.

.. index:: du, disk usage, coreutils, directory size, console
.. _directory-size-console:

Как из консоли получить размер каталога вместе со всем его содержимым?
=========================================================================

Выведем общий размер каталога в человеко-читаемом формате, включая вложенные объекты:

.. code-block:: text

    du -sh ~/foo-bar

.. index:: du, disk usage, coreutils, directory size, console
.. _directory-size-top:

Как из консоли вывести список десяти самых крупных каталогов?
=================================================================

Вывыдем список десяти самых крупных каталогов:

.. code-block:: text

    du -hs /path/to/directory/* 2>/dev/null | sort -rh | head -10

Здесь **/path/to/directory** -- начальный каталог.

.. index:: disk usage, directory size, filelight, baobab
.. _directory-size-gui:

Как вывести содержимое каталога в графическом виде?
======================================================

В графическом режиме для визуализации содержимого каталога могут применяться такие утилиты, как **Baobab** (Gnome, GTK), либо **Filelight** (KDE, Qt).

Установим **Baobab** (для пользователей Gnome или других DE, основанных на GTK):

.. code-block:: text

    sudo dnf install baobab

Установим **Filelight** (для пользователей KDE):

.. code-block:: text

    sudo dnf install filelight

.. index:: kde, plasma, restart, shell
.. _plasma-restart:

Как перезапустить зависшую оболочку KDE Plasma 5?
====================================================

Перезапустим KDE Plasma 5:

.. code-block:: text

    kquitapp5 plasmashell && kstart plasmashell

.. index:: kde, plasma, restart, window manager, kwin, x11, wayland
.. _kwin-restart:

Как перезапустить оконный менеджер KDE Plasma 5?
====================================================

Перезапустим оконный менеджер KWin, работающий поверх X11:

.. code-block:: text

    kwin_x11 --replace &>/dev/null &

Перезапустим оконный менеджер KWin, работающий поверх Wayland:

.. code-block:: text

    kwin_wayland --replace &>/dev/null &

.. index:: gnome, restart, shell
.. _gnome-shell-restart:

Как перезапустить зависшую оболочку Gnome Shell?
===================================================

Перезапустим Gnome Shell:

.. code-block:: text

    gnome-shell --replace

.. index:: hash, bash, check, files, sha512sum, sha2, sha512, find
.. _dir-hash-save:

Как сохранить контрольные суммы файлов в каталоге рекурсивно?
================================================================

Cгенерируем файл с контрольными суммами SHA2 (SHA-512) содержимого текущего каталога при помощи утилит **find** и **sha512sum**:

.. code-block:: text

    find -type f \( -not -name 'sha512sum.txt' \) -exec sha512sum '{}' \; > sha512sum.txt

Результат будет сохранён в файле с именем **sha512sum.txt**.

.. index:: hash, bash, check, verification, files, sha512sum, sha2, sha512
.. _dir-hash-verify:

Как проверить контрольные суммы файлов в каталоге?
=====================================================

Проверим контрольные суммы SHA2 (SHA-512), :ref:`сохранённые <dir-hash-save>` в **sha512sum.txt**:

.. code-block:: text

    sha512sum -c sha512sum.txt > check_results.txt

Для удобства :ref:`перенаправим вывод <bash-pipelines>` в файл **check_results.txt** ибо он может быть очень большим и не поместиться на экране.

.. index:: hash, bash, check, verification, files, sha512sum, sha2, sha512, grep
.. _dir-hash-missmatch:

Как вывести список не совпадающих с сохранёнными контрольными суммами файлов?
=================================================================================

Проверим контрольные суммы SHA2 (SHA-512), :ref:`сохранённые <dir-hash-save>` в **sha512sum.txt** и выведем лишь те, проверка которых завершилась неудачно:

.. code-block:: text

    sha512sum -c sha512sum.txt | grep -v 'OK'

Для удобства :ref:`перенаправим вывод <bash-pipelines>` в файл **failed_results.txt** ибо он может быть очень большим и не поместиться на экране:

.. code-block:: text

    sha512sum -c sha512sum.txt | grep -v 'OK' > failed_results.txt

.. index:: qt, theme, override
.. _qt-theme-override:

Как переопределить тему в Qt приложениях?
============================================

Воспользуемся :ref:`переменными окружения <env-set>` для переопределения темы Qt:

.. code-block:: text

    QT_STYLE_OVERRIDE=adwaita QT_QPA_PLATFORMTHEME=qgnomeplatform /usr/bin/foo-bar

.. index:: wine, windows
.. _wine-fedora:

Как правильно установить Wine в Fedora?
===========================================

В основном репозитории Fedora всегда находится самый свежий и правильно опакеченный выпуск Wine, поэтому подключать какие-либо сторонние репозитории, в т.ч. официальный от WineHQ, категорически не рекомендуется.

Установим Wine из репозитория Fedora:

.. code-block:: text

    sudo dnf install wine wine.i686

.. index:: wine, dxvk, windows, directx, direct3d
.. _wine-dxvk:

Как правильно установить dxvk для Wine из репозиториев?
==========================================================

Наряду с :ref:`правильно опакеченным Wine <wine-fedora>`, в основном репозитории Fedora доступен и dxvk.

Установим dxvk с поддержкой DirectX 10, 11:

.. code-block:: text

    sudo dnf install wine-dxvk wine-dxvk.i686

Установим dxvk с поддержкой DirectX 9:

.. code-block:: text

    sudo dnf install wine-dxvk-d3d9 wine-dxvk-d3d9.i686

.. index:: kde, chromium, chrome, default, plasma, browser
.. _kde-chromium-default:

Как сделать Chromium браузером по умолчанию в KDE?
======================================================

Для того, чтобы назначить Chromium браузером по умолчанию, выполним **Параметры системы** -- **Приложения** -- **Приложения по умолчанию** -- **Браузер** -- установим точку около **в следующем приложении**, затем в выпадающем списке выберем **Chromium** и нажмём кнопку **Применить**.

Однако, даже если указанное действие сделано верно, Chromium всё равно будет предлагать установить его браузером по умолчанию при каждом запуске, т.к. он проверяет привязку не только к протоколам, но и к конкретным :ref:`mime-типам <file-types>` для HTML-файлов.

Чтобы избавиться от данного сообщения, повторно откроем **Параметры системы** -- **Приложения** -- **Привязки файлов**, в строке поиска введём ``html`` и переместим Chromium в самый верх списка приоритетов для **xhtml+xml** и **html**. Нажмём **Применить**.

.. index:: oom, kernel, earlyoom
.. _earlyoom-info:

Что такое earlyoom и почему он установлен по умолчанию?
============================================================

В Fedora 32 и 33, в редакции Workstation, `предустановлен <https://pagure.io/fedora-workstation/issue/119>`__ пакет **earlyoom**, который представляет собой систему раннего предотвращения нехватки памяти из пользовательского режима (user-space OOM Killer).

В случаях, когда объём доступной оперативной памяти опустится ниже 4% или 400 МБ (в зависимости от того, что меньше), earlyoom принудительно завершит работу процесса, наиболее активно потребляющего память (имеющего самое высокое значение oom_score), не доводя систему до очистки системных буферов и вызова ядерного OOM Killer.

Наиболее приоритетными кандидатами на завершение являются процессы *Web Content* браузера Mozilla Firefox. В то же время, снижен приоритет для различных системных сервисов, критичных для работы системы.

.. index:: oom, kernel, earlyoom, systemd
.. _earlyoom-enable:

Как активировать earlyoom?
===============================

Установим пакет **earlyoom** (для версий, :ref:`отличных от Workstation <earlyoom-info>`):

.. code-block:: text

    sudo dnf install earlyoom

Активируем его сервис (будет запускаться вместе с системой):

.. code-block:: text

    sudo systemctl enable --now earlyoom.service

.. index:: oom, kernel, earlyoom, systemd
.. _earlyoom-disable:

Как отключить earlyoom?
============================

Отключим earlyoom (не будет запускаться вместе с системой):

.. code-block:: text

    sudo systemctl disable --now earlyoom.service

Удалим пакет **earlyoom**:

.. code-block:: text

    sudo dnf remove earlyoom

Внимание! Если удалить пакет **earlyoom** в Fedora 32 и 33, он может быть :ref:`установлен заново <earlyoom-info>` из-за включённых по умолчанию :ref:`слабых зависимостей <dnf-weakdeps>`.

.. index:: oom, kernel, earlyoom, config
.. _earlyoom-configure:

Как настроить earlyoom?
============================

Параметры :ref:`earlyoom <earlyoom-info>` хранятся в файле ``/etc/default/earlyoom``.

Откроем его в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/default/earlyoom

Внесём правки, сохраним изменения, а затем перезапустим сервис:

.. code-block:: text

    sudo systemctl restart earlyoom.service

Подробную документацию о всех поддерживаемых опциях можно найти в ``man earlyoom``.

.. index:: oom, kernel, systemd, oomd
.. _oomd-info:

Что такое systemd-oomd?
=============================

Начиная с Fedora 34, во всех редакциях `активирован по умолчанию <https://fedoraproject.org/wiki/Changes/EnableSystemdOomd>`__ сервис **systemd-oomd**.

Как и :ref:`earlyoom <earlyoom-info>`, он представляет собой систему раннего предотвращения нехватки памяти из пользовательского режима (user-space OOM Killer).

.. index:: oom, kernel, systemd, oomd
.. _oomd-disable:

Как отключить systemd-oomd?
===============================

Отключим сервис **systemd-oomd** (не будет запускаться вместе с системой):

.. code-block:: text

    sudo systemctl disable --now systemd-oomd.service

Заблокируем возможность его повторной активации и запуска:

.. code-block:: text

    sudo systemctl mask systemd-oomd.service

.. index:: oom, kernel, systemd, oomd, earlyoom
.. _oomd-revert:

Как отключить systemd-oomd и вернуться к earlyoom?
=====================================================

Выполним два простых шага:

  1. :ref:`отключим systemd-oomd <oomd-disable>`;
  2. :ref:`активируем earlyoom <earlyoom-enable>`.

Изменения вступят в силу немедленно.

.. index:: kde, iso, dolphin, ark, udf, plasma, dolphin
.. _kde-iso:

Как открыть ISO образ в KDE?
===================================

Файлы образов ISO могут быть открыты архиватором Ark (``sudo dnf install ark``), если они не используют `файловую систему UDF <https://ru.wikipedia.org/wiki/Universal_Disk_Format>`__.

В качестве альтернативного варианта можно установить утилиту Gnome Disks (``sudo dnf install gnome-disk-utility``), после чего пункт монтирования ISO-файла появится в контекстном меню по щелчку правой кнопки мыши в Dolphin. Таким способом можно быстро смонтировать образ с любой ФС.

.. index:: kernel, memory, uresourced, gui, ram, cgroupsv2
.. _uresourced-info:

Что такое uresourced и почему он установлен по умолчанию?
============================================================

Начиная с Fedora 33, в редакции Workstation `предустановлен <https://pagure.io/fedora-workstation/issue/154>`__ пакет **uresourced**, который представляет собой систему повышения отзывчивости графической оболочки.

По умолчанию данный сервис резервирует 250 МБ или 10% от общего объёма оперативной памяти (в зависимости от того, что меньше) при помощи cgroupsv2.

В результате снижается вероятность возникновения ошибок страниц за счёт исключения возможности вытеснения страниц памяти, занимаемых графической оболочкой, что в итоге и приводит к повышению отзывчивости.

.. index:: kernel, memory, uresourced, gui, ram, systemd
.. _uresourced-enable:

Как активировать uresourced?
===============================

Установим пакет **uresourced** (для версий, :ref:`отличных от Workstation <uresourced-info>`):

.. code-block:: text

    sudo dnf install uresourced

Активируем его сервис (будет запускаться вместе с системой):

.. code-block:: text

    sudo systemctl enable --now uresourced.service

.. index:: kernel, memory, uresourced, gui, ram, systemd
.. _uresourced-disable:

Как отключить uresourced?
============================

Отключим uresourced (не будет запускаться вместе с системой):

.. code-block:: text

    sudo systemctl disable uresourced.service

Удалим пакет **uresourced**:

.. code-block:: text

    sudo dnf remove uresourced

Внимание! Если удалить пакет **uresourced** в Fedora Workstation, он может быть :ref:`установлен заново <earlyoom-info>` из-за включённых по умолчанию :ref:`слабых зависимостей <dnf-weakdeps>`.

.. index:: firefox, dialog, save, open, file, kde
.. _firefox-kde-dialog:

Как в Firefox включить диалог загрузки и сохранения файлов от KDE?
======================================================================

По умолчанию Firefox использует диалоги открытия и сохранения файлов из GTK, однако существует возможность активации родных от используемой рабочей среды, например KDE.

Установим соответствующий пакет с порталом:

.. code-block:: text

    sudo dnf install xdg-desktop-portal-kde

Откроем ``about:config`` и установим переменной ``widget.use-xdg-desktop-portal`` значение ``true``.

Изменения вступят в силу немедленно.

.. index:: text editor, text, editor, vim, nano
.. _nano-to-vim:

Как заменить текстовый редактор по умолчанию Nano на Vim?
=============================================================

Призведём замену пакета, предоставляющего общесистемную конфигурацию по умолчанию:

.. code-block:: text

    sudo dnf swap nano-default-editor vim-default-editor --allowerasing

Данное действие затронет всех пользователей системы, явно не указавших :ref:`предпочитаемый текстовый редактор <editor-selection>` при помощи :ref:`переменных окружения <env-set>`.

Осуществим новый вход в систему для вступления изменений в силу.

.. index:: pdf, combine, merge, texlive, pdfjam
.. _pdf-merge:

Как объединить несколько PDF-файлов в один?
===============================================

Для объединения нескольких PDF-файлов в один воспользуемся утилитой **pdfjam**, входящей в набор **texlive**.

Установим пакет **texlive-pdfjam**:

.. code-block:: text

    sudo dnf install texlive-pdfjam

Объединим файлы с именами *file1.pdf* -- *fileN.pdf* в **result.pdf** по схеме 3x1 (три на одной странице):

.. code-block:: text

    pdfjam file*.pdf --nup 3x1 --outfile result.pdf

Поддерживаются следующие схемы размещения исходников:

  * **1x1** -- один файл на странице (по сути, простое объединение);
  * **2x1** -- два файла;
  * **3x1** -- три файла;
  * **4x1** -- четыре файла.

Внимание! Если в оригиналах присутствовали цифровые подписи, они не будут перенесены в итоговый PDF.

.. index:: sed, find, files
.. _mass-change-files:

Как изменить строку во всех файлах рекурсивно?
=================================================

Воспользуемся утилитами **find** и **sed** для замены строки *foo* на *bar*.

Произведём поиск и замену во всех файлах каталога **src**:

.. code-block:: text

    find src -type f -exec sed -e "s/foo/bar/g" -i "{}" \;

Произведём поиск и замену в файлах, удовлетворяющих маске имени ``*.txt``, начиная с текущего каталога:

.. code-block:: text

    find -type f -name "*.txt" -exec sed -e "s/foo/bar/g" -i "{}" \;

.. index:: git, xargs, sed, find, files
.. _mass-change-files-git:

Как изменить строку во всех файлах Git-репозитория?
======================================================

При использовании системы контроля версий Git, не следует применять :ref:`классический поиск <mass-change-files>` без указания маски имени, либо начального каталога, т.к. это может повлечь за собой внесение правок в индексы, расположенные внутри служебной директории ``.git``, что приведёт к повреждению локальной копии репозитория.

Воспользуемся функцией Git **ls-files** и утилитами **xargs** и **sed** для замены строки *foo* на *bar*.

Произведём поиск и замену во всех файлах репозитория:

.. code-block:: text

    git ls-files | xargs sed -i -e "s/foo/bar/g"

Произведём поиск и замену в файлах репозитория, удовлетворяющих маске имени ``*.txt``:

.. code-block:: text

    git ls-files "*.txt" | xargs sed -i -e "s/foo/bar/g"

.. index:: kde, plasma, kactivitymanagerd, privacy
.. _plasma-privacy:

Как улучшить приватность KDE Plasma 5?
===========================================

С настройками по умолчанию KDE activity manager отслеживает, собирает и сохраняет в базе данных SQLite ``~/.local/share/kactivitymanagerd/resources/database`` подробную информацию об использовании системы, включая запуск приложений, открытие документов и каталогов и т.д.

Для отключения этой функциональности перейдём в **Настройки системы** (**System Settings**) -- **Рабочая среда** (**Workspace**) -- **Поведение рабочей среды** (**Workspace Behaviour**) -- **Комнаты** (**Комнаты**).

На вкладке **Комнаты** (**Activities**), справа от имени каждой существующей комнаты, выберем вариант **Настроить комнату** (**Configure activity**), в появившемся окне установим флажок в чекбокс **Не запоминать статистику использования** (**Do not track usage for this activity**) и нажмём кнопку **OK**.

На вкладке **Конфиденциальность** (**Privacy**), в разделе **Запоминать открытые документы** (**Remember opened documents**), установим точку около пункта **Не запоминать** (**Do not remember**), после чего нажмём **Применить** (**Apply**). Здесь же обязательно очистим все уже собранные данные при помощи **Очистить историю** (**Clear history**) -- **Стереть всё** (**Forget everything**).

Изменения вступят в силу при следующем входе в систему.
