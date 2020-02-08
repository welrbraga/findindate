# findindate

A complement for GNU Find Tool that simplify searchs for files in a specific date.

How many files you've created yesterday? How can I archive your files of 2016?
Is it possible to delete my files of July 2017?

If you have asked these question once, so this tool is for you.

I have to manipulate lots of files everyday and one of the most common resource
I use to filter the files is that available by GNU find but work with dates is
very hard so I had created this litle script to simplify these jobs.


## INSTALL / UNINSTALL ##

After clone this repo or just download de file "findindate.sh" we can use make to install or uninstall the script:

$ make install

or

$ make uninstall


## EXAMPLES ##

  Looking for all log files created today

  $ find /var/log -type f \`findindate --today\` -ls


  ... and yesterday

  $ find /var/log -type f \`findindate --yesterday\` -ls


  What files do you have created in May ?

  $ find /home/myuser -type f \`findindate --inmonth 05\` -ls


  During the whole 2018 which txt files you have created

  $ find /home/myuser -type f -iname '*.txt' \`findindate --inyear 2018\` -ls


  Pictures saved in February, 2016

  $ find /home/myuser/Pictures -type f \`findindate --inyear 2016 --inmonth 02\` -ls


  Files saved before or after a specific point in time

  $ find /home -type f \`findindate --before 201705010000\` -ls

  $ find /home -type f \`findindate --after 201705010000\` -ls


## USAGE ##

Note that findindate is not a standalone tool. It works creating and passing the correct parameters to GNU Find tool.

Doubts? Check the output of "findindate --help" to get examples or ask here.
