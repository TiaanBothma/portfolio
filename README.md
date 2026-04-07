# Tiaan Bothma OS 🖥️

> A portfolio website that looks and feels like a real desktop operating system — built entirely in Flutter Web.

![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/License-Viewing%20Only-red?style=flat)

---

## What Is This?

Most portfolio websites look the same — a hero section, an about section, a projects section, and a contact form. I wanted something different.

**Tiaan Bothma OS** is a portfolio that doubles as a fully interactive desktop operating system. When you visit the site, you land on a working OS desktop. You can open windows, drag them around, resize them, use a real terminal, and browse custom-built versions of my GitHub, LinkedIn, and Fiverr profiles — all without leaving the page.

The OS combines the best of three real systems:
- **macOS** — top bar with system info and a start menu
- **Windows** — dock at the bottom with app icons
- **Linux** — a fully functional terminal with real commands

---

## Why I Built It This Way

I am a Flutter developer. Building my portfolio in Flutter Web means the portfolio itself is a demonstration of my skills — not just a description of them.

---

## Features

### 🖥️ Desktop Environment
- Wallpaper, transparent taskbar and top bar
- Start menu with quick launch and social links
- System status card showing skills, availability, and tech stack
- Desktop-only (intentionally — a mobile OS didn't make sense for this concept)

### 💻 Terminal
A real working terminal with commands that return my actual CV data:

```bash
whoami                 # name, role, bio, availability
cv --view              # full CV output
projects --list        # all projects with descriptions
experience --list      # work history
education --list       # education background
skills --list          # skills with ASCII progress bars
certifications --list  # certifications
contact                # LinkedIn, GitHub, Fiverr
clear
```

### 🌐 Browser
A fake browser window with real tab support that renders custom-built pages:
- **GitHub page** — profile, pinned repos from my real projects, contribution graph
- **LinkedIn page** — full profile with experience, education, skills, certifications
- **Fiverr page** — seller profile, gigs, and reviews

### 🪟 Window System
Every app window is draggable, resizable, and remembers its last position and size — just like a real OS.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter Web | Entire frontend — UI, logic, routing |
| Dart | Language |
| GetX | State management |
| Google Fonts | Oxanium (UI) + JetBrains Mono (terminal) |
| Phosphor Icons | OS-style thin line icons |

No backend. No database. No external APIs. Everything is self-contained intentionally as using a database or API for the data would not have been practical.
Please visit my client project: https://clientzone.mo27.co.za/ as this is more backend and API focussed.

---

## Architecture Highlights

**Separation of concerns** — data, logic, and UI are strictly separated:
- `data/portfolio_data.dart` — all CV content as static constants. One file to update, everything reflects across the entire OS automatically.
- Controllers handle all state (GetX). Widgets never manage their own window state.
- `DraggableResizableWindow` — a reusable wrapper that gives any app window drag, resize, and position memory for free.

**Scalable window system** — adding a new app window requires four steps: register it in the controller, add a dock icon, create the widget, wrap it. No other changes needed.

**Reactive state** — every window's open/closed state, position, and size is stored in `DesktopController` as observable values. Windows react independently without rebuilding the entire widget tree.

---

## About Me

I am a remote Flutter Full Stack developer and BSc Information Technology student at North-West University. I have been building real production applications since I was 16 years old.

- 3+ years of professional Flutter experience
- Full stack: Flutter frontend + Cloud Firestore backend
- Experience across freelance (Fiverr), agency (18INK Productions), and startup (MyEncore CC) environments
- Built and shipped apps used by real clients in production

**Currently:** Available for remote, part-time opportunities.

---

## Project Structure

```
lib/
  main.dart                     # App entry, GetX init
  home_page.dart                # Desktop layout
  controllers/
    desktop_controller.dart     # Window state + DesktopController
  data/
    portfolio_data.dart         # All CV/portfolio content
  os_windows/
    terminal/                   # Terminal app
    browser/                    # Browser app + pages
  pages/
    github_page.dart            # Fake GitHub profile
    linkedin_page.dart          # Fake LinkedIn profile
    fiverr_page.dart            # Fake Fiverr profile
  widgets/
    drag_resize_window.dart     # Reusable window wrapper
    status_card.dart            # Desktop status widget
    start_menu.dart             # Start menu popup
```

---

## Running Locally

```bash
git clone https://github.com/tiaanbothma/portfolio-os
cd portfolio-os
flutter pub get
flutter run -d chrome
```

Requires Flutter 3.x or higher.

---

## License

This repository is open to view for portfolio and reference purposes.  
Redistribution, reuse, or copying of any kind is not permitted without explicit written permission.

Copyright © 2026 Tiaan Bothma. All rights reserved.

---

## Contact

- **GitHub** — https://github.com/TiaanBothma
- **LinkedIn** — https://linkedin.com/in/tiaan-bothma-0b1bb3283/

*Or just open the terminal on the site and type `contact`.*