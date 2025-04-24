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

(use-package use-package
  :custom
  (use-package-always-ensure t)
  (package-native-compile t)
  (warning-minimum-level :emergency))

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

(provide 'init)
