(defmacro dhu/badges-template-assign-variable (template var)
  `(progn
     (string-match (concat "\\$" ,var "\\$") ,template)
     (replace-match (symbol-value (intern ,var)) nil t ,template)))

(defun dhu/badges-template-write (template output)
  (with-temp-buffer
    (insert-file-contents template)
    (labels ((replace-string-in-buffer (from-string to-string)
                                       (goto-char (point-min))
                                       (replace-string from-string to-string)))
      (let ((badges (save-excursion
                     (set-buffer "*badges*")
                     ;; LaTeX needs escaping characters underscore and ampersand
                     (toggle-read-only)
                     (replace-string-in-buffer "_" "\\_")
                     (replace-string-in-buffer "&" "\\&")
                     (buffer-string))))
        (replace-string-in-buffer
         (buffer-string)
         (dhu/badges-template-assign-variable (buffer-string) "badges"))))
    (write-file output)))

(defun dhu/make-badges (latex-tpl badge-tpl csv output)
  "Populate LaTeX source for badges.

Open up the LaTeX file TEMPLATE and replace placeholder
'%%REPLACME %%' with appropirate data generated upon fields
stored in file CSV.  Write result LaTeX source in file OUTPUT."
  (interactive
   (list
    (read-file-name "Document template: " nil nil t "document.tex"
                    (lambda (arg) (string-match "\.tex$" arg)))
    (read-file-name "Badge template: " nil nil t "badge.tex"
                    (lambda (arg) (string-match "\.tex$" arg)))
    (read-file-name "CSV: " nil nil t nil
                    (lambda (arg) (string-match "\.csv$" arg)))
    (read-file-name "Output: " nil nil t nil
                    (lambda (arg) (string-match "\.tex$" arg)))))
  (let ((badge-string (with-temp-buffer
		       (insert-file-contents badge-tpl)
		       (buffer-string))))
    (with-output-to-temp-buffer "*badges*"
      (with-temp-buffer
	(insert-file-contents csv)
        ;; skip first header row
        (goto-char (point-min))
        (beginning-of-line 2)
	(while (re-search-forward "^\"\\([^\"]+\\)\",\"?\\([^\"]*\\)\"?,\"?\\([^\"]*\\)\"?,\"?\\([^\"]*\\)\"?,\"?\\([^\"]*\\)\"?,\"?\\([^\"]*\\)\"?,\"?\\([^\"]*\\)\"?,\"?\\([^\"]*\\)\"?$" nil t)
	  (let ((current-badge badge-string)
                (name (match-string 1))
		(nick (match-string 2))
		(company (match-string 3))
		(role (match-string 4))
		(profile1 (match-string 5))
		(profile2 (match-string 6))
		(profile3 (match-string 7))
		(profile4 (match-string 8)))
 	    (string-match "\\$color1\\$" current-badge)
 	    (setq current-badge
                  (if (string= "X" profile1)
                      (replace-match "Dark" nil nil current-badge)
                    (replace-match "Bright" nil nil current-badge)))
 	    (string-match "\\$color2\\$" current-badge)
 	    (setq current-badge
                  (if (string= "X" profile2)
                      (replace-match "Dark" nil nil current-badge)
                    (replace-match "Bright" nil nil current-badge)))
 	    (string-match "\\$color3\\$" current-badge)
 	    (setq current-badge
                  (if (string= "X" profile3)
                      (replace-match "Dark" nil nil current-badge)
                    (replace-match "Bright" nil nil current-badge)))
 	    (string-match "\\$color4\\$" current-badge)
 	    (setq current-badge
                  (if (string= "X" profile4)
                      (replace-match "Dark" nil nil current-badge)
                    (replace-match "Bright" nil nil current-badge)))
            (setq profile4 "programozó")
            (setq profile3 "sminkmester")
            (setq profile2 "webmester")
            (setq profile1 "ismerkedő")
            (dolist (var '("name" "nick" "company" "role" "profile1" "profile2" "profile3" "profile4"))
              (setq current-badge (dhu/badges-template-assign-variable current-badge var)))
	    (princ current-badge))))))
  (dhu/badges-template-write latex-tpl output))
