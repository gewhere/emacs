;; (setq org-startup-indented t) ;; auto-indent text in subtrees
;; http://pages.sachachua.com/.emacs.d/Sacha.html
(setq org-html-head "<link rel=\"stylesheet\" type=\"text/css\"
href=\"http://sachachua.com/blog/wp-content/themes/sacha-v3/foundation/css/foundation.min.css\"></link>
<link rel=\"stylesheet\" type=\"text/css\" href=\"http://sachachua.com/org-export.css\"></link>
<link rel=\"stylesheet\" type=\"text/css\" href=\"http://sachachua.com/blog/wp-content/themes/sacha-v3/style.css\"></link>
<script src=\"http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js\"></script>")
(setq org-html-htmlize-output-type 'css)
(setq org-src-fontify-natively t)
;; FOOTER


(setq org-html-preamble "<a name=\"top\" id=\"top\"></a>")
(setq org-html-postamble "
<style type=\"text/css\">
.back-to-top {
    position: fixed;
    bottom: 2em;
    right: 0px;
    text-decoration: none;
    color: #000000;
    background-color: rgba(235, 235, 235, 0.80);
    font-size: 12px;
    padding: 1em;
    display: none;
}

.back-to-top:hover {
    background-color: rgba(135, 135, 135, 0.50);
}
</style>

<div class=\"back-to-top\">
<a href=\"#top\">Back to top</a> | <a href=\"mailto:gediapou@student.jyu.fi\">E-mail me</a>
<p></p>
<center>
<a href=\"http://users.jyu.fi/~gediapou\">Georgios Diapoulis</a>
</center>
</div>

<script type=\"text/javascript\">
    var offset = 220;
    var duration = 500;
    jQuery(window).scroll(function() {
        if (jQuery(this).scrollTop() > offset) {
            jQuery('.back-to-top').fadeIn(duration);
        } else {
            jQuery('.back-to-top').fadeOut(duration);
        }
    });
</script>")


;;
(setq org-src-window-setup 'current-window)
;;
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (dot . t)
   (ditaa . t)
   (lilypond . t)
   (shell . t)
   ))

;;
(add-to-list 'org-src-lang-modes (quote ("sh" . shell)))
(add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))
(add-to-list 'org-src-lang-modes (quote ("ghc" . haskell)))
(add-to-list 'org-src-lang-modes (quote ("latex" . latex)))
(add-to-list 'org-src-lang-modes (quote ("sclang" . sclang)))
(add-to-list 'org-src-lang-modes (quote ("sclang" . sclang)))
(add-to-list 'org-src-lang-modes (quote ("lilypond" . lilypond)))
(add-to-list 'org-src-lang-modes (quote ("octave" . octave)))

(provide 'orgextras);;; ends here
