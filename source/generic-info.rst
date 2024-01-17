..
    SPDX-FileCopyrightText: 2018-2023 EasyCoding Team and contributors. 2024 Linuxiston

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _generic:

*********************
Asosiy ma'lumotlar
*********************

.. index:: fedora, information
.. _what-is:

Fedora bu nima?
================

Fedora -- bu GNU/Linux distributivlaridan biri hisoblanib, :ref:`Red Hat kompaniyasi <rh-contribution>` homiyligida ochiq hamjamiyat tomonidan ishlab chiqariladi.

.. index:: fedora, red hat
.. _rh-contribution:

Distrbituvi Red Hat kompaniyasiga qanchalik bog'langan?
=======================================================

Red Hat distributivning asosiy homiysi hisoblanib, ushbu distributivni yig'ish uchun qurilmalar va resurslarni taqdim etadi.

Bundan tashqari ushbu distributivga kiritiladigan ko'plab ushbu kompaniya hodimlari tomonidan kiritilsada, bularning barchasi :ref:`mustaqil hamjamiyat <fesco>` tomonidan tekshiruvdan o'tadi. Fedora prinsiplariga mos kelmaydigan tashabbuslar esa rad etiladi. 

Va yuqoridagi holatlar :ref: `package review <becoming-maintainer>` jarayonida ham taaluqli.

.. index:: fedora, fesco
.. _fesco:

FESCo bu nima?
===============

FESCo -- `Fedora Engineering Steering Committee <https://docs.fedoraproject.org/en-US/fesco/>`__. Bu :ref:`umumiy ovoz berish <elections>` yo'li bilan saylanadigan organ bo'lib, distributivni rivojlantirish va boshqaruv bilan shug'ullanadi.

Ushbu komitetning asosiy vazifalari:

  * distributivga yangi o'zgarishlar va tashabbuslarni qabul qilish yoki rad etish;
  * distributiv bilan bog'liq bo'lgan texnik muammolarga yechim izlash;
  * ba'zi ta'minotchilarga kengaytirilgan huquqlar berish;
  * manfaatlar bo'yicha guruhlarni boshqarish (SIG, Special Interest Groups);
  * ziddiyatli holatlarni bartaraf etish.

.. index:: fedora, elections
.. _elections:

Ovoz berishda kimlar qatnashishi mumkin?
=========================================

Bo'lib o'tadigan ovoz berish jarayonlari bo'yicha ma'lumotlar :ref:`mailing list <get-help>` ro'yxatlarida, shuningdek `hamjamiyat bloglarida <https://communityblog.fedoraproject.org/>`__ oldindan e'lon qilinadi.

Ovoz berishning aksariyatida distributivning rivojlanishiga hissa qo'shgan barcha hamjamiyat a'zolari ishtirok etishlari mumkin: ta'minotchilar, dizaynerlar, maqola mualliflari, muharrirlar va boshqalar.

Shu bilan birga, har kim ovoz berishi mumkin bo'lgan maxsus ochiq ovozlar (masalan, yangi ish stoli fonini tanlash bo'yicha) ham mavjud.

.. index:: releases, fedora
.. _releases:

Odatda relizlar qancha vaqtda chiqariladi?
===========================================

Bir relizni ishlab chiqarishning to'liq sikli 6 oydan 8 oygacha bo'lgan muddatni tashkil etadi.

.. index:: releases, fedora
.. _supported:

Nechta reliz faol qo'llab-quvvatlanadi?
=======================================

2 ta: joriy barqaror (stable) va undan oldingi.

.. index:: releases, fedora
.. _next-release:

Keyingi reliz qachon chiqariladi?
===================================

`Fedora 39 Schedule <https://fedorapeople.org/groups/schedule/f-40/f-40-all-tasks.html>`__.

.. index:: difference, fedora, bleeding edge, distribution
.. _differences:

Ushbu distributivning boshqa distributivlardan qanday farqlari bor?
===================================================================

Fedora -- bu `bleeding edge <https://en.wikipedia.org/wiki/Bleeding_edge_technology>`__ distributiv. U har doim taraqqiyotning boshida turadi. Odatda, yangi ishlanmalar bu yerda va faqat ma'lum vaqtdan keyin boshqa distributivlarda paydo bo'ladi. Shu sababdan ham ko'pchilik Fedorani "sinov poligoni" deb ataydi, lekin aslida bu unchalik ham to'g'ri emas, balki Fedora :ref:`relizlari <supported>` yetarli darajada barqaror.

.. index:: fedora, download, iso, respins
.. _download:

