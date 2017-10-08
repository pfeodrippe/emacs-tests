;;; package -- Summary
;;; Commentary:

(require 'cider)
(require 'buttercup)
(require 'cider-interaction)
(require 'cider-browse-ns)
(require 'clomacs)
(require 'highlight)

;;; Code:
(defun eita-test ()
  (interactive)
  ;; (with-current-buffer "*cider-repl banka*"
  ;;   (clojure-mode)
  ;;   ;;(save-excursion (insert "(defn a [] (let [x 1] (inc x)) {:a 1, :b 2})"))
  ;;   (print (cider--var-namespace "#'c/var-two"))
  ;;   ;;(cider--debug-move-point '(3 2 1))
  ;;   )

  ;;(cider-insert-in-repl "(+ 1 2)" t)
  ;;(cider-insert-region-in-repl 1 20)

  ;;(print (cider-defun-at-point))
  (print (point))
  ;;(cider--pprint-eval-form "(+ 1 4)")
  ;;(cider-interactive-eval "(+ 1 77)")

  (print (replace-regexp-in-string "->>"
                                   "->>s"
                                   (cider-defun-at-point)))

  (cider-interactive-eval
   (replace-regexp-in-string "->>"
                             "->>s"
                             (cider-defun-at-point)))

  (clomacs-defun summ-1 +)
  (print (summ-1 2 22)))

(defmacro n (body)
  nil)

(defmacro s (body)
  body)

(defun clj-pip-fill-lines (regex face)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward regex nil t)
      (let ((init-point (or (match-beginning 0) (match-beginning 1))))
        (goto-char init-point)
        (beginning-of-line)
        (let ((init-line (point)))
          (goto-char init-point)
          (forward-sexp)
          (hlt-highlight-region init-line
                                (progn (end-of-line)
                                       (forward-char)
                                       (point))
                                face))))))

(defun eita-test2 ()
  (interactive)
  (cider-load-buffer)
  (cider-interactive-eval
   (replace-regexp-in-string "->>"
                             (concat "clj-pip.core/->>sexp " (cider-last-sexp))
                             (cider-defun-at-point)))
  (save-excursion
    (end-of-defun)
    (backward-char)
    (backward-char)
    (let ((fn-name (cider-second-sexp-in-list)))
      (let ((cmd-str (concat " (apply "
                             fn-name
                             " (clojure.spec.gen.alpha/generate (clojure.spec.alpha/gen (:args (clojure.spec.alpha/get-spec `"
                             fn-name
                             ")))))")))
        (with-current-buffer (get-buffer-create "*clj-pip*")
          (clojure-mode)
          (setq buffer-read-only nil)
          (erase-buffer)
          (display-buffer "*clj-pip*")
          (goto-char (point-min))
          (clomacs-defun clj-eval eval-read-string)
          (let ((str-to-be-inserted (clj-eval cmd-str)))
            (n(put-text-property 0
                                 10
                                 'font-lock-face
                                 '(:background "#006635")
                                 str-to-be-inserted))
            (insert str-to-be-inserted))
          (clj-pip-fill-lines "\\(\\[:\\+\\)" 'ediff-current-diff-B)
          (clj-pip-fill-lines "\\(\\[:\\-\\)" 'ediff-current-diff-A))))))

(global-set-key (kbd "C-c C-a tt") 'eita-test)
(global-set-key (kbd "C-c C-a ty") 'eita-test2)

(with-current-buffer "aaaa"
  (while (re-search-forward "\\[:\\+" nil t)
    (let ((cur-point (or (match-beginning 0) (match-beginning 1)))
          (color (if (match-beginning 0)
                     "#006635"
                   "deep pink")))
      (end-of-line)
      (print cur-point)
      (print (point))
      (hlt-highlight-region cur-point (point)))))

(with-current-buffer "aaaa"
  (hlt-highlight-region 170 264))

(with-current-buffer "aaaa"
  (hlt-unhighlight-region))

(n (highlight-regexp "\\[:\\+.*\\]" 'hi-green))

(with-current-buffer "aaaa"
  (clj-pip-fill-lines "\\(\\[:\\+\\)" 'ediff-current-diff-B)
  (clj-pip-fill-lines "\\(\\[:\\-\\)" 'ediff-current-diff-A))

(with-current-buffer "aaaa"
  (hlt-unhighlight-region))

(defun hlt-highlight-lines (start end face msgp)
  (save-excursion (goto-char (region-beginning))
                  (line-beginning-position))
  (save-excursion (goto-char (region-end))
                  (line-beginning-position 2))
  (hlt-highlight-region start end face msgp))
;;; tests.el ends here
