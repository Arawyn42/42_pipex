/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_utils2.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: drenassi <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/10 20:48:40 by drenassi          #+#    #+#             */
/*   Updated: 2023/11/17 21:15:27 by drenassi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

/* Close the current pipe fds, send an error message with perror then exit */
void	ft_error_exit(int *pipe_fd, const char *msg)
{
	ft_close(pipe_fd);
	perror(msg);
	exit(EXIT_FAILURE);
}

/* Frees a double array of characters */
void	ft_free(char **array)
{
	int	i;

	i = 0;
	while (array[i])
	{
		free(array[i]);
		i++;
	}
	free(array);
}

void	ft_close(int *pipe_fd)
{
	close(pipe_fd[0]);
	close(pipe_fd[1]);
}

/* Used for ft_split, which splits only spaces out of quotes... */
int	ft_quotes(const char c, int *quotes)
{
	if (*quotes == 0 && c == '\'')
		*quotes = 1;
	else if (*quotes == 1 && c == '\'')
		*quotes = 0;
	return (*quotes);
}
