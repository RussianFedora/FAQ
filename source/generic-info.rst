.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _generic:

*******************************
Основная информация
*******************************

.. index:: fedora, information
.. _what-is:

Что есть Fedora?
==========================================

Fedora - это один из дистрибутивов GNU/Linux, разрабатываемый сообществом и спонсируемый компанией Red Hat.

.. index:: releases, fedora
.. _releases:

Как часто выходят релизы?
==========================================

Полный цикл разработки одного релиза составляет от 6 до 8 месяцев.

.. index:: releases, fedora
.. _supported:

Сколько релизов поддерживаются?
==========================================

Два: текущий стабильный и предыдущий.

.. index:: difference, fedora, bleeding edge, distribution
.. _differences:

В чём отличие от других дистрибутивов?
==========================================

Fedora - это `bleeding edge <https://en.wikipedia.org/wiki/Bleeding_edge_technology>`__ дистрибутив. Он всегда находится на острие прогресса. Сначала новые разработки появляются здесь и лишь спустя определённое время в остальных дистрибутивах. Из-за этого некоторые называют федору «тестовым полигоном», но это в корне не верно ибо :ref:`релизы <supported>` достаточно стабильны.

.. index:: fedora, download, iso, respins
.. _download:

Где скачать Fedora?
==========================================

Загрузить ISO образ дистрибутива можно с официального сайта:

  * `Fedora Workstation (с Gnome 3) <https://getfedora.org/ru/workstation/download/>`__;
  * `Fedora с другими DE <https://spins.fedoraproject.org/>`__;
  * `официальные торренты <https://torrents.fedoraproject.org/>`__.

Также существуют еженедельные `автоматически сборки <https://dl.fedoraproject.org/pub/alt/live-respins/>`__ («respins»), содержащие все выпущенные на данный момент обновления.

.. index:: de, desktop, environment
.. _de-supported:

Какие DE поддерживаются?
==========================================

Gnome 3 (версия Workstation), KDE, XFCE, LXDE, LXQt, Cinnamon, Mate.

.. index:: releases, rolling, fedora, rawhide
.. _rolling-model:

Я хочу использовать rolling модель обновлений. Это возможно?
===============================================================

Да, ибо существует :ref:`Fedora Rawhide <using-rawhide>`.

.. index:: rawhide, rolling, fedora
.. _using-rawhide:

Возможно ли использовать Rawhide на постоянной основе?
===============================================================

Вполне ибо его качество уже давно на уровне альфа-версий других дистрибутивов.

.. index:: boot, grub, loader, boot
.. _grub-loader:

Какая версия загрузчика Grub используется в Fedora?
======================================================

:ref:`Grub 2 <grub-reinstall>`.

.. index:: repository, installation, software
.. _software-installation:

Откуда следует устанавливать ПО?
====================================

В Fedora, а равно как и любых других пакетных дистрибутивах, следует устанавливать программное обеспечение исключительно из репозиториев дистрибутива, :ref:`доверенных сторонних репозиториев <3rd-repositories>`, либо посредством самодостаточных Flatpak пакетов.

Ни в коем случае не следует использовать установку посредством :ref:`make install <make-install>`, т.к. это породит в системе большое количество никем не отслеживаемых зависимостей и создаст множество проблем при дальнейшем использовании системы.

.. index:: repository, rpmfusion, third-party
.. _rpmfusion:

Что такое RPM Fusion?
========================

Это самый популярный сторонний репозиторий, содержащий пакеты, которые по какой-то причине нельзя распространять в главном репозитории: кодеки мультимедиа, драйверы, проприетарные прошивки для различных устройств.

Подключение репозитория:

.. code-block:: text

    sudo dnf install --nogpgcheck https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

Отключение репозитория:

.. code-block:: text

    sudo dnf remove rpmfusion-free-release rpmfusion-nonfree-release

.. index:: repository, russianfedora, third-party
.. _russian-fedora:

Что такое Russian Fedora?
============================

Популярный сторонний репозиторий. Содержит большое количество ПО, включая правильно собранные Chromium (с поддержкой всех доступных мультимедийных кодеков), PyCharm Community Edition, Double Commander, а также множество популярного проприетарного ПО: Opera, Viber, Sublime Text 3, Adobe Flash Player, RAR и т.д.

Большая часть представленных здесь пакетов зависит от :ref:`RPM Fusion <rpmfusion>`, поэтому необходимо подключить сначала его.

Подключение репозитория:

.. code-block:: text

    sudo dnf install --nogpgcheck https://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/russianfedora-free-release-stable.noarch.rpm https://mirror.yandex.ru/fedora/russianfedora/russianfedora/nonfree/fedora/russianfedora-nonfree-release-stable.noarch.rpm

