;; load path
(push "~/.emacs.d/lisp" load-path)
(let ((default-directory  "~/.emacs.d/lisp/"))
(normal-top-level-add-subdirs-to-load-path))

;; load glsl-mode
(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))


;; delete selection mode
(delete-selection-mode 1)

;;; Tune the GC
;; The default settings are too conservative on modern machines making Emacs
;; spend too much time collecting garbage in alloc-heavy code.
(setq gc-cons-threshold (* 4 1024 1024))
(setq gc-cons-percentage 0.3)

;;; Initialize the package manager
(eval-and-compile
  (require 'package)
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("gnu" . "https://elpa.gnu.org/packages/")))
  (setq package-enable-at-startup nil)
  (package-initialize)
  (defvar init-el-package-archives-refreshed nil)
  (defun init-el-install-package (package-name)
    (unless (package-installed-p package-name)
      (unless init-el-package-archives-refreshed
        (package-refresh-contents)
        (setq init-el-package-archives-refreshed t))
      (package-install package-name)))
  (defmacro init-el-with-eval-after-load (feature &rest body)
    (declare (indent 1) (debug t))
    (require feature)
    `(with-eval-after-load ',feature ,@body))
  (defmacro init-el-require-package (package-name &optional feature-name)
    (init-el-install-package package-name)
    (require (or feature-name package-name))
    `(init-el-install-package ',package-name)))



;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)






;; View line number, except shell mode
(global-linum-mode 1) ; always show line numbers
(setq linum-format "%02d ") ;set format
(add-hook 'shell-mode-hook (lambda ()(linum-mode 0)))
(setq linum-mode-inhibit-modes-list '(eshell-mode
                                      shell-mode
                                      erc-mode
                                      jabber-roster-mode
                                      jabber-chat-mode
                                      gnus-group-mode
                                      gnus-summary-mode
                                      gnus-article-mode))

(defadvice linum-on (around linum-on-inhibit-for-modes)
  "Stop the load of linum-mode for some major modes."
    (unless (member major-mode linum-mode-inhibit-modes-list)
      ad-do-it))

(ad-activate 'linum-on)











(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages (quote (multiple-cursors ## gnu-elpa-keyring-update))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; default theme
(setq default-frame-alist
	'((background-color . "black")
	  (foreground-color . "grey")
	  (cursor-color . "gold1")))
(set-default-font "Source Code Pro 16")

;; .emacs default layouthell
;; layout definition
(defun my-startup-layout ()
 (interactive)
 (delete-other-windows)
 (split-window-horizontally) ;; -> |
 (next-multiframe-window)
 ;; (find-file "~/.emacs.d/init.el")
 (split-window-vertically) ;;  -> --
 (shell)
 (next-multiframe-window)
 ;;(next-multiframe-window)
 (dired "~")
)

;; execute the layout
(my-startup-layout )

;; for copy pasting
(setq x-select-enable-clipboard t)
(unless window-system
 (when (getenv "DISPLAY")
  (defun xsel-cut-function (text &optional push)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
  (defun xsel-paste-function()
    (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
      (unless (string= (car kill-ring) xsel-output)
	xsel-output )))
  (setq interprogram-cut-function 'xsel-cut-function)
  (setq interprogram-paste-function 'xsel-paste-function)
  ))

;; no C-z
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))



