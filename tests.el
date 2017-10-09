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

(clomacs-defun clj-eval clj-pip.core/eval-read-string)

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
  (cider-interactive-eval "(require 'clj-pip.core)")
  (cider-repl-set-ns (cider-current-ns))
  (cider-interactive-eval
   (replace-regexp-in-string "\\_<->>\\_>"
                             (concat "clj-pip.core/->>sexp " (cider-last-sexp))
                             (replace-regexp-in-string
                              "\\_<->\\_>"
                              (concat "clj-pip.core/->sexp " (cider-last-sexp))
                              (cider-defun-at-point))))
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
          (let ((str-to-be-inserted (clj-eval cmd-str)))
            (insert str-to-be-inserted))
          (clj-pip-fill-lines "\\(\\[:\\+\\)" 'ediff-current-diff-B)
          (clj-pip-fill-lines "\\(\\[:\\-\\)" 'ediff-current-diff-A))))))

(global-set-key (kbd "C-c C-a tt") 'eita-test)
(global-set-key (kbd "C-c C-a ty") 'eita-test2)

(n
 (with-current-buffer (get-buffer-create "*clj-pip*")
   (let ((danosse (clj-eval "(apply eita (clojure.spec.gen.alpha/generate (clojure.spec.alpha/gen (:args (clojure.spec.alpha/get-spec `eita)))))")))
     (insert danosse))))

;;; tests.el ends here
