# Unofficial Fedora FAQ in russian

[![GitHub version](https://badge.fury.io/gh/RussianFedora%2FFAQ.svg)](https://github.com/RussianFedora/FAQ/releases)
[![Github downloads](https://img.shields.io/github/downloads/RussianFedora/FAQ/total.svg?label=PDF%20downloads&maxAge=60)](https://github.com/RussianFedora/FAQ/releases)
[![GitHub issues](https://img.shields.io/github/issues/RussianFedora/FAQ.svg?label=issues&maxAge=60)](https://github.com/RussianFedora/FAQ/issues)
---

We decided to find and document answers to the most of the frequently asked questions from our conferences about Fedora for convenience of end users.

You can ask new questions in issues of this repository or you can help us and contribute project by sending your pull requests.

This FAQ maintained by independent community members. Not related to Fedora Project. Fedora is a registered trademark of Red Hat, Inc.

# Build HTML

1. Install sphinx-doc package:

```bash
sudo dnf install python3-sphinx
```

2. Clone this repository:

```bash
git clone https://github.com/RussianFedora/FAQ.git fedora-faq-ru
```

3. Generate HTML from sources:

```bash
cd fedora-faq-ru
make html
```

4. Open result in default web-browser:

```bash
xdg-open build/html/index.html
```

# Build PDF

1. Install sphinx-doc and texlive packages:

```bash
sudo dnf install python3-sphinx latexmk texlive-cmap texlive-metafont-bin texlive-collection-fontsrecommended texlive-babel-russian texlive-hyphen-russian texlive-titling texlive-fancyhdr texlive-titlesec texlive-tabulary texlive-framed texlive-wrapfig texlive-parskip texlive-upquote texlive-capt-of texlive-needspace texlive-collection-langcyrillic texlive-cyrillic-bin texlive-cmcyr texlive-cyrillic-bin-bin texlive-fncychap texlive-xetex dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts texlive-polyglossia
```

2. Clone this repository:

```bash
git clone https://github.com/RussianFedora/FAQ.git fedora-faq-ru
```

3. Generate PDF from sources:

```bash
cd fedora-faq-ru
make latexpdf
```

4. Open result in default PDF viewer:

```bash
xdg-open build/latex/fedora-faq-ru.pdf
```
