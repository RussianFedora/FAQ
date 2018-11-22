.. Fedora-Faq-Ru (c) 2018, EasyCoding Team and contributors
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

.. index:: fedora
.. _what-is:

Что есть Fedora?
==========================================

Fedora - это один из дистрибутивов GNU/Linux, разрабатываемый сообществом и спонсируемый компанией Red Hat.

.. index:: releases, релизы, выпуски
.. _releases:

Как часто выходят релизы?
==========================================

Полный цикл разработки одного релиза составляет от 6 до 8 месяцев.

.. index:: releases, релизы, выпуски
.. _supported:

Сколько релизов поддерживаются?
==========================================

Два: текущий стабильный и предыдущий.

.. index:: отличия
.. _differences:

В чём отличие от других дистрибутивов?
==========================================

Fedora - это bleeding edge дистрибутив. Он всегда находится на острие прогресса. Сначала новые разработки появляются здесь и только через некоторое время в остальных дистрибутивах. Из-за этого некоторые называют федору «тестовым полигоном», но это в корне не верно ибо релизы достаточно стабильны.

.. index:: скачать, download
.. _download:

Где скачать Fedora?
==========================================

Загрузить ISO образ дистрибутива можно с `официального сайта <https://getfedora.org/ru/workstation/download/>`_.

Также существуют еженедельные `автоматически сборки <https://dl.fedoraproject.org/pub/alt/live-respins/>`_ («respins»), содержащие все выпущенные на данный момент обновления.

.. index:: DE, поддерживаемые DE, supported DE
.. _de-supported:

Какие DE поддерживаются?
==========================================

Gnome 3 (версия Workstation), KDE, XFCE, LXDE, LXQt, Cinnamon.

.. index:: releases, релизы, выпуски, rolling
.. _rolling-model:

Я хочу использовать rolling модель обновлений. Это возможно?
===============================================================

Да, ибо существует Fedora Rawhide.

.. index:: rawhide, rolling
.. _using-rawhide:

Возможно ли использовать Rawhide на постоянной основе?
===============================================================

Вполне ибо его качество уже давно на уровне альфа-версий других дистрибутивов.

.. index:: boot, загрузчик, grub
.. _grub-loader:

Какая версия загрузчика Grub используется в Fedora?
======================================================

Grub 2.

.. index:: repository, installation, установка ПО, software
.. _software-installation:

Откуда следует устанавливать ПО?
====================================

В Fedora, а равно как и любых других пакетных дистрибутивах, следует устанавливать программное обеспечение исключительно из репозиториев дистрибутива, :ref:`доверенных сторонних репозиториев <3rd-repositories>`, либо посредством самодостаточных Flatpak пакетов.

Ни в коем случае не следует использовать установку посредством :ref:`make install <make-install>`, т.к. это породит в системе кучу никем не отслеживаемых зависимостей и создаст множество проблем при дальнейшем использовании системы.

.. index:: installation, установка ПО, software, snap
.. _snap:

Можно ли использовать в Fedora Snap пакеты?
===============================================

Технически возможно, однако мы настоятельно не рекомендуем этого делать ибо качество большинства Snap пакетов очень низкое, к тому же в некоторых из них `были обнаружены <https://xakep.ru/2018/05/14/snap-store-miner/>`_ вредоносные майнеры.

.. index:: repository, rpmfusion
.. _rpmfusion:

Что такое RPM Fusion?
========================

Это самый популярный сторонний репозиторий, содержащий пакеты, которые по какой-то причине нельзя распространять в главном репозитории: кодеки мультимедиа, драйверы, проприетарные прошивки для различных устройств.

Подключение репозитория:

.. code-block:: bash

    sudo dnf install --nogpgcheck https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

Отключение репозитория:

.. code-block:: bash

    sudo dnf remove rpmfusion-free-release rpmfusion-nonfree-release

.. index:: repository, russianfedora
.. _russian-fedora:

Что такое Russian Fedora?
============================

