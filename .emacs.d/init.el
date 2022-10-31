(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-general)
;; (if (version< emacs-version "24.4")
    ;; (require 'setup-ivy-counsel)
  ;; (require 'setup-helm)
  ;; (require 'setup-helm-gtags))
;; (require 'setup-ggtags)  ;; this makes my CPU run at 100% forever whenever I edit a c++ file.
(require 'setup-cedet)
(require 'setup-editing)
(require 'neotree)
(require 'clang-format)
(require 'diff-hl)


;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(zeal-at-point coverlay cov xml+ magit diff-hl flycheck-pyflakes plantuml-mode org-roam-ui org-wc org-roam fill-column-indicator solarized-theme elpher clang-format flymake-google-cpplint json-mode buffer-expose flycheck zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu neotree elpy column-enforce-mode)))
;; helm-gtags, iedit, mastodon, elpher

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 128 :width normal :foundry "DAMA" :family "DejaVu Sans Mono")))))

;; font
;; (set-default-font "DejaVu Sans Mono 16")

;; confirm closing of emacs
(setq confirm-kill-emacs 'y-or-n-p)

(setq inhibit-splash-screen 1)
(setq inhibit-startup-message 1)

;; (neotree)
(global-set-key [f8] 'neotree-toggle)
;; (setq-default neo-show-hidden-files t)
;; (setq neo-hidden-files-toggle t)
;; (setq neo-hidden-regexp-list '("^\\." "\\.cs\\.meta$" "\\.pyc$" "~$" "^#.*#$" "\\.elc$" "*~"))

;; auto save
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 1) ;; in seconds

;; to work with git
(global-auto-revert-mode 1)

;; Enable elpy
(elpy-enable)

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; highlights matchings parentesis
(show-paren-mode 1)

;; (add-hook 'c-mode-common-hook
          ;; (function (lambda ()
                    ;; (add-hook 'before-save-hook
                              ;; 'clang-format-buffer))))
;; (remove-hook 'c-mode-common-hook)

;; c++ indentation
;; (c-set-offset 'syntactic-symbol ++) ;; 4 spaces

;; ;; Doesn't work
;; ;; Mastodon
;; (use-package mastodon
;;   :ensure t)
;; (setq mastodon-instance-url "https://mastodon.fedi.quebec")
;; ;; (setq mastodon-auth-source-file "~/.emacs/auth-mastodon")

;; https://stackoverflow.com/questions/663588/emacs-c-mode-incorrect-indentation
;; this matches the default setup for visual studio.
(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here

  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2

  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq indent-tabs-mode t)  ; use spaces only if nil
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; cmake
(setq cmake-tab-width 4)

;; spaces and tabs
;; https://www.emacswiki.org/emacs/NoTabs
(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))
;;
(setq indent-tabs-mode nil)
(infer-indentation-style)

;; helm
(require 'helm)
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-move-to-line-cycle-in-source t) ; move to end or beginning of source when reaching top or bottom of source.

;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/colin/org-roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))


;; (use-package plantuml-mode
;;   :init
;;   ;; (setq plantuml-default-exec-mode 'executable)
;;   ;; (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
;;   ;; (setq org-plantuml-jar-path (expand-file-name "/usr/share/plantuml/plantuml.jar"))
;;   ;; (setq org-startup-with-inline-images t)
;;   ;; (add-to-list 'org-src-lang-modes '("plantuml" . plantuml)))
;;   x;; (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t))))

;; (setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
;; (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

;; Sample jar configuration
(setq plantuml-jar-path "/home/colinbrosseau/plantuml.jar")
(setq org-plantuml-jar-path "/home/colinbrosseau/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)

;; Sample executable configuration
;; (setq plantuml-executable-path "/path/to/your/copy/of/plantuml.bin")
;; (setq plantuml-default-exec-mode 'executable)



;; in Org-Mode, activate line wrap
(add-hook 'org-mode-hook (lambda() (visual-line-mode 1)))

;; Enable `diff-hl' support by default in programming buffers
(add-hook 'prog-mode-hook #'diff-hl-mode)
;; Update the highlighting without saving
(diff-hl-flydiff-mode t)

;; (load "python-coverage")

;; Python
(add-hook 'python-mode-hook 'flyspell-prog-mode)
(add-hook 'python-mode-hook 'column-enforce-mode)
(setq column-enforce-column 120)

(defvar cov-lcov-patterns '("*.lcov"))

(setq org-agenda-files '("~/colin/projets/colinbrosseau.com/index.org"))
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)

;; LaTex
(require 'tex-mode)`
(add-hook 'latex-mode-hook 'flyspell-mode)


;; Load/Save opened buffers and locations at startup/exit of emacs
(desktop-save-mode 1)
