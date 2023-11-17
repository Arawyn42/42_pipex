/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   bonus.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: drenassi <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/14 19:44:19 by drenassi          #+#    #+#             */
/*   Updated: 2023/11/15 20:44:57 by drenassi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef BONUS_H
# define BONUS_H

# ifndef BUFFER_SIZE
#  define BUFFER_SIZE 42

# endif

/***************************** BONUS UTILS *****************************/
char	*gnl_strchr(char const *s, int c);
size_t	gnl_strlen(char const *s);
char	*gnl_strdup(char const *src);
char	*gnl_strjoin(char *s1, char const *s2);
char	*gnl_substr(const char *s, unsigned int start, size_t len);
char	*get_next_line(int fd);

/*************************** BONUS FUNCTIONS ***************************/
void	ft_here_doc(int ac, char **av);
void	ft_pipe(char *cmd, char **env);

#endif