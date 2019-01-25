.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _development:

*****************************************************
Вопросы, связанные с разработкой и сборкой пакетов
*****************************************************

.. index:: repository, package, packaging, rpm
.. _create-package:

Я хочу создать пакет для Fedora. Что мне следует знать?
============================================================

См. `здесь <https://docs.fedoraproject.org/quick-docs/en-US/creating-rpm-packages.html>`__ и `здесь <https://www.easycoding.org/2018/06/17/pravilno-paketim-po-dlya-linux.html>`__.

.. index:: package, packaging, rpm, building
.. _build-package:

Как собрать RPM пакет в mock?
==================================

См. `здесь <https://www.easycoding.org/2017/02/22/sobiraem-rpm-pakety-dlya-fedora-v-mock.html>`__.

.. index:: packaging, repository, maintainer
.. _becoming-maintainer:

Как добавить свой пакет в репозиторий Fedora и стать мейнтейнером?
=====================================================================

См. `здесь <https://www.easycoding.org/2016/06/20/dobavlyaem-paket-v-glavnyj-repozitorij-fedora.html>`__.

.. index:: koji, about
.. _koji-about:

Что такое Koji?
===================

`Fedora Koji <https://koji.fedoraproject.org/koji/>`__ - это автоматизированная среда для сборки пакетов для Fedora.

.. index:: fedpkg, package, rebuild, mock, rpm
.. _fedpkg-rebuild:

Хочу внести свои правки в пакет и пересобрать его для личных нужд. Как проще это сделать?
===============================================================================================

Установим утилиты fedpkg и mock:

.. code-block:: bash

    sudo dnf install fedpkg mock

Скачаем исходники необходимого пакета **foo-bar**:

.. code-block:: bash

    fedpkg clone -a foo-bar

Перейдём в каталог с загруженными исходниками и переключимся на ветку для конкретной версии Fedora (если нужна версия из Rawhide - следует использовать **master**):

.. code-block:: bash

    cd foo-bar
    fedpkg switch-branch f29

Внесём свои правки, сделаем коммит в репозиторий:

.. code-block:: bash

    git add -A
    git commit -m "Description of our changes."

Запустим автоматическую :ref:`сборку в mock <build-package>`:

.. code-block:: bash

    fedpkg mockbuild

.. index:: git, tarball
.. _git-tarball:

Как создать tarball с исходниками из Git репозитория?
=========================================================

Если проект по какой-либо причине не поставляет готовые тарболы и отсутствует возможность их скачать напрямую с хостинга VCS, можно создать их из Git.

Клонируем репозиторий источника:

.. code-block:: bash

    git clone https://example.org/foo-bar.git

Создадим архив с исходниками:

.. code-block:: bash

    git archive --format=tar --prefix=foo-bar-1.0.0/ HEAD | gzip > ~/rpmbuild/SOURCES/foo-bar-1.0.0.tar.gz

Здесь **HEAD** - указатель на актуальный коммит (вместо этого можно использовать SHA1 хеш любого коммита, а также имя тега или ветки), **foo-bar** - название проекта, а **1.0.0** - его версия.
