
;;initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


(use-package ivy)
(ivy-mode 1)

;;ui set up
(setq inhibit-startup-message t ; no splash screen
      visible-bell t ; flash the bell rings
      use-dialog-box nil)       ; no dialog boxes
(setq display-line-numbers-type 'relative)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)

; disable line numbers in certain modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))





(set-face-attribute 'default nil :font "CommitMono Nerdfont")


(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))



;;themes
(load-theme 'modus-vivendi t)

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


