/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_utils.h                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: drenassi <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/09 19:12:14 by drenassi          #+#    #+#             */
/*   Updated: 2023/11/17 21:15:15 by drenassi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FT_UTILS_H
# define FT_UTILS_H

/*************************** UTILITARIES ***************************/
void	ft_putstr(char *s, int fd);
size_t	ft_strlen(const char *s);
int		ft_strcmp(const char *s1, const char *s2);
char	*ft_substr(char const *s, unsigned int start, size_t len);
char	*ft_strjoin(char const *s1, char const *s2);
char	**ft_split(const char *s, char c);
int		ft_quotes(const char c, int *quotes);
void	ft_error_exit(int *pipe_fd, const char *msg);
void	ft_free(char **array);
void	ft_close(int *pipe_fd);

#endif