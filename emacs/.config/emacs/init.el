;; -*- lexical-binding: t; -*-

;; -------------------------------------------------------------------------
;; Startup Performance Optimization
;; -------------------------------------------------------------------------

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
;;(server-start)

;;short answers
(setq use-short-answers t)

;; Bind key for customising variables

(keymap-global-set "C-c w v" 'customize-variable)

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

(load-file (concat (file-name-as-directory user-emacs-directory)
		   "ews.el"))

(ews-missing-executables
 '(("gs" "mutool")
   "pdftotext"
   "soffice"
   "zip"
   "ddjvu"
   "curl"
   ("mpg321" "ogg123" "mplayer" "mpv" "vlc") 
   ("grep" "ripgrep")
   ("convert" "gm")
   "dvipng"
   "latex"
   "hunspell"
   "git"))

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
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))



(setq visible-bell t            ; flash the bell rings
      use-dialog-box nil)       ; no dialog boxes


;; Window management
;; Split windows sensibly

(setq split-width-threshold 120
      split-height-threshold nil)

(use-package balanced-windows
  :config
  (balanced-windows-mode))

;; Enhanced mode line
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-bar-width 3)
  (setq doom-modeline-project-detection 'project)
  (setq doom-modeline-buffer-file-name-style 'relative-from-project))

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

(use-package modus-themes
  :custom
  (modus-themes-to-toggle '(modus-operandi-tinted
			    modus-vivendi-tinted))
  :bind
  (("C-c w t t" . modus-themes-toggle)
   ("C-c w t m" . modus-themes-select)
   ("C-c w t s" . consult-theme)))
(load-theme 'modus-vivendi :no-confirm)

(use-package ef-themes)

; icons
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))


;; -------------------------------------------------------------------------
;; Evil Mode (Vim Emulation)
;; -------------------------------------------------------------------------

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; More comprehensive escape key behavior
(use-package evil-escape
  :init
  (evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

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
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package corfu
  :ensure t
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

(use-package vterm
  :ensure t)

;; Git integration
(use-package magit
  :commands magit-status)

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

;; Configure R formatting style
(setq-default eglot-workspace-configuration
              '((r . ((style.spacing . 1)    ;; Number of spaces around operators
                      (style.indentation . 2) ;; Indentation size
                      (lsp.diagnostics . t)   ;; Keep diagnostics (linting)
                      (lsp.formatting . t))))) ;; Keep formatting enabled
;; Snippets
(use-package yasnippet
  :init (yas-global-mode 1))

(use-package yasnippet-snippets) ;; Collection of snippets

;; Delete the selected text upon text insertion
(use-package delsel
  :ensure nil ; no need to install it as it is built-in
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
(use-package ess
  :init
  (require 'ess-site)
  :config
  ;; Optional: Add command line arguments if needed
  (setq inferior-R-args "--no-save --no-restore-data --quiet"))

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
  :ensure
  nil
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
  :ensure nil
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
  :ensure t
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
  :ensure t
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
  :defer t
  :custom
  (denote-sort-keywords t)
  (denote-link-description-function #'ews-denote-link-description-title-case)
  :hook
  (dired-mode . denote-dired-mode)
  :custom-face
  (denote-faces-link ((t (:slant italic))))
  :bind
  (("C-c w d b" . denote-find-backlink)
   ("C-c w d d" . denote-date)
   ("C-c w d l" . denote-find-link)
   ("C-c w d i" . denote-link-or-create)
   ("C-c w d k" . denote-rename-file-keywords)
   ("C-c w d n" . denote)
   ("C-c w d r" . denote-rename-file)
   ("C-c w d R" . denote-rename-file-using-front-matter)))

(use-package denote-org
  :bind
  (("C-c w d h" . denote-org-link-to-heading)
   ("C-c w d s" . denote-org-extract-subtree)))

;; Consult-Notes for easy access to notes

(use-package consult-notes
  :custom
  (consult-notes-denote-display-keywords-indicator "_")
  :bind
  (("C-c w d f" . consult-notes)
   ("C-c w d g" . consult-notes-search-in-all-notes))
  :init
  (consult-notes-denote-mode))

;; Citar-Denote to manage literature notes

(use-package citar-denote
  :custom
  (citar-open-always-create-notes t)
  :init
  (citar-denote-mode)
  :bind
  (("C-c w b c" . citar-create-note)
   ("C-c w b n" . citar-denote-open-note)
   ("C-c w b x" . citar-denote-nocite)
   :map org-mode-map
   ("C-c w b k" . citar-denote-add-citekey)
   ("C-c w b K" . citar-denote-remove-citekey)
   ("C-c w b d" . citar-denote-dwim)
   ("C-c w b e" . citar-denote-open-reference-entry)))

;; Explore and manage your Denote collection

(use-package denote-explore
  :bind
  (;; Statistics
   ("C-c w x c" . denote-explore-count-notes)
   ("C-c w x C" . denote-explore-count-keywords)
   ("C-c w x b" . denote-explore-barchart-keywords)
   ("C-c w x e" . denote-explore-barchart-filetypes)
   ;; Random walks
   ("C-c w x r" . denote-explore-random-note)
   ("C-c w x l" . denote-explore-random-link)
   ("C-c w x k" . denote-explore-random-keyword)
   ("C-c w x x" . denote-explore-random-regex)
   ;; Denote Janitor
   ("C-c w x d" . denote-explore-identify-duplicate-notes)
   ("C-c w x z" . denote-explore-zero-keywords)
   ("C-c w x s" . denote-explore-single-keywords)
   ("C-c w x o" . denote-explore-sort-keywords)
   ("C-c w x w" . denote-explore-rename-keyword)
   ;; Visualise denote
   ("C-c w x n" . denote-explore-network)
   ("C-c w x v" . denote-explore-network-regenerate)
   ("C-c w x D" . denote-explore-barchart-degree)))

;; Distraction-free writing

(use-package olivetti
  :demand t
  :bind
  (("C-c w o" . ews-olivetti)))

;; ediff

(use-package ediff
  :ensure nil
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