Отключение репозитория:

.. code-block:: text

    sudo dnf remove russianfedora-free-release russianfedora-nonfree-release

С апреля 2019 года репозиторий находится в отпуске на 1 релиз Fedora. Подключать данный репозиторий в настоящее время не следует.

.. index:: repository, copr, overlay, third-party
.. _copr:

Что такое COPR?
==================

Fedora COPR - это бесплатный хостинг для размещения :ref:`пользовательских <copr-use>` репозиториев (аналог AUR в Arch Linux или PPA в Ubuntu).

.. index:: distribution, russianfedora, rfremix
.. _rfremix:

Что такое RFRemix?
======================

RFRemix - это ремикс оргинального дистрибутива Fedora с использованием репозиториев :ref:`RPM Fusion <rpmfusion>` и :ref:`Russian Fedora <russian-fedora>`, адаптированный для российских пользователей. Больше информации можно найти `здесь <https://ru.fedoracommunity.org/stories/rfremix/>`__.

Из-за отпуска команды :ref:`Russian Fedora <russian-fedora>`, выпуск RFRemix временно приостановлен.

.. index:: bug report, report, bug
.. _bug-report:

Я нашёл ошибку в программе. Как мне сообщить о ней?
======================================================

Необходимо `создать тикет <https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora>`__ в Red Hat BugZilla для проблеммного компонента и подробно описать суть возникшей проблемы.

При необходимости разработчики могут запросить более подробную информацию, а также журналы работы системы.

.. index:: get help, telegram, irc, channels, chats, im, help
.. _get-help:

У меня возникло затруднение. Где я могу получить помощь?
=============================================================

Вы всегда можете обратиться за помощью к другим участникам сообщества.

Чаты в Telegram:

 * `Russian Fedora <https://t.me/russianfedora>`__ - основной чат на русском языке;
 * `Fedora <https://t.me/fedora>`__ - основной чат на английском языке;
 * `Russian Fedora Flood <https://t.me/russianfedora_flood>`__ - специальный чат для флуда и оффтопика.

Чаты в Matrix:

 * `#russianfedora:matrix.org <https://matrix.to/#/#russianfedora:matrix.org>`__ - основной чат на русском языке;
 * `#fedora-rpm-ru:matrix.org <https://matrix.to/#/#fedora-rpm-ru:matrix.org>`__ - технические вопросы по :ref:`созданию RPM пакетов <create-package>`;
 * `#rust-rpm-ru:matrix.org <https://matrix.to/#/#rust-rpm-ru:matrix.org>`__ - чат по особенностям пакетирования приложений, написанных на языке программирования Rust;
 * `#linux-ru-gaming:matrix.org <https://matrix.to/#/#linux-ru-gaming:matrix.org>`__ - обсуждения запуска и работы различных игр, а также :ref:`клиента Steam <steam>`.

Чаты в IRC:

 * `#fedora <https://webchat.freenode.net/?channels=#fedora>`__ - основной чат на английском языке;
 * `#fedora-devel <https://webchat.freenode.net/?channels=#fedora-devel>`__ - чат для разработчиков на английском языке;
 * `#rpmfusion <https://webchat.freenode.net/?channels=#rpmfusion>`__ - чат поддержки репозитория :ref:`RPM Fusion <rpmfusion>` на английском языке.

Форумы:

 * `Fedora Ask на русском языке <https://ask.fedoraproject.org/ru/questions/>`__;
 * `Fedora Ask на английском языке <https://ask.fedoraproject.org/en/questions/>`__.

.. index:: popularity, distribution, distrowatch
.. _distrowatch:

Можно ли доверять информации о популярности дистрибутива на DistroWatch?
============================================================================

Нет, т.к.:

 * данный сайт оценивает популярность дистрибутивов только по количеству просмотров их страницы *на данном ресурсе*;
 * не имеет доступа к реальной статистике посещений официальных сайтов;
 * большая часть загрузок дистрибутивов GNU/Linux осуществляется посредством протокола BitTorrent, поэтому точной информацией о количестве загрузок не обладают даже их создатели.

.. index:: fedora, silverblue
.. _silverblue:

Что такое Silverblue?
========================

Fedora Silverblue - это особая версия Fedora, основанная на принципах максимальной контейнеризации и неизменяемых (immutable) образов основной системы.

Благодаря использованию rpm-ostree Silverblue имеет атомарные обновления с возможностью отката на любую предыдущую версию системы. В то же время основной образ и корневая файловая система являются неизменяемыми, что делает невозможным их повреждение.

Пользовательские приложения предлагается устанавливать исключительно из :ref:`Flatpak репозиториев <flatpak-info>`.
