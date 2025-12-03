;; -*- lexical-binding: t; -*-
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

  ;;;Bootstrap straight.el

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

;; add project and flymake to the pseudo-packages variable so straight.el doesn't download a separate version than what eglot downloads.
(setq straight-built-in-pseudo-packages '(emacs nadvice eglot python image-mode project flymake org org-element org-loaddefs))

;; stop warnings when installing packages

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

;;;Core System Settings

(use-package diminish :ensure t)

;; use zshell
(use-package exec-path-from-shell
  :config
  (setq exec-path-from-shell-shell-name "/usr/bin/zsh")
  (when (daemonp)
    (exec-path-from-shell-initialize)))

;; Use zsh for shell commands
(setq shell-file-name "/usr/bin/zsh")
(setq explicit-shell-file-name "/usr/bin/zsh")

;; make terminals read only after input so to not overwrite previous commands/output
(setq comint-prompt-read-only t)
(defun my-comint-preoutput-turn-buffer-read-only (text)
  (propertize text 'read-only t))
(add-hook 'comint-preoutput-filter-functions 'my-comint-preoutput-turn-buffer-read-only)

;; ansi colors in terminals and such
(use-package ansi-color
  :straight nil
  :config
  ;; For compilation/shell command buffers
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

  ;; Also handle colors in shell-mode if you use M-x shell
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on))

;; Make shell command output buffers easier to read
(with-eval-after-load 'compile
  ;; Automatically scroll to show new output
  (setq compilation-scroll-output t)

  ;; Don't ask to kill the buffer when running new command
  (setq compilation-always-kill t))

(setq use-short-answers t)

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
        gcmh-high-cons-threshold (* 16 1024 1024)) ;; 16MB
  :diminish gcmh-mode)

(electric-pair-mode 1)
(use-package ews
  :straight nil
  :load-path "~/.config/emacs/lisp")

  ;;; Core UI Configuration

;; Basic UI settings
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative) ;; Vim-like relative line numbers

;;line highlighting
;;enable it for all programming major modes
(add-hook 'prog-mode-hook #'hl-line-mode)
;;and for all modes derived from text-mode
(add-hook 'text-mode-hook #'hl-line-mode)


