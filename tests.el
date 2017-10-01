;;; package -- Summary
;;; Commentary:

(require 'cider)
(require 'buttercup)
(require 'cider-interaction)
(require 'cider-browse-ns)
(require 'clomacs)


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

(defun eita-test2 ()
  (interactive)
  (cider-load-buffer)
  (cider-interactive-eval
   (replace-regexp-in-string "->>"
                             (concat "->>sexp " (cider-last-sexp))
                             (cider-defun-at-point)))
  (save-excursion
    (end-of-defun)
    (backward-char)
    (backward-char)
    (cider--pprint-eval-form
     (concat "(clojure.pprint/pprint (apply "
             (cider-second-sexp-in-list)
             " (clojure.spec.gen.alpha/generate (clojure.spec.alpha/gen (:args (clojure.spec.alpha/get-spec `"
             (cider-second-sexp-in-list)
             "))))))"))))

(global-set-key (kbd "C-c C-a tt") 'eita-test)
(global-set-key (kbd "C-c C-a ty") 'eita-test2)

;;; tests.el ends here
