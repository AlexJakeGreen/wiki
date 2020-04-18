;;; wiki.el -- Wiki package
;;; Code:
;;; Commentary:

(defvar wiki-dir "~/org/wiki/")

(defun wiki-get-page-path (pagename)
  "Return file path for PAGENAME."
  (concat wiki-dir "/" pagename ".org"))

(defun wiki-get-pagename-from-path (path)
  "Return pagename from PATH."
  (substring path (+ 1 (length (expand-file-name wiki-dir))) (length path)))

(defun wiki-page-exists (pagename)
  "Check if PAGENAME exists."
  (file-exists-p (wiki-get-page-path pagename)))

(defun wiki-dirname (pagename)
  "Return dirname for PAGENAME."
  (replace-regexp-in-string "[^/]+$" "" (wiki-get-page-path pagename)))

(defun wiki-open-page (pagename)
  "Open wiki page PAGENAME."
  (interactive)
  (if (wiki-page-exists pagename)
      (find-file (wiki-get-page-path pagename))
    (progn
      (unless (file-directory-p (wiki-dirname pagename))
        (make-directory (wiki-dirname pagename) t))
      (find-file (wiki-get-page-path pagename))
      (insert (format (concat
                       "#+TITLE: %s\n"
                       "#+DESCRIPTION:\n"
                       "#+STARTUP:  content\n"
                       "\n\n"
                       "- [[index][Index]]\n\n")
                      pagename))
      (save-buffer)
      )))

(defun wiki-make-link (pagename)
  "Make a link from PAGENAME."
  (format "[[%s][%s]]" pagename pagename))

(defun wiki-insert-link ()
  "Insert a link to a page."
  (interactive)
  (insert (wiki-make-link (read-string "Enter link path: "))))

(provide 'wiki)
;;; wiki.el ends here