;; disable line numbers in certain modes
(dolist (mode '(org-mode-hook
    		  term-mode-hook
    		  vterm-mode-hook
    		  R-mode-hook
	        inferior-ess-r-mode-hook
  		  inferior-python-mode
    	          eshell-mode-hook
    		  eww-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq visible-bell t            ; flash the bell rings
      use-dialog-box nil)       ; no dialog boxes

;; Split windows sensibly

(setq split-width-threshold 120
      split-height-threshold nil)

;(use-package balanced-windows
;  :config
;  (balanced-windows-mode 1))

(use-package popper
  :straight t
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
	  "\\*eshell\\*"
	  "\\*vterm\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
	  "\\*python:main\\*"
          help-mode
	  helpful-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints

(use-package modus-themes
  :config
  (mapc #'disable-theme custom-enabled-themes)
  (modus-themes-include-derivatives-mode 1)

  :bind ("<f5>" . modus-themes-toggle)
  :custom
  (modus-themes-mixed-fonts t)
  (modus-themes-variable-pitch-ui t)
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-completions '((t . (bold))))
  (modus-themes-prompts '(bold))
  (modus-themes-headings
         '((agenda-structure . (variable-pitch light 2.2))
          (agenda-date . (variable-pitch regular 1.3))
          (t . (regular 1.15))))
  )

(use-package ef-themes)

(use-package doric-themes
  :defer t)

(use-package theme-buffet
      :after (modus-themes ef-themes)  ; add your favorite themes here
      :init
      ;; variable below needs to be set when you just want to use the timers mins/hours
      (setq theme-buffet-menu 'modus-ef) ; changing default value from built-in to modus-ef
      :config
      ;;; one of the three below can be uncommented
      ;; (theme-buffet-modus-ef)
      ;; (theme-buffet-built-in)
      ;; (theme-buffet-end-user)
      ;;; two additional timers are available for theme change, both can be set
      (theme-buffet-timer-mins 25)  ; change theme every 25m from now, similar below
      (theme-buffet-timer-hours 2))

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

(use-package spacious-padding
  :config
  (setq spacious-padding-subtle-frame-lines
     	`( :mode-line-active 'default
           :mode-line-inactive vertical-border))
  :custom
  (line-spacing 3)
  (spacious-padding-mode 1))

;; see colors
(use-package rainbow-mode)

;; Highlight matching parentheses
(show-paren-mode 1)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package fontaine
  :straight t
  :init
  ;; Set the state file location BEFORE the package loads
  (setq fontaine-latest-state-file
        (locate-user-emacs-file "fontaine-latest-state.eld"))

  :config
  ;; Configure presets AFTER the package loads
  (setq fontaine-presets
        '((small
           :default-family "Aporetic Serif Mono"
           :default-height 80
           :variable-pitch-family "Aporetic Sans")
          (regular) ; uses all fallback values and is named `regular'
          (medium
           :default-weight semilight
           :default-height 115
           :bold-weight extrabold)
          (large
           :inherit medium
           :default-height 140)
          (presentation
           :default-height 180)
          (t
           ;; Default preset with all properties
           :default-family "Aporetic Sans Mono"
           :default-weight regular
           :default-height 100

           :fixed-pitch-family nil ; falls back to :default-family
           :fixed-pitch-weight nil ; falls back to :default-weight
           :fixed-pitch-height 1.0

           :fixed-pitch-serif-family nil
           :fixed-pitch-serif-weight nil
           :fixed-pitch-serif-height 1.0

           :variable-pitch-family "Aporetic Serif"
           :variable-pitch-weight nil
           :variable-pitch-height 1.0

           :mode-line-active-family nil
           :mode-line-active-weight nil
           :mode-line-active-height 0.9

           :mode-line-inactive-family nil
           :mode-line-inactive-weight nil
           :mode-line-inactive-height 0.9

           :header-line-family nil
           :header-line-weight nil
           :header-line-height 0.9

           :line-number-family nil
           :line-number-weight nil
           :line-number-height 0.9

           :tab-bar-family nil
           :tab-bar-weight nil
           :tab-bar-height 1.0

           :tab-line-family nil
           :tab-line-weight nil
           :tab-line-height 1.0

           :bold-family nil
           :bold-weight bold

           :italic-family nil
           :italic-slant italic

           :line-spacing nil)))

  ;; Set the initial preset
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))

  ;; Enable fontaine-mode to persist settings
  (fontaine-mode 1)

  :bind ("C-c f" . fontaine-set-preset))

(use-package show-font
  :bind
  (("C-c s f" . show-font-select-preview)
   ("C-c s t" . show-font-tabulated)))

;;; Evil Mode (Vim Emulation)

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
  (evil-collection-init)
  :diminish evil-collection-unimpaired-mode)

;; More comprehensive escape key behavior
(use-package evil-escape
  :init
  (evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2)
  :diminish evil-escape-mode)

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1)
  :diminish evil-surround-mode
  )

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode)
  :diminish evil-commentary-mode)

  ;;; Which Key