Fedorani qayerdan yuklab olish mumkin?
======================================

Distributivning ISO fayllarini distributivning rasmiy saytidan yuklab olish mumkin:

  * `Fedora Workstation (GNOME ish stoli bilan) <https://getfedora.org/workstation/download/>`__;
  * `Fedora boshqa ish stollari bilan <https://spins.fedoraproject.org/>`__;
  * `rasmiy torrentlar <https://torrents.fedoraproject.org/>`__.

Bundan tashqari haftalik `avtomatik yig'iladigan <https://dl.fedoraproject.org/pub/alt/live-respins/>` ("respinlar") ham mavjud, ular hozirgi vaqtda chiqarilgan barcha yangilanishlarni o'z ichiga oladi.

.. index:: de, desktop, environment
.. _de-supported:

Qanday ish stollarini qo'llab-quvvatlaydi?
==========================================

Fedoraning ayni vaqtdagi talqini quyidagi ish stollarini qo'llab-quvvatlaydi:

  * `GNOME <https://getfedora.org/workstation/download/>`__;
  * `KDE Plasma <https://spins.fedoraproject.org/kde/download/>`__;
  * `XFCE <https://spins.fedoraproject.org/xfce/download/>`__;
  * `LXQt <https://spins.fedoraproject.org/lxqt/download/>`__;
  * `Mate <https://spins.fedoraproject.org/mate-compiz/download/>`__;
  * `Cinnamon <https://spins.fedoraproject.org/cinnamon/download/>`__;
  * `LXDE <https://spins.fedoraproject.org/lxde/download/>`__;
  * `SOAS <https://spins.fedoraproject.org/soas/download/>`__;
  * `i3 <https://spins.fedoraproject.org/i3/download/>`__.

.. index:: releases, rolling, fedora, rawhide
.. _rolling-model:

Men rolling usulidagi yangilanishlardan foydalanishni xoxlayman. Buning imkoni bormi?
=====================================================================================

Albatta, buning uchun :ref:`Fedora Rawhide <using-rawhide>`dan foydalaning.

.. index:: rawhide, rolling, fedora
.. _using-rawhide:

Rawhidedan doimiy foydalanish uchun o'rnatsa bo'ladimi?
=======================================================

Bemalol, chunki uning holati boshqa distributivlarning alfa holatidagi talqinlariga mos tushadi.

.. index:: boot, grub, loader, boot
.. _grub-loader:

Fedorada Grubning qaysi talqinidan foydalaniladi?
=================================================

:ref:`Grub 2 <grub-reinstall>`.

.. index:: repository, installation, software
.. _software-installation:

Dasturlarni qayerdan o'rnatish kerak?
=====================================
Fedorada ham boshqa barcha distributivlar singari dasturlarni distributivning o'z repozitoriyalaridan, :ref:`ishonchli tomonlarning repozitoriyalaridan <3rd-repositories>` yoki  Flatpak paketlari orqali o'rnatish kerak.

Imkoni boricha dasturlarni :ref:`make install <make-install>` usuli bilan o'rnatmaslik kerak, chunki bu usul distributivning boshqa qismlariga zarar yetkazishi mumkin va bu distirbutivdan foydalanishda ko'plab bartaraf qilish mumkin bo'lgan muammolarni keltirib chiqaradi.

.. index:: repository, rpmfusion, third-party
.. _rpmfusion:

RPM Fusion bu nima?
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

  * `#fedora <https://web.libera.chat/?channels=#fedora>`__ -- основной чат на английском языке;
  * `#fedora-devel <https://web.libera.chat/?channels=#fedora-devel>`__ -- чат для разработчиков на английском языке;
  * `#rpmfusion <https://web.libera.chat/?channels=#rpmfusion>`__ -- чат поддержки репозитория :ref:`RPM Fusion <rpmfusion>` на английском языке.

Чаты в XMPP:

  * `fedora@conference.a3.pm <xmpp:fedora@conference.a3.pm?join>`__ -- основной чат на русском языке.

Форумы:

  * `Fedora Discussion на английском языке <https://discussion.fedoraproject.org/>`__;
  * `Fedora Ask на русском языке <https://ask.fedoraproject.org/questions/>`__;
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

Да. При накоплении определённого числа изменений, формируются выпуски для оффлайнового чтения в формате PDF.

Скачать их можно из `раздела загрузок <https://github.com/RussianFedora/FAQ/releases>`__ на GitHub, либо по `прямой ссылке <https://github.com/RussianFedora/FAQ/releases/latest/download/fedora-faq-ru.pdf>`__.
