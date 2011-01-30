Movie Organiser
===============

Installation
-----------

    $ git clone git@github.com:owenmoony/movie_organiser.git

To Run
------

    $ ruby lib/run.rb your_movies_directory


Description
-----------

Will re-organise your movies directory in such a way:

    Babe 1995 720p XYZ/Babe 1995 720p XYZ-etc.avi
    Devil.2010.DVDRip.XviD-Name.avi

To:

    Adventure/Babe (1995) - 7.2/...
    Horror/Devil (2010) - 6.5.avi

Where 'Adventure', 'Horror' is the genre from imdb and '7.2', '6.5' is the imdb user rating.

TODO
-----
 - Add a web interface :)
 - Add better command line options parsing, help
 - Many more tests
 - Better installation
