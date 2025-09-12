;; -*- lexical-binding: t; -*-

;; -------------------------------------------------------------------------
;; Startup Performance Optimization
;; -------------------------------------------------------------------------

;;; code:
;; Restore reasonable GC settings after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000)) ;; 2MB
            (setq gc-cons-percentage 0.1)
            
            ;; Show startup time
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; -------------------------------------------------------------------------
;; Package Management Setup
;; -------------------------------------------------------------------------

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Configure use-package to use straight.el by default
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; stop warnings when installing packages
(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))


;; -------------------------------------------------------------------------
;; Core System Settings
;; -------------------------------------------------------------------------

;;start server for emacs client
;(server-start)

;;short answers
(setq use-short-answers t)

;;prompt for kill emacs
(setq confirm-kill-emacs 'yes-or-no-p)

;; Keep the directory clean
(use-package no-littering
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; Better help system
(use-package helpful
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))

;; Garbage collection magic hack for better performance
(use-package gcmh
  :init (gcmh-mode 1)
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024))) ;; 16MB

(use-package ews
  :straight nil
  :load-path "~/.config/emacs/")

; -------------------------------------------------------------------------
;; Core UI Configuration
;; -------------------------------------------------------------------------

;; Basic UI settings
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative) ;; Vim-like relative line numbers

;;line highlighting
;; let's enable it for all programming major modes
(add-hook 'prog-mode-hook #'hl-line-mode)
;; and for all modes derived from text-mode
(add-hook 'text-mode-hook #'hl-line-mode)


;; disable line numbers in certain modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		eww-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq visible-bell t            ; flash the bell rings
      use-dialog-box nil)       ; no dialog boxes

;; Window management
;; Split windows sensibly

(setq split-width-threshold 120
      split-height-threshold nil)

(use-package balanced-windows
  :config
  (balanced-windows-mode 1))

