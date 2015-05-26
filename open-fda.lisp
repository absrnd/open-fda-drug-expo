;;;; open-fda.lisp

(in-package #:open-fda)

;;; Example request, from the open-fda website
;;; https://open.fda.gov/drug/event/


;; the following works (i.e returns JSON data from API
(flexi-streams:octets-to-string
 (drakma:http-request "http://api.fda.gov/drug/event.json"
		      :method :get))

;; problem seems to be with passing parameters..
;;
;; The following returns 500 Internal Server Error
;; NOTE that the URL search parameter is encoded as..
;; ..search=receivedate%3A%5B20040101%2BTO%2B20150101%5D
(drakma:http-request "http://api.fda.gov/drug/event.json"
		     :method :get
		     :parameters '(("api_key" . "XyHGGLN0s1jl8QMBOeiaNckpqAM7v6gmmj13nd4R")
				   ("search" . "receivedate:[20040101+TO+20150101]")
				   ("limit" . "1")))

;; WHEREAS by self-coding the parameters using the :CONTENT keyword works
(flexi-streams:octets-to-string
 (drakma:http-request "http://api.fda.gov/drug/event.json"
		      :method :get
		      :content "search=receivedate:[2004-01-01+TO+2015-01-01]&limit=1"))

(defun null-encoder (string format) string) ; Return the string. Regardless of format!

;;
;; www.weitz.de suggests that the :PARAMETERS are coded using FLEXI-STREAMS
;; external-format-out before they are sent to the server, unless the
;; :FORM-DATA keyword is set.
;; However, if we encode the url using the NULL-ENCODER then it works!
;;
(flexi-streams:octets-to-string
 (drakma:http-request "http://api.fda.gov/drug/event.json"
		      :method :get
		      :url-encoder #'null-encoder
		      :parameters '(("api_key" . "XyHGGLN0s1jl8QMBOeiaNckpqAM7v6gmmj13nd4R")
				    ("search" . "receivedate:[20040101+TO+20150101]")
				   ("count" . "receivedate"))))
