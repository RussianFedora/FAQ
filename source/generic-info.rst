..
    Fedora-Faq-Ru (c) 2018 - 2020, EasyCoding Team and contributors

    Fedora-Faq-Ru is licensed under a
    Creative Commons Attribution-ShareAlike 4.0 International License.

    You should have received a copy of the license along with this
    work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.

.. _generic:

*******************************
Основная информация
*******************************

.. index:: fedora, information
.. _what-is:

Что такое Fedora?
====================

Fedora -- это один из дистрибутивов GNU/Linux, разрабатываемый сообществом и спонсируемый :ref:`компанией Red Hat <rh-contribution>`.

.. index:: fedora, red hat
.. _rh-contribution:

Как сильно дистрибутив зависит от компании Red Hat?
=======================================================

Red Hat является основным спонсором дистрибутива: предоставляет ресурсы и оборудование для сборки дистрибутива.

И, хотя многие крупные изменения вносятся сотрудниками данной компании на окладе, все они на общих основаниях проходят контроль :ref:`независимого сообщества <fesco>`. Инициативы, не соответствующие принципам Fedora, отклоняются.

То же касается и процесса :ref:`package review <becoming-maintainer>` для всех пакетов в основных репозиториях.

.. index:: fedora, fesco
.. _fesco:

Что такое FESCo?
===================

FESCo -- `Fedora Engineering Steering Committee <https://docs.fedoraproject.org/en-US/fesco/>`__. Это избираемый :ref:`общим голосованием <elections>` орган, занимающийся непосредственным управлением и развитием дистрибутива.

Основные задачи комитета:

  * принятие или отклонение новых инициатив и изменений в дистрибутиве;
  * решение ряда технических вопросов;
  * наделение некоторых мейнтейнеров расширенными правами;
  * управление группами по интересам (SIG, Special Interest Groups);
  * разрешение некоторых конфликтных ситуаций.

.. index:: fedora, elections
.. _elections:

Кто может принимать участие в голосованиях?
==============================================

Информация о проходящих голосованиях всегда заранее публикуется в :ref:`списках рассылки <get-help>`, а также `блогах сообщества <https://communityblog.fedoraproject.org/>`__.

Принять участие в большинстве из них могут все участники сообщества, которые когда-либо вносили вклад в развитие дистрибутива: мейнтейнеры, дизайнеры, авторы статей, редакторы и т.д.

Однако существуют и специальные открытые голосования (например по выбору новых фонов рабочего стола), оставить свой голос в которых могут все желающие.

.. index:: releases, fedora
.. _releases:

Как часто выходят релизы?
============================

Полный цикл разработки одного релиза составляет от 6 до 8 месяцев.

.. index:: releases, fedora
.. _supported:

Сколько релизов поддерживается?
==================================

Два: текущий стабильный и предыдущий.

.. index:: releases, fedora
.. _next-release:

Когда выходит следующий релиз?
===================================

`Fedora 32 Schedule <https://fedorapeople.org/groups/schedule/f-32/f-32-key-tasks.html>`__.

.. index:: difference, fedora, bleeding edge, distribution
.. _differences:

В чём отличие от других дистрибутивов?
==========================================

Fedora -- это `bleeding edge <https://en.wikipedia.org/wiki/Bleeding_edge_technology>`__ дистрибутив. Он всегда находится на острие прогресса. Сначала новые разработки появляются здесь и лишь спустя определённое время в остальных дистрибутивах. Из-за этого некоторые называют федору «тестовым полигоном», но это в корне неверно, ибо :ref:`релизы <supported>` достаточно стабильны.

.. index:: fedora, download, iso, respins
.. _download:

Где скачать Fedora?
======================

Загрузить ISO образ дистрибутива можно с официального сайта:

  * `Fedora Workstation (с Gnome 3) <https://getfedora.org/ru/workstation/download/>`__;
  * `Fedora с другими DE <https://spins.fedoraproject.org/>`__;
  * `официальные торренты <https://torrents.fedoraproject.org/>`__.

Также существуют еженедельные `автоматические сборки <https://dl.fedoraproject.org/pub/alt/live-respins/>`__ («respins»), содержащие все выпущенные на данный момент обновления.

.. index:: de, desktop, environment
.. _de-supported:

Какие DE поддерживаются?
===========================

Gnome 3 (версия Workstation), KDE Plasma 5, Xfce, LXDE, LXQt, Cinnamon, Mate.

.. index:: releases, rolling, fedora, rawhide
.. _rolling-model:

Я хочу использовать rolling модель обновлений. Это возможно?
===============================================================

Да, ибо существует :ref:`Fedora Rawhide <using-rawhide>`.

.. index:: rawhide, rolling, fedora
.. _using-rawhide:

Возможно ли использовать Rawhide на постоянной основе?
=========================================================

Вполне, ибо его качество уже давно на уровне альфа-версий других дистрибутивов.

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

Ранее популярный сторонний репозиторий. Содержал большое количество ПО, включая правильно собранные Chromium (с поддержкой всех доступных мультимедийных кодеков), PyCharm Community Edition, Double Commander, а также множество популярного проприетарного ПО: Opera, Viber, Sublime Text 3, Adobe Flash Player, RAR и т.д.

