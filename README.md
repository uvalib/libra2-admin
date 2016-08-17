# Libra 2 Admin

* Project started as a plain Rails 5 app, generated with `rails new libra2-admin -O`

(There is no Active Record support for this application -- all data will be accessed through web services.)

* Basic functionality has been copied from "deposit registration" application.

* All authentication happens using shiboleth. If the browser can reach this app, we already know it is a legal user.
