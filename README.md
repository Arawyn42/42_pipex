# 42_pipex

This project consists in reproducing the behaviour of the pipe | in bash.

Done in 42 cursus at 42 Perpignan, in November of 2023 with bonus.

The following command : "./pipex file1 cmd1 cmd2 file2" is the equivalent of the bash command : " < file1 cmd1 | cmd2 > file2".

With the 'make bonus' build allows multi pipes, like this : "./pipex file1 cmd1 cmd2 cmd3 ... cmdN file2".

With the bonus build, it is possible to perform a here_doc pipe, like this : "./pipex here_doc LIMITER cmd1 cmd2 ... cmdN outfile", where LIMITER correspond to the stop keyword of the here_doc. By convention, it's 'EOF', for End Of File.
