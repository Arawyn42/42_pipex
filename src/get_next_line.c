/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: drenassi <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/10/19 14:57:14 by drenassi          #+#    #+#             */
/*   Updated: 2023/11/14 19:47:18 by drenassi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../includes/pipex.h"

static char	*ft_stash(char *stash)
{
	int		i;
	char	*res;

	i = 0;
	if (!stash)
		return (NULL);
	while (stash[i] && stash[i] != '\n')
		i++;
	if (stash[i] == '\n')
		i++;
	res = gnl_substr(stash, i, gnl_strlen(stash) - i + 1);
	free(stash);
	if (res[0] == 0)
	{
		free(res);
		res = NULL;
	}
	return (res);
}

static char	*ft_get_line(char *stash)
{
	int		i;
	char	*line;

	i = 0;
	if (!stash)
		return (NULL);
	while (stash[i] && stash[i] != '\n')
		i++;
	if (stash[i] == '\n')
		i++;
	line = gnl_substr(stash, 0, i);
	return (line);
}

static char	*ft_read(int fd, char *buffer, char *stash)
{
	int		r;

	r = 1;
	while (r && !gnl_strchr(stash, '\n'))
	{
		r = read(fd, buffer, BUFFER_SIZE);
		if (r <= -1)
		{
			free(buffer);
			free(stash);
			return (NULL);
		}
		if (r == 0)
			break ;
		buffer[r] = '\0';
		stash = gnl_strjoin(stash, buffer);
		if (!stash)
		{
			free(buffer);
			return (NULL);
		}
	}
	free(buffer);
	return (stash);
}

char	*get_next_line(int fd)
{
	static char	*stash;
	char		*buffer;
	char		*line;

	if (fd < 0 || BUFFER_SIZE <= 0 || read(fd, 0, 0) < 0)
		return (free(stash), stash = NULL, NULL);
	buffer = malloc(sizeof(char) * (BUFFER_SIZE + 1));
	if (!buffer)
		return (NULL);
	stash = ft_read(fd, buffer, stash);
	line = ft_get_line(stash);
	stash = ft_stash(stash);
	return (line);
}
