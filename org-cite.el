;; ;;; org-cite --- format Org-mode bibliographic references

;; ;; Copyright (C) 2011 Christian Moe

;; ;; Author: Christian Moe <mail at christianmoe dot com>
;; ;; Keywords: citations, references, bibliography, wp
;; ;; Version: 0.1 alpha

;; ;; This file is not part of GNU Emacs.

;; ;; Org-cite is free software; you can redistribute it and/or modify
;; ;; it under the terms of the GNU General Public License as published by
;; ;; the Free Software Foundation; either version 3, or (at your option)
;; ;; any later version.

;; ;; Org-cite is distributed in the hope that it will be useful,
;; ;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; ;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; ;; GNU General Public License for more details.

;; ;; You should have received a copy of the GNU General Public License
;; ;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;; ;;; Commentary:

;; ;;; Code:


;; (defun org-cite-format ()
;;   "Dispatch formatting if there is at least one cite, and the
;; export target is not LaTeX."
;;   (goto-char (point-min))
;;   (when (re-search-forward org-cite-latex-cite-re nil t)
;;     (unless (equal org-export-current-backend 'latex)
;;       (org-cite-format-with-bibtex))))

;; (defun org-cite-toggle ()
;;   "Toggle use of org-cite-format on export."
;;   (interactive)
;;   (if (member 'org-cite-format org-export-preprocess-hook)
;;       (remove-hook 'org-export-preprocess-hook 'org-cite-format)
;;     (add-hook 'org-export-preprocess-hook 'org-cite-format)))

;; (defvar org-cite-strings
;;   ()
;;   "Plist of strings, returned by org-cite-str. Set at runtime
;; depending on how we're formatting.")

;; (defvar org-cite-default-strings
;;   '(:loc-sep ", "
;;     :nobreak  "Â "             ; (char-to-string ?\240)
;;     :and "and"                ; e.g. before last author name
;;     :et-al "et al."    ; in place of full list of co-authors
;;     :number "no."
;;     :p "p."
;;     :pp "pp."
;;     :in "in"
;;     :ed "ed."
;;     :eds "eds."
;;     :ed-by "ed."
;;     :edn "ed."       ; abbreviation for edition, e.g. in "(2nd ed.)"
;;     :no-date "n.d."
;;     )
;;   "Default strings to use when formatting citations and bibliographies.")

;; (defun org-cite-str (key)
;;   "Gettext function for org-cite. Looks up org-cite-strings for the
;;  string corresponding to KEY."
;;   (plist-get org-cite-strings key))

;; (defvar org-cite-alphabet
;;   "abcdefghijklmnopqrstuvwxyz"
;;   "String containing the alphabet in lower-case letters. You can
;; customize this if you need a different alphabet, default is
;; English.")

;; (defvar org-cite-months
;;   '("January" "February" "March" "April" "May" "June"
;;     "July" "August" "September" "October" "November" "December"))

;; (defvar org-cite-months-abbrev
;;   '("Jan" "Feb" "Mar" "Apr" "May" "Jun"
;;     "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"))

;; (defun org-cite-num-to-letter (num)
;;   "Helper function that returns letter number NUM from the list
;; a, b, c... NUM can be numeric or string; if NUM is nil, the empty
;; string is returned."
;;   (when (stringp num) (setq num (string-to-number num)))
;;   (if num
;;       (char-to-string (aref (vconcat org-cite-alphabet) (1- num)))
;;     ""))

;; (defvar org-cite-method 'numeric
;;   "The basic reference method to use. Possible values:

;; - author-date: e.g. citations formatted as `(Brown, 2006)',
;;   with alphabetically ordered reference list at end
;; - numeric: numeric references, e.g. citations like (1), and
;;   reference list with items prefixed in same way.
;; - notes: inserted as Org footnotes. Note that locator
;;   information is currently lost.
;; - text: inserted as full text.")

;; (defvar org-cite-formatter 'bibtex
;;   "The reference-formatting backend to use. Currently bibtex is
;; the only option.")

;; (defun org-cite-replace-in-buffer (subst)
;;   "Make simple substitutions in the buffer. SUBST is an alist of
;; regexps matched to replacements. Goes beyond
;; format-replace-strings in that replacements can be strings,
;; symbols, or expressions."
;;   (let (rep)
;;     (while subst
;;       (goto-char (point-min))
;;       (while (re-search-forward (car (car subst)) nil t)
;; 	(setq rep (cdr (car subst)))
;; 	(replace-match
;; 	 (cond
;; 	  ((symbolp rep) ; replacement is a symbol, get value
;; 	   (symbol-value rep))
;; 	  ((and (listp rep) (functionp (car rep))) ; replacement is a function,
;; 	   (eval rep))                             ; evaluate it
;; 	  ((stringp rep) rep)) ; replacement is a string, return it
;; 	 t)) ; replace with fixed-case
;;       (setq subst (cdr subst)))))


;; (defvar org-cite-final-substitutions
;;   '(
;;     ;; (" ()" . "") ; empty parens, e.g. because of missing journal number
;;     ;; (", )" . ")") ; nothing after comma, e.g. missing month info
;;     ("/(" . "/ (")) ; give italics space to breathe before issue number
;; "These are just dirty fixes to problems left by other dirty fixes.
;; TODO: clean fixes.")


;; ;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; BibTeX-specific ;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;

;; ;; A note on LaTeX regexps
;; ;;
;; ;; To match LaTeX command arguments, I have used
;; ;; "{\\([^}]+\\)}". That's fine e.g. in org-cite-latex-cite-re and
;; ;; bibitem searches, which only look for a citekey. However, this
;; ;; fails if the argument itself contains curly braces. org-cite relies
;; ;; on cleaning those up first. It will not always succeed. A better
;; ;; approach is needed.


;; (defvar org-cite-latex-cite-re
;;   "\\\\\\(.*?cite.*?\\)\\(\\[\\(.+?\\)\\]\\)?\\(\\[\\(.+?\\)\\]\\)?{\\([^}]+\\)}"
;;   "Regular expression to search and parse latex cites.
;; The match-strings are:
;; 1 - the cite macro (cite, citet, etc.),
;; 2 - the pre-note option (if any);
;; 3 - its contents (e.g. `see');
;; 4 - the post-note option (if any);
;; 5 - its contents, usually a locator, e.g. page number;
;; 6 - the citekey(s).
;; TODO: May break if there's a line-break in an option.")

;; (defvar org-cite-apacite-cite-re
;;    "\\\\\\(.*?cite.*?\\)\\(<\\([^>]+\\)>\\)?\\(\\[\\([^]]+\\)\\]\\)?{\\([^}]+\\)}"
;;   ;; WAS: "\\\\\\(.*?cite.*?\\)\\(<\\(.+?\\)>\\)?\\(\\[\\(.+?\\)\\]\\)?{\\([^}]+\\)}"
;;   "Regular expression to search and parse latex cites.
;; The match-strings are as for org-cite-latex-cite-re.")

;; (defvar org-cite-apacite-strings
;;   '(:loc-sep ", "
;;     :nobreak  "Â "             ; (char-to-string ?\240)
;;     :and "&"
;;     :et-al "et al."
;;     :number "No."
;;     :p "p."
;;     :pp "pp."
;;     :in "In"
;;     :ed "Ed."
;;     :eds "Eds."
;;     :ed-by "ed."
;;     :edn "ed."
;;     :no-date "n.d.")
;;   "Default strings to use with apacite.")

;; (defvar org-cite-bibtex-package nil
;; "A symbol representing the BibTeX package used. Currently
;; supported options are 'natbib and 'apacite.")

;; (defvar org-cite-bibcite-re "\\\\bibcite{\\([^}]+\\)}{\\([^}]+\\)}"
;; "Analytic regexp for a default bibcite.
;; Match-strings: 1 citekey, 2 numbering,
;; e.g. \\bibcite{Smith2000}{1}")

;; (defvar org-cite-natbib-bibcite-re
;;   "\\\\bibcite{\\([^}]+\\)}{{\\([^}]+\\)}{\\([^}]+\\)}{{\\([^}]+\\)}}{{\\([^}]+\\)}}}"
;; "Analytic regexp for bibcites when using natbib.
;; Match-strings: 1 citekey, 2 numbering, 3 year, 4 shortened
;; authorlist, 5 full authorlist, e.g.
;; \\bibcite{Smith2000}{{1}{2000}{{Smith et al}}{{Smith, Jones and Black}}}")

;; (defvar org-cite-apacite-bibcite-re
;;   "\\\\bibcite{\\([^}]+\\)}{\\\\citeauthoryear {\\(.+?\\)}{\\(.+?\\)}{{\\(.+?\\)}\\({\\\\APACexlab {{\\\\BCnt {\\([0-9]\\)}}}}\\)?}}"
;; ;; WAS: "\\\\bibcite{\\([^}]+\\)}{\\\\citeauthoryear {\\(.+?\\)}{\\(.+?\\)}{{\\\\APACyear {\\([0-9]+\\)}}\\({\\\\APACexlab {{\\\\BCnt {\\([0-9]\\)}}}}\\)?}}"
;; "Analytic regexp for bibcites when using apacite.
;; Match-strings:
;;  1) citekey
;;  2) authorslong
;;  3) authors
;;  4) year (or no date)
;;  5) Maybe a section with same-author-same-year distinguisher
;;  6) Maybe a same-author-same-year distinguisher")

