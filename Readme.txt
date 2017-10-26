Teaching Learning Students Quiz
Profesor Examen

Created by: Autumn, Hana and Walter

This project solves the problem of a teacher having too many students and not having an easy way to learn their names
Este proyecto resuelve el problema de que un profesor tenga demasiados estudiantes y no tenga una manera fácil de aprender sus nombres

This is an update.
adding update from test branch

How to start the postgres server: In the command prompt, type:
sudo service postgresql start


If you get an error like this:

Connection refused Is the server running on host "0.0.0.0" and accepting TCP/IP connections on port 5432?

Run these lines of code: 

sudo -u postgres pg_ctlcluster 9.3 main stop

sudo -u postgres pg_ctlcluster 9.3 main restart