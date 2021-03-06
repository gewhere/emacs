;; Commentary: http://iris.math.aegean.gr/~atsol/emacs-unicode/
;; (load "auctex.el" nil t t)
;; (load "preview-latex.el" nil t t)


;;(prefer-coding-system 'greek-iso-8bit)
;;(prefer-coding-system 'utf-8)

;; ;; (prefer-coding-system 'iso-8859-7)
;; (load "~/.emacs.d/personal/preload/greek.elc")

;; (setq default-input-method "el_GR")

;; GREEK FONTS
;; ;; ;; https://github.com/iani/emacs-prelude/blob/master/user/iani.org
;; ;; ;; by IZ
;; (set-fontset-font "fontset-default"
;;                   'greek
;;                   ;; Note: iso10646-1 = Universal Character set (UCS)
;;                   ;; It is compatible to Unicode, in its basic range
;; ;;                  '("Monospace" . "iso8859-1"))
;;                   '("Monospace" . "utf-8"))
;; ;; xetex ends here

;; ;; BABEL
;; (defun org-babel-load-current-file ()
;;   (interactive)
;;   (org-babel-load-file (buffer-file-name (current-buffer))))

;; ;; Note: Overriding default key binding to provide consistent pattern:
;; ;; C-c C-v f -> tangle, C-c C-v C-f -> load
;; (eval-after-load 'org
;;   '(define-key org-mode-map (kbd "C-c C-v C-f") 'org-babel-load-current-file))
;; ;; end BABEL

;; ;; http://emacs-fu.blogspot.gr/2011/04/nice-looking-pdfs-with-org-mode-and.html
;; ;;; Load latex package
;; (require 'ox-latex)

;; ;;; Use xelatex instead of pdflatex, for support of multilingual fonts (Greek etc.)
;; (setq org-latex-pdf-process (list "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f"))

;; ;;; Add beamer to available latex classes, for slide-presentaton format
;; (add-to-list 'org-latex-classes
;;              '("beamer"
;;                "\\documentclass\[presentation\]\{beamer\}"
;;                ("\\section\{%s\}" . "\\section*\{%s\}")
;;                ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
;;                ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;; ;;; Add memoir class (experimental)
;; (add-to-list 'org-latex-classes
;;              '("memoir"
;;                "\\documentclass[12pt,a4paper,article]{memoir}"
;;                ("\\section{%s}" . "\\section*{%s}")
;;                ("\\subsection{%s}" . "\\subsection*{%s}")

;;                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;;                ("\\paragraph{%s}" . "\\paragraph*{%s}")
;;                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
;; ;; end of IANI CODE

;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ;;
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>https://github.com/suvayu/.emacs.d/blob/master/org-mode-config.el#L176

;; USE C-v l p for pdf export
;;
;; https://github.com/suvayu/.emacs.d/blob/master/org-mode-config.el#L176

;; ;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;; ;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;; ;; COMMENT BELOW ---------------------------------------------------------
;; ;;; XeLaTeX customisations
;; ;; remove "inputenc" from default packages as it clashes with xelatex
;; (setf org-latex-default-packages-alist
;;       (remove '("AUTO" "inputenc" t) org-latex-default-packages-alist))
;; ;; the sexp below will also work in this case. But it is not robust as it
;; ;; pops the first element regardless if its a match or not.
;; ;; (pop org-latex-default-packages-alist)

;; (add-to-list 'org-latex-packages-alist '("" "xltxtra" t))
;; ;; choose Linux Libertine O as serif and Linux Biolinum O as sans-serif fonts
;; (add-to-list 'org-latex-packages-alist '("" "libertine" t))
;; ;; commented for now as preferable to set per file for now
;; ;; (add-to-list 'org-latex-packages-alist '("" "unicode-math" t))
;; ;; (add-to-list 'org-latex-packages-alist
;; ;; "\\setmathfont{Linux Libertine}" t) ; needed for unicode-math

;; ;; org to latex customisations, -shell-escape needed for minted
;; (setq org-export-dispatch-use-expert-ui t ; non-intrusive export dispatch
;;       org-latex-pdf-process	; for regular export
;;       '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;; "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
;; "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; ;; export single chapter
;; (add-to-list 'org-latex-classes
;; '("chapter" "\\documentclass[11pt]{report}"
;; ("\\chapter{%s}" . "\\chapter*{%s}")
;; ("\\section{%s}" . "\\section*{%s}")
;; ("\\subsection{%s}" . "\\subsection*{%s}")
;; ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

;; ;; ;; FIXME: doesn't work because of \hypersetup, \tableofcontents, etc.
;; ;; ;; minimal export with the new exporter (maybe use the standalone class?)
;; ;; (add-to-list 'org-latex-classes
;; ;; '("minimal"
;; ;; "\\documentclass\{minimal\}\n[NO-DEFAULT-PACKAGES]\n[NO-PACKAGES]"
;; ;; ("\\section\{%s\}" . "\\section*\{%s\}")
;; ;; ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
;; ;; ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;; ;; beamer export with the new exporter
;; (add-to-list 'org-beamer-environments-extra
;; '("onlyenv" "O" "\\begin{onlyenv}%a" "\\end{onlyenv}"))

;; (add-to-list 'org-beamer-environments-extra
;; '("boldH" "h" "\\textbf{%h}" "%%%%"))

;; (add-to-list 'org-beamer-environments-extra
;; '("phantom" "P" "\\phantom{%h}" ""))

;; (add-to-list 'org-export-snippet-translation-alist
;; '("b" . "beamer"))
;; (add-to-list 'org-export-snippet-translation-alist
;; '("l" . "latex"))
;; (add-to-list 'org-export-snippet-translation-alist
;; '("h" . "html"))
;; (add-to-list 'org-export-snippet-translation-alist
;; '("o" . "odt"))

;; ;; filters for markups
;; (defun sa-beamer-bold (contents backend info)
;;   (when (org-export-derived-backend-p backend 'beamer)
;;     (replace-regexp-in-string "\\`\\\\[A-Za-z0-9]+" "\\\\textbf" contents)))

;; (add-to-list 'org-export-filter-bold-functions 'sa-beamer-bold)

;; (defun sa-beamer-structure (contents backend info)
;;   (when (org-export-derived-backend-p backend 'beamer)
;;     (replace-regexp-in-string "\\`\\\\[A-Za-z0-9]+" "\\\\structure" contents)))

;; (add-to-list 'org-export-filter-strike-through-functions 'sa-beamer-structure)

;; ;; FIXME: using $_{\text{string}}$ looks much better!
;; ;; (defun sa-latex-subscript (contents backend info)
;; ;; (when (org-export-derived-backend-p backend 'beamer 'latex)
;; ;; (replace-regexp-in-string "\\$_{\\\\text{\\([^}]+\\)}}\\$"
;; ;; "\\\\textsubscript{\\1}" contents)))

;; ;; (add-to-list 'org-export-filter-subscript-functions 'sa-latex-subscript)

;; ;; (defun sa-latex-superscript (contents backend info)
;; ;; (when (org-export-derived-backend-p backend 'beamer 'latex)
;; ;; (replace-regexp-in-string "\\$\\^{\\\\text{\\([^}]+\\)}}\\$"
;; ;; "\\\\textsuperscript{\\1}" contents)))

;; ;; (add-to-list 'org-export-filter-superscript-functions 'sa-latex-superscript)

;; ;; FIXME: implement configurable reference style for latex export
;; ;; (defun sa-latex-reflink (contents backend info)
;; ;; (when (and (eq (plist-get info :refstyle) t)
;; ;; (org-export-derived-backend-p backend 'latex))
;; ;; (replace-regexp-in-string "\\`\\\\\\(ref\\){\\([a-zA-Z0-9]+\\):\\([a-zA-Z0-9]+\\)}"
;; ;; "\\\\\\2\\1{\\2:\\3}" contents)))

;; ;; (add-to-list 'org-export-filter-link-functions 'sa-latex-reflink)

;; ;;; not needed any more, here for example purposes
;; ;; ;; smart quotes on only for latex backend (courtesy: Jambunathan)
;; ;; (defun sa-org-latex-options-function (info backend)
;; ;; (when (eq backend 'latex)
;; ;; (plist-put info :with-smart-quotes t)))

;; ;; (add-to-list 'org-export-filter-options-functions 'sa-org-latex-options-function)

;; (defun sa-ignore-headline (contents backend info)
;;   "Ignore headlines with tag `ignoreheading'."
;;   (when (and (org-export-derived-backend-p backend 'latex 'html 'ascii)
;; (string-match "\\`.*ignoreheading.*\n"
;; (downcase contents)))
;;     (replace-match "" nil nil contents)))

;; (add-to-list 'org-export-filter-headline-functions 'sa-ignore-headline)
;; ;;---------------------------------------------------------------------------
;; ;;---------------------------------------------------------------------------
