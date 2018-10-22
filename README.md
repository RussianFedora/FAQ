# Big Fedora FAQ in russian

We decided to find and document answers to the most of the frequently asked questions from our conferences about Fedora for convenience of end users.

You can ask new questions in issues of this repository or you can help us and contribute project by sending your pull requests.

# View in HTML

1. Install sphinx-doc package:

```bash
sudo dnf install python3-sphinx
```

2. Clone this repository:

```bash
git clone https://github.com/xvitaly/fedora-faq-ru.git
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
