# Unofficial Fedora FAQ in uzbek

[![GitHub version](https://img.shields.io/github/v/release/Linuxiston/fedora-faq?sort=semver&color=brightgreen&logo=git&logoColor=white)](https://github.com/Linuxiston/fedora-faq/releases)
[![Github downloads](https://img.shields.io/github/downloads/Linuxiston/fedora-faq/total.svg?label=PDF%20downloads&logo=github&logoColor=white)](https://github.com/Linuxiston/fedora-faq/releases/latest/download/fedora-faq-ru.pdf)
[![Pages CI status](https://github.com/Linuxiston/fedora-faq/actions/workflows/gh-pages.yaml/badge.svg)](https://github.com/Linuxiston/fedora-faq/actions/workflows/gh-pages.yaml)
[![Release CI status](https://github.com/Linuxiston/fedora-faq/actions/workflows/release.yaml/badge.svg)](https://github.com/Linuxiston/fedora-faq/actions/workflows/release.yaml)
[![GitHub issues](https://img.shields.io/github/issues/Linuxiston/fedora-faq.svg?label=issues&logo=pinboard&logoColor=white)](https://github.com/Linuxiston/fedora-faq/issues)
---

We decided to find and document answers to the most of the frequently asked questions from our conferences about Fedora for convenience of end users.

You can ask new questions in issues of this repository or you can help us and contribute project by sending your pull requests.

This FAQ maintained by independent community members. Not related to Fedora Project. Fedora is a registered trademark of Red Hat, Inc.

# Build HTML

1. Install make and sphinx-doc packages:

```bash
sudo dnf install make python3-sphinx
```

2. Clone this repository:

```bash
git clone https://github.com/Linuxiston/fedora-faq.git fedora-faq-uz
```

3. Generate HTML from sources:

```bash
cd fedora-faq-uz
make html
```

4. Open result in default web-browser:

```bash
xdg-open build/html/index.html
```

# Build PDF

1. Install make, sphinx-doc and texlive packages:

```bash
sudo dnf install make python3-sphinx latexmk texlive-cmap texlive-metafont-bin texlive-collection-fontsrecommended texlive-babel-russian texlive-hyphen-russian texlive-titling texlive-fancyhdr texlive-titlesec texlive-tabulary texlive-framed texlive-wrapfig texlive-parskip texlive-upquote texlive-capt-of texlive-needspace texlive-collection-langcyrillic texlive-cyrillic-bin texlive-cmcyr texlive-cyrillic-bin-bin texlive-fncychap texlive-xetex dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts texlive-polyglossia texlive-xindy
```

2. Clone this repository:

```bash
git clone https://github.com/Linuxiston/fedora-faq.git fedora-faq-uz
```

3. Generate PDF from sources:

```bash
cd fedora-faq-uz
make latexpdf
```

4. Open result in default PDF viewer:

```bash
xdg-open build/latex/fedora-faq-uz.pdf
```
