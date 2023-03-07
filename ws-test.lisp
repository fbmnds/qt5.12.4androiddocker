(ql:quickload :websocket-driver-client)

(defvar *p990* "ws://192.168.178.22:7700/echo")
(defvar *tab910* "ws://192.168.178.2:7700/echo")

(defun client (url text)
  (let ((client (wsd:make-client url)))
    (wsd:start-connection client)
    (wsd:send client text)
    (wsd:close-connection client)))
