;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package tangotango-theme
  ;; Dark theme using the Tango color palette
  :ensure t
  :init (load-theme 'tangotango t)
  :config (let ((gray    "#444455") (black "#888a85")
                (red     "tomato")  (green "#8ae234")
                (yellow  "#edd400") (blue  "#729fcf")
                (magenta "#ad7fa8") (cyan  "pale-turquoise")
                (white   "#eeeeec") (bg    "#2e3434"))
            (require 'whitespace)
            (set-face-attribute 'whitespace-space   nil :foreground gray)
            (set-face-attribute 'whitespace-tab     nil :foreground gray)
            (set-face-attribute 'whitespace-newline nil :foreground gray)

            (require 'term)
            (set-face-attribute 'term-color-black   nil :foreground black)
            (set-face-attribute 'term-color-red     nil :foreground red)
            (set-face-attribute 'term-color-green   nil :foreground green)
            (set-face-attribute 'term-color-yellow  nil :foreground yellow)
            (set-face-attribute 'term-color-blue    nil :foreground blue)
            (set-face-attribute 'term-color-magenta nil :foreground magenta)
            (set-face-attribute 'term-color-cyan    nil :foreground cyan)
            (set-face-attribute 'term-color-white   nil :foreground white)

            ;; UI Elements
            (set-face-attribute 'fringe             nil :foreground gray :background bg)
            (set-face-attribute 'mode-line          nil :box nil :underline gray :overline gray)
            (set-face-attribute 'mode-line-inactive nil :box nil :underline gray :overline gray)))

(use-package diminish
  ;; Remove minor-mode cruft from the status line
  :ensure t)

(use-package smartrep
  ;; Easy repeating keybinds
  :ensure t
  :init (require 'smartrep))

(use-package ido
  ;; Nicer file/buffer/etc. switching
  :ensure t
  :init (ido-mode 1)
  :config (setq ido-save-directory-list-file "~/.emacs.d/tmp/ido"
                ido-enable-flex-matching t
                ido-use-virtual-buffers t
                ido-default-buffer-method 'samewindow
                ido-default-file-method 'samewindow
                ido-ignore-buffers (append ido-ignore-buffers
                                           '("\\*Messages\\*" "\\*Compile-Log\\*"
                                             "\\*Completions\\*" "\\*Help\\*"
                                             "\\*magit-process\\*"))))

(use-package flx-ido
  ;; Flex-matching algorithm for ido
  :ensure t
  :init (flx-ido-mode 1)
  :config (setq flx-ido-use-faces nil))

(use-package ido-ubiquitous
  ;; Allow ido-style completion in more places
  :ensure t
  :requires ido
  :init (ido-ubiquitous-mode 1))

(use-package ido-vertical-mode
  ;; Display ido completions in a vertical list
  :ensure t
  :requires (ido ido-ubiquitous)
  :init (ido-vertical-mode 1))

(use-package recentf
  ;; Stores recent files for easy access
  :ensure t
  :config (setq recentf-save-file "~/.emacs.d/tmp/recent-files"))

(use-package smex
  ;; Smarter M-x with ido completion
  :ensure t
  :requires (recentf ido)
  :init (smex-initialize)
  :config (setq smex-save-file "~/.emacs.d/tmp/smex-items"
                smex-key-advice-ignore-menu-bar t)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c M-x" . execute-extended-command)))

(use-package term
  ;; term and ansi-term
  :config (progn
            (defun rm-ansi-term ()
              (interactive)
              (let ((buffer (get-buffer "*ansi-term*")))
                (if buffer
                    (switch-to-buffer buffer)
                  (ansi-term (getenv "SHELL")))))
            (define-key rm-map (kbd "t") 'rm-ansi-term)
            (define-key term-raw-map (kbd "C-h") nil)
            (define-key term-raw-map (kbd "M-x") nil)))

(use-package js2-mode
  ;; A better javascript mode
  :ensure t
  :mode "\\.js\\|\\.jsx\\'")

(use-package jinja2-mode
  ;; Support for jinja-style templates
  :ensure t
  :mode "\\.jinja\\|\\.html\\'")

(use-package python
  ;; fgallina's python mode
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :config (progn
            (define-key python-mode-map (kbd "RET") 'newline-and-indent)
            (defun rm-fix-python-tab-width ()
              (setq tab-width 4
                    python-indent-offset 4))
            (add-hook 'python-mode-hook 'rm-fix-python-tab-width)))

(use-package whitespace
  ;; Display whitespace as meaningful characters
  :ensure t
  :diminish whitespace-mode
  :init (add-hook 'prog-mode-hook (lambda () (whitespace-mode 1)))
  :config (setq whitespace-style
                '(face tabs spaces trailing
                       space-before-tab newline
                       space-mark tab-mark newline-mark)
                whitespace-display-mappings
                '((space-mark ?\s [?·])
                  (newline-mark ?\n [?⏎ ?\n])
                  (tab-mark ?\t [?⇥ ?\t]))))

(use-package uniquify
  ;; Better display duplicate buffer names
  :init (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

(use-package org
  ;; Org mode
  :ensure t
  :config (progn
            (setq org-startup-indented t
                  org-default-notes-file "~/org/todo.org"
                  org-archive-location "~/org/archive.org::* From %s"
                  org-agenda-files '("~/org/todo.org" "~/org/meetings/")
                  org-plantuml-jar-path (expand-file-name "~/bin/plantuml.jar")
                  org-src-fontify-natively t
                  org-todo-keywords '((sequence "TODO" "IN PROGRESS" "|" "DONE")
                                      (sequence "|" "CANCELED"))
                  org-todo-keyword-faces '(("IN PROGRESS" . "#fff68f"))
                  org-agenda-custom-commands
                  '(("u" "Agenda and all unscheduled TODO's"
                     ((agenda "")
                      (todo "" ((org-agenda-todo-ignore-scheduled t)
                                (org-agenda-todo-ignore-deadlines t))))))
                  org-agenda-sorting-strategy
                  '((agenda habit-down time-up priority-down category-keep todo-state-down)
                    (todo priority-down category-keep todo-state-down)
                    (tags priority-down category-keep)
                    (search category-keep)))

            (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))))

(use-package org-capture
  ;; Quickly make notes to reference later
  :requires org
  :config (progn
            (setq org-capture-templates
                  '(("t" "Todo" entry (file org-default-notes-file))))
            (define-key rm-map (kbd "c") 'org-capture)))

(use-package multiple-cursors
  ;; Run commands on multiple parts of the buffer simultaniously
  :ensure t
  :config (smartrep-define-key global-map "C-h"
            '(("n" . 'mc/mark-next-like-this)
              ("s" . 'mc/skip-to-next-like-this)
              ("p" . 'mc/unmark-next-like-this))))

(use-package ack
  ;; Replacement for M-x find-grep
  :ensure t
  :init (defalias 'ag 'ack)
  :config (setq ack-command
                (concat (cond ((executable-find "ag"))
                              ((executable-find "ack-grep"))
                              ((executable-find "ack"))) " ")))

(use-package ps-print
  ;; Pretty printing
  :ensure t
  :config (setq ps-number-of-columns 2
                ps-landscape-mode t
                ps-header-font-size '(8.5 . 10)
                ps-font-size '(6 . 7.5)
                ps-print-color-p 'black-white
                ps-header-offset 14
                ps-inter-column 40
                ps-left-margin 40
                ps-right-margin 40))

(use-package tramp
  ;; Transparent Remote Access
  :ensure t
  :config (setq tramp-default-method "ssh"
                tramp-persistency-file-name "~/.emacs.d/tmp/tramp"
                tramp-shell-prompt-pattern
                "\\(?:^\\|

(use-package tramp-term
  ;; Create remote ansi-terms that automatically track pwd
  :ensure t
  :init (defalias 'ssh 'tramp-term)
  :commands tramp-term)

(use-package saveplace
  ;; Restore point position when revisiting a file
  :init (require 'saveplace)
  :config (progn
            (setq-default save-place t)
            (setq save-place-file "~/.emacs.d/tmp/places")))

(use-package savehist
  ;; Restore minibuffer history
  :init (savehist-mode 1)
  :config (setq savehist-file "~/.emacs.d/tmp/history"))

(use-package hippie-exp
  ;; Extensive list of completion methods
  :bind (("M-/" . hippie-expand)))

(use-package hideshow
  ;; Code folding
  :diminish hs-minor-mode
  :init (progn
          (defun rm-hs-toggle (arg)
            "Simple single-key folding"
            (interactive "p")
            (call-interactively
             (cond ((>= arg 16) 'hs-show-all)
                   ((>= arg 4) 'hs-hide-all)
                   (t 'hs-toggle-hiding))))
          (add-hook 'prog-mode-hook (lambda () (hs-minor-mode 1))))
  :bind ("C-z" . rm-hs-toggle))

(use-package magit
  :ensure t
  :config (progn
            (setq magit-completing-read-function 'magit-ido-completing-read
                  magit-status-buffer-switch-function 'switch-to-buffer
                  magit-save-some-buffers t
                  magit-process-popup-time 10)
            (define-key rm-map (kbd "s") 'magit-status)))

(use-package magit-svn
  :ensure t
  :init (progn
          (require 'magit-svn)
          (defun init-magit-svn-mode-maybe ()
            (if (magit-svn-get-ref-info)
                (magit-svn-mode)))
          (add-hook 'magit-mode-hook 'init-magit-svn-mode-maybe)))

(use-package flycheck
  ;; Syntax checking on the fly
  :ensure t
  :config (smartrep-define-key rm-map "F"
            '(("n" . 'flycheck-next-error)
              ("p" . 'flycheck-previous-error))))

(provide 'rm-packages)