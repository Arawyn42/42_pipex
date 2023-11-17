/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: drenassi <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/09 19:07:09 by drenassi          #+#    #+#             */
/*   Updated: 2023/11/15 17:13:47 by drenassi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include <unistd.h>
# include <stdlib.h>
# include <stdio.h>
# include <fcntl.h>
# include <sys/types.h>
# include <sys/wait.h>
# include "ft_utils.h"
# include "bonus.h"

/************************ PIPEX FUNCTIONS ************************/
int		ft_open(char *file, int in_out);
char	*ft_get_path_env(char **env);
char	*ft_get_path(char *cmd, char **env);
void	ft_exec(char *cmds, char **env);

#endif