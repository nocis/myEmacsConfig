
;; bind two files, and switch between them
;; <backtab> bind
;; C-x <backtab> rebind

(eval-when-compile			; required and optional libraries
  (require 'cc-mode)
  (require 'find-file))

(require 'align)


(setq files-pair '() )

(message files-pair)
(message (getenv "HOME"))
;; (plist-get '("1" "2" "2" "1") "1") cannot be used for string  


(defun add-new-pairs ( file-name )
  (progn
    (setq files-pair (plist-put files-pair file-name (read-file-name "Find other file: ")))
  )
)


(defun switch-file (file-name)
  (if (plist-member files-pair file-name)
    (progn
       (if ( plist-get files-pair file-name )
	  (progn
	     (find-file ( plist-get files-pair file-name ) )
	  )
	  (progn
	    (add-new-pairs file-name )
	    ( switch-file file-name )
	  )
       )
       ;(message "1")
    )
    (progn
       (setq files-pair (plist-put files-pair file-name nil))
       ( switch-file file-name )
       ;(message "0")
    )
  )
)

;(mapcar 'car vl/paths)
;(switch-file (buffer-file-name) ) 

;(global-set-key (kbd "<backtab>") (switch-file (buffer-file-name) ) )
(define-key (current-global-map) (kbd "<backtab>") (lambda () (interactive)
		 (switch-file (expand-file-name buffer-file-name ) )
	       ) )

(define-key (current-global-map) (kbd "C-x <backtab>") (lambda () (interactive)
	       (setq files-pair (plist-put files-pair (expand-file-name buffer-file-name ) nil))
	       (switch-file (expand-file-name buffer-file-name ) )
	       ) )

(setq files-map
  (let ((files-map (make-sparse-keymap)))
    ;;(define-key files-map (kbd "<backtab>") (message "1") )
    files-map)
)