Популярный сторонний репозиторий. Содержит большое количество ПО, включая правильно собранные Chromium (с поддержкой всех доступных мультимедийных кодеков), PyCharm Community Edition, Double Commander, а также множество популярного проприетарного ПО: Opera, Viber, Sublime Text 3, Adobe Flash Player, RAR и т.д. Большая часть представленных здесь пакетов зависит от :ref:`RPM Fusion <rpmfusion>`, поэтому необходимо подключить сначала его.

Подключение репозитория:

.. code-block:: bash

    sudo dnf install --nogpgcheck https://mirror.yandex.ru/fedora/russianfedora/russianfedora/free/fedora/russianfedora-free-release-stable.noarch.rpm https://mirror.yandex.ru/fedora/russianfedora/russianfedora/nonfree/fedora/russianfedora-nonfree-release-stable.noarch.rpm

Отключение репозитория:

.. code-block:: bash

    sudo dnf remove russianfedora-free-release russianfedora-nonfree-release

.. index:: repository, copr, overlay
.. _copr:

Что такое COPR?
==================

Fedora COPR - это бесплатный хостинг для размещения пользовательских репозиториев (аналог AUR в Arch Linux или PPA в Ubuntu).

.. index:: repository, copr, overlay
.. _copr-use:

Безопасно ли использовать COPR репозитории?
===============================================

Т.к. все пакеты в COPR создаются простыми пользователями, их качество значительно отличается. Есть как хорошие репозитории, так и те, что способны вывести систему из строя.

Перед подключением мы рекомендуем проверить является ли владелец репозитория мейнтейнером Fedora или нет и если нет, то не делать этого.

.. index:: repository, copr, overlay
.. _copr-legal:

Что разрешается хранить в COPR репозиториях?
================================================

Ровно всё то же, что и в основных репозиториях Fedora. Распространение запатентованного и проприетарного программного обеспечения в пользовательских оверлеях не допускается.

.. index:: distribution, russianfedora, rfremix
.. _rfremix:

Что такое RFRemix?
======================

RFRemix - это ремикс оргинального дистрибутива Fedora с использованием репозиториев :ref:`RPM Fusion <rpmfusion>` и :ref:`Russian Fedora <russian-fedora>`, адаптированный для российских пользователей. Больше информации можно найти `здесь <https://ru.fedoracommunity.org/stories/rfremix/>`_.

.. index:: distribution, russianfedora, rfremix
.. _rfremix-to-fedora:

Как превратить RFRemix в Fedora и наоборот?
===============================================

Для превращения Fedora в RFRemix необходимо и достаточно подключить репозиторий **russianfedora-branding**, а чтобы вернуть всё назад - отключить его.

После подключения/отключения необходимо выполнить синхронизацию:

.. code-block:: bash

    sudo dnf distro-sync

.. index:: bug report, сообщить об ошибке
.. _bug-report:

Я нашёл ошибку в программе. Как мне сообщить о ней?
======================================================

Для начала следует `создать тикет <https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora>`_ в RHBZ.

.. index:: get help, получение помощи, telegram, irc, channels, chats
.. _get-help:

У меня возникло затруднение. Где я могу получить помощь?
=============================================================

Вы всегда можете обратиться за помощью к другим участникам сообщества.

Чаты и каналы:

 * `Russian Fedora <https://t.me/russianfedora>`_ чат в Telegram;
 * `Fedora <https://t.me/fedora>`_ чат в Telegram (на английском языке);
 * `#russianfedora:matrix.org <https://matrix.to/#/#russianfedora:matrix.org>`_ чат в Matrix;
 * `#fedora <https://webchat.freenode.net/?channels=#fedora>`_ в IRC сети FreeNode (на английском языке).

Форумы:

 * `Fedora Ask на русском языке <https://ask.fedoraproject.org/ru/questions/>`_;
 * `Fedora Ask на английском языке <https://ask.fedoraproject.org/en/questions/>`_.