В данный момент репозиторий отключён, поскольку проект выполнил свою задачу на 100%: все его наработки были приняты в официальные репозитории Fedora, а также RPM Fusion. Мейнтейнеры Russian Fedora теперь являются мейнтейнерами Fedora и RPM Fusion.

Подробности можно узнать `здесь <https://ru.fedoracommunity.org/posts/rfremix-retired/>`__.

Russian Fedora остаётся полноценной частью сообщества Fedora. Поддержка пользователей продолжается в материнском проекте Fedora.

.. index:: repository, copr, overlay, third-party
.. _copr:

Что такое COPR?
==================

Fedora COPR -- это бесплатный хостинг для размещения :ref:`пользовательских <copr-use>` репозиториев (аналог AUR в Arch Linux или PPA в Ubuntu).

.. index:: distribution, russianfedora, rfremix
.. _rfremix:

Что такое RFRemix?
======================

RFRemix -- это ремикс оргинального дистрибутива Fedora с использованием репозиториев :ref:`RPM Fusion <rpmfusion>` и :ref:`Russian Fedora <russian-fedora>`, адаптированный для российских пользователей. На данный момент все релизы устарели и более не поддерживаются.

Выпуск RFRemix прекращён, поскольку проект выполнил свою задачу на 100%: все его наработки были приняты в официальные репозитории Fedora, а также RPM Fusion. Мейнтейнеры Russian Fedora теперь являются мейнтейнерами Fedora и RPM Fusion.

Подробности можно узнать `здесь <https://ru.fedoracommunity.org/posts/rfremix-retired/>`__.

.. index:: bug report, report, bug
.. _bug-report:

Я нашёл ошибку в программе. Как мне сообщить о ней?
======================================================

Необходимо `создать тикет <https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora>`__ в Red Hat BugZilla для проблемного компонента и подробно описать суть возникшей проблемы на английском языке.

При необходимости разработчики могут запросить более подробную информацию, а также журналы работы системы.

.. index:: get help, telegram, irc, channels, chats, im, help
.. _get-help:

У меня возникло затруднение. Где я могу получить помощь?
=============================================================

Вы всегда можете обратиться за помощью к другим участникам сообщества.

Чаты в Telegram:

  * `Russian Fedora <https://t.me/russianfedora>`__ -- основной чат на русском языке;
  * `Fedora <https://t.me/fedora>`__ -- основной чат на английском языке;
  * `Russian Fedora Offtopic <https://t.me/russianfedora_offtopic>`__ -- специальный чат для оффтопика.

Чаты в Matrix:

  * `#russianfedora:matrix.org <https://matrix.to/#/#russianfedora:matrix.org>`__ -- основной чат на русском языке;
  * `#fedora-rpm-ru:matrix.org <https://matrix.to/#/#fedora-rpm-ru:matrix.org>`__ -- технические вопросы по :ref:`созданию RPM пакетов <create-package>`;
  * `#rust-rpm-ru:matrix.org <https://matrix.to/#/#rust-rpm-ru:matrix.org>`__ -- чат по особенностям пакетирования приложений, написанных на языке программирования Rust;
  * `#linux-ru-gaming:matrix.org <https://matrix.to/#/#linux-ru-gaming:matrix.org>`__ -- обсуждение запуска и работы различных игр, а также :ref:`клиента Steam <steam>`;
  * `#fedora-ru-offtopic:matrix.org <https://matrix.to/#/#fedora-ru-offtopic:matrix.org>`__ -- специальный чат для оффтопика.

Чаты в IRC:

  * `#fedora <https://webchat.freenode.net/?channels=#fedora>`__ -- основной чат на английском языке;
  * `#fedora-devel <https://webchat.freenode.net/?channels=#fedora-devel>`__ -- чат для разработчиков на английском языке;
  * `#rpmfusion <https://webchat.freenode.net/?channels=#rpmfusion>`__ -- чат поддержки репозитория :ref:`RPM Fusion <rpmfusion>` на английском языке.

Форумы:

  * `Fedora Ask на русском языке <https://ask.fedoraproject.org/ru/questions/>`__;
  * `Fedora Ask на английском языке <https://ask.fedoraproject.org/en/questions/>`__.

Списки рассылки:

  * `пользовательский список рассылки на английском языке <https://lists.fedoraproject.org/archives/list/users@lists.fedoraproject.org/>`__;
  * `список рассылки для разработчиков на английском языке <https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/>`__.

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

Fedora Silverblue -- это особая версия Fedora, основанная на принципах максимальной контейнеризации и неизменяемых (immutable) образов основной системы.

Благодаря использованию rpm-ostree Silverblue имеет атомарные обновления с возможностью отката на любую предыдущую версию системы. В то же время основной образ и корневая файловая система являются неизменяемыми, что делает невозможным их повреждение.

Пользовательские приложения предлагается устанавливать исключительно из :ref:`Flatpak репозиториев <flatpak-info>`.

.. index:: fedora, faq, download, offline, pdf, chm
.. _faq-download:

Можно ли скачать данный FAQ для оффлайнового чтения?
========================================================

Да. Каждый месяц формируются выпуски для оффлайнового чтения в форматах PDF и CHM.

Скачать их можно из `раздела загрузок <https://github.com/RussianFedora/FAQ/releases>`__ на GitHub.