;; (defun org-cite-get-bibcites (file)
;;   (let ((package org-cite-bibtex-package)
;; 	path bibcites bibstyle bibcite-re year key-citation)
;;     (with-temp-buffer
;;       (unless (file-exists-p (setq path (concat "./" file ".aux")))
;; 	(error (format "org-cite could not find %s" path)))
;;       (insert-file-contents path)
;;       ;; Convert special characters to utf-8 representation
;;       (setq case-fold-search nil)
;;       (org-cite-replace-in-buffer org-cite-latex-chars-utf8)
;;       ;; Find the bibstyle
;;       (goto-char (point-min))
;;       (re-search-forward "\\\\bibstyle{\\([^}]+\\)}" nil t)
;;       (setq bibstyle (match-string 1))
;;       (when (equal package 'apacite)
;; 	;; cleanup apacite crud
;; 	(org-cite-replace-in-buffer org-cite-apacite-substitutions))
;;       (setq bibcite-re
;; 	    (cond
;; 	     ((equal package 'natbib)
;; 	      org-cite-natbib-bibcite-re)
;; 	     ((equal package 'apacite)
;; 	      org-cite-apacite-bibcite-re)
;; 	     (t org-cite-bibcite-re))) ; close setq
;;       (goto-char (point-min))
;;       (while (re-search-forward bibcite-re nil t)
;; 	(setq year
;; 	      (cond
;; 	       ((equal package 'apacite) (match-string 4))
;; 	       (t (match-string 3)))) ; natbib
;; 	;; (unless (and year (string-match "[0-9]+" year)) ; FIXME - not working
;; 	;;   (setq year (org-cite-str :no-date)))
;; 	(setq key-citation
;; 	      (cond
;; 	       ;; natbib
;; 	       ((equal package 'natbib) ; natbib
;; 		(cons (match-string 1)
;; 		      (list :num (match-string 2)
;; 			    :year year
;; 			    :authors (match-string 4)
;; 			    :authorslong (match-string 5))))
;; 	       ;; apacite
;; 	       ((equal package 'apacite)
;; 		(cons (match-string 1)
;; 		      (list :authorslong (match-string 2)
;; 			    :authors (match-string 3)
;; 			    :year
;; 			    (concat year
;; 			     ;; with letter marker, if any
;; 			     (if (match-string 6)
;; 				 (org-cite-num-to-letter (match-string 6)))))))
;; 	       ;; plain
;; 	       (t (cons (match-string 1) (match-string 2))))) ; close setq
;; 	(setq bibcites (cons key-citation bibcites))) ; close while
;;       bibcites)))

;; (defun org-cite-format-natbib-citation (citetype citekey bibcite &optional loc pre)
;;   "Format a citation as if using the BibTeX natbib
;; package. CITETYPE can be one of the following symbols: cite,
;; citet, citet*, citep, citep*, citealt, citealt*, citealp,
;; citealp*, citeauthor, citeauthor*, citeyear, citeyearpar,
;; nocite. BIBCITE should be a plist including :year, :authors
;; and :authorslong; if there are multiple citekeys, the value of
;; this argument is ignored and each bibcite is looked up
;; afresh. LOC is a note to appear at the end of the citation (aka a
;; post-note), usually referencing a location within the work,
;; e.g. page number. PRE is a note to appear before the citation,
;; e.g. `see'. The logical order of LOC and PRE is reversed in the
;; argument list because LOC is far more frequent."
;;   (let ((citekeys (split-string citekey " ?, ?")) ; allows a single space
;; 	(locs (when loc (split-string loc " ?, ?")))
;; 	previous-authors ; lets us check if current authors same as last
;; 	citet-parens-open ; flag if we have a citet parenthesis open for more works by same authors
;; 	citation)
;;     (setq pre (if pre (concat pre " ") ""))

;;     ;; If there are multiple works in one cite, loop through them
;;     (while citekeys
;;       (setq citekey (car citekeys))
;;       (setq loc (car locs))
;;       (setq bibcite (cdr (assoc citekey bibcites)))
;;       (let ((authors (if (string-match "[*]" citetype)
;; 			 (plist-get bibcite :authorslong)
;; 		       (plist-get bibcite :authors)))
;; 	    (year (plist-get bibcite :year))
;; 	    (locstring (format "%s%s"
;; 			       (if loc (org-cite-str :loc-sep) "")
;; 			       (or loc ""))))
;; 	;; If this is not the first work, add a separator, keeping
;; 	;; track of whether we're in an open citet parenthesis
;; 	(when previous-authors
;; 	  (when citet-parens-open
;; 	    (unless (string= authors previous-authors)
;; 	      (setq citation (concat citation ")"))
;; 	      (setq citet-parens-open nil)))
;; 	  (setq citation (concat citation "; ")))
;; 	;; add this work
;; 	(setq
;; 	 citation
;; 	 (concat
;; 	  citation
;; 	  (if (string= authors previous-authors)
;; 	      ;; if this is another work by authors already named in this citation
;; 	      ;; TODO Find a less extensive way to do the following!
;; 		  (cond
;; 		   ((string-match "citet" citetype) ; matches citet and citet*
;; 		    (format "[[%s][%s]]%s" citekey year locstring))
;; 		   ((string-match "citeauthor" citetype) ; this shouldn't happen
;; 		    (format "[[%s][%s]]%s" citekey authors locstring))
;; 		   ((string-match "citeyearpar" citetype)
;; 		    (format "[[%s][%s]]%s" citekey year locstring))
;; 		   ((string-match "citeyear" citetype)
;; 		    (format "[[%s][%s]]%s" citekey year locstring))
;; 		   ((string-match "citealt" citetype)
;; 		    (format "[[%s][%s]]%s" citekey year locstring))
;; 		   ((string-match "citealp" citetype)
;; 		    (format "[[%s][%s]]%s" authors citekey year locstring))
;; 		   ((string-match "nocite" citetype)
;; 		    "")
;; 		   ((string-match "cite" citetype) ; cite or citep
;; 		    (format "[[%s][%s]]%s" citekey year locstring))
;; 		   (t
;; 		    (format "*[org-cite failed to format =%s= citation]*" citetype)))
;; 	    ;; else (when authors are not already named in this citation)
;; 	    (cond
;; 	     ((string-match "citet" citetype)
;; 	      (format "%s ([[%s][%s]]%s" authors citekey year locstring))
;; 	     ((string-match "citeauthor" citetype)
;; 	      (format "[[%s][%s]]%s" citekey authors locstring))
;; 	     ((string-match "citeyearpar" citetype)
;; 	      (format "[[%s][%s]]%s" citekey year locstring))
;; 	     ((string-match "citeyear" citetype)
;; 	      (format "[[%s][%s]]%s" citekey year locstring))
;; 	     ((string-match "citealt" citetype)
;; 	      (format "%s [[%s][%s]]%s" authors citekey year locstring))
;; 	     ((string-match "citealp" citetype)
;; 	      (format "%s, [[%s][%s]]%s" authors citekey year locstring))
;; 	     ((string-match "nocite" citetype)
;; 	      "")
;; 	     ((string-match "cite" citetype) ; other alternatives eliminated, this leaves "cite" or "citep", both bracketed
;; 	      (format "[[%s][%s, %s]]%s" citekey authors year locstring))
;; 	     (t
;; 	      (format "*[org-cite failed to format =%s= citation]*" citetype)))))) ; end setq citation
;; 	;; Keep track of whether we might be adding to an open citet parenthesis
;; 	(when (string-match "citet" citetype) (setq citet-parens-open t))
;; 	;; Loop round
;; 	(setq previous-authors authors)
;; 	(setq locs (cdr locs))
;; 	(setq citekeys (cdr citekeys)))) ; end while citekeys

;;     ;; Close citet bracket if necessary
;;     (when citet-parens-open
;;       (setq citation (concat citation ")")))
;;     ;; Add pre-note
;;     (setq citation (concat pre citation))
;;     ;; Bracket whole citation, if it's one of those types
;;     (when (member citetype
;; 		  '("citeauthor" "citeauthor*" "citeyearpar"
;; 		   "cite" "cite*" "citep" "citep*"))
;;       (setq citation (concat "(" citation ")")))
;;     ;; Tidy up
;;     (setq citation (replace-regexp-in-string "~" (org-cite-str :nobreak) citation))
;;     (setq citation (replace-regexp-in-string "[{}]" "" citation)) ;; FIXME this may hide debugging info
;;     ;; Return citation
;;     citation))

;; (defun org-cite-format-with-bibtex ()
;;   (interactive)
;;   (let* ((package org-cite-bibtex-package) ; natbib, apacite, nil=plain...
;; 	 (cite-re (if (equal package 'apacite)
;; 		      org-cite-apacite-cite-re
;; 		    org-cite-latex-cite-re))
;; 	 (loc-sep (org-cite-str :loc-sep))
;; 	 method file
;; 	 bibcites bibcite
;; 	 biblist ; if method is 'text, biblist holds the formatted bibliography
;; 	 cited ; list of already cited works
;; 	 citetype pre loc citekey citation)
;;     ;; Set default method
;;     (unless method (setq method org-cite-method))
;;     ;; Set the strings to use
;;     (cond
;;      ((equal package 'apacite)
;;       (setq org-cite-strings org-cite-apacite-strings))
;;      (t
;;       (setq org-cite-strings org-cite-default-strings)))
;;     ;; Get file
;;     (setq file (file-name-sans-extension
;; 		(file-name-nondirectory
;; 		 (or
;; 		  org-current-export-file
;; 		  (buffer-file-name)))))
;;     ;; Get bibcites
;;     (setq bibcites (org-cite-get-bibcites file))
;;     ;; If using references in text, get the references now
;;     (when (equal method 'text)
;;       (let (parts tmplist)
;; 	(setq biblist (split-string (org-cite-get-bbl file method bibcites) "\n\n" t))
;; 	(while biblist
;; 	   (setq parts (split-string (car biblist) "::::"))
;; 	   (setq tmplist
;; 		 (cons (cons
;; 			(org-trim (car parts)) ; TODO a better way to trim newlines than:
;; 			(replace-regexp-in-string "\n" " " (org-trim (car (cdr parts)))))
;; 		       tmplist))
;; 	   (setq biblist (cdr biblist)))
;; 	(setq biblist tmplist)))
;;     ;;; Format citations
;;     ;;;
;;     (goto-char (point-min))
;;     ;; Analyse cite macros
;;     (while (re-search-forward cite-re nil t)
;;       (if (equal package 'apacite)
;; 	  (setq citetype (match-string 1) ; see org-cite-latex-cite-re
;; 		pre (match-string 3)
;; 		loc (match-string 5)
;; 		citekey (match-string 6))
;; 	;; else (natbib or plain)
;; 	(setq citetype (match-string 1) ; see org-cite-latex-cite-re
;; 	      pre (and (match-string 4) (match-string 3)) ; only if there is a second, perhaps empty, option
;; 	      loc (or (match-string 5) (match-string 3))
;; 	      citekey (match-string 6)))
;;       (setq bibcite (cdr (assoc citekey bibcites)))

;; 	;; (setq citetype (match-string 1) ; see org-cite-latex-cite-re
;; 	;; 	    pre (if (and (match-string 2)
;; 	;; 			 (string= "<" (substring (match-string 2) 0)))
;; 	;; 		    ;; if apacite, the pre-note is in sharp brackets
;; 	;; 		    (match-string 3)
;; 	;; 		  ;; else (natbib), make first option pre only if there is a second
;; 	;; 		  (and (match-string 4) (match-string 3)))
;; 	;; 	    loc (or (match-string 5) (match-string 3))
;; 	;; 	    citekey (match-string 6)
;; 	;; 	    bibcite (cdr (assoc citekey bibcites)))

;;       (cond

;;        ;; Author-date or numerical references
;;        ((or (equal method 'author-date) (equal method 'numeric))
;; 	(replace-match
;; 	 (cond
;; 	  ;; natbib
;; 	  ((equal package 'natbib)
;; 	   (save-match-data
;; 	     (org-cite-format-natbib-citation citetype citekey bibcite loc pre)))
;; 	  ;; apacite
;; 	  ((equal package 'apacite)
;; 	   (save-match-data
;; 	     ;; TODO - implement org-cite-format-apacite-citation if needed
;; 	     ;;        but for now, rely on natbib
;; 	     (when (string-match "^cite\\($\\|[^y]\\)" citetype)
;; 	       ;; apacite commands that begin with "cite", except
;; 	       ;; those that begin with "citeyear", map to "fullcite"
;; 	       ;; the first time they appear, "shortcite" thereafter
;; 	       (setq citetype
;; 		     (concat
;; 		      (if (member citekey cited) "short" "full")
;; 		      citetype)))
;; 	     ;; Map the apacite cite to a natbib citetype and do the natbib formatting
;; 	     (if (assoc citetype org-cite-apacite-citetypes)
;; 		 (setq citetype (cdr (assoc citetype org-cite-apacite-citetypes)))
;; 	       (setq citetype "unknown")) ; TODO improve error handling
;; 	     (org-cite-format-natbib-citation citetype citekey bibcite loc pre)))
;; 	  ;; plain
;; 	  (t (format " ([[%s][%s%s%s]])"
;; 		   citekey
;; 		   bibcite
;; 		   (if loc loc-sep "")
;; 		   (or loc "")))))) ; close cond, replace-match, or

;;        ;; Full-text reference
;;        ((equal method 'text)
;; 	(replace-match
;; 	 (format "%s%s%s"
;; 		 (cdr (assoc citekey biblist)) ; biblist item, not bibcite
;; 		 (if loc loc-sep "")
;; 		 (or loc ""))))

;;        ;; Footnote reference
;;        ((equal method 'notes)
;; 	(replace-match (format "[fn:%s]" citekey)))) ; end cond
;;       ;; Add this to list of already cited works
;;       (setq cited (cons citekey cited))) ; end while

;;   ;; Insert bibliography/references unless we have full references in
;;   ;; text. If there is a \bibliography command, place it there, after
;;   ;; the surrounding latex block if there is one. Else place at end of
;;   ;; buffer.
;;   (unless (equal method 'text)
;;     (goto-char (point-min))
;;     (if (search-forward "\\bibliography" nil t)
;; 	(when (org-in-block-p '("latex"))
;; 	    (search-forward "#+end_latex" nil t))
;;       (goto-char (point-max)))
;;     (insert (org-cite-get-bbl file method bibcites))))
;;   (goto-char (point-min))
;;   (if (called-interactively-p)
;;       (message "Your original document has changed. Kill without saving or undo (C-c /) to avoid losing data.")
;;     (message "Done formatting bibliographic references")))

;; (defun org-cite-get-bbl (file method bibcites)
;;   "Return the contents of a .bbl file output by Bibtex as a
;; string in Org format."
;;   (let ((package org-cite-bibtex-package)
;; 	citekey
;; 	returnvalue)
;;     ;; Get the .bbl contents and reformat them
;;     ;;
;;     ;; We're using a named buffer for debugging purposes -- if bbl
;;     ;; cleanup fails (as it often will), inspecting the contents of
;;     ;; org-cite-temp-bbl will show what org-cite choked on. With luck,
;;     ;; there'll be some superfluous braces that can be removed from
;;     ;; the BibTeX.
;;     (with-current-buffer (get-buffer-create "org-cite-temp-bbl")
;;       (latex-mode)
;;       (insert-file-contents (concat "./" file ".bbl"))
;;       (goto-char (point-min))
;;       ;; Remove thebibliography environment
;;       (while (search-forward "{thebibliography}" nil t)
;; 	(move-beginning-of-line nil)
;; 	(kill-whole-line))
;;       ;; Replace bibitem macros with link/footnote targets
;;       (goto-char (point-min))
;;       (while (re-search-forward "\\\\bibitem\\(\\[[^]]+\\]\\)?{\\([^}]+\\)}" nil t)
;; 	;; WAS:    (re-search-forward "\\\\bibitem{\\([^}]+\\)}" nil t)
;; 	(setq citekey (match-string 2))
;; 	(cond
;; 	 ((equal method 'author-date)
;; 	  (replace-match (format "# <<%s>>" citekey)))
;; 	 ((equal method 'numeric)
;; 	  (replace-match
;; 	   (format "# <<%s>>\n(%s)"
;; 		   citekey
;; 		   (cdr (assoc citekey bibcites)))))
;; 	 ((equal method 'text)
;; 	  (replace-match (format "%s::::" citekey)))
;; 	 ((equal method 'notes)
;; 	  (replace-match (format "[fn:%s]" citekey)))))
;;       ;; Replace special characters with utf8 representation
;;       (setq case-fold-search nil)
;;       (org-cite-replace-in-buffer org-cite-latex-chars-utf8)
;;       ;; Replace {\e ...} with /.../, _{...}, ^{...} and [space]{...} with nothing
;;       ;; - TODO could this be done by org-cite-replace-in-buffer?
;;       (org-cite-latex-clean-braces)
;;       ;; Do a couple more substitutions before tackling apacite
;;       (org-cite-replace-in-buffer
;;        '(("\\\\textit{\\([^}]+\\)}" . "/\\1/")
;; 	 ("\\\\textbf{\\([^}]+\\)}" . "*\\1*")))
;;       ;; Remove APACITE crud
;;       (when (equal package 'apacite)
;; 	(org-cite-replace-in-buffer org-cite-apacite-substitutions))
;;       ;; Remove ordinary NATBIB crud
;;       (org-cite-replace-in-buffer
;;        '(("\\\\newblock" . "")
;; 	 ("~" . (org-cite-str :nobreak))
;; 	 ("\\\\/" . "") ; weird \/ sequences
;; 	 ("\\\\" . ""))) ; all remaining backslashes
;;       ;; If apacite, remove single empty newlines if not followed by
;;       ;; link target)
;;       (when (equal package 'apacite)
;; 	(org-cite-replace-in-buffer '(("\n\n\\([^#]\\)" . " \\1"))))
;;       ;; Tidy up
;;       (org-cite-replace-in-buffer org-cite-final-substitutions)
;;       ;; Fill as org-mode
;;       (org-mode)
;;       (fill-region (point-min) (point-max))
;;       ;; Return as string
;;       (setq returnvalue (buffer-string))
;;       ;; Close buffer
;;       (kill-buffer))
;;     returnvalue))

;; (defun org-cite-latex-clean-braces ()
;;   "Clean up various formatting in curly braces within the main macros."
;;   (let (opentag closetag at-closing-brace)
;;     (goto-char (point-min))
;;     (while (re-search-forward "\\([{[:space:]~_^\n\"'-]\\){\\(\\\\em\\)?\\( \\)?" nil t)
;;       (setq at-closing-brace nil)
;;       (cond
;;        ((string= (match-string 2) "\\em")
;; 	(setq opentag " /" closetag "/"))
;;        ((string= (match-string 1) "^")
;; 	;;(setq opentag "@<sup>" closetag "@</sup>"))
;; 	(setq opentag " " closetag ""))
;;        ((string= (match-string 1) "_")
;; 	;;(setq opentag "@<sub>" closetag "@</sub>"))
;; 	(setq opentag " " closetag ""))
;;        ((string= (match-string 1) "~")
;; 	(setq opentag "~" closetag " "))
;;        ((string= (match-string 1) "\"")
;; 	(setq opentag "\"" closetag " "))
;;        ((string= (match-string 1) "'")
;; 	(setq opentag "'" closetag " "))
;;        ((string= (match-string 1) "{")
;; 	(setq opentag "{" closetag ""))
;;        ((string= (match-string 1) "\n")
;; 	(setq opentag "\n" closetag ""))
;;        (t
;; 	(setq opentag " " closetag "")))
;;       (goto-char (match-beginning 0))
;;       (if (or (string= (match-string 1) "{")
;; 	      (string= (match-string 1) "\n"))
;; 	  ;; if the opening curly brace is right after a brace or
;; 	  ;; a newline, move forward to the brace we want
;; 	  (forward-char))
;;       (while (not at-closing-brace)
;; 	(forward-sexp)
;; 	(if (= 125 (char-before)) (setq at-closing-brace t)))
;;       (delete-char -1)
;;       (insert closetag)
;;       (replace-match opentag))))

;; (defvar org-cite-apacite-citetypes
;;   '(("fullcite" . "citep*") ; (Black, Green and Brown, 2011)
;;     ("shortcite" . "citep") ; (Black et al., 2011)
;;     ("fullciteNP" . "citealp*") ; Black, Green and Brown, 2011
;;     ("shortciteNP" . "citealp") ; Black et al., 2011
;;     ;; there's no apacite equivalent of natbib citealt(*)
;;     ("fullciteA" . "citet*") ; Black, Green and Brown (2011)
;;     ("shortciteA" . "citet") ; Black et al. (2011)
;;     ("fullciteauthor" . "citeauthor*") ; (Black, Green and Brown) NO - natbib doesn't have a "citeauthorpar*"
;;     ("shortciteauthor" . "citeauthor") ; (Black et al.) NO - ditto
;;     ("fullciteauthorNP" . "citeauthor*") ; Black, Green and Brown
;;     ("shortciteauthorNP" . "citeauthor") ; Black et al.
;;     ("citeyear" . "citeyearpar") ; (2011)
;;     ("citeyearNP" . "citeyear") ; 2011
;;     ("nocite" . "nocite") ;
;;     ("nocitemeta" . "nocite")) ; NOT QUITE - natbib doesn't have this
;; "Maps apacite cite commands to the corresponding natbib
;; commands. The apacite commands beginning with `cite' are not
;; included, as they are mapped to the corresponding commands
;; beginning with `full' or `short' before this table is looked up.

;; MAYBE TODO: For full APA support, it may be necessary to define a
;; separate citation-formatting function for apacites, but for now
;; we try cheating.")

;; (defvar org-cite-apacite-substitutions
;;   '(("%\n" . "")
;;     ("\\\\nobreakspace " . (org-cite-str :nobreak))
;;     ;; I have no idea if these complicated expressions are necessary.
;;     ;; Will have to look more into apacite.
;;     ("\\\\BAstyle\\({\\([^}]*\\)}\\)?" . "")
;;     ("\\\\BAastyle\\({\\([^}]*\\)}\\)?" . "")
;;     ("\\\\BAnd\\({\\([^}]*\\)}\\)?" . (org-cite-str :and)) ; ed. AND trans.
;;     ("\\\\BBOP\\({\\([^}]*\\)}\\)?" . "(")
;;     ("\\\\BBCP\\({\\([^}]*\\)}\\)?" . ")")
;;     ("\\\\BAP\\({\\([^}]*\\)}\\)?" . " ")
;;     ("\\\\BBAA\\({\\([^}]*\\)}\\)?" . (org-cite-str :and))
;;     ("\\\\BBA\\({\\([^}]*\\)}\\)?" . (org-cite-str :and))
;;     ("\\\\BBAA\\({\\([^}]*\\)}\\)?" . (org-cite-str :and))
;;     ("\\\\BOthers\\(Period\\| \\){.}" . (org-cite-str :et-al))
;;     ("\\\\BBAY\\({\\([^}]*\\)}\\)?" . ", ") ; between author and year
;;     ("\\\\BBYY\\({\\([^}]*\\)}\\)?" . ", ") ; between subsequent years
;;     ("\\\\BBN\\({\\([^}]*\\)}\\)?" . ", ")  ; before a postfix note (locator)
;;     ("\\\\BBOQ\\({\\([^}]*\\)}\\)?" . "") ; TODO opening quote in title
;;     ("\\\\BBCQ\\({\\([^}]*\\)}\\)?" . "") ; TODO closing quote in title
;;     ("\\\\BBC\\({\\([^}]*\\)}\\)?" . "; ")  ; between multiple cites
;;     ("\\\\BPBI\\({\\([^}]*\\)}\\)?" . ".~") ; Period between initial
;;     ("\\\\BHBI\\({\\([^}]*\\)}\\)?" . ".-") ; Hyphen between initials
;;     ("\\\\BCBL\\({\\([^}]*\\)}\\)?" . ",") ; comma before last author
;;     ("\\\\BCBT\\({\\([^}]*\\)}\\)?" . ",") ; comma between author
;;     ("\\\\BIn\\({\\([^}]*\\)}\\)?" . (org-cite-str :in)) ; part of other work
;;     ("\\\\BEDS\\({\\([^}]*\\)}\\)?" . (org-cite-str :eds)) ; Book editors
;;     ("\\\\BED\\({\\([^}]*\\)}\\)?" . (org-cite-str :ed)) ; Book editor
;;     ("\\\\BEd" . (org-cite-str :edn))  ; abbreviation for "edition"
;;     ("\\\\BTR\\({\\([^}]*\\)}\\)?" . "Tech. Rep.")
;;     ("\\\\BPGS\\({\\([^}]*\\)}\\)?" . (org-cite-str :pp)) ; between pages
;;     ("\\\\BNUM\\({\\([^}]*\\)}\\)?" . (org-cite-str :number)) ; Non-journal-issue number, e.g. Report No.
;;     ;; The followig three are important for cleaning up no-date bibcites
;;     ("\\\\bibnodate{}" . (org-cite-str :no-date)) ; TODO check format
;;     ("{\\\\bibnodate {}}" . (org-cite-str :no-date)) ; NOTE this is some weirdness that crops up in .aux files
;;     ("\\\\APACyear {\\([^}]+\\)}" . "\\1")
;;     ("\\\\bibcomputersoftwaremanual" . "computer software manual") ; TODO check format
;;     ("\\\\unskip" . "")
;;     ("\\\\protect" . "")
;;     ("\\\\&" . "&")
;;     ("{\\\\BCnt{\\([0-9]\\)}}" . (org-cite-num-to-letter (match-string 1))) ; year letter
;;     (" {}" . "")
;;     ("\\\\ " . " ")
;;     ("\\\\APACinsertmetastar{\\([^}]+\\)}" . "\n") ; Before the authorlist
;;     ("\\\\APACciteatitle{\\([^}]+\\)}" . "â€œ\\1â€") ; Cite article title in text
;;     ("\\\\APACcitebtitle{\\([^}]+\\)}" . "/\\1/") ; Cite book title in text
;;     ("\\\\APACmonth{\\([0-9]+\\)}" . (nth (1- (string-to-number (match-string 1))) org-cite-months)) ;
;;     ("\\\\APACrefYearMonthDay{\\([^}]*\\)}{\\([^}]+\\)?}{\\([^}]+\\)?}" . ;; "(\\1, \\2)")
;;      (concat "(\\1"
;;      	     (when (match-string 2) ", \\2")
;; 	     (when (match-string 3) " \\3")
;; 	     ")"))
;;     ("\\\\APACrefYear{\\([^}]+\\)}" . "(\\1)")
;;     ("\\\\APACrefatitle{\\([^}]+\\)}{\\([^}]+\\)}" . "\\1") ; article title (\\1 is lowercased)
;;     ("\\\\APACrefbtitle{\\([^}]+\\)}{\\([^}]+\\)}" . "/\\1/") ; book title (\\1 is lowercased)
;;     ("\\\\APACrefnote{\\([^}]+\\)}" . "(\\1)") ; TODO check formatting (brackets?)
;;     ("\\\\APACjournalVolNumPages{\\([^}]*\\)}{\\([^}]+\\)?}{\\([^}]+\\)?}{\\([^}]+\\)?}" .
;;      (concat "/\\1"
;; 	     (if (match-string 2) ", \\2/ " "/ ")
;; 	     (when (match-string 3) "(\\3)")
;; 	     (when (match-string 4) ", \\4")))
;;     ("\\\\APACbVolEdTR{\\([^}]*\\)}{\\([^}]*\\)}" . "\\1 \\2") ; not sure about this one
;;     ("\\\\APACaddressPublisher{\\([^}]+\\)?}{\\([^}]+\\)?}" .
;;      (concat (match-string 1)
;; 	     (when (and (match-string 1) (match-string 2)) ": ")
;; 	     (match-string 2)))
;;     ("\\\\APACaddressPublisherEqAuth{\\([^}]+\\)}{\\([^}]+\\)}" . "\\1: \\2")
;;     ("\\\\APACaddressInstitution{\\([^}]+\\)}{\\([^}]+\\)}" . "\\1: \\2")
;;     ("\\\\APAChowpublished{\\([^}]+\\)}" . "\\1")
;;     ("\\\\begin{APACrefURL}" . "Available from ")
;;     ("\\\\url{\\([^}]+\\)}" . "\\1")
;;     ("\\\\end{APACrefURL}" . "")
;;     ("\\\\PrintBackRefs{\\([^}]+\\)}" . "\n")
;;     ("\\\\PrintOrdinal{\\([^}]+\\)}" . "\\1"))
;; "Substitutions for the semantic crud left in LaTeX aux and bbl
;; files by apacite.")


;; (defun org-cite-map-chars (&optional source target include-math to-string)
;;   "Utility to extract from org-entities an alist of special
;; characters/markup in the SOURCE encoding and their equivalents in
;; the TARGET encoding (for an example, see
;; org-cite-latex-chars-utf8). SOURCE and TARGET default to latex
;; and utf8 respectively. Other options are org, html, ascii and
;; latin1. The list is extracted from org-entities. If INCLUDE-MATH
;; is non-nil, characters that need to be in math-mode in LaTeX are
;; also included. If TO-STRING is non-nil, results are returned as a
;; string of elisp rather than as a list."
;;   (let ((entities (reverse org-entities))
;; 	(fields '((org . 0) (latex . 1) (mathp . 2) (html . 3)
;; 		  (ascii . 4) (latin1 . 5) (utf8 . 6)))
;; 	charmap
;; 	record sourcechar targetchar)
;;     (unless source
;;       (setq source 'latex
;; 	    target 'utf8))
;;     (while entities
;;       (setq record (car entities))
;;       (when (and (listp record)  ; this is an entry in org-entities
;; 		 (or (not (nth 2 record)) ; and it either is not math-only
;; 		     include-math))  ; or we include math
;; 	(setq sourcechar (nth (cdr (assoc source fields)) record)
;; 	      targetchar (nth (cdr (assoc target fields)) record))
;; 	(when (eq source 'latex)
;; 	  ;; Don't include it if it doesn't start with a "\"
;; 	  (unless (string-match "\\\\" sourcechar) (setq sourcechar ""))
;; 	  ;; Add matchsticks for matching rather than replacing
;; 	  (setq sourcechar (replace-regexp-in-string "\\\\" "\\\\\\\\\\\\\\\\" sourcechar)))
;; 	(unless (string= sourcechar "")
;; 	  (setq charmap
;; 		(if to-string
;; 		    (concat "\n(\"" sourcechar "\" . \"" targetchar "\")" charmap)
;; 		  (cons (cons sourcechar targetchar) charmap)))))
;; 	(setq entities (cdr entities)))
;;     charmap))

;; (org-cite-map-chars 'latex 'utf8)

;; (defvar org-cite-latex-chars-utf8
;;       '(("\\\\`{A}" . "Ã€")
;; 	("\\\\`{a}" . "Ã ")
;; 	("\\\\'{A}" . "Ã")
;; 	("\\\\'{a}" . "Ã¡")
;; 	("\\\\^{A}" . "Ã‚")
;; 	("\\\\^{a}" . "Ã¢")
;; 	("\\\\~{A}" . "Ãƒ")
;; 	("\\\\~{a}" . "Ã£")
;; 	("\\\\\"{A}" . "Ã„")
;; 	("\\\\\"{a}" . "Ã¤")
;; 	("\\\\AA{}" . "Ã…")
;; 	("\\\\AA{}" . "Ã…")
;; 	("\\\\aa{}" . "Ã¥")
;; 	("\\\\AE{}" . "Ã†")
;; 	("\\\\ae{}" . "Ã¦")
;; 	("\\\\c{C}" . "Ã‡")
;; 	("\\\\c{c}" . "Ã§")
;; 	("\\\\'{C}" . "Ä†") ; lat2: Cacute
;; 	("\\\\'{c}" . "Ä‡") ; lat2: cacute
;; 	("\\\\v{C}" . "ÄŒ") ; lat2: Ccaron
;; 	("\\\\v{c}" . "Ä") ; lat2: ccaron
;; 	("\\\\^{C}" . "Äˆ") ; lat2: Ccirc
;; 	("\\\\^{c}" . "Ä‰") ; lat2: ccirc
;; 	("\\\\DJ" . "Ä")   ; lat2: Dstrok
;; 	("\\\\dj" . "Ä‘")   ; lat2: dstrok
;; 	("\\\\`{E}" . "Ãˆ")
;; 	("\\\\`{e}" . "Ã¨")
;; 	("\\\\'{E}" . "Ã‰")
;; 	("\\\\'{e}" . "Ã©")
;; 	("\\\\^{E}" . "ÃŠ")
;; 	("\\\\^{e}" . "Ãª")
;; 	("\\\\\"{E}" . "Ã‹")
;; 	("\\\\\"{e}" . "Ã«")
;; 	("\\\\^{G}" . "Äœ") ; lat2: Gcirc
;; 	("\\\\^{g}" . "Ä") ; lat2: gcirc
;; 	("\\\\^{H}" . "Ä¤") ; lat2: Hcirc
;; 	("\\\\^{h}" . "Ä¥") ; lat2: hcirc
;; 	("\\\\`{I}" . "ÃŒ")
;; 	("\\\\`{i}" . "Ã¬")
;; 	("\\\\'{I}" . "Ã")
;; 	("\\\\'{i}" . "Ã­")
;; 	("\\\\^{I}" . "ÃŽ")
;; 	("\\\\^{i}" . "Ã®")
;; 	("\\\\\"{I}" . "Ã")
;; 	("\\\\\"{i}" . "Ã¯")
;; 	("\\\\^{J}" . "Ä´") ; lat2: Jcirc
;; 	("\\\\^{j}" . "Äµ") ; lat2: jcirc
;; 	("\\\\~{N}" . "Ã‘")
;; 	("\\\\~{n}" . "Ã±")
;; 	("\\\\`{O}" . "Ã’")
;; 	("\\\\`{o}" . "Ã²")
;; 	("\\\\'{O}" . "Ã“")
;; 	("\\\\'{o}" . "Ã³")
;; 	("\\\\^{O}" . "Ã”")
;; 	("\\\\^{o}" . "Ã´")
;; 	("\\\\~{O}" . "Ã•")
;; 	("\\\\~{o}" . "Ãµ")
;; 	("\\\\\"{O}" . "Ã–")
;; 	("\\\\\"{o}" . "Ã¶")
;; 	("\\\\O" . "Ã˜")
;; 	("\\\\o{}" . "Ã¸")
;; 	("\\\\OE{}" . "Å’")
;; 	("\\\\oe{}" . "Å“")
;; 	("\\\\v{S}" . "Å ")
;; 	("\\\\v{s}" . "Å¡")
;; 	("\\\\^{S}" . "Åœ") ; lat2: Scirc
;; 	("\\\\^{s}" . "Å") ; lat2: scirc
;; 	("\\\\ss{}" . "ÃŸ")
;; 	("\\\\`{U}" . "Ã™")
;; 	("\\\\`{u}" . "Ã¹")
;; 	("\\\\'{U}" . "Ãš")
;; 	("\\\\'{u}" . "Ãº")
;; 	("\\\\^{U}" . "Ã›")
;; 	("\\\\^{u}" . "Ã»")
;; 	("\\\\\"{U}" . "Ãœ")
;; 	("\\\\\"{u}" . "Ã¼")
;; 	("\\\\u{U}" . "Å¬") ; lat2: Ubreve
;; 	("\\\\u{u}" . "Å­") ; lat2: ubreve
;; 	("\\\\'{Y}" . "Ã")
;; 	("\\\\'{y}" . "Ã½")
;; 	("\\\\\"{Y}" . "Å¸")
;; 	("\\\\\"{y}" . "Ã¿")
;; 	("\\\\v{Z}" . "Å½") ; lat2
;; 	("\\\\v{z}" . "Å¾") ; lat2
;; 	("\\\\DH{}" . "Ã")
;; 	("\\\\dh{}" . "Ã°")
;; 	("\\\\TH{}" . "Ãž")
;; 	("\\\\th{}" . "Ã¾")
;; 	("\\\\dots{}" . "â€¦")
;; 	("\\\\dots{}" . "â€¦")
;; 	("\\\\textperiodcentered{}" . "Â·")
;; 	("\\\\-" . "")
;; 	("\\\\textquotedbl{}" . "\"")
;; 	("\\\\textasciiacute{}" . "Â´")
;; 	("\\\\textquotedblleft{}" . "â€œ")
;; 	("\\\\textquotedblright{}" . "â€")
;; 	("\\\\quotedblbase{}" . "â€ž")
;; 	("\\\\textquoteleft{}" . "â€˜")
;; 	("\\\\textquoteright{}" . "â€™")
;; 	("\\\\quotesinglbase{}" . "â€š")
;; 	("\\\\guillemotleft{}" . "Â«")
;; 	("\\\\guillemotright{}" . "Â»")
;; 	("\\\\guilsinglleft{}" . "â€¹")
;; 	("\\\\guilsinglright{}" . "â€º")
;; 	("\\\\textbrokenbar{}" . "Â¦")
;; 	("\\\\S" . "Â§")
;; 	("\\\\&" . "&")
;; 	("\\\\textless{}" . "<")
;; 	("\\\\textgreater{}" . ">")
;; 	("\\\\~{}" . "~")
;; 	("\\\\textdagger{}" . "â€ ")
;; 	("\\\\textdaggerdbl{}" . "â€¡")
;; 	("\\\\hspace*{.5em}" . "â€‚")
;; 	("\\\\hspace*{1em}" . "â€ƒ")
;; 	("\\\\hspace*{.2em}" . "â€‰")
;; 	("\\\\textcurrency{}" . "Â¤")
;; 	("\\\\textcent{}" . "Â¢")
;; 	("\\\\pounds{}" . "Â£")
;; 	("\\\\textyen{}" . "Â¥")
;; 	("\\\\texteuro{}" . "â‚¬")
;; 	("\\\\EUR{}" . "â‚¬")
;; 	("\\\\EURdig{}" . "â‚¬")
;; 	("\\\\EURhv{}" . "â‚¬")
;; 	("\\\\EURcr{}" . "â‚¬")
;; 	("\\\\EURtm{}" . "â‚¬")
;; 	("\\\\textcopyright{}" . "Â©")
;; 	("\\\\textregistered{}" . "Â®")
;; 	("\\\\texttrademark{}" . "â„¢")
;; 	("\\\\textpm{}" . "Â±")
;; 	("\\\\textpm{}" . "Â±")
;; 	("\\\\texttimes{}" . "Ã—")
;; 	("\\\\textdiv{}" . "Ã·")
;; 	("\\\\textonehalf{}" . "Â½")
;; 	("\\\\textonequarter{}" . "Â¼")
;; 	("\\\\textthreequarters{}" . "Â¾")
;; 	("\\\\textperthousand{}" . "â€°")
;; 	("\\\\textonesuperior{}" . "Â¹")
;; 	("\\\\texttwosuperior{}" . "Â²")
;; 	("\\\\textthreesuperior{}" . "Â³")
;; 	("\\\\textmu{}" . "Âµ")
;; 	("\\\\textasciimacron{}" . "Â¯")
;; 	("\\\\textdegree{}" . "Â°")
;; 	("\\\\textlnot{}" . "Â¬")
;; 	("\\\\textbullet{}" . "â€¢")
;; 	("\\\\textbullet{}" . "â€¢")
;; 	("\\\\P{}" . "Â¶")
;; 	("\\\\textordfeminine{}" . "Âª")
;; 	("\\\\textordmasculine{}" . "Âº")
;; 	("\\\\c{}" . "Â¸")
;; 	("\\\\textasciidieresis{}" . "Â¨")
;; 	("\\\\/{}" . "â€Œ")
;; 	("\\\\smiley{}" . "â˜º")
;; 	("\\\\blacksmiley{}" . "â˜»")
;; 	("\\\\frownie{}" . "â˜¹"))
;; "Maps LaTeX special characters to utf-8. Based on org-entities,
;; with additions.")

;; (provide 'org-cite)
