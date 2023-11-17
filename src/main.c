/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: drenassi <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/09 17:58:17 by drenassi          #+#    #+#             */
/*   Updated: 2023/11/16 18:04:14 by drenassi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

/****************************** Child process *******************************/
/*					To execute the first command (cmd1).					*/
/* 1. Open file1 (1st arg) and put the fd in a variable.					*/
/* 2. Duplicate and link file1 to standard input (0).						*/
/* 3. Link the pipe's output to the standard output (1).					*/
/* 4. Executes cmd1 on the given environnement.								*/
/****************************************************************************/
void	ft_child_process(char **av, int *pipe_fd, char **env)
{
	int		fd;

	fd = ft_open(av[1], STDIN_FILENO);
	dup2(fd, STDIN_FILENO);
	close(fd);
	dup2(pipe_fd[1], STDOUT_FILENO);
	ft_close(pipe_fd);
	ft_exec(av[2], env);
}

/****************************** Parent process ******************************/
/*					To execute the second command (cmd2).					*/
/* 1. Open file2 (4th arg) and put the fd in a variable.					*/
/* 2. Link the write entry of the pipe to the standard input (0).			*/
/* 3. Duplicate and link file2 to standard output (1).						*/
/* 4. Executes cmd2 on the given environnement.								*/
/****************************************************************************/
void	ft_parent_process(char **av, int *pipe_fd, char **env)
{
	int	fd;

	fd = ft_open(av[4], STDOUT_FILENO);
	dup2(pipe_fd[0], STDIN_FILENO);
	ft_close(pipe_fd);
	dup2(fd, STDOUT_FILENO);
	close(fd);
	ft_exec(av[3], env);
}

/****************************** Main function *******************************/
/* 1. Check if there are enough arguments.									*/
/* 2. Create a pipe array: pipe_fd[0] = Write end ; pipe_fd[1] = Read end.	*/
/* 3. Create a child process with fork.										*/
/* 4. If pid = 0, we're in the child process.								*/
/* 5. If pid > 0, we're in the parent process.								*/
/****************************************************************************/
int	main(int ac, char **av, char **env)
{
	int		pipe_fd[2];
	pid_t	pid;

	if (ac != 5)
	{
		ft_putstr("Too few parameters. ", 2);
		ft_putstr("Usage: ./pipex file1 cmd1 cmd2 file2\n", 2);
		exit(127);
	}
	if (pipe(pipe_fd) == -1)
		ft_error_exit(pipe_fd, "pipe error");
	pid = fork();
	if (pid == -1)
		ft_error_exit(pipe_fd, "fork error");
	if (pid == 0)
		ft_child_process(av, pipe_fd, env);
	waitpid(pid, NULL, 0);
	ft_parent_process(av, pipe_fd, env);
	ft_close(pipe_fd);
	return (0);
}
