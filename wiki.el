;;; wiki.el -- Wiki package
;;; Commentary:
;;; Code:

(require 'org)

(defvar wiki-dir "~/org/wiki/")

(defun wiki--page-path (name)
  "Return file path for page NAME."
  (concat wiki-dir "/" name ".org"))

(defun wiki--dirname (name)
  "Return dirname for page NAME."
  (replace-regexp-in-string "[^/]+$" "" (wiki--page-path name)))

(defun wiki--page-exists (name)
  "Check if page NAME exists."
  (file-exists-p (wiki--page-path name)))

(defun wiki--make-link (name)
  "Make a link from page NAME."
  (format "[[wiki:%s][%s]]"
          name
          (replace-regexp-in-string ".+/\\([^/]+\\)$" "\\1" name)))

(defun wiki-open (name)
  "Open wiki page NAME."
  (interactive)
  (if (wiki--page-exists name)
      (find-file (wiki--page-path name))
    (progn
      (unless (file-directory-p (wiki--dirname name))
        (make-directory (wiki--dirname name) t))
      (find-file (wiki--page-path name))
      (insert (format (concat
                       "#+TITLE: %s\n"
                       "#+DESCRIPTION:\n"
                       "#+TIMESTAMP: %s\n"
                       "#+STARTUP:  content\n"
                       "\n\n"
                       "- [[wiki:index][Index Page]]\n\n")
                      name
                      (current-time-string)))
      (save-buffer)
      )))

(defun wiki-insert-link ()
  "Insert a link to a page."
  (interactive)
  (insert (wiki--make-link (read-string "Enter link path: "))))

(defun wiki--link-follow (path)
  "Follow a link with PATH."
  (wiki-open path))

(org-link-set-parameters "wiki"
                         :follow 'wiki-open)

(provide 'wiki)
;;; wiki.el ends here
