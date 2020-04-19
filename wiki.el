;;; wiki.el -- Wiki package
;;; Commentary:
;;; Code:

(require 'org)

(defvar wiki-dir "~/org/wiki")

(defun wiki--page-path (name)
  "Return full file path for page NAME."
  (if (or (string-prefix-p "/" name)
          (not (string-prefix-p (expand-file-name wiki-dir) (buffer-file-name))))
      (concat (replace-regexp-in-string "/$" "" wiki-dir)
              "/"
              (replace-regexp-in-string "^/" "" name)
              ".org")
    (concat (replace-regexp-in-string "\\.org$" "" (buffer-file-name))
            "/"
            name
            ".org")))

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
          (replace-regexp-in-string ".*/\\([^/]+\\)$" "\\1" name)))

(defun wiki--open-page (name)
  "Open wiki page NAME."
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
                       "- [[wiki:/index][Index Page]]\n\n")
                      (replace-regexp-in-string ".*/\\([^/]+\\)$" "\\1" name)
                      (current-time-string)))
      (save-buffer)
      )))

(defun wiki-insert-link ()
  "Insert a link to a page."
  (interactive)
  (insert (wiki--make-link (read-string "Enter link path: "))))

(org-link-set-parameters "wiki"
                         :follow 'wiki--open-page)

(provide 'wiki)
;;; wiki.el ends here