(use-package which-key
  :init
  (setq which-key-idle-delay 0.3)
  :config
  (which-key-mode)
  :custom
  (which-key-max-description-length 80)
  (which-key-lighter nil)
  (which-key-sort-order 'which-key-description-order)
  (which-key-side-window-location 'bottom)
  (which-key-popup-type 'minibuffer))

  ;;; Completion Framework
;; minibuffer completion
(use-package vertico
  :config (vertico-mode))


;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  ; (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))


;; vertico uses posframe (frame in center of screen)
(use-package vertico-posframe
  :init (vertico-posframe-mode 1))

;; adds helpful info about options in minibuffer
(use-package marginalia
  :init (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless flex basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; one column that does not take up whole screen
(setq completions-format 'one-column)
(unless (version< emacs-version "29.0")
  (setq completions-max-height 20))

;; similar to Prot's MCT package
(setq completion-auto-help 'always
      completion-auto-select 'second-tab
      completion-show-help nil
      completions-sort nil
      completions-header-format nil)

(file-name-shadow-mode 1)

(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

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
  :bind (:map corfu-map
	      ("<tab>" . corfu-complete)
	      ("TAB" . corfu-complete)
	      ("RET" . nil)
	      )
  :custom
  (tab-always-indent 'complete)
  (corfu-preselect 'prompt)
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

(use-package cape
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
  )
(use-package embark
  :bind
  (("C-," . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h b" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  (vertico-multiform-mode)
  (add-to-list 'vertico-multiform-categories '(embark-keybinding grid))

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

      ;;; Development Tools & Features
(use-package vterm)

;; Git integration
(use-package magit
  :commands magit-status)

(setq-default ispell-program-name "hunspell")


;; LSP support using built-in eglot
(use-package eglot
  :straight nil
  :hook ((python-ts-mode . eglot-ensure)  ; Python
         ;(r-mode . eglot-ensure)           ; R
         (css-mode . eglot-ensure)         ; CSS
         (html-mode . eglot-ensure)        ; HTML
         (web-mode . eglot-ensure))        ; Web templates
  :config
  ;; Configure LSP servers
  (add-to-list 'eglot-server-programs '(python-ts-mode . ("pylsp")))
  (add-to-list 'eglot-server-programs '(r-mode . ("R" "--slave" "-e" "languageserver::run()")))
  (add-to-list 'eglot-server-programs '(web-mode . ("vscode-html-language-server" "--stdio")))
  (setq eglot-autoshutdown t  ; Shutdown server when last buffer is killed
        eglot-sync-connect nil))  ; Don't block on connection
;; try this later so that pylsp is running from uv
;; `((python-ts-mode python-mode) . ("uv" "tool" "run" "--from" "python-lsp-server[all]" "pylsp")))

;; Syntax checking
(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-eglot
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

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

;;; eshell customization
(use-package eshell
  :straight nil  ; built-in
  :bind ("C-c e" . eshell)
  :config
  ;; Better prompt
  (defun my/eshell-prompt ()
    (concat
     ;; Directory
     (propertize (abbreviate-file-name (eshell/pwd))
                 'face '(:foreground "purple"))
     ;; Git branch if in repo
     (when-let ((branch (magit-get-current-branch)))
       (propertize (format " (%s)" branch)
                   'face '(:foreground "green")))
     ;; Prompt symbol
     (if (= (user-uid) 0) " # " " $ ")))

  (setq eshell-prompt-function #'my/eshell-prompt)

  ;; History settings
  (setq eshell-history-size 10000
        eshell-hist-ignoredups t
        eshell-save-history-on-exit t
        eshell-history-file-name
        (expand-file-name "eshell/history" user-emacs-directory))

  ;; Scrolling behavior
  (setq eshell-scroll-to-bottom-on-input t
        eshell-scroll-show-maximum-output t
        eshell-buffer-maximum-lines 10000)

  ;; Prefer Emacs commands over external
  (setq eshell-prefer-lisp-functions t
        eshell-prefer-lisp-variables t)

  ;; Enable smart mode (optional - try without first)
  ;; Load the smart module
  (require 'em-smart)

  ;; Add it to modules list
  (add-to-list 'eshell-modules-list 'eshell-smart)

  ;; Better completion
  (setq eshell-cmpl-ignore-case t))

;;;; Python
(use-package python
  :straight nil
  :init
  :config
  (setq python-indent-offset 4)
  (setq python-shell-completion-native-enable nil))

(use-package uv
  :straight (uv :type git :host github :repo "johannes-mueller/uv.el")
  :init
  (add-to-list 'treesit-language-source-alist '(toml "https://github.com/tree-sitter-grammars/tree-sitter-toml"))
  (unless (treesit-language-available-p 'toml)
    (treesit-install-language-grammar 'toml)))

(use-package py-vterm-interaction
  :after python
  :hook (python-ts-mode . py-vterm-interaction-mode)
  :config
    ;;; Suggested:
  ;; (setq-default py-vterm-interaction-repl-program "ipython")
  ;;(setq-default py-vterm-interaction-silent-cells t)
  )

;;;; R support

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
  :commands (R r ess-r-mode)
  :mode (("\\.R\\'" . ess-r-mode)
         ("\\.r\\'" . ess-r-mode)
         ("\\.Rmd\\'" . poly-markdown+r-mode))
  :config
  (setq inferior-R-args "--no-save --no-restore-data --quiet")
  (setq ess-ask-for-ess-directory nil)
  (setq ess-use-flymake nil)
  (setq ess-use-eldoc nil)
  (setq ess-eldoc-show-on-symbol nil)
  (setq ess-use-R-completion nil)
  (setq ess-history-file nil) 
  (setq ess-history-file nil)
  (setq comint-move-point-for-output t) 
  (setq comint-prompt-read-only t)
  
  (define-key ess-r-mode-map (kbd "M--") #'my/insert-r-assignment)
  (define-key ess-r-mode-map (kbd "C-S-m") #'my/insert-r-pipe-native)
  
  ;; Also bind in the inferior (REPL) buffer
  (define-key inferior-ess-r-mode-map (kbd "M--") #'my/insert-r-assignment)
  (define-key inferior-ess-r-mode-map (kbd "C-S-m") #'my/insert-r-pipe-native))


;; (defun my/start-httpgd ()
;;   "Start httpgd server for R plotting."
;;   (interactive)
;;   (ess-eval-linewise "if (!httpgd::hgd_url()) httpgd::hgd(host='127.0.0.1', port=8888)")
;;   (browse-url "http://127.0.0.1:8888/live"))
;; 
;; ;; Bind to a key
;; (with-eval-after-load 'ess-r-mode
;;   (define-key ess-r-mode-map (kbd "C-c C-g") #'my/start-httpgd))

(use-package ess-plot
  :straight (ess-plot :type git :host github :repo "DennieTeMolder/ess-plot")
  :hook (ess-r-post-run . ess-plot-on-startup-h))

(use-package format-all
  :commands (format-all-buffer)
  :config
  (setq-default format-all-formatters '(("R" styler))))

(use-package ess-view-data
  :after ess
  :commands (ess-view-data-print))

(use-package poly-R
  :defer t
  :mode (("\\.Rmd\\'" . poly-markdown+r-mode)))

(use-package quarto-mode
  :defer t
  :mode ("\\.qmd\\'" . quarto-mode))

;;;; Web development
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

  ;;;; data work formats

;; CSV/TSV file handling
(use-package csv-mode
  :mode "\\.csv\\'")

;; Support for markdown docs
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :mode ("\\.md\\'" . markdown-mode))

;; Hledger
(use-package ledger-mode
  :custom
  ((ledger-binary-path "hledger")
   (ledger-mode-should-check-version nil)
   (ledger-report-auto-width nil)
   (ledger-report-links-in-register nil)
   (ledger-report-native-highlighting-arguments '("--color=always")))
  :mode ("\\.hledger\\'" "\\.ledger\\'"))

;;; Org Mode Configuration
(use-package org
  :straight nil
  :config
  ;; Global keybindings (set early so they're available)
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c l") 'org-store-link)

  :custom
  ;; Appearance
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-startup-with-inline-images t)
  (org-image-actual-width '(450))
  (org-pretty-entities t)
  (org-use-sub-superscripts "{}")
  (org-fold-catch-invisible-edits 'show)
  (org-fontify-quote-and-verse-blocks t)
  (org-fontify-whole-block-delimiter-line t)

  ;; Editing behavior
  (org-M-RET-may-split-line '((default . nil)))
  (org-insert-heading-respect-content t)
  (org-return-follows-link t)
  (org-fold-catch-invisible-edits 'show-and-error)

  ;; Links
  (org-id-link-to-org-use-id t)
  (org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (org-refile-allow-creating-parent-nodes 'confirm)
 )

(use-package org
  :config
  ;; Don't ask for confirmation when executing code blocks
  (setq org-confirm-babel-evaluate nil)

  ;; Enable languages for babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (R . t)
     (emacs-lisp . t)
     (shell . t)))

  ;; Source block editing behavior
  (setq org-src-fontify-natively t      ; Syntax highlight in src blocks
        org-src-tab-acts-natively t     ; Tab works like in the language's major mode
        org-src-preserve-indentation t  ; Don't add extra indentation
        org-edit-src-content-indentation 0))

(with-eval-after-load 'org
  (setq org-structure-template-alist
        '(("s" . "src")
          ;; Emacs Lisp (lowercase e for simple, uppercase E for fancy)
          ("e" . "src emacs-lisp")
          ("E" . "src emacs-lisp :results value code :lexical t")
          ;; Python
          ("p" . "src python")
          ("po" . "src python :results output")
          ("ps" . "src python :session :results output")
          ;; R
          ("r" . "src R")
          ("rp" . "src R :results output graphics file :file plot.png")
          ;; Shell
          ("b" . "src bash")
          ("sh" . "src shell :results output")
          ;; Documentation blocks
          ("x" . "example")
          ("q" . "quote")
          ("v" . "verse"))))

(with-eval-after-load 'org
  (setq org-babel-default-header-args:R
        '((:session . "*R*")           ; Use persistent R session
          (:results . "output")        ; Show console output
          (:exports . "both")          ; Export code and results
          (:cache . "no")              ; Don't cache (for interactive work)
          (:tangle . "no"))))

(defun my/babel-ansi-colorize-results ()
  "Apply ANSI color escape sequences to Org Babel results."
  (when-let ((beg (org-babel-where-is-src-block-result nil nil)))
    (save-excursion
      (goto-char beg)
      (when (looking-at org-babel-result-regexp)
        (let ((end (org-babel-result-end))
              (ansi-color-context-region nil))
          (ansi-color-apply-on-region beg end))))))

(add-hook 'org-babel-after-execute-hook 'my/babel-ansi-colorize-results)

(use-package org
  :config
  (setq org-capture-templates
        '(("i" "Inbox" entry
           (file+headline "~/Documents/notes/inbox.org" "Inbox")
           "* %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\nContext: %a"
           :empty-lines 1)

          ("t" "Todo" entry
           (file+headline "~/Documents/notes/inbox.org" "Tasks")
           "* TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\nContext: %a"
           :empty-lines 1))))

(use-package org
  :config
  (setq org-agenda-files '("~/Documents/notes/inbox.org" "~/Documents/notes/projects.org")))

(use-package org
  :custom
  (org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)" "CANCELLED(c@/!)")
          (sequence "GOAL(g)" "|" "ACHIEVED(a!)" "ABANDONED(x@/!)")))

  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies t)
  
  (org-tag-alist
        '(("parenting" . ?P)
          ("home" . ?h)
          ("finances" . ?$)
          ("travel" . ?t)
          ("photography" . ?p)
          ("admin" . ?a)))

  (org-agenda-custom-commands
        '(("c" "Contexts"
	   (
	    (todo "GOAL"
		       ((org-agenda-overriding-header "Goals")))



	    ;; To do next
	    (tags-todo "TODO=\"NEXT\""
		       ((org-agenda-overriding-header "NEXT")))


	    ;; scheduled for today
	    ;; due this week
	    
	    ;; main tags
	    (tags-todo "admin"
                       ((org-agenda-overriding-header "Admin Tasks")))
	    (tags-todo "home"
                       ((org-agenda-overriding-header "Home")))
            (tags-todo "finances"
                       ((org-agenda-overriding-header "Finances")))
	    (tags-todo "travel"
                       ((org-agenda-overriding-header "travel")))
	    (tags-todo "photography"
                       ((org-agenda-overriding-header "photography")))

	    ;; misc tags
	    (tags-todo "-admin-home-finances-travel-photography"
                       ((org-agenda-overriding-header "misc")))

	    ;; untagged
	    (tags-todo "-{.*}"
                       ((org-agenda-overriding-header "Untagged")))

	;; View recent accomplishments
	    ;((tags "CLOSED>=\"<-7d>\""
            ;      ((org-agenda-overriding-header "✅ Completed Last 7 Days")))
                   ;(org-agenda-files '("~/Documents/notes/archive.org")))
	    ))))

  (org-agenda-prefix-format
          '((agenda . " %i %-12:c%?-12t% s")
            (todo . " %i %-12:c")
            (tags . " %i %-12:c")
            (search . " %i %-12:c")))
  
  (org-agenda-todo-keyword-format "%-1s")
  (org-agenda-fontify-priorities 'cookies)
  
  
  ;; Log when tasks are completed
  (org-log-done 'time)
  (org-log-into-drawer t))

(use-package org
  :config
  (setq org-archive-location "~/Documents/notes/archive.org::datetree/"))

(defun my/dedicated-agenda-frame ()
  "Open org-agenda in a clean, dedicated frame."
  (interactive)
  (let ((display-buffer-alist
         '((".*" (display-buffer-same-window)))))
    (with-selected-frame (make-frame '((name . "*Org Agenda*")))
      (switch-to-buffer "*scratch*")
      (delete-other-windows)
      (org-agenda nil "c"))))

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(use-package org-block-capf
  :straight (org-block-capf :type git :host github :repo "xenodium/org-block-capf")
  :hook (org-mode . org-block-capf-add-to-completion-at-point-functions))

;;; General Settings

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

;;comand history settings
(setq history-length 25)

;; remember and restore the last cursor location of opened files
(save-place-mode 1)

;;revert buffers when the file has been changed
(global-auto-revert-mode 1)

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

;;; dired settings
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
  (setq dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso")
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

(use-package dired-preview
  :after dired
  :config
  (setq dired-preview-delay 0.7)
  (setq dired-preview-max-size (expt 2 25))
  (setq dired-preview-ignored-extensions-regexp
        (concat "\\."
                "\\(gz\\|"
                "zst\\|"
                "tar\\|"
                "xz\\|"
                "rar\\|"
                "zip\\|"
                "iso\\|"
                "RAF\\|"
                "epub"
                "\\)"))

  (dired-preview-global-mode 1))

(use-package bibtex
  :custom
  (bibtex-user-optional-fields
   '(("keywords" "Keywords to describe the entry" "")
     ("file"     "Relative or absolute path to attachments" "" )))
  (bibtex-align-at-equal-sign t)
  :config
  (ews-bibtex-register)
  :bind
  (("C-c b r" . ews-bibtex-register)))

;; Biblio package for adding BibTeX records

(use-package biblio
  :bind
  (("C-c b b" . ews-bibtex-biblio-lookup)))

;; Citar to access bibliographies

(use-package citar
  :defer t
  :custom
  (citar-bibliography ews-bibtex-files))

  ;;; Denote
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
   ("C-c n d" . denote-dired))
  :config
  (setq denote-directory (expand-file-name "~/Documents/notes/"))
  (denote-rename-buffer-mode 1)
  (setq denote-prompts '(title keywords signature))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-file-type 'org))

(use-package denote-org
  :bind
  (("C-c n o h" . denote-org-link-to-heading)
   ("C-c n o s" . denote-org-extract-subtree)))

(use-package denote-markdown)

;; Consult-Notes for easy access to notes

(use-package consult-notes
  :custom
  (consult-notes-denote-display-keywords-indicator "_")
  :bind
  (("C-c d f" . consult-notes)
   ("C-c d g" . consult-notes-search-in-all-notes))
  :init
  (consult-notes-denote-mode))

(use-package consult-denote
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package denote-sequence
  :bind
  ( :map global-map
    ;; Here we make "C-c n s" a prefix for all "[n]otes with [s]equence".
    ;; This is just for demonstration purposes: use the key bindings
    ;; that work for you.  Also check the commands:
    ;;
    ;; - `denote-sequence-new-parent'
    ;; - `denote-sequence-new-sibling'
    ;; - `denote-sequence-new-child'
    ;; - `denote-sequence-new-child-of-current'
    ;; - `denote-sequence-new-sibling-of-current'
    ("C-c n s s" . denote-sequence)
    ("C-c n s f" . denote-sequence-find)
    ("C-c n s l" . denote-sequence-link)
    ("C-c n s d" . denote-sequence-dired)
    ("C-c n s r" . denote-sequence-reparent)
    ("C-c n s c" . denote-sequence-convert)))

;; Citar-Denote to manage literature notes

(use-package citar-denote
  :custom
  (citar-bibliography '("~/Documents/library/all.bib"))
  (citar-open-always-create-notes t)
  :init
  (citar-denote-mode)
  :bind
  (("C-c n c c" . citar-create-note)
   ("C-c n c n" . citar-denote-open-note)
   ("C-c n c x" . citar-denote-nocite)
   :map org-mode-map
   ("C-c n c k" . citar-denote-add-citekey)
   ("C-c n c K" . citar-denote-remove-citekey)
   ("C-c n c d" . citar-denote-dwim)
   ("C-c n c e" . citar-denote-open-reference-entry)))

;;; content
;; Distraction-free writing

(use-package olivetti
  :demand t
  :bind
  (("C-c o" . ews-olivetti)))

;; ediff
(use-package ediff
  :straight nil
  :custom
  (ediff-keep-variants nil)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain))

;; Doc-View
(use-package doc-view
  :custom
  (doc-view-resolution 300)
  (large-file-warning-threshold (* 50 (expt 2 20))))

;;;; PDF Tools
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :init
  ;; Point to the manually compiled server
  (setq pdf-info-epdfinfo-program
        (expand-file-name "straight/repos/pdf-tools/server/epdfinfo"
                          user-emacs-directory))
  :config
  ;; Load pdf-tools
  (pdf-loader-install)

  ;; Display settings
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-resize-factor 1.1)  ; Zoom increment

  ;; Annotation settings
  (setq pdf-annot-activate-created-annotations t)

  ;; Keybindings for common tasks
  :bind (:map pdf-view-mode-map
              ;; Annotations
              ("C-c C-a h" . pdf-annot-add-highlight-markup-annotation)
              ("C-c C-a t" . pdf-annot-add-text-annotation)
              ("C-c C-a d" . pdf-annot-delete)
              ("C-c C-a l" . pdf-annot-list-annotations)
              ;; Navigation
              ("M-g g" . pdf-view-goto-page)))

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
