;; -*- lexical-binding: t; -*-

;; Adjust garbage collection for startup
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.6)

;; Disable package.el initialization at startup
;; We'll use straight.el for package management instead
(setq package-enable-at-startup nil)

;; Prevent UI elements from showing during startup
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(internal-border-width . 0) default-frame-alist)
(push '(undecorated . t) default-frame-alist) ;; Remove frame decoration

;; Use a dark background from the start to prevent white flash
(push '(background-color . "#000000") default-frame-alist)
(push '(foreground-color . "#bbc2cf") default-frame-alist)

;; Don't resize the frame at this early stage
(setq frame-inhibit-implied-resize t)

;; Disable startup screen while loading
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message user-login-name)
(setq initial-scratch-message nil)

;; Speed up initial rendering
(setq redisplay-skip-fontification-on-input t)
(setq fast-but-imprecise-scrolling t)
(setq inhibit-compacting-font-caches t)

;; Disable bidirectional text rendering for performance
(setq-default bidi-display-reordering 'left-to-right)
(setq-default bidi-paragraph-direction 'left-to-right)

;; Prevent unwanted runtime builds for native compilation
;; Only relevant if using native-comp branch of Emacs
(when (featurep 'native-comp)
  (setq native-comp-deferred-compilation nil)
  (setq native-comp-speed 2)
  (setq native-comp-async-report-warnings-errors nil))

;; Disable file handlers during startup
(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore file handlers after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist default-file-name-handler-alist)))

;; Keep custom settings in a separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Set default coding system
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

;;; early-init.el ends here
