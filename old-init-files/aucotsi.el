;; (require 'package)
;; (package-initialize)

;; (load-theme 'zenburn t)
;; (load-theme 'tango-dark t)
;; (load-theme 'solarized-dark t)

;; (disable-theme 'solarized-dark)
;; disable insert

;; (define-key global-map [(insert)] nil)
;; (define-key global-map [(control insert)] 'overwrite-mode)


;; TRAMP
;; (setq tramp-default-method "ssh")

;; org-reveal
(require 'ox-reveal)

;; (setq org-src-fontify-natively t) ;; colorize source-code blocks natively

;; org bibtex
;; (require 'org-bibtex)
;; (require 'ox-bibtex)

;; (require 'org-cite)
;; (add-hook 'org-export-preprocess-hook 'org-cite-format)

;; (setq org-cite-bibtex-package 'apacite)

;; (require 'langtool)
;; (setq langtool-language-tool-jar "/home/aucotsi/sources/languagetool/languagetool-commandline.jar")

;; ORG-AGENDA
;; (setq org-agenda-custom-commands
;;       '(("f" tags "+COFFEE")
;;         ("w" tags "+ESPRESSO")))


;; ;; -- START SOLARIZED

;; ;; (load-theme 'resolve)
;; (defun dark-theme ()
;; "set theme to solarized dark, adapt hl faces."
;; (interactive)
;; (load-theme 'solarized-dark)
;; (custom-set-faces
;; ;; custom-set-faces was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(mode-line-buffer-id ((t (:foreground "gray97" :weight bold))))
;; '(helm-selection ((t (:background "gray100" :underline t))))
;; '(cursor ((t (:background "grey" :foreground "dark red"))))
;; '(hl-line ((t (:inherit highlight :background "#002030" :underline nil))))
;; '(hl-sexp-face ((t (:background "#002530"))))))
;; (defun light-theme ()
;; "set theme to solarized dark, adapt hl faces."
;; (interactive)
;; (load-theme 'tsdh-light)
;; (custom-set-faces
;; ;; custom-set-faces was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(mode-line-buffer-id ((t (:foreground "gray90" :weight bold))))
;; '(helm-selection ((t (:background "green1" :underline t))))
;; '(cursor ((t (:background "grey" :foreground "dark red"))))
;; '(hl-line ((t (:inherit highlight :background "grey96" :underline nil))))
;; '(hl-sexp-face ((t (:background "LemonChiffon1"))))))

;; ;; -- END SOLARIZED

;; (setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; enable very long lines
(require 'whitespace)
(setq whitespace-line-column 200)

;; GURU MODE DISABLED
;; (defun disable-guru-mode ()
;;   (guru-mode -1)
;;   )
;; (add-hook 'prelude-prog-mode-hook 'disable-guru-mode t)
;; WARNINGS ONLY
(setq guru-warn-only t)

;; Delete whitespaces at the end of lines when saving
;; (add-hook 'before-save-book 'dalete-trailing-whitespace)
;; disable TRAMP
(require 'recentf)
(setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
(recentf-mode 1)
;;http://stackoverflow.com/questions/880625/stop-tramp-mode-running-on-emacs-startup
;;http://www.emacswiki.org/emacs/RecentFiles#toc9

;;;
(defalias 'yes-or-no-p 'y-or-n-p) ;; y and n instead of yes and no
(column-number-mode t)
(line-number-mode t)
(delete-selection-mode 1)
(visual-line-mode 1)

;;set USER
(setq user-full-name "Georgios Diapoulis")
;;
;; (setq user-full-name "DIAPOULIS TRAVEL")
;; (setq user-full-name "Sir Copy Here")
;; http://batsov.com/prelude/

;; SCLANG
(require 'sclang)
;;-- skeleton pair insertion for brackets and stuff
(global-set-key "\"" 'skeleton-pair-insert-maybe)
(global-set-key "\'" 'skeleton-pair-insert-maybe)
(global-set-key "\`" 'skeleton-pair-insert-maybe)
(global-set-key "\{" 'skeleton-pair-insert-maybe)
(global-set-key "\[" 'skeleton-pair-insert-maybe)
(global-set-key "\(" 'skeleton-pair-insert-maybe)
(global-set-key "\<" 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)
;; end for sc-lang

;; scaling images in tables
(setq org-image-actual-width 350)

(provide 'aucotsi);;; ends here