(use-package popper
  :straight t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints

;; Enhanced mode line
;; (use-package doom-modeline
;;   :init (doom-modeline-mode 1)
;;   :config
;;   (setq doom-modeline-height 25)
;;   (setq doom-modeline-bar-width 3)
;;   (setq doom-modeline-project-detection 'project)
;;   (setq doom-modeline-buffer-file-name-style 'relative-from-project))

(use-package spacious-padding
  :straight t
  :config
  (spacious-padding-mode))

;; Highlight matching parentheses
(show-paren-mode 1)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;font
(let ((mono-spaced-font "CommitMono Nerd Font Mono")
      (proportionately-spaced-font "CommitMono Nerd Font"))
  (set-face-attribute 'default nil :family mono-spaced-font :height 150)
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))

(when (display-graphic-p)
  (context-menu-mode))

(use-package mixed-pitch
  :hook
  (org-mode . mixed-pitch-mode))

;;themes

(use-package modus-themes)

(use-package ef-themes
  :ensure t
  :config
(mapc #'disable-theme custom-enabled-themes)
(setq ef-themes-mixed-fonts t)
(setq ef-themes-to-toggle '(ef-cyprus ef-autumn))
(load-theme 'ef-cyprus :no-confirm-loading))


(use-package doric-themes
  :ensure t
  :demand t
  :config
  ;; These are the default values.
  (setq doric-themes-to-toggle '(doric-light doric-dark))
  (setq doric-themes-to-rotate doric-themes-collection)

  (doric-themes-select 'doric-light)
  :bind
  (("<f5>" . doric-themes-toggle)
   ("C-<f5>" . doric-themes-select)
   ("M-<f5>" . doric-themes-rotate)))

; icons
(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))


;; -------------------------------------------------------------------------
;; Evil Mode (Vim Emulation)
;; -------------------------------------------------------------------------

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; More comprehensive escape key behavior
(use-package evil-escape
  :init
  (evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;; -------------------------------------------------------------------------
;; Key Bindings and Command Discovery
;; -------------------------------------------------------------------------

;; Which Key for discovering keybindings
(use-package which-key
  :config
  (which-key-mode)
  :custom
  (which-key-max-description-length 40)
  (which-key-lighter nil)
  (which-key-sort-order 'which-key-description-order)
  (setq which-key-idle-delay 0.3)
  (which-key-setup-side-window-bottom))
  

;; -------------------------------------------------------------------------
;; Completion Framework
;; -------------------------------------------------------------------------

;; minibuffer completion
(use-package vertico
  :config (vertico-mode))

;; vertico uses posframe (frame in center of screen)
(use-package vertico-posframe
  :init(vertico-posframe-mode 1))

;; adds helpful info about options in minibuffer
(use-package marginalia
  :init (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless flex basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; one column that does not take up whole screen
(setq completions-format 'one-column)
(unless (version< emacs-version "29.0")
  (setq completions-max-height 15))

;; similar to Prot's MCT package
(unless (version< emacs-version "29.0")
  (setq completion-auto-help 'always
        completion-auto-select 'second-tab
        completion-show-help nil
        completions-sort nil
        completions-header-format nil))

;; Enhanced command, buffer, and file selection
(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-c s" . consult-ripgrep)
         ("C-s" . consult-line)))

(use-package savehist
  :straight nil
  :hook (after-init . savehist-mode))

(use-package corfu
  :init (global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :custom
  (tab-always-indent 'complete)
  (corfu-preview-current nil)
  (corfu-min-width 20)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

  ;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))
;; -------------------------------------------------------------------------
;; Development Tools & Features
;; -------------------------------------------------------------------------

(use-package vterm)

;; Git integration
(use-package magit
  :commands magit-status)

(setq-default ispell-program-name "hunspell")

;; Syntax checking
(use-package flycheck
  :init (global-flycheck-mode))

;; LSP support using built-in eglot
(use-package eglot
  :hook ((python-mode . eglot-ensure)
         (r-mode . eglot-ensure)
         (css-mode . eglot-ensure)
         (html-mode . eglot-ensure)
         (web-mode . eglot-ensure)
	 (ess-mode . eglot-ensure))
  :config
  ;; Configure LSP servers
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(r-mode . ("R" "--slave" "-e" "languageserver::run()")))
  (add-to-list 'eglot-server-programs '(web-mode . ("vscode-html-language-server" "--stdio"))))

(use-package yasnippet
  :init (yas-global-mode 1))

(use-package yasnippet-snippets) ;; Collection of snippets

;; Delete the selected text upon text insertion
(use-package delsel
  :straight nil ; no need to install it as it is built-in
  :hook (after-init . delete-selection-mode))


(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Python
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq python-indent-offset 4))

;; Better Python REPL
(use-package jupyter
  :defer t)

;; R support

;; R operator insertion functions
(defun my/insert-r-assignment ()
  "Insert R assignment operator with spaces."
  (interactive)
  (insert " <- "))

(defun my/insert-r-pipe-native ()
  "Insert R native pipe operator with spaces."
  (interactive)
  (insert " |> "))

(use-package ess
  :bind (:map ess-r-mode-map
	("M--" . my/insert-r-assignment)  ; Alt + hyphen
        ("C-c p" . my/insert-r-pipe-native)) ; Ctrl+c p for |>
  :init
  (require 'ess-site)
  :config
  ;; Optional: Add command line arguments if needed
  (setq inferior-R-args "--no-save --no-restore-data --quiet"))

(use-package format-all
  :hook (ess-r-mode . format-all-mode)
  :config
  (setq-default format-all-formatters '(("R" styler))))

(use-package ess-view-data
  :after ess
(require 'ess-view-data))

;; Web development
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
         ("\\.njk\\'" . web-mode)) ;; Nunjucks templates
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-css-colorization t))

;; Emmet for fast HTML/CSS writing
(use-package emmet-mode
  :hook (web-mode . emmet-mode))

;; -------------------------------------------------------------------------
;; data work formats
;; -------------------------------------------------------------------------

;; CSV/TSV file handling
(use-package csv-mode
  :mode "\\.csv\\'")

;; Support for markdown docs
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :mode ("\\.md\\'" . markdown-mode))

(use-package ledger-mode
  :custom
  ((ledger-binary-path "hledger")
   (ledger-mode-should-check-version nil)
   (ledger-report-auto-width nil)
   (ledger-report-links-in-register nil)
   (ledger-report-native-highlighting-arguments '("--color=always")))
  :mode ("\\.hledger\\'" "\\.ledger\\'"))
;; -------------------------------------------------------------------------
;; Org Mode Configuration
;; -------------------------------------------------------------------------

(use-package org
  :config
  (setq org-confirm-babel-evaluate nil)
  ;; Enable code blocks for languages you use
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (R . t)
     (emacs-lisp . t)))
  
  ;; Nice bullets instead of asterisks
  (use-package org-bullets
    :hook (org-mode . org-bullets-mode)))

;; -------------------------------------------------------------------------
;;; General Settings
;; -------------------------------------------------------------------------

(use-package text-mode
  :straight nil
  :hook
  (text-mode . visual-line-mode)
  :init
  (delete-selection-mode t)
  :custom
  (sentence-end-double-space nil)
  (scroll-error-top-bottom t)
  (save-interprogram-paste-before-kill t))

;;recent files
(recentf-mode 1)

;;saves sessions
(desktop-save-mode 1)

;;comand history settings
(setq history-length 25)
(savehist-mode 1)

;; remember and restore the last cursor location of opened files
(save-place-mode 1)

;;revert buffers when the file has been changed
(global-auto-revert-mode 1)

;;dired sees file changes
(setq global-auto-revert-non-file-buffers t)

;; move customization variables to a separate file and load it
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; stop creation of ~ files
(setq make-backup-files nil)

;; C-g is more helpful
(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)

;; -------------------------------------------------------------------------
;;; dired settings
;; -------------------------------------------------------------------------

(use-package dired
  :straight nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

;; -------------------------------------------------------------------------
;;; Denote
;; -------------------------------------------------------------------------

(use-package denote
  :custom
  (denote-sort-keywords t)
  (denote-link-description-function #'ews-denote-link-description-title-case)
  :hook
  (dired-mode . denote-dired-mode)
  :custom-face
  (denote-faces-link ((t (:slant italic))))
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
   :config
   (setq denote-directory (expand-file-name "~/Documents/notes/"))
   (denote-rename-buffer-mode 1)
   (setq denote-prompts '(title keywords))
   (setq denote-infer-keywords t)
   (setq denote-sort-keywords t)
   (setq denote-file-type 'markdown))

(use-package denote-org
  :bind
  (("C-c n d h" . denote-org-link-to-heading)
   ("C-c n d s" . denote-org-extract-subtree)))

(use-package denote-markdown
  :ensure t)

;; Consult-Notes for easy access to notes

(use-package consult-denote
  :ensure t
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

;; Citar-Denote to manage literature notes

(use-package citar-denote
  :custom
  (citar-open-always-create-notes t)
  :init
  (citar-denote-mode)
  :bind
  (("C-c n b c" . citar-create-note)
   ("C-c n b n" . citar-denote-open-note)
   ("C-c n b x" . citar-denote-nocite)
   :map org-mode-map
   ("C-c n b k" . citar-denote-add-citekey)
   ("C-c n b K" . citar-denote-remove-citekey)
   ("C-c n b d" . citar-denote-dwim)
   ("C-c n b e" . citar-denote-open-reference-entry)))

;; Distraction-free writing

(use-package olivetti
  :demand t
  :bind
  (("C-c w o" . ews-olivetti)))

;; ediff

(use-package ediff
  :straight nil
  :custom
  (ediff-keep-variants nil)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain))

;; -------------------------------------------------------------------------
;;; content
;; -------------------------------------------------------------------------

;; Doc-View

(use-package doc-view
  :custom
  (doc-view-resolution 300)
  (large-file-warning-threshold (* 50 (expt 2 20))))

;; Read ePub files

(use-package nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; Read RSS feeds with Elfeed

(use-package elfeed
  :custom
  (elfeed-db-directory
   (expand-file-name "elfeed" user-emacs-directory))
  (elfeed-show-entry-switch 'display-buffer)
  :bind
  ("C-c w e" . elfeed))

(provide 'init)
